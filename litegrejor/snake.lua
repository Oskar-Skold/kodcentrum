-- for pico-8

function _init()
    frame = 0
    board = {x=16, y=16}
    arr = {{x=1, y=3}, {x=2, y=3}, {x=3, y=3}, {x=4, y=3}}
    dir = {x=1, y=0}
    food = {x=8, y=8}
    has_eaten_food = false
    lost = false
end

function re_add_tail(to_remove)
    for i=#arr,1,-1 do arr[i+1] = arr[i] end
    arr[1] = to_remove
end

function add_head_remove_tail(head)
    for i=1,#arr-1 do arr[i] = arr[i+1] end
    arr[#arr] = head
end

function snake_hit_itself()
    for i=1,#arr-1 do
        lost = (arr[i].x == arr[#arr].x and arr[i].y == arr[#arr].y) or lost
    end
end

function move_snake()
    local to_remove     = arr[1]
    local head           = {x=(arr[#arr].x+dir.x) % board.x, y=(arr[#arr].y+dir.y) % board.y}
    local has_eaten_food = false

    has_eaten_food = head.x == food.x and head.y == food.y
    
    -- move snake 
    add_head_remove_tail(head)
    
    if has_eaten_food then
        re_add_tail(to_remove)
        spawn_food()
    end

    snake_hit_itself()
end

function spawn_food() food = {x=flr(rnd(board.x)), y=flr(rnd(board.y))} end

function _update()
    if btn(0) and dir.x ~= 1  then dir = {x=-1, y=0} end
    if btn(1) and dir.x ~= -1 then dir = {x=1, y=0}  end
    if btn(2) and dir.y ~= 1  then dir = {x=0, y=-1} end
    if btn(3) and dir.y ~= -1 then dir = {x=0, y=1}  end
    
    
    if frame % 5 == 0 and not lost then move_snake() end
    frame += 1
end

function _draw()
    cls()
    print("Size: " .. #arr, 0, 0, 7)
    
    for i=1,#arr do
        local s = arr[i]
        rect(s.x*8, s.y*8, s.x*8+8, s.y*8+8, 7)
    end
    
    rect(food.x*8, food.y*8, food.x*8+8, food.y*8+8, 8)

    if lost then
        print("You lost!", 60, 60, 7)
    end
end