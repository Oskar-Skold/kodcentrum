# Uppgift 1 - Circles and squares in outer space🚀✨ 

## Lär dig koda geometriska former i PICO-8 

### Introduktion 

Vi ska nu lära oss att koda geometriska former som rör sig och ändrar färg i PICO-8. Följ med steg för steg för att skapa ett program där geometriska former ändrar form och färg och rör sig slumpmässigt! 

### Steg 1: Rita en cirkel 

Vi börjar med att rita en cirkel på skärmen. 

I pico-8, ta fram kod-editorn och börja med att skriva följande kod: 
```lua
function _init() 
    -- skapa variabler för cirkel 1 
    c1_x = 64 
    c1_y = 64 
    c1_r = 10 
    c1_color = 8 
end 
 
function _draw() 
    -- Rensa skärmen med svart färg och rita ut cirkel 1 
    cls() 
    circfill(c1_x, c1_y, c1_r, color) 
end 
```

**Förstå koden** 

- ``` function _init() ``` Den här delen körs en gång när spelet startar. Här skapar vi våra variabler för cirkel 1.

- ```function _draw()``` Den här delen ritas om och om igen. Vi ritar cirkeln 1 här. 

### Steg 2: Ändra cirkelns position 

Nu ska vi få cirkel 1 att röra sig slumpmässigt. Lägg till följande kod längst ned: 
```lua
function _update() 
    -- Ändra positionen för cirkel 1 slumpmässigt 
    c1_x = c1_x + rnd({-1, 1}) 
    c1_y = c1_y + rnd({-1, 1}) 
end 
```

**Förstå koden** 

- ```function _update()``` Den här delen körs 30 gånger per sekund och uppdaterar spelets logik. 

- ```rnd({-1, 1})``` Ger oss antingen -1 eller 1 slumpmässigt, vilket gör att cirkel 1 rör sig lite i varje riktning. 

### Steg 3: Byt form och färg 

Nu ska vi få cirkeln 1 att ändra form och färg slumpmässigt. Uppdatera koden i  ```_update-funktionen``` så här: 

```lua
function _update() 
    -- Ändra positionen för cirkel 1 slumpmässigt
    c1_x = c1_x + rnd({-1, 1}) 
    c1_y = c1_y + rnd({-1, 1}) 
     
    -- Ändra radien på cirkel 1 slumpmässigt 
    c1_r = c1_r + rnd({-1, 1}) 
     
    -- Ändra färgen på cirkel 1 slumpmässigt 
    c1_color = flr(rnd(16)) 
end 
```

**Förstå koden** 
- ```r = r + rnd({-1, 1})``` Ändrar radien på cirkeln slumpmässigt. 

- ```color = flr(rnd(16))``` Ändrar färgen på cirkeln till en slumpmässig färg från PICO-8s färgpalett. 

### Steg 4: Lägg till fler former 

Låt oss lägga till en fyrkant också! Ändra ```_init-funktionen``` för att lägga till variabler för fyrkanten:

```lua
function _init() 
    -- skapa variabler för cirkel 1 
    c1_x = 64 
    c1_y = 64 
    c1_r = 10 
    c1_color = 8 

    -- skapa variabler för fyrkant 1 
    sq1_x = 32 
    sq1_y = 32 
    sq1_size = 10 
    sq1_color = 9 
end 
```

Ändra i ```_draw-funktionen``` för att rita fyrkant 1: 

```lua
function _draw() 
    -- Rensa skärmen med svart färg 
    cls() 
        
    -- Rita ut cirkel 1 
    circfill(c1_x, c1_y, c1_r, c1_color) 
        
    -- Rita ut fyrkant 1 
    rectfill(sq1_x, sq1_y, sq1_x + sq1_size, sq1_y + sq1_size, sq1_color) 
end 
```
Uppdatera koden i  _update-funktionen för att ändra  position, storlek och färg på fyrkant 1 slumpmässigt: 

```lua
function _update() 
-- Ändra positionen för cirkel 1 slumpmässigt 
    c1_x = c1_x + rnd({-1, 1}) 
    c1_y = c1_y + rnd({-1, 1}) 
        
    -- Ändra radien på cirkel 1 slumpmässigt 
    c1_r = c1_r + rnd({-1, 1}) 
        
    -- Ändra färgen på cirkel 1 slumpmässigt 
    c1_color = flr(rnd(16)) 
        
    -- Ändra position på fyrkant 1 slumpmässigt 
    sq1_x = sq1_x + rnd({-1, 1}) 
    sq1_y = sq1_y + rnd({-1, 1}) 
        
    -- Ändra storlek på fyrkant 1 slumpmässigt 
    sq1_size = sq1_size + rnd({-1, 1}) 
        
    -- Ändra färg på fyrkant 1 slumpmässigt 
    sq1_color = flr(rnd(16)) 
end 
```

### Slutresultat 

Nu har du ett program där både en cirkel och en fyrkant ändrar form, färg och position slumpmässigt! Testa att köra programmet genom att trycka på "Run". 

Här kommer koden i sin helhet: 
````lua
function _init() 
    -- skapa variabler för cirkel 1 
    c1_x = 64 
    c1_y = 64 
    c1_r = 10 
    c1_color = 8 

    -- skapa variabler för fyrkant 1 
    sq1_x = 32 
    sq1_y = 32 
    sq1_size = 10 
    sq1_color = 9 
end 

function _draw() 
    -- Rensa skärmen med svart färg 
    cls() 
        
    -- Rita ut cirkel 1 
    circfill(c1_x, c1_y, c1_r, c1_color) 
        
    -- Rita ut fyrkant 1 
    rectfill(sq1_x, sq1_y, sq1_x + sq1_size, sq1_y + sq1_size, sq1_color) 
end

function _update() 
-- Ändra positionen för cirkel 1 slumpmässigt 
    c1_x = c1_x + rnd({-1, 1}) 
    c1_y = c1_y + rnd({-1, 1}) 
        
    -- Ändra radien på cirkel 1 slumpmässigt 
    c1_r = c1_r + rnd({-1, 1}) 
        
    -- Ändra färgen på cirkel 1 slumpmässigt 
    c1_color = flr(rnd(16)) 
        
    -- Ändra position på fyrkant 1 slumpmässigt 
    sq1_x = sq1_x + rnd({-1, 1}) 
    sq1_y = sq1_y + rnd({-1, 1}) 
        
    -- Ändra storlek på fyrkant 1 slumpmässigt 
    sq1_size = sq1_size + rnd({-1, 1}) 
        
    -- Ändra färg på fyrkant 1 slumpmässigt 
    sq1_color = flr(rnd(16)) 
end

````
 

## Utmaning ⭐ 
- Testa att ändra startvärdena på variablerna för de olika formerna för att se vad som händer.

- Kan du lägga till ytterligare en cirkel och en fyrkant som ändrar färg och form i ditt program? experimentera med olika PICO-8-funktioner som line, tri, och pset. 