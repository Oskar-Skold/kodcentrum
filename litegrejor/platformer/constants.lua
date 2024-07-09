-- All constants
function init_const()
 game_state = "game"
 gravity = false
 debug_mode = 0 -- 0 = off, 1+ = different modes
 debug    = false -- debug mode
 score    = 0
 health   = 100
 frm      = 0    -- frame
 background_spr = 4
 background_col = 6
 pl = {
  show = true,   -- show player
  active = true, -- player active
  x = 8 * 3,     -- start x
  y = 0,         -- start y
  sp = { 1 },    -- sprite list
  an_speed = 10,  -- animation speed
  speed = 2 -- speed of the player
 }

 objs = {}
-- all dynamic objects have the
-- following properties:
-- x = x pixel position
-- y = y pixel position
-- sp = list of sprites
-- active  = is it active?
-- show    = show object?
-- tag     = tag for the object
--           each tag can do
--           different things
-- p = points for the player
--            (if applicable)
-- an_speed = animation speed
--            (if applicable)
-- speed   = speed of the object
--            (if applicable)
-- moveable = can the object move?
-- start    = gx, gy start position

 stand_objs = {
  {
   tag = "coin",
   sp = {6,7},
   active = true,
   show = true,
   p = 10,
   an_speed = 10,
   speed = 0,
   moveable = false
  },
  { -- enemy
   tag = "enemy",
   sp = {17},
   active = true,
   show = true,
   p = 0,
   an_speed = 2,
   speed = 1,
   moveable = true
  }
 }
end