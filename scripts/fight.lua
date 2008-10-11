----------------------------------------------------------------
--  FIGHT SIMULATOR
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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


-- ===================
--  BATTLE SIMULATION
-- ===================
--
-- Inputs:
--    monsters : list of monsters that the player must kill
--    weapons  : list of weapons that player can use
--    skill    : skill level
--
-- Output:
--    health   : health that player needs to survive the battle
--    ammos    : ammo quantities required by the player
--
-- Notes:
--
-- *  Health result is stored in the 'ammos' table.  All the
--    values are >= 0 and can be partial (like 3.62 rockets).
--
-- *  Armor is not directly modelled.  Instead you can assume
--    that some percentage of the returned 'health' would have
--    been saved if the player was wearing armor.
--
-- *  Powerups are not modelled.  The assumption here is that
--    any powerups on the level are bonuses for the player
--    and not a core part of gameplay.  It could be handled
--    by being stingy on health/ammo in the room containing
--    the powerup (and subsequent rooms).
--
-- *  Monsters are "fought" one by one in the given list.
--    Typically they should be in order of distance from the
--    room's entrance (with some preference for having the
--    toughest monsters first, which is how the real player
--    would tackle them).  Your weapons can damage other
--    monsters though, to model such things as rocket splash,
--    shotgun spread, the BFG etc...
--
--    All of the monsters are fighting the player.  They are
--    assumed to be linearly spread out (first one is closest
--    and last one is far away), 2D layouts are not modelled.
--    Further away monsters do less damage, we also assume
--    that closer monsters get in the way (especially for
--    missile attacks), and that melee monsters can only hurt
--    you when they are first (at most second) in the list.
--
-- *  Infighting between monsters is modelled but is toned
--    down, since the real layout will make a big difference
--    to the results, so we aim for some kind of average.
--

function fight_simulator(monsters, weapons, skill, ammos)

  local function player_shoot()
  end


  local function monsters_shoot()
  end

  ---===| fight_simulator |===---

  ammos.health = 0

  while #monsters > 0 do
    monsters_shoot()
    player_shoot()
  end
end

