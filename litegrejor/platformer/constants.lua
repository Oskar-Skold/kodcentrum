-- All constants
function init_const()
 gravity = true
 debug    = false -- debug mode
 score    = 0
 frm      = 0    -- frame
 background_spr = 4
 pl = {
  show = true,   -- show player
  active = true, -- player active
  x = 8 * 3,     -- start x
  y = 0,         -- start y
  sp = { 1 },    -- sprite list
  an_speed = 10  -- animation speed
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
  { -- coin
   sp = {6,7},
   active = true,
   show = true,
   tag = "coin",
   p = 10,
   an_speed = 10,
   speed = 0,
   moveable = false
  },
  { -- enemy
   sp = {17},
   active = true,
   show = true,
   tag = "enemy",
   p = 0,
   an_speed = 10,
   speed = 1,
   moveable = true
 }
 }
end