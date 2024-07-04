-- Some cool platformer stuff
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

function printText(txt,x,y,c)
    print(txt,cam.x+x-64,cam.y+y-64,c)
end

function anim(obj)
    
    return obj.sp[((flr(frm/obj.an_speed))%#obj.sp)+1]
end
