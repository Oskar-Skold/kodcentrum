pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- all constants
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
-->8
-- main functions
-- pico-8

function _init()
 init_const() -- constants
 init_magic() -- magic
 initdyn()    -- dynamic objects
end

function _update()
 if pl.active then
  if btn(0) then move(-2, 0) end -- left
  if btn(1) then move( 2, 0) end -- right

  if gravity then -- if gravity is on

   if btn(2) and check_map(pl.x, pl.y, 0,1,0) 
   then 
     jmp = 4 end

   if btn(3) then move(0, 2) end

   if frm % 1 == 0 then 
    move(0, 4) end

  else -- if gravity is off
   if btn(2) then move(0,-2) end
   if btn(3) then move(0, 2) end
  end
 end

 if btnp(5) then debug = not debug end

 if jmp > 0 then
  jmp -= 1
  move(0, -8)
 end

 -- dynamic object coliisions
 coin_col = coldyn("coin")
 if coin_col > -1 then
  score += objs[coin_col].p
  sfx(0)
  objs[coin_col].active = false
  objs[coin_col].show = false
 end

 -- enemy
 enemy_col = coldyn("enemy")
 if enemy_col > -1 then
  -- pl.active = false
  -- pl.show = false
 end
 
 frm += 1
end

function _draw()
 cls()
 rectfill(cam.x - 64, cam.y - 64, cam.x + 64, 128, 12)
 
 map()

 align_camera()

 rectfill(cam.x - 64 - 16, cam.y + 64 - 8 * 3, cam.x + 64 + 16, cam.y + 64, 0)

 camera(cam.x - 64, cam.y - 64)

 drawdyn()

 if pl.show then p_draw() end

 if debug then
  printtext("x: " .. pl.x .. ", ~" .. hitb(pl.x, pl.y).gx, 1, 129 - 8 * 3, 7)
  printtext("y: " .. pl.y .. ", ~" .. hitb(pl.x, pl.y).gy, 1, 129 - 8 * 2, 7)
 end

 printtext("score: " .. score, 1, 1, 7)
 
 updatedyn()
end
-->8
-- some cool platformer stuff
function init_magic()
    cam = {x = pl.x, y = pl.y}
    jmp = 0 -- each num is 4px
end

function move(dx, dy)
    if abs(dx) > 0 then
        if not check_map(pl.x, pl.y, sgn(dx), 0, 0) then
            pl.x += dx
        else
            pl.x = hitb(pl.x, pl.y).gx*8
        end
    end

    if abs(dy) > 0 then
        if not check_map(pl.x, pl.y, 0, sgn(dy), 0) then
            pl.y += dy
        else
            pl.y = hitb(pl.x, pl.y).gy*8
        end
    end
end

function hitb(x,y) return {gx = flr((x+4)/8), gy = flr((y+4)/8)} end

function p_draw()
    spr(
        anim(pl),
        pl.x, pl.y)

    local hb = hitb(pl.x, pl.y)
    
    if debug then rect(hb.gx*8, hb.gy*8, hb.gx*8+7, hb.gy*8+7, 8) end
end

function check_map(x,y,dx,dy,fl)
    local hb = hitb(x,y)
    return fget(mget(hb.gx+dx, hb.gy+dy), fl)
end

function align_camera()
    sz = 2
    local dz = {xmin = pl.x-8*sz, xmax = pl.x+8*sz,
                        ymin = pl.y-8*sz, ymax = pl.y+8*sz}
    
    if cam.x < dz.xmin then cam.x = dz.xmin end
    if cam.x > dz.xmax then cam.x = dz.xmax end
    if cam.y < dz.ymin then cam.y = dz.ymin end
    if cam.y > dz.ymax then cam.y = dz.ymax end
end

function printtext(txt,x,y,c)
    print(txt,cam.x+x-64,cam.y+y-64,c)
end

