# SNICO-8

> 2024-07-02
> Gustav Lundgren och Oskar Sköld

## Hur går det till?

Spelet är en version av det populära spelet snake och går ut på att man har en orm som man styr med piltangenterna. Målet är att man ska fånga "maten" och om man gör det så ökar scoren. Varje block av ormen är en sprite så om ni vill kommer ni att kunna skapa egna sprites för att få erat spel unikt!

---

## Skapa spelet

### Ormen

Vi håller koll på ormen med hjälp av en lista av kordinater. Hela ritbilden i PICO-8 är uppyggd av ett kordinatsystem, vi hittar kordinaten (0, 0) hittar vi längst upp i det vänstra hörnet och kordinaten (128, 128) hittar vi längst ner i det högra hörnet.

För att kunna lagra ormen så kommer vi behöva veta vilka kordinater som alla delar av ormen har samt vilken riktning huvudet på ormen har. Riktningen kommer att avgöra vart vi kommer att placera näsata block för ormen. Samtidigt som vi gör detta kommer vi att ta bort det sista blocket av ormen för att ormen ska behålla sin storlek.

Allt inom matematiken har en invers, inversen är det som är den raka motsatsen till något. Exempelvis är höger en invers till väster och division är en invers av multiplikation


### Börja Koda!

Som vanligt kommer vi att börja koden med en init funktion för att skapa alla startvärden på variabler.

```lua
function _init()
    frame = 0
    board = {x=16, y=16}
    arr = {{x=1, y=3}, {x=2, y=3}, {x=3, y=3}, {x=4, y=3}}
    dir = {x=1, y=0}
    food = {x=8, y=8}
    has_eaten_food = false
    lost = false
end
```

**Röra på ormen**  
För att röra på ormen så behöver vi först skapa en del variabler för att kunna hålla koll på den.

```lua
function move_snake()
    local to_remove = arr[1]
    local head = {x=(arr[#arr].x + dir.x) % board.x, y = (arr[#arr].y + dir.y) % board.y}
    local has_eaten = false

    has_eaten_food = head.x == food.x and head.y == 0 food.y
end
```

Nu ska vi skapa de grundläggande funktionerna till ormens rörelse. Den första funktionen tar bort delen av ormen som är längst bak och lägger till en ny del längst fram i ormen.

```lua
function add_head_remove_tail(head)
    for i=1,#arr-1 do arr[i] = arr[i+1] end
    arr[#arr] = head
end
```



```lua
function re_add_tail(to_remove)
    for i=#arr,1,-1 do arr[i+1] = arr[i] end
    arr[1] = to_remove
end
```

Sista steget är att skapa en funktion som håller koll på om ormen träffar sig själv. Den fungerar genom att loopa igenom hela listan av ormens kropp och kolla om huvudet på ormen är på samma ställe som något av dem. Om huvudet är det så kommer man förlora. 

```lua
function snake_hit_itself()
    for i=1,#arr-1 do
        lost = (arr[i].x == arr[#arr].x and arr[i].y == arr[#arr].y) or lost
    end
end
```

Nu kan vi använda alla dessa funktioner i update för att få en fungerande rörelse för ormen.

```lua
function move_snake()
    local to_remove = arr[1]
    local head = {x=(arr[#arr].x + dir.x) % board.x, y = (arr[#arr].y + dir.y) % board.y}
    local has_eaten = false

    has_eaten_food = head.x == food.x and head.y == 0 food.y
    
    -- Här är den nya delen

    -- move snake 
    add_head_remove_tail(head)
    
    if has_eaten_food then
        re_add_tail(to_remove)
        spawn_food()
    end

    snake_hit_itself()
end
```

För att kunna ta input från spelaren så använder vi funktionen `btn()` som kollar om man trycker på någon av piltangenterna. 0 är vänster, 1 är höger, 2 är ner och 3 är upp. Vi använder detta för att ge en riktning till ormen. Vi kollar sedan om vi har förlorat och om vi inte har det så kör vi `move_snake()` för att ormen ska röra sig.

```lua
function _update()
    if btn(0) and dir.x ~= 1  then dir = {x=-1, y=0} end
    if btn(1) and dir.x ~= -1 then dir = {x=1, y=0}  end
    if btn(2) and dir.y ~= 1  then dir = {x=0, y=-1} end
    if btn(3) and dir.y ~= -1 then dir = {x=0, y=1}  end
    
    
    if frame % 5 == 0 and not lost then move_snake() end
    frame += 1
end
```

För att vi ska få fram något så måste vi avsluta våran skript med att rita ut all logik som vi precis har skapat. Detta gör vi med `_draw()` funktionen. Vi gör detta genom att först rensa skärmen varje frame, vi kommer sedan skriva ut lite statistik från spelet med hjälp av print. Vi använder listan med ormen för att loopa genom och rita kvadrater på varje kordinat i listan.

Vi gör även en kvadrat för att rita ut maten och en print för att man förlorade om `lost` variabeln är `true`.

```lua
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
```

Om du vill lägga in din egen sprite för huvudet så får du uppdatera `_draw()` funktionen till detta.

```lua
function _draw()
    cls()
    print("Size: " .. #arr, 0, 0, 7)
    
    for i=1,#arr do
        local s = arr[i]
        
        -- Huvud Sprite
        if i == #arr then spr(1, s.x*8, s.y*8)

        -- Resten av kroppen
        rect(s.x*8, s.y*8, s.x*8+8, s.y*8+8, 7)
    end
    
    rect(food.x*8, food.y*8, food.x*8+8, food.y*8+8, 8)

    if lost then
        print("You lost!", 60, 60, 7)
    end
end
```