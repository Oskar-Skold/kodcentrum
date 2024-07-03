function _init()
	x=60
	y=60
	frame = 1
	
	start_frame = 0
	n_frames = 4
end

function _draw()

 if frame % 4 == 0 then
  cls()
  sprite = (frame / 4) + start_frame
  spr(sprite,x,y)
 end
 
 if frame == 16 then
 	frame = 1
 else 
  frame += 1
 end
end