function anim(obj)
    
    return obj.sp[((flr(frm/obj.an_speed))%#obj.sp)+1]
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
  
  if mget(h.gx, h.gy) ~= background_spr then
   mset(h.gx, h.gy, 
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
     movedyn(i, 0, 4)
    end
   end
  end
 end
end

-- pathfind from dynamic object
-- to (x,y)
function dst(x1, y1, x2, y2)
 return ((x2-x1)^2 + (y2-y1)^2)
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
 local o = objs[dyn_num]
 local h = hitb(o.x, o.y)
 local t = hitb(x, y)
 
 local l = not check_map(o.x,o.y,-1, 0, 0)
 local r = not check_map(o.x,o.y, 1, 0, 0)
 local up= not check_map(o.x,o.y, 0,-1, 0)
 local d = not check_map(o.x,o.y, 0, 1, 0)

 local lc = 
  {gx=h.gx-1, gy=h.gy}
 local rc = 
  {gx=h.gx+1, gy=h.gy}
 local uc  = 
  {gx=h.gx, gy=h.gy-1}
 local dc = 
  {gx=h.gx, gy=h.gy+1}

  local ld =
   dst(lc.gx, lc.gy, t.gx, t.gy)
  local rd =
   dst(rc.gx, rc.gy, t.gx, t.gy)
  local ud =
   dst(uc.gx, uc.gy, t.gx, t.gy)
  local dd =
   dst(dc.gx, dc.gy, t.gx, t.gy)

  if debug and l then print(flr(ld), lc.gx*8, lc.gy*8, 7) end
  if debug and r then print(flr(rd), rc.gx*8, rc.gy*8, 7) end
  if debug and up then print(flr(ud), uc.gx*8, uc.gy*8, 7) end
  if debug and d then print(flr(dd), dc.gx*8, dc.gy*8, 7) end

  local dsts = {ld, rd, ud, dd}
  local lcs  = {lc, rc, uc, dc}
  local checks = {l, r, up, d}

  for i=1, #dsts do
   local lowest = lowest_inde(dsts)
   if checks[lowest] then
    st = {"left", "right", "up", "down"}
    
    --printtext("lowest:"..st[lowest], 1, 128-7, 7)
    
    return lowest
   else
    dsts[lowest] = 9999
   end
  end
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

 if nearest == 1 then
  --printtext("left", 1, 128-16, 7)
  movedyn(obj_ind, -1 * o.speed, 0)
 elseif nearest == 2 then
  --printtext("right", 1, 128-16, 7)
  movedyn(obj_ind, 1 * o.speed, 0)
 elseif nearest == 3 then
  --printtext("up", 1, 128-16, 7)
  if gravity then
   movedyn(obj_ind, 0, -6 * o.speed)
  else
   movedyn(obj_ind, 0, -1 * o.speed)
  end
 elseif nearest == 4 then
  --printtext("down", 1, 128-16, 7)
  movedyn(obj_ind, 0, 0 * o.speed)
 end
end
__gfx__
00000000000770000000000000000000cccccccc0000000077777777777777775555555555555555555555550000000000000000000000000000000000000000
00000000000770000000000000000000cccccccc0000000070000007700000075bbbbbb554444445566666650000000000000000000000000000000000000000
00700700888888880000000000000000cccccccc0000000070070007700070075bbbbbb554444445566666650000000000000000000000000000000000000000
00077000808888080000000000000000cccccccc0000000070770007700770075444444554444445566666650000000000000000000000000000000000000000
00077000801111080000000000000000cccccccc0000000070070007700070075444444554444445566666650000000000000000000000000000000000000000
00700700001111000000000000000000cccccccc0000000070777007700777075444444554444445566666650000000000000000000000000000000000000000
00000000001001000000000000000000cccccccc0000000070000007700000075444444554444445566666650000000000000000000000000000000000000000
00000000055005500000000000000000cccccccc0000000077777777777777775555555555555555555555550000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888887870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000880880880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a000000000000000000000011000006000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a000000000000000000000000000000000a00000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090909090909090909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090909090909090909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001d2501d2501d2502425024250242501c2003420035200232003520027200352002a2002d2002e20033200322003320032200322003120000000000000000000000000000000000000000000000000000
