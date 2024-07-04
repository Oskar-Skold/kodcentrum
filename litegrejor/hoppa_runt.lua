function _init()
    game_on = true
    gold_add = 15
    moves = 0
    score = 30
    max_score = score
    frame = 0
    colx = -1
    coly = -1
    wo = {}
    holes = {}

    predict = {}
    predict_index = 1
    
    pi = 3.1415

    -- initial values
    deg = 0.125
    llen = 25

    pos_x = 64
    pox_y = 64

    col = false
    col_type = "blue"

    px = 64
    py = 64
    camera_x = 64
    camera_y = 64

    camera_x0 = 64
    camera_y0 = 64
    camera_x1 = 64
    camera_y1 = 64
    camera_frame_start = -100
    camera_frame_end = -50 -- should not happen at start
    fade_frame_start = -100
    fade_frame_end = -50
    move_player = false

    -- set camera
    camera(camera_x - 64, camera_y - 64)
    for bx = -500,500,40 do
        for by = 0,500,40 do
            gen_random_wo(bx, bx + 40, by, by + 40, 12)
        end
    end

    for bx = -500,500, 120 do
        for by = 0,500,120 do
            gen_random_wo(bx, bx + 120, by, by + 120, 9)
        end
    end
end

function rand_range(minn, maxx)
    return flr(rnd(maxx - minn + 1)) + minn
end

function gen_random_wo(xmin, xmax, ymin, ymax, co)
    x0 = rnd(xmax - xmin) + xmin
    y0 = rnd(ymax - ymin) + ymin

    -- random degree, from 0 to 1
    degr = rnd(1)
    -- random length, from 4 to 30
    len = rand_range(4, 30)
    x1 = x0 + (len / 2) * cos(degr)
    y1 = y0 + (len / 2) * sin(degr)
    x2 = x0 + (len / 2) * cos(degr + 0.5)
    y2 = y0 + (len / 2) * sin(degr + 0.5)

    add_wo(x1, y1, x2, y2, co)
end

