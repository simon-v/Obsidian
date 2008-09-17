//------------------------------------------------------------------------
//  LUA interface
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_signal.h"
#include "lib_util.h"
#include "main.h"

#include "g_lua.h"
#include "twister.h"


static lua_State *LUA_ST;

static const char *script_path;

static bool has_loaded = false;
static bool has_added_buttons = false;

static std::vector<std::string> * conf_line_buffer;


namespace con
{

// random number generator (Mersenne Twister)
MT_rand_c RNG(0);

// state needed for progress() call
int lev_IDX = 0;
int lev_TOTAL = 0;


// LUA: raw_log_print(str)
//
int raw_log_print(lua_State *L)
{
  int nargs = lua_gettop(L);

  if (nargs >= 1)
  {
    const char *res = luaL_checkstring(L,1);
    SYS_ASSERT(res);

    LogPrintf("%s", res);
  }

  return 0;
}

// LUA: raw_debug_print(str)
//
int raw_debug_print(lua_State *L)
{
  int nargs = lua_gettop(L);

  if (nargs >= 1)
  {
    const char *res = luaL_checkstring(L,1);
    SYS_ASSERT(res);

    DebugPrintf("%s", res);
  }

  return 0;
}

// LUA: config_line(str)
//
int config_line(lua_State *L)
{
  const char *res = luaL_checkstring(L,1);

  SYS_ASSERT(conf_line_buffer);

  conf_line_buffer->push_back(res);

  return 0;
}


// LUA: add_button (what, id, label)
//
int add_button(lua_State *L)
{
  const char *what  = luaL_checkstring(L,1);
  const char *id    = luaL_checkstring(L,2);
  const char *label = luaL_checkstring(L,3);

  SYS_ASSERT(what && id && label);

  // only allowed during startup
  if (has_added_buttons)
    Main_FatalError("LUA script problem: con.add_button called late.\n");

DebugPrintf("add_button: %s id:%s\n", what, id);

  if (StringCaseCmp(what, "game") == 0)
    main_win->game_box->game->AddPair(id, label);

  else if (StringCaseCmp(what, "engine") == 0)
    main_win->game_box->engine->AddPair(id, label);

  else if (StringCaseCmp(what, "theme") == 0)
    main_win->level_box->theme->AddPair(id, label);

  else if (StringCaseCmp(what, "module") == 0)
    main_win->mod_box->opts->AddPair(id, label);

  else if (StringCaseCmp(what, "option") == 0)
    main_win->option_box->opts->AddPair(id, label);

  else
    Main_FatalError("add_button: unknown what value '%s'\n", what);

  return 0;
}

// LUA: show_button(what, id, shown)
//
int show_button(lua_State *L)
{
  const char *what = luaL_checkstring(L,1);
  const char *id   = luaL_checkstring(L,2);

  int shown = lua_toboolean(L,3) ? 1 : 0;

  SYS_ASSERT(what && id);

DebugPrintf("show_button: %s id:%s %s\n", what, id, shown ? "show" : "HIDE");

  if (StringCaseCmp(what, "game") == 0)
    main_win->game_box->game->ShowOrHide(id, shown);

  else if (StringCaseCmp(what, "engine") == 0)
    main_win->game_box->engine->ShowOrHide(id, shown);

  else if (StringCaseCmp(what, "theme") == 0)
    main_win->level_box->theme->ShowOrHide(id, shown);

  else if (StringCaseCmp(what, "module") == 0)
    main_win->mod_box->opts->ShowOrHide(id, shown);

  else if (StringCaseCmp(what, "option") == 0)
    main_win->option_box->opts->ShowOrHide(id, shown);

  else
    Main_FatalError("show_button: unknown what value '%s'\n", what);

  return 0;
}

// LUA: change_button(what, id [, bool])
//
int change_button(lua_State *L)
{
  const char *what = luaL_checkstring(L,1);
  const char *id   = luaL_checkstring(L,2);

  int opt_val = lua_toboolean(L,3) ? 1 : 0;

  SYS_ASSERT(what && id);

DebugPrintf("change_button: %s --> %s\n", what, id);

  if (StringCaseCmp(what, "game") == 0)
    main_win->game_box->game->SetID(id);

  else if (StringCaseCmp(what, "engine") == 0)
    main_win->game_box->engine->SetID(id);

  else if (StringCaseCmp(what, "theme") == 0)
    main_win->level_box->theme->SetID(id);

  else if (StringCaseCmp(what, "module") == 0)
    main_win->mod_box->opts->SetOption(id, opt_val);

  else if (StringCaseCmp(what, "option") == 0)
    main_win->option_box->opts->SetOption(id, opt_val);

  else
    Main_FatalError("change_button: unknown what value '%s'\n", what);

  return 0;
}


// LUA: at_level(name, idx, total)
//
int at_level(lua_State *L)
{
  // TODO: get name, show it
 
  lev_IDX = luaL_checkint(L, 2);
  lev_TOTAL = luaL_checkint(L, 3);

  return 0;
}

// LUA: progress(percent)
//
int progress(lua_State *L)
{
  lua_Number perc = luaL_checknumber(L, 1);

  SYS_ASSERT(lev_TOTAL > 0);

  perc = ((lev_IDX-1) * 100 + perc) / lev_TOTAL;

  main_win->build_box->ProgUpdate(perc);

  return 0;
}


// LUA: ticker()
//
int ticker(lua_State *L)
{
  Main_Ticker();

  return 0;
}

// LUA: abort() -> boolean
//
int abort(lua_State *L)
{
  int value = 0;

  if (main_win->action >= UI_MainWin::ABORT)
    value = 1;

  lua_pushboolean(L, value);
  return 1;
}


// LUA: rand_seed(seed)
//
int rand_seed(lua_State *L)
{
  int the_seed = luaL_checkint(L, 1) & 0x7FFFFFFF;

  RNG.Seed(the_seed);

  return 0;
}

// LUA: random()
//
int random(lua_State *L)
{
  int raw = RNG.Rand() & 0x7FFFFFFF;

  // target range is [0-1), including 0 but not including 1
  lua_Number value = (lua_Number)raw / 2147483648.0;

  lua_pushnumber(L, value);
  return 1;
}


// LUA: bit_and(A, B)
//
int bit_and(lua_State *L)
{
  int A = luaL_checkint(L, 1);
  int B = luaL_checkint(L, 2);

  lua_pushinteger(L, A & B);
  return 1;
}

// LUA: bit_or(A, B)
//
int bit_or(lua_State *L)
{
  int A = luaL_checkint(L, 1);
  int B = luaL_checkint(L, 2);

  lua_pushinteger(L, A | B);
  return 1;
}

// LUA: bit_xor(A, B)
//
int bit_xor(lua_State *L)
{
  int A = luaL_checkint(L, 1);
  int B = luaL_checkint(L, 2);

  lua_pushinteger(L, A ^ B);
  return 1;
}

// LUA: bit_not(val)
//
int bit_not(lua_State *L)
{
  int A = luaL_checkint(L, 1);

  // do not make the result negative
  lua_pushinteger(L, (~A) & 0x7FFFFFFF);
  return 1;
}

} // namespace con


