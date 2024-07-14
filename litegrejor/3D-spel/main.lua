-- pico 8 lua
-- fake 3d

function _init()
    fov = 64/360 -- field of view (% of circle)
    dir = 0 -- direction
    ang_speed = 0.01
    mov_speed = 0.5
    x,y = 5,5
    front_dst = 100
    back_dst = 100
    distances = {}

    -- 0 0 10 0
    -- 10 0 10 2
    -- 10 2 15 2
    -- 0 0 0 10
    -- 0 10 10 10
    -- 10 10 10 4
    -- 10 4 15 4
    
    -- 15 4 15 5
    -- 15 2 15 -2
    -- 17 -2 17 10
    -- 15 7 15 10
    -- 10 10 15 10
    -- 17 -2 15 -2

    lines = {
        {0,0,10,0},
        {10,0,10,2},
        {10,2,15,2},
        {0,0,0,10},
        {0,10,10,10},
        {10,10,10,4},
        {10,4,15,4},
        {15,4,15,5},
        {15,2,15,-2},
        {17,-2,17,10},
        {15,7,15,10},
        {10,10,15,10},
        {17,-2,15,-2}
    }
    
    coins = {
        
    }
end

function line_inter(lx0, ly0, lx1, ly1, x0, y0, x1, y1)
    -- Calculate direction vectors
    local lx, ly = lx1 - lx0, ly1 - ly0
    local dx, dy = x1 - x0, y1 - y0

    -- Calculate determinants
    local det = lx * dy - ly * dx
    if det == 0 then
        -- Lines are parallel
        return nil
    end

    -- Calculate intersection point
    local t = ((x0 - lx0) * dy - (y0 - ly0) * dx) / det
    local u = ((x0 - lx0) * ly - (y0 - ly0) * lx) / det

    -- Check if intersection is on the line segment and in the ray's direction
    if t >= 0 and t <= 1 and u >= 0 then
        local ix, iy = lx0 + t * lx, ly0 + t * ly
        -- Calculate distance from (x0, y0) to intersection point

        local distance = sqrt((ix - x0) ^ 2 + (iy - y0) ^ 2)
        return distance 
    else
        return nil
    end
end


function _update()
    -- turn left
    if btn(0) then
        dir += ang_speed
    end
    -- turn right
    if btn(1) then
        dir -= ang_speed
    end

    -- move forward
    if btn(2) and front_dst > 2 then
        x += cos(dir) * mov_speed
        y += sin(dir) * mov_speed
    end
    -- move backward
    if btn(3) and back_dst > 2 then
        x -= cos(dir) * mov_speed
        y -= sin(dir) * mov_speed
    end
end

function ray_dst(x,y,dir,lines)
    local dst = 100
    -- test intersection straight forward
    for i=1,#lines do
        local l = lines[i]
        local dstget = line_inter(l[1],l[2],l[3],l[4],x,y,x+cos(dir)*10,y+sin(dir)*10)

        if dstget then
            dst = min(dstget,dst)
        end
    end
    return dst
end

function _draw()
    cls()

    -- floor should be white
    rectfill(0,64,128,128,-10)

    -- ceil should be orange
    rectfill(0,0,128,64,4)
    
    local mid_dst = ray_dst(x,y,dir, lines)
    back_dst = ray_dst(x,y,dir+0.5, lines)
    local dst = 0
    for i=0,127 do
        local dirr = dir-fov/2+fov*i/128
        dst = ray_dst(x,y,dirr, lines)
        distances[i] = dst
        
        if dst < 100 then
            local h = 64/dst*10

            --rectfill(i,64-h/2,i,64+h/2,7)
            -- instead of rectfill, use sspr on sprite 2
            -- sprite is 16x16
            local sx = 8*2 + (i % 16)
            local sy = 0
            local sw = 1
            local sh = 16
            local dx = 127-i
            local dy = 64-h/2
            local dw = 1
            local dh = h
            sspr(sx,sy,sw,sh,dx,dy,dw,dh,2)
        end
    end

    -- draw coins
    for i=0,127 do
        local dirr = dir-fov/2+fov*i/128
        dst = ray_dst(x,y,dirr, coins)
        distances[i] = dst
        
        if dst < 100 then
            local h = (64/dst*10) * 0.25

            --rectfill(i,64-h/2,i,64+h/2,7)
            -- instead of rectfill, use sspr on sprite 2
            -- sprite is 16x16
            local sx = 8*4 + (i % 16)
            local sy = 0
            local sw = 1
            local sh = 16
            local dx = 127-i
            local dy = 64
            local dw = 1
            local dh = h
            sspr(sx,sy,sw,sh,dx,dy,dw,dh,2)
        end
    end

    local ox, oy = 2, 5
    local ms = 2
    --line end (direction)
    line((x+ox)*ms,(y+oy)*ms,(x+cos(dir)*4+ox)*ms,(y+sin(dir)*4+oy)*ms,8)
    
    --pset((x+ox)*ms,(y+oy)*ms,8)

    --print(mid_dst,0,127-8,8)
    -- draw lines
    for i=1,#lines do
        local l = lines[i]
        line(
            (l[1]+ox)*ms,
            (l[2]+oy)*ms,
            (l[3]+ox)*ms,
            (l[4]+oy)*ms,
            7)
    end

    -- sprite 4 is a coin

    --print(dst,0,0,8)
    front_dst = mid_dst
end