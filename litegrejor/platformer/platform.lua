-- Some cool platformer stuff
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

function printText(txt, x, y, c)
 print(txt, cam.x + x - 64, cam.y + y - 64, c)
end

function anim(obj)
 return obj.sp[flr(frm / obj.an_speed) % #obj.sp + 1]
end

function debug_coords()
 printtext("debug mode 1", 1, 129 - 8, 7)
 printText("x: " .. pl.x .. ", ~" .. hitb(pl.x, pl.y).gx, 1, 129 - 8 * 3, 7)
 printText("y: " .. pl.y .. ", ~" .. hitb(pl.x, pl.y).gy, 1, 129 - 8 * 2, 7)
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