// FIXME: header file?
extern int CSG2_begin_level(lua_State *L);
extern int CSG2_end_level(lua_State *L);
extern int CSG2_property(lua_State *L);
extern int CSG2_add_brush(lua_State *L);
extern int CSG2_add_entity(lua_State *L);

extern int Wolf_add_block(lua_State *L);


static const luaL_Reg gui_script_funcs[] =
{
  { "raw_log_print",   con::raw_log_print },
  { "raw_debug_print", con::raw_debug_print },
  { "config_line",     con::config_line },

  { "add_button",    con::add_button },
  { "show_button",   con::show_button },
  { "change_button", con::change_button },

  { "at_level",   con::at_level },
  { "progress",   con::progress },
  { "ticker",     con::ticker },
  { "abort",      con::abort },
 
  { "rand_seed",  con::rand_seed },
  { "random",     con::random },

  { "bit_and",    con::bit_and },
  { "bit_or",     con::bit_or  },
  { "bit_xor",    con::bit_xor },
  { "bit_not",    con::bit_not },

  { "begin_level", CSG2_begin_level },
  { "end_level",   CSG2_end_level   },
  { "property",    CSG2_property    },

  { "add_brush",   CSG2_add_brush  },
  { "add_entity",  CSG2_add_entity },

  { "wolf_block",  Wolf_add_block },

  { NULL, NULL } // the end
};


