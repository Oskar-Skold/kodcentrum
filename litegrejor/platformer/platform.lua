-- pico-8
function init_magic()
    cam = {x = pl.x, y = pl.y}
    jmp = 0 -- each num is 4px
end

function init_coins()
    cls()
    map()
    
    -- get all coins (sprite 6)
    for x=0,127 do
        for y=0,127 do
            if mget(x,y) == 6 then
                add(coins, {x = x*8, y = y*8, on=true,p=10,sp={6,7},speed=10})
            end
        end
    end
    cls()
end

function move(dx, dy)
    if abs(dx) > 0 then
        if not check_map(sgn(dx), 0, 0) then
            pl.x += dx
        else
            pl.x = gethitb(pl.x, pl.y).gx*8
        end
    end

    if abs(dy) > 0 then
        if not check_map(0, sgn(dy), 0) then
            pl.y += dy
        else
            pl.y = gethitb(pl.x, pl.y).gy*8
        end
    end
end

function gethitb(x,y) return {gx = flr((x+4)/8), gy = flr((y+4)/8)} end

function p_draw()
    spr(
        get_spr_anim(pl),
        pl.x, pl.y)

    local hb = gethitb(pl.x, pl.y)
    
    if debug then rect(hb.gx*8, hb.gy*8, hb.gx*8+7, hb.gy*8+7, 8) end
end

function check_map(dx,dy,fl)
    local hb = gethitb(pl.x,pl.y)
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

function get_spr_anim(obj)
    return obj.sp[((flr(frm/obj.speed))%#obj.sp)+1]
end
