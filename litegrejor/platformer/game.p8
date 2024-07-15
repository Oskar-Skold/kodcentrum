pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- all constants
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
-->8
-- main functions
-- pico-8

function _init()
 init_const()  -- constants
 init_magic()  -- magic
 initdyn()    -- dynamic objects
end

function _update()
 domove() -- player movement

 -- change debug mode
 -- ignore this magic
 if btnp(5) then
  debug_mode += 1
  debug_mode %= 3
 end

 -- dynamic object colisions
 
 -- coin 
 coin_col = coldyn("coin")
 if coin_col > -1 then
  score += objs[coin_col].p
  objs[coin_col].active = false
  objs[coin_col].show = false
  sfx(0)
 end

 -- enemy
 enemy_col = coldyn("enemy")
 if enemy_col > -1 then
  health -= 1
 end

 frm += 1
end

function _draw()
 cls(background_col)
 
 if game_state == "gameover" then
  render_screen("game over",0,7)
  return 0
 end
 render_frame()
 
 printtext("score: " .. score, 1, 9, 7)
 dsp_health()

 if debug_mode == 1 then debug_coords() end
 if debug_mode == 2 then debug_cols() end

 updatedyn()
end
-->8
-- some cool platformer stuff
function init_magic()
 cam = { x = pl.x, y = pl.y }
 jmp = 0
end

function move(dx, dy)
 if abs(dx) > 0 then
  if not check_map(pl.x, pl.y, sgn(dx), 0, 0) then
   pl.x += dx
  else
   pl.x = hitb(pl.x, pl.y).gx * 8
  end
 end

 if abs(dy) > 0 then
  if not check_map(pl.x, pl.y, 0, sgn(dy), 0) then
   pl.y += dy
  else
   pl.y = hitb(pl.x, pl.y).gy * 8
  end
 end
end

function hitb(x, y) return { gx = flr((x + 4) / 8), gy = flr((y + 4) / 8) } end

function p_draw()
 spr(
  anim(pl),
  pl.x, pl.y
 )

 local hb = hitb(pl.x, pl.y)

 if debug then rect(hb.gx * 8, hb.gy * 8, hb.gx * 8 + 7, hb.gy * 8 + 7, 8) end
end

function check_map(x, y, dx, dy, fl)
 local hb = hitb(x, y)
 return fget(mget(hb.gx + dx, hb.gy + dy), fl)
end

function align_camera()
 sz = 2
 local dz = {
  xmin = pl.x - 8 * sz, xmax = pl.x + 8 * sz,
  ymin = pl.y - 8 * sz, ymax = pl.y + 8 * sz
 }

 if cam.x < dz.xmin then cam.x = dz.xmin end
 if cam.x > dz.xmax then cam.x = dz.xmax end
 if cam.y < dz.ymin then cam.y = dz.ymin end
 if cam.y > dz.ymax then cam.y = dz.ymax end
end

function printtext(txt, x, y, c)
 print(txt, cam.x + x - 64, cam.y + y - 64, c)
end