//------------------------------------------------------------------------

// forward decl
static bool Script_DoRun(const char *func_name, int nresult=0,
                         const char **params = NULL);


int Script_RegisterLib(const char *name, const luaL_Reg *reg)
{
  SYS_NULL_CHECK(LUA_ST);

  luaL_register(LUA_ST, name, reg);

  // remove the table which luaL_register created
  lua_pop(LUA_ST, 1);

  return 0;
}

static int p_init_lua(lua_State *L)
{
  /* stop collector during initialization */
  lua_gc(L, LUA_GCSTOP, 0);
  {
    luaL_openlibs(L);  /* open libraries */

    Script_RegisterLib("gui", gui_script_funcs);
  }
  lua_gc(L, LUA_GCRESTART, 0);

  return 0;
}

static void Script_SetLoadPath(lua_State *L)
{
  script_path = StringPrintf("%s/scripts/?.lua", install_path);

  LogPrintf("script_path: [%s]\n\n", script_path);

  lua_getglobal(L, "package");

  if (lua_type(L, -1) == LUA_TNIL)
    Main_FatalError("LUA SetPath failed: no 'package' module!");

  lua_pushstring(L, script_path);

  lua_setfield(L, -2, "path");

  lua_pop(L, 1);
}

void Script_Init(void)
{
  LUA_ST = lua_open();
  if (! LUA_ST)
    Main_FatalError("LUA Init failed: cannot create new state");

  int status = lua_cpcall(LUA_ST, &p_init_lua, NULL);
  if (status != 0)
    Main_FatalError("LUA Init failed: cannot load standard libs (%d)", status);

  Script_SetLoadPath(LUA_ST);
}

void Script_Close(void)
{
  if (LUA_ST)
    lua_close(LUA_ST);

  LUA_ST = NULL;
}


static void add_extra_script(const char *name, int flags, void *priv_dat)
{
  std::vector<const char*> *list = (std::vector<const char*> *) priv_dat;
    
  DebugPrintf("  file [%s] flags:%d\n", name, flags);
      
  if (flags & SCAN_F_IsDir)
    return;

  if (flags & SCAN_F_Hidden)
    return;

  if (! CheckExtension(name, "lua"))
    return;

  list->push_back(StringDup(name));
}

struct Compare_ScriptFilename_pred
{
  inline bool operator() (const char *A, const char *B) const
  {
    return StringCaseCmp(A, B) < 0;
  }
};

void Script_LoadFromDir(const char *subdir)
{
  // load all scripts (files which match "*.lua") from a
  // sub-directory.

  const char *path = StringPrintf("%s/%s", install_path, subdir);

  LogPrintf("Loading extra scripts from: [%s]\n", path);

  std::vector<const char*> file_list;

  int count = ScanDirectory(path, add_extra_script, &file_list);

  if (count < 0)
    Main_FatalError("Unable to find extra scripts! (%d)\n", count);

  DebugPrintf("Scanned %d entries in sub-directory.\n", count);

  std::sort(file_list.begin(), file_list.end(),
            Compare_ScriptFilename_pred());

  for (unsigned int i = 0; i < file_list.size(); i++)
  {
    LogPrintf("Loading %d/%d : %s\n", i+1, file_list.size(), file_list[i]);
 
    const char *full_name = StringPrintf("%s/%s", path, file_list[i]);

    // load it !!
    int status = luaL_loadfile(LUA_ST, full_name);

    if (status == 0)
      status = lua_pcall(LUA_ST, 0, 0, 0);

    if (status != 0)
    {
      const char *msg = lua_tolstring(LUA_ST, -1, NULL);

      Main_FatalError("Unable to load script '%s' (%d)\n%s",
                      file_list[i], status, msg);
    }

    StringFree(full_name);
    StringFree(file_list[i]);
    
    file_list[i] = NULL;
  }
 
  StringFree(path);

  LogPrintf("\n");
}


