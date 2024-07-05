-- Main functions
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
  printText("x: " .. pl.x .. ", ~" .. hitb(pl.x, pl.y).gx, 1, 129 - 8 * 3, 7)
  printText("y: " .. pl.y .. ", ~" .. hitb(pl.x, pl.y).gy, 1, 129 - 8 * 2, 7)
 end

 printText("score: " .. score, 1, 1, 7)
 
 updatedyn()
end