-- Main functions
-- pico-8

function _init()
 init_const()
 -- constants
 init_magic()
 -- magic
 initdyn()
 -- dynamic objects
end


function _update()
 domove() -- player movement

 if btnp(5) then
  debug_mode += 1
  debug_mode %= 3
 end

 -- dynamic object colisions
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
  health -= 1
  -- pl.active = false
  -- pl.show = false
 end

 if health < 1 then
  game_state = "gameover" end
   
 frm += 1
end

function _draw()
 cls()
 
 if game_state == "gameover" then
  printText("game over", 64 - (4*4), 20, 7)
  return 0
 end

 render_frame()

 printText("score: " .. score, 1, 9, 7)
 dsp_health()

 if debug_mode == 1 then debug_coords() end
 if debug_mode == 2 then debug_cols() end

 updatedyn()
end