function add_wo(x0, y0, x1, y1, co)
    wo[#wo + 1] = {x = x0, y = y0, x1 = x1, y1 = y1, colo = co}
end

function draw_wo()
    for i = 1, #wo do
        line(wo[i].x, wo[i].y, wo[i].x1, wo[i].y1, wo[i].colo)   
        line(wo[i].x, wo[i].y+1, wo[i].x1, wo[i].y1+1, wo[i].colo)
    end
end

function draw_holes()
    for i = 1, #holes do
        circfill(holes[i].x, holes[i].y, 15, 0)
    end
end

function draw_line(x, y, arrow, length, color)
    -- draw a line, (0,0) -> (llen * cos(deg), llen * sin(deg))
    sx = x + length * cos(arrow)
    sy = y + length * sin(arrow)
    

    line(x, y, sx, sy, color)
    
    -- arrow pointers
    line(sx, sy, sx + 3 * cos(arrow + (0.5 - 0.125)), sy + 4 * sin(arrow + (0.5 - 0.125)), color)
    line(sx, sy, sx + 3 * cos(arrow - (0.5 - 0.125)), sy + 4 * sin(arrow - (0.5 - 0.125)), color)
end

function end_screen()
    cls()
    fade_frame_start = frame
    fade_frame_end = frame + 50
    
    print("Game over", camera_x - ((9 * 4 - 1)/2), camera_y-20, 7)
    print("Score: " .. max_score, camera_x - ((9 * 4 - 1)/2), camera_y - 10, 7)
end

function draw_throwprew(px, py, speed, angle)
    -- draw line
    

    -- for i = 0, 10 do
    vx_0 = speed * cos(angle)
    vy_0 = speed * sin(angle)

    co = 5

    -- has colided bool
    col = false
    predict = {}
    cou = 0
    for t = 0, 10,0.01 do
        cou += 1
        x = px + t * vx_0
        y = py + t * vy_0 + 0.5 * 9.82 * t * t
        --circ(x, y, 0, 7)
        -- if pixel at that position is 12, then make pixel red
        col_type = "none"
        predict[#predict + 1] = {x = x, y = y}
        if pget(x, y) == 12 then
            -- pset(x, y, 8)
            colx = x
            coly = y
            col = true
            col_type = "blue"
            break
        elseif pget(x, y) == 9 or pget(x, y) == 10 then
            -- pset(x, y, 8)
            colx = x
            coly = y
            col = true
            col_type = "gold"
            break
        else
            if cou % 10 == 0 then
                pset(x, y, co)
            end
        end
        
        -- break if distance to the player is too far
        if x - px > 300 or y - py > 300 then
            break
        end
    end

    draw_line(px + 0, py + 0, angle, speed, 8)
end

function draw_char(x, y)
    circfill(x, y, 3, 0)
    circ(x, y, 3, 8)
end

function animate_camera(xstart, ystart, xend, yend, frame_start, frame_end)
    if frame > frame_start and frame < frame_end then
        camera_x = xstart + (xend - xstart) * (frame - frame_start) / (frame_end - frame_start)
        camera_y = ystart + (yend - ystart) * (frame - frame_start) / (frame_end - frame_start)
        -- camera(xstart + (xend - xstart) * (frame - frame_start) / (frame_end - frame_start) - 64, ystart + (yend - ystart) * (frame - frame_start) / (frame_end - frame_start) - 64)
        camera(camera_x - 64, camera_y - 64)
    end
end

function get_cost()
    return flr((llen * llen) / 100)
end

function _draw()
    if game_on then
        cls()
        draw_wo()
        draw_holes()
        
        -- draw a small circle at the player, to not confuse with the line
        circfill(px, py, 4, 0)
        
        if not move_player then draw_throwprew(px, py, llen, deg) end
        
        draw_char(px, py)

        print("score:     " .. max_score, camera_x-64+1, camera_y - 64, 7)
        print("fuel:      " .. score,      camera_x-64+1, camera_y + 64-7, 7)
        print("move cost: " .. get_cost(),      camera_x-64+1, camera_y + 64-7-7, 7)
        
        -- draw a circle at col
        if col then
            circ(colx, coly, 3, 5)
        end
        
        if move_player then
            if predict_index == 1 then
                if pget(predict[#predict].x, predict[#predict].y) == 9 
                or pget(predict[#predict].x, predict[#predict].y) == 10
                then
                    -- add a hole of 5x5 pixels
                    -- holes[#holes + 1] = {x = predict[predict_index].x, y = predict[predict_index].y}
                end
                
            end
            -- move player to the predicted position
            px = predict[predict_index].x
            py = predict[predict_index].y
            predict_index += flr((#predict) / 30) -- approx 1 sek
            
            if predict_index > #predict - 1 then
                move_player = false
                predict_index = 1
                sfx(3)
                if col_type == "gold" then
                    score += gold_add
                    sfx(4)
                    holes[#holes + 1] = {x = colx, y = coly}
                end
                end
            end
            
            -- orange pixels (12) are gold, make 50% of all gold pixels to white
            -- xmin = camera_x - 64
            -- ymin = camera_y - 64
            if moves == 0 then
                print(" Use arrows to aim, ", camera_x - ((20 * 4 - 1)/2), camera_y+10, 7)
                print("Each move costs fuel", camera_x - ((20 * 4 - 1)/2), camera_y+10+7*1, 7)
                print("Gold gives you 15 fuel ", camera_x - ((20 * 4 - 1)/2), camera_y+12+7*2, 9)
                print("and looks like this", camera_x - ((20 * 4 - 1)/2),       camera_y+12+7*3, 9)
                print("press M to jump.", camera_x - ((20 * 4 - 1)/2),       camera_y+12+7*4, 7)
                
            end
            for x = camera_x - 64, camera_x + 64 do
                for y = camera_y - 64, camera_y + 64 do
                    if pget(x, y) == 9 then
                        if rnd(1) > 0.5 then
                            pset(x, y, 10)
                        end
                    end
                end
            end
            animate_camera(camera_x0, camera_y0, camera_x1, camera_y1, camera_frame_start, camera_frame_end)
            
            
    end
end    

function _update()
    -- move the line
    if btn(0) then 
        deg += 1 / 100 
        -- play sound 1
        sfx(1)
    end
    if btn(1) then 
        deg -= 1 / 100 
        sfx(1)
    end

    if btn(3) then 
        llen -= 1 
    end
    if btn(2) then 
        llen += 1 
    end

    -- make sure llen is at least 1
    if llen < 1 then llen = 1 end
    -- up
    if btn(5) and not move_player then
        moves += 1
        -- throw the player
        -- remove the cost
        score -= get_cost()
        move_player = true 
        precict_index = 1
        -- animate_camera(px, py, predict[#predict].x, predict[#predict].y, frame, frame + 30)
        camera_x0 = px
        camera_y0 = py
        camera_x1 = predict[#predict].x
        camera_y1 = predict[#predict].y
        camera_frame_start = 30 + frame
        camera_frame_end = 30 + frame + 30
        sfx(2)
    end
    if score < 0 then
        game_on = false
        end_screen()
        -- play tone 6
        sfx(6)
    end

    if btn(4) then
        _init()
    end
    max_score = max(max_score, score)
    frame += 1
end
