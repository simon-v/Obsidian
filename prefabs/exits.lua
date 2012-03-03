----------------------------------------------------------------
--  EXIT PREFABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2012 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------


PREFAB.EXIT_PILLAR =
{
  defaults =
  {
    act = ""
    next_map = ""
  }

  brushes =
  {
    -- floor underneath
    {
      { x = -96, y = -96, mat = "?floor" }
      { x =  96, y = -96, mat = "?floor" }
      { x =  96, y =  96, mat = "?floor" }
      { x = -96, y =  96, mat = "?floor" }
      { t = 8, mat = "?floor" }
    }

    -- pillar itself
    {
      { x = -32, y = -32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { t = 136, mat = "?switch" }
    }

    -- exit signs
    {
      { x = -60, y = 44, mat = "?exitside" }
      { x = -32, y = 60, mat = "?exitside" }
      { x = -40, y = 68, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -68, y = 52, mat = "?exitside" }
      { t = 24, light = 0.82, mat = "?exitside" }
    }

    {
      { x = 60, y = 44, mat = "?exitside" }
      { x = 68, y = 52, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 40, y = 68, mat = "?exitside" }
      { x = 32, y = 60, mat = "?exitside" }
      { t = 24, light = 0.82, mat = "?exitside" }
    }

    {
      { x = -60, y = -44, mat = "?exitside" }
      { x = -68, y = -52, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -40, y = -68, mat = "?exitside" }
      { x = -32, y = -60, mat = "?exitside" }
      { t = 24, light = 0.82, mat = "?exitside" }
    }

    {
      { x = 60, y = -44, mat = "?exitside" }
      { x = 32, y = -60, mat = "?exitside" }
      { x = 40, y = -68, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 68, y = -52, mat = "?exitside" }
      { t = 24, light = 0.82, mat = "?exitside" }
    }
  }
}


PREFAB.OUTDOOR_EXIT_SWITCH =  -- BORKED : NEEDS WALK BRUSHES
{
  brushes =
  {

    -- podium
    {
      { x =  64, y = -64, mat = "?podium" }
      { x =  64, y =  64, mat = "?podium" }
      { x = -64, y =  64, mat = "?podium" }
      { x = -64, y = -64, mat = "?podium" }
      { t = 12, mat = "?podium" }
    }

    -- base of switch
    {
      { x = -36, y = -24, mat = "?base" }
      { x =  36, y = -24, mat = "?base" }
      { x =  44, y = -16, mat = "?base" }
      { x =  44, y =  16, mat = "?base" }
      { x =  36, y =  24, mat = "?base" }
      { x = -36, y =  24, mat = "?base" }
      { x = -44, y =  16, mat = "?base" }
      { x = -44, y = -16, mat = "?base" }
      { t = 22, mat = "?base" }
    }

    -- switch itself
    {
      { x =  32, y = -8, mat = "?base" }
      { x =  32, y =  8, mat = "?switch", special="?special", tag="?tag", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  8, mat = "?base" }
      { x = -32, y = -8, mat = "?switch", special="?special", tag="?tag", peg=1, x_offset=0, y_offset=0 }
      { t = 86, mat = "?base" }
    }

    {
      { x = -40, y = 32, mat = "?base" }
      { x = -12, y = 48, mat = "?base" }
      { x = -20, y = 56, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -48, y = 40, mat = "?base" }
      { t = 28, mat = "?base" }
    }

    {
      { x = 40, y = 32, mat = "?base" }
      { x = 48, y = 40, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 20, y = 56, mat = "?base" }
      { x = 12, y = 48, mat = "?base" }
      { t = 28, mat = "?base" }
    }

    {
      { x = -40, y = -32, mat = "?base" }
      { x = -48, y = -40, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -20, y = -56, mat = "?base" }
      { x = -12, y = -48, mat = "?base" }
      { t = 28, mat = "?base" }
    }

    {
      { x = 40, y = -32, mat = "?base" }
      { x = 12, y = -48, mat = "?base" }
      { x = 20, y = -56, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 48, y = -40, mat = "?base" }
      { t = 28, mat = "?base" }
    }
  }
}


PREFAB.SMALL_EXIT =  -- BORKED : NEED WALK BRUSHES (ETC?)
{
  brushes =
  {
    -- outer walls
    {
      { x = 0, y =   0, mat = "?outer" }
      { x = 8, y =   0, mat = "?outer" }
      { x = 8, y = 256, mat = "?outer" }
      { x = 0, y = 256, mat = "?outer" }
    }

    {
      { x = 248, y =   0, mat = "?outer" }
      { x = 256, y =   0, mat = "?outer" }
      { x = 256, y = 256, mat = "?outer" }
      { x = 248, y = 256, mat = "?outer" }
    }

    {
      { x =   8, y = 248, mat = "?outer" }
      { x = 248, y = 248, mat = "?outer" }
      { x = 248, y = 256, mat = "?outer" }
      { x =   8, y = 256, mat = "?outer" }
    }

    {
      { x =   8, y =  0, mat = "?outer" }
      { x = 248, y =  0, mat = "?outer" }
      { x = 248, y = 48, mat = "?outer" }
      { x =   8, y = 48, mat = "?outer" }
      { t = 0.3, mat = "?outer" }
    }

    {
      { x =   8, y = -24, mat = "?outer" }
      { x = 248, y = -24, mat = "?outer" }
      { x = 248, y =  48, mat = "?outer" }
      { x =   8, y =  48, mat = "?outer" }
      { b = 128, mat = "?outer" }
    }

    -- inner walls
    {
      { x =  8, y =  80, mat = "?inner" }
      { x = 16, y =  80, mat = "?inner" }
      { x = 16, y = 248, mat = "?inner" }
      { x =  8, y = 248, mat = "?inner" }
    }

    {
      { x = 240, y =  80, mat = "?inner" }
      { x = 248, y =  80, mat = "?inner" }
      { x = 248, y = 248, mat = "?inner" }
      { x = 240, y = 248, mat = "?inner" }
    }


    {
      { x =   8, y =  48, mat = "?floor" }
      { x = 248, y =  48, mat = "?floor" }
      { x = 248, y = 248, mat = "?floor" }
      { x =   8, y = 248, mat = "?floor" }
      { t = 0.3, mat = "?floor" }
    }

    {
      { x =   8, y =  48, mat = "?ceil" }
      { x = 248, y =  48, mat = "?ceil" }
      { x = 248, y = 248, mat = "?ceil" }
      { x =   8, y = 248, mat = "?ceil" }
      { b = 128, mat = "?ceil", light=0.75 }
    }

    -- the switch iteslf
    {
      { x =  16, y = 240, mat = "?inner" }
      { x =  88, y = 240, mat = "?trim",  peg=1, x_offset=0, y_offset=0 }
      { x =  96, y = 240, mat = "?switch", special="?special", peg=0, x_offset=0, y_offset=0 }
      { x = 160, y = 240, mat = "?trim",  peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 240, mat = "?inner" }
      { x = 240, y = 240, mat = "?inner" }
      { x = 240, y = 248, mat = "?inner" }
      { x =  16, y = 248, mat = "?inner" }
    }


    -- door itself
    {
      { x = 160, y = 48, mat = "?door", special="?door_kind", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 64, mat = "?door", special="?door_kind", peg=1, x_offset=0, y_offset=0 }
      { x =  96, y = 64, mat = "?door", special="?door_kind", peg=1, x_offset=0, y_offset=0 }
      { x =  96, y = 48, mat = "?door", special="?door_kind", peg=1, x_offset=0, y_offset=0 }
      { b = 16, delta_z=-16, mat = "?door" }
    }

    {
      { x = 160, y = 32, mat = "?inner" }
      { x = 160, y = 80, mat = "?inner" }
      { x =  96, y = 80, mat = "?inner" }
      { x =  96, y = 32, mat = "?outer" }
      { b = 72, mat = "?outer", light=0.75 }
    }

    -- side of door
    {
      { x =  0, y =  80, mat = "?outer" }
      { x =  0, y = -24, mat = "?outer" }
      { x = 32, y = -24, mat = "?outer" }
      { x = 96, y =  32, mat = "?key", peg=1, x_offset=0, y_offset=0 }
      { x = 96, y =  48, mat = "?track", peg=1, x_offset=0, y_offset=0 }
      { x = 96, y =  64, mat = "?key", peg=1, x_offset=0, y_offset=0 }
      { x = 96, y =  80, mat = "?inner" }
    }

    {
      { x = 256, y =  80, mat = "?inner" }
      { x = 160, y =  80, mat = "?key", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y =  64, mat = "?track", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y =  48, mat = "?key", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y =  32, mat = "?outer" }
      { x = 224, y = -24, mat = "?outer" }
      { x = 256, y = -24, mat = "?outer" }
    }

    -- exit signs
    {
      { x = 60, y =  -8, mat = "?exitside" }
      { x = 68, y = -16, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 96, y =   0, mat = "?exitside" }
      { x = 88, y =   8, mat = "?exitside" }
      { b = 112, mat = "?exitside" }
    }

    {
      { x = 196, y =  -8, mat = "?exitside" }
      { x = 168, y =   8, mat = "?exitside" }
      { x = 160, y =   0, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 188, y = -16, mat = "?exitside" }
      { b = 112, mat = "?exitside" }
    }

  }
}


PREFAB.QUAKE_EXIT_PAD =
{
  brushes =
  {
    -- the pad itself
    {
      { x = -32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { t = 16, mat = "?pad" }
    }
  }

  models =
  {
    -- the trigger
    {
      x1 = -20, x2 = 20,  x_face = { mat="TRIGGER" }
      y1 = -20, y2 = 20,  y_face = { mat="TRIGGER" }
      z1 =  16, z2 = 240, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "change_lev", map = "?next_map",      
      }
    }
  }

  entities =
  {
    { x = 0, y = 0, z = 20, ent = "light", light = 128, style = 10 }
  }
}


PREFAB.QUAKE2_EXIT_PAD =
{
  brushes =
  {
    -- the pad itself
    {
      { x = -32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { t = 16, mat = "?pad" }
    }
  }

  models =
  {
    -- the trigger
    {
      x1 = -20, x2 = 20,  x_face = { mat="TRIGGER" }
      y1 = -20, y2 = 20,  y_face = { mat="TRIGGER" }
      z1 =  16, z2 = 240, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "trigger", target = "?targetname"
      }
    }
  }

  entities =
  {
    { x = 0, y = 0, z = 20, ent = "change_lev", map = "?next_map", targetname = "?targetname" }

    { x = 0, y = 0, z = 20, ent = "light", light = 128, style = 10 }
  }
}


PREFAB.QUAKE_WALL_EXIT =
{
  fitted = "xy"

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- the pad itself
    {
      { x =  64, y = 32, mat = "?pad", x_offset=0, y_offset=0 }
      { x = 128, y = 32, mat = "?pad", x_offset=0, y_offset=0 }
      { x = 128, y = 96, mat = "?pad", x_offset=0, y_offset=0 }
      { x =  64, y = 96, mat = "?pad", x_offset=0, y_offset=0 }
      { t = 16, mat = "?pad" }
    }
  }

  models =
  {
    -- the trigger
    {
      x1 =  76, x2 = 116, x_face = { mat="TRIGGER" }
      y1 =  44, y2 = 84,  y_face = { mat="TRIGGER" }
      z1 =  16, z2 = 240, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "change_lev", map = "?next_map",      
      }
    }
  }

  entities =
  {
    { x = 96, y = 80, z = 20, ent = "light", light = 128, style = 10 }
  }
}

