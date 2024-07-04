function _init()
    debug = false
    score = 0
    frm = 0     -- frame
    pl = {  show = true,
            x = 8*3,
            y = 0,
            sp = {1},
            speed = 10
    }
    
    coins = {}
    
    init_magic()
    init_coins()

    gravity = true
end

function _update()
    if pl.show then
        if btn(0) then move(-2, 0) end     
        if btn(1) then move( 2, 0) end

        if gravity then
            if btn(2) and check_map(0, 1, 0) then jmp = 4 end
            if btn(3) then move( 0, 2) end
            if frm % 1 == 0 then move(0, 4) end
        else
            if btn(2) then move(0, -2) end
            if btn(3) then move(0, 2) end
        end
    end
    
    if jmp > 0 then
        jmp -= 1
        move(0, -8)
    end

    -- check if player is on a coin
    for i=1, #coins do
        if coins[i].on then
            if pl.x == coins[i].x and pl.y == coins[i].y then
                coins[i].on = false
                score += coins[i].p
                sfx(0)
            end
        end
    end

    frm += 1
end

function _draw()
    cls()
    rectfill(cam.x-64,cam.y-64,cam.x+64,128,12)
    map()
    
    align_camera()
    
    rectfill(cam.x-64-16,cam.y+64-8*3,cam.x+64+16,cam.y+64,0)
    
    camera(cam.x-64, cam.y-64)
    
    for i=1, #coins do
        if coins[i].on then
            spr(get_spr_anim(coins[i]), coins[i].x, coins[i].y)
        else
            spr(4, coins[i].x, coins[i].y)
        end
    end
    if pl.show then p_draw() end
    
    if debug then
        printText("x: "..pl.x  .. ", ~" .. gethitb(pl.x, pl.y).gx        , 1,129-8*3, 7)
        printText("y: "..pl.y  .. ", ~" .. gethitb(pl.x, pl.y).gy        , 1,129-8*2, 7)

        printText("coin x: "..coins[1].x..", y: "..coins[1].y, 1, 129-8, 7)
    end

    printText("score: "..score, 1, 1, 7)
end