void Script_Load(void)
{
  int status = luaL_loadstring(LUA_ST, "require 'oblige'");

  if (status == 0)
    status = lua_pcall(LUA_ST, 0, 0, 0);

  if (status != 0)
  {
    const char *msg = lua_tolstring(LUA_ST, -1, NULL);

    Main_FatalError("Unable to load script 'oblige.lua' (%d)\n%s", status, msg);
  }

  Script_LoadFromDir("games");
  Script_LoadFromDir("mods");

  has_loaded = true;
 
  if (! Script_DoRun("ob_init"))
    Main_FatalError("The ob_init script failed.\n");

  has_added_buttons = true;
  
}


// ========================
// NOTES ABOUT CONFIG STATE
// ========================
//
// By "config state" I mean all the things in the GUI which
// the user can change (game, mode, engine, theme, etc...).
//
// THE MASTER STATE IS STORED IN LUA
//
// Most of it is in the OB_CONFIG[] table, but some bits are
// stored in the modules in OB_MODULES[] and the options in
// OB_OPTIONS[].
//
// Hence the GUI state is merely a reflection of the config
// stored by the script.  The script manages most of the
// inter-dependencies (e.g. the engines and themes which can
// be used for the currently selected game).
// 

bool Script_SetConfig(const char *key, const char *value)
{
  SYS_NULL_CHECK(key);
  SYS_NULL_CHECK(value);

  if (! has_loaded)
  {
    DebugPrintf("Script_SetConfig(%s) called before loaded!\n", key);
    return false;
  }
 
  const char *params[3];

  params[0] = key;
  params[1] = value;
  params[2] = NULL; // end of list

  if (! Script_DoRun("ob_set_config", 0, params))
  {
    DebugPrintf("Failed trying to call 'ob_set_config'\n");
    return false;
  }

  return true;
}

bool Script_ReadAllConfig(std::vector<std::string> * lines)
{
  if (! has_loaded)
  {
    DebugPrintf("Script_GetAllConfig called before loaded!\n");
    return false;
  }

  conf_line_buffer = lines;
 
  bool result = Script_DoRun("ob_read_all_config", 0, NULL);

  conf_line_buffer = NULL;

  if (! result)
    DebugPrintf("Failed trying to call 'ob_read_all_config'\n");

  return result;
}


static bool Script_DoRun(const char *func_name, int nresult, const char **params)
{
  lua_getglobal(LUA_ST, "ob_traceback");
 
  if (lua_type(LUA_ST, -1) == LUA_TNIL)
    Main_FatalError("LUA script problem: missing function '%s'", "ob_traceback");

  lua_getglobal(LUA_ST, func_name);

  if (lua_type(LUA_ST, -1) == LUA_TNIL)
    Main_FatalError("LUA script problem: missing function '%s'", func_name);

  int nargs = 0;
  if (params)
  {
    for (; *params; params++, nargs++)
      lua_pushstring(LUA_ST, *params);
  }

  int status = lua_pcall(LUA_ST, nargs, nresult, -2-nargs);
  if (status != 0)
  {
    const char *msg = lua_tolstring(LUA_ST, -1, NULL);

    DLG_ShowError("LUA script error:\n%s", msg);
  }
 
  // remove the traceback function
  lua_remove(LUA_ST, -1-nresult);

  return (status == 0) ? true : false;
}


const char * Script_GameFormat(void)
{
  if (! Script_DoRun("ob_game_format", 1))
    return NULL;

  const char *res = lua_tolstring(LUA_ST, -1, NULL);

  if (res)
    res = StringDup(res);

  // remove result from lua stack
  lua_pop(LUA_ST, 1);

  return res;
}


bool Script_Build(void)
{
  if (! Script_DoRun("build_cool_shit", 1))
    return false;

  const char *res = lua_tolstring(LUA_ST, -1, NULL);

  // remove result from lua stack
  lua_pop(LUA_ST, 1);

  if (res && strcmp(res, "ok") == 0)
    return true;

  return false;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