function anim(obj)
 return obj.sp[flr(frm / obj.an_speed) % #obj.sp + 1]
end

function debug_coords()
 printtext("debug mode 1", 1, 129 - 8, 7)
 printtext("x: " .. pl.x .. ", ~" .. hitb(pl.x, pl.y).gx, 1, 129 - 8 * 3, 7)
 printtext("y: " .. pl.y .. ", ~" .. hitb(pl.x, pl.y).gy, 1, 129 - 8 * 2, 7)
end

function debug_cols()
 printtext("debug mode 2", 1, 129 - 8, 7)
 -- loop through the map, around
 -- the player, create a rectangle
 -- around each tile that has
 -- flag 0 set
 local plh = hitb(pl.x, pl.y)
 for y = -9, 8 do
  for x = -9, 8 do
   local m = mget(plh.gx + x, plh.gy + y)
   if fget(m, 0) then
    rect((plh.gx + x) * 8, (plh.gy + y) * 8, (plh.gx + x) * 8 + 7, (plh.gy + y) * 8 + 7, 3)
   end
  end
 end

 -- draw a rectangle around the player
 rect(plh.gx * 8, plh.gy * 8, plh.gx * 8 + 7, plh.gy * 8 + 7, 7)

 -- draw all dynamic objects
 for i = 1, #objs do
  if objs[i].active then
   local o = objs[i]
   local oh = hitb(o.x, o.y)
   rect(oh.gx * 8, oh.gy * 8, oh.gx * 8 + 7, oh.gy * 8 + 7, 14) 
  end
 end

 -- 14 = dynamic object
 -- 3 = map flag 0
 -- 7 = player
end

function alrect(x1, y1, x2, y2, c)
 rect(cam.x + x1 - 64, cam.y + y1 - 64, cam.x + x2 - 64, cam.y + y2 - 64, c)
end

function alrectfill(x1, y1, x2, y2, c)
 rectfill(cam.x + x1 - 64, cam.y + y1 - 64, cam.x + x2 - 64, cam.y + y2 - 64, c)
end

function render_frame()
 --rectfill(cam.x - 64, cam.y - 64, cam.x + 64, 128, 12)

 map()

 align_camera()

 rectfill(cam.x - 64 - 16, cam.y + 64 - 8 * 3, cam.x + 64 + 16, cam.y + 64, 0)
 camera(cam.x - 64, cam.y - 64)
 drawdyn()

 if pl.show then p_draw() end
 
end

function dsp_health()
 x_min = 1
 x_max = 80
 xval = health * (x_max - x_min) / 100
 alrect(1,1, 82, 7, 7)
 
 local col = 11
 if health < 75 then col = 10 end
 if health < 50 then col = 9 end
 if health < 25 then col = 8 end
 alrectfill(3, 3, max(1 + xval,3), 1+4, col)
end

function domove()
 if pl.active then
  if btn(0) then move(-1 * pl.speed, 0) end -- left
  if btn(1) then move(1 * pl.speed, 0) end -- right

  if gravity then
   -- if gravity is on
   if btn(2) and check_map(pl.x, pl.y, 0, 1, 0) then
    jmp = 4 end

   if btn(3) then move(0, pl.speed) end

   if frm % 1 == 0 then
    move(0, 2)
   end
  else
   -- if gravity is off
   if btn(2) then move(0, -1 * pl.speed) end
   if btn(3) then move(0, 1 * pl.speed) end
  end
 end

 -- jump
 if jmp > 0 then
  jmp -= 1
  move(0, -6)
 end
end

function render_screen(txt, bg, c)
 cls(bg)
 local w = #txt * 4 - 1
 local h = 5
 printtext(txt, 64 - w / 2, 64 - h / 2, c)
end
-->8
-- dynamic objects
-- are objects that can move
-- or change their state.
-- animations / etc.

-- dynamic object drawing
function drawdyn()
 for i = 1, #objs do
  local o = objs[i]
  local h = hitb(o.x, o.y)
  
  if mget(o.start.gx, o.start.gy) ~= background_spr then
   mset(o.start.gx, o.start.gy, 
    background_spr) 
  end
  
  if o.show then
   local sprt = anim(o)
   if o.moveable then
    spr(sprt, o.x, o.y)
   else
    mset(h.gx, h.gy, sprt) end
  end
 end
end

-- dynamic object initialization
function initdyn()
 for x=0,127 do
  for y=0,127 do
   local t = mget(x, y)
   for i = 1, #stand_objs do
    local o = stand_objs[i]
    for j = 1, #o.sp do
     if t == o.sp[j] then
      add(objs, {
       x = x * 8,
       y = y * 8,
       sp = o.sp,
       active = o.active,
       show = o.show,
       tag = o.tag,
       p = o.p,
       an_speed = o.an_speed,
       speed = o.speed,
       moveable = o.moveable,
       start = {gx = x, gy = y}
      })
     end
    end
   end
  end
 end
end

-- dynamic object coliisions
function coldyn(tag)
 for i = 1, #objs do
  local o = objs[i]
  if o.tag == tag and 
    (o.active and o.show) then
   local ho = hitb(o.x, o.y)
   local hp = hitb(pl.x, pl.y)
   if ho.gx == hp.gx and
      ho.gy == hp.gy then
    return i
   end
  end
 end
 return -1
end

-- dynamic object update
function updatedyn()
 for i = 1, #objs do
  local o = objs[i]
  if o.active then
   if o.moveable then
    if true then 
     pathmovedyn(i, pl.x, pl.y)
    end
    if gravity then
     movedyn(i, 0, 3)
    end
   end
  end
 end
end

-- pathfind from dynamic object
-- to (x,y)
function dst(x1, y1, x2, y2)
 return sqrt((x2-x1)^2 + (y2-y1)^2)
end

function lowest_inde(list)
 local lowest_ind = 1
  -- find the lowest distance
 for i=1, #list do
  if list[i] < list[lowest_ind] then
   lowest_ind = i
  end
 end
 return lowest_ind
end

function pathfind(dyn_num, x, y)
 if debug_mode == 2 then
  pset(x, y, 7)
 end
 local o = objs[dyn_num]
 local h = hitb(o.x, o.y)
 local t = hitb(x, y)
 
 -- check if h is the same as t
 if h.gx == t.gx and h.gy == t.gy then
  return -1
 end 
 
 local l = not check_map(o.x,o.y,-1, 0, 0)
 local r = not check_map(o.x,o.y, 1, 0, 0)
 local up= -- no block above, and a block below 
  not check_map(o.x,o.y, 0,-1, 0) and --check_map(o.x,o.y, 0,-1, 0)
  ((check_map(o.x,o.y, 0, 1, 0) and o.y % 8 == 0) or not gravity)
 local d = not check_map(o.x,o.y, 0, 1, 0)

 -- pixel coordinates
 local lc = 
  {gx=h.gx-1, gy=h.gy}
 local rc = 
  {gx=h.gx+1, gy=h.gy}
 local uc  = 
  {gx=h.gx, gy=h.gy-1}
 local dc = 
  {gx=h.gx, gy=h.gy+1}

  local ld = dst(lc.gx, lc.gy, t.gx, t.gy)
  local rd = dst(rc.gx, rc.gy, t.gx, t.gy)
  local ud = dst(uc.gx, uc.gy, t.gx, t.gy)
  local dd = dst(dc.gx, dc.gy, t.gx, t.gy)
  
  if debug_mode == 1 and l then print(flr(ld), lc.gx*8, lc.gy*8, 7) end
  if debug_mode == 1 and r then print(flr(rd), rc.gx*8, rc.gy*8, 7) end
  if debug_mode == 1 and up then print(flr(ud), uc.gx*8, uc.gy*8, 7) end
  if debug_mode == 1 and d then print(flr(dd), dc.gx*8, dc.gy*8, 7) end
  
  local dsts = {ld, rd, ud, dd}
  local lcs  = {lc, rc, uc, dc}
  local checks = {l, r, up, d}
  
  if not l then dsts[1] = 9999 end
  if not r then dsts[2] = 9999 end
  if not up then dsts[3] = 9999 end
  if not d then dsts[4] = 9999 end
  
  local lowest = lowest_inde(dsts)
  if checks[lowest] then
   -- if lowest is up
   if lowest == 3 then
    if gravity then
     -- if ld < rd, go left and up
     if ld < rd then
      return 5
     else
      return 6
     end
    end
   end
   return lowest
  end
  return -1
end

-- dynamic object movement
function movedyn(obj_ind, dx, dy)
 local o = objs[obj_ind]
 if abs(dx) > 0 then
     if not check_map(o.x,o.y, sgn(dx), 0, 0) then
      objs[obj_ind].x += dx
     else
      objs[obj_ind].x = hitb(o.x, o.y).gx*8
     end
 end

 if abs(dy) > 0 then
     if not check_map(o.x, o.y, 0, sgn(dy), 0) then
         objs[obj_ind].y += dy
     else
         objs[obj_ind].y = hitb(o.x, o.y).gy*8
     end
 end
end

-- dynamic object move_path
function pathmovedyn(obj_ind,x,y)
 local nearest = pathfind(obj_ind, x, y)
 local o = objs[obj_ind]
 local h = hitb(o.x, o.y)
 if nearest == -1 then
  return
 end
 if nearest == 1 then
  --printtext("left", 1, 128-16, 7)
  movedyn(obj_ind, -1 * o.speed, 0)
 elseif nearest == 2 then
  --printtext("right", 1, 128-16, 7)
  movedyn(obj_ind, 1 * o.speed, 0)
 elseif nearest == 3 then
  if gravity then
   movedyn(obj_ind, 0, -12)
   --printtext("up", 1, 128-16, 7)
  else
   movedyn(obj_ind, 0, -1 * o.speed)
  end 
 elseif nearest == 4 then
  --printtext("down", 1, 128-16, 7)
  movedyn(obj_ind, 0, 1 * o.speed)
 end
 if nearest == 5 then
  if gravity then
   -- go left and up
   -- left
   movedyn(obj_ind, 0, -12)
   movedyn(obj_ind, -2 * o.speed, 0)
   -- up 1 whole block
  else
   movedyn(obj_ind, -1 * o.speed, 0)
  end
 end
 if nearest == 6 then
  if gravity then
   -- go right and up
   -- right
   movedyn(obj_ind, 0, -12)
   movedyn(obj_ind, 2 * o.speed, 0)
   -- up 1 whole block
  else
   movedyn(obj_ind, 1 * o.speed, 0)
  end
 end 
end
__gfx__
00000000000770000000000000000000666666660000000077777777777777775555555555555555666555665555555500000000000000000000000000000000
00000000000770000000000000000000666666660000000070000007700000075bbbbbb554444445655555554454444400000000000000000000000000000000
00700700888888880000000000000000666666660000000070070007700070075bbbbbb554444445655556654454444400000000000000000000000000000000
00077000808888080000000000000000666666660000000070770007700770075444444554444445555556554454444400000000000000000000000000000000
00077000801111080000000000000000666666660000000070070007700070075444444554444445556556555555555500000000000000000000000000000000
00700700001111000000000000000000666666660000000070777007700777075444444554444445556655554444454400000000000000000000000000000000
00000000001001000000000000000000666666660000000070000007700000075444444554444445655555664444454400000000000000000000000000000000
00000000055005500000000000000000666666660000000077777777777777775555555555555555665555654444454400000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888887870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000880880880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0a0a0a0a0a0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a040404040a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a040404040a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a04040604040000000008080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a04040404040808080809090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001d2501d2501d2502425024250242501c2003420035200232003520027200352002a2002d2002e20033200322003320032200322003120000000000000000000000000000000000000000000000000000
