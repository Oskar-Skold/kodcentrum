-- Dynamic objects
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
    st = {"LEFT", "RIGHT", "UP", "DOWN"}
    
    --printText("lowest:"..st[lowest], 1, 128-7, 7)
    
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
  --printText("LEFT", 1, 128-16, 7)
  movedyn(obj_ind, -1 * o.speed, 0)
 elseif nearest == 2 then
  --printText("RIGHT", 1, 128-16, 7)
  movedyn(obj_ind, 1 * o.speed, 0)
 elseif nearest == 3 then
  --printText("UP", 1, 128-16, 7)
  if gravity then
   movedyn(obj_ind, 0, -6 * o.speed)
  else
   movedyn(obj_ind, 0, -1 * o.speed)
  end
 elseif nearest == 4 then
  --printText("DOWN", 1, 128-16, 7)
  movedyn(obj_ind, 0, 0 * o.speed)
 end
end