# CheatSheet Pico-8, Lua
Här har ni er nya bästa vän, en cheatsheet för Pico-8 och Lua. Här hittar ni allt ni behöver för att komma igång med att skapa spel i Pico-8.

## Innehållsförteckning
- [CheatSheet Pico-8, Lua](#cheatsheet-pico-8-lua)
  - [Innehållsförteckning](#innehållsförteckning)
  - [Kommentarer](#kommentarer)
  - [Variabler](#variabler)
      - [Variabeldeklaration](#variabeldeklaration)
      - [Öka / sänka värden.](#öka--sänka-värden)
  - [Villkor](#villkor)
      - [Lista över de vanligaste villkoren](#lista-över-de-vanligaste-villkoren)
      - [IF-sats:](#if-sats)
      - [If-else-sats:](#if-else-sats)
  - [Loopar](#loopar)
      - [For-loop:](#for-loop)
      - [while-loop:](#while-loop)
  - [Rita Funktioner](#rita-funktioner)
  - [Sprites](#sprites)
  - [Text](#text)
  - [Färghantering](#färghantering)
    - [Pico-8s Färgpalett](#pico-8s-färgpalett)
  - [Ljud](#ljud)
  - [Kartor](#kartor)
  - [Rörelse](#rörelse)
  - [Slump](#slump)
  - [Vanliga funktioner i Pico-8-spel](#vanliga-funktioner-i-pico-8-spel)
  - [Exempelprogram](#exempelprogram)
    - [Enkel Spel Loop](#enkel-spel-loop)

## Kommentarer
```lua
-- Det går att lägga till kommentarer i kod.
-- För att göra detta skriver man --, och sedan
-- texten man vill skriva som kommentar. 
-- Texten bakom strecken kommer inte att läsas in som kod.
```
## Variabler
####  Variabeldeklaration
Skapa en variabel x med värdet 10
```lua
x = 10 
```
---

Skapa en variabel med en text
```lua
name = "Alice"  
```

#### Öka / sänka värden.
```lua
x = x + 3  -- öka x med 3
x = x - 6  -- minska x med 6
```
 

## Villkor
#### Lista över de vanligaste villkoren
|lua villkor||beskrivning|
|-|-|-|
|```x == 10```|$=$   | x är lika med 10 ger true
|```x ~= 10```|$\neq$| ger true om x inte är lika med 10
|```x > 10``` |$>$   | ger true om x är större än 10
|```x >= 10```|$\geq$| ger true om x är större eller lika med 10
|```x < 10``` |$<$   | ger true om x är mindre än 10
|```x <= 10```|$\leq$| ger true om x är mindre eller lika med 10
|```x and y```|$\land$| ger true om både x och y är sanna
|```x or y``` |$\lor$ | ger true om x eller y är sanna, eller båda
|```not x```  |$\lnot$| ger true om x är falsk, annars false

#### IF-sats:
``` lua
if this then
  print("villkoret 'this' uppfylls")
```

#### If-else-sats:
```lua
if x > 5 then 
  print("x är större än 5") 
else
  print("x är mindre eller lika med 5") 
end 
```
## Loopar 
#### For-loop:
```lua
-- kommer att skriva ut 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
for i=1,10 do 
  print(i) 
end
```

#### while-loop:
```lua
while x > 0 do 
  print(x) 
  x = x - 1 
end 
```
## Rita Funktioner 
Rensar skärmen: 
```lua
cls()  
```
---

Sätt en pixel på position (x, y) till en specifik färg:
```lua
pset(x, y, color)
```

---
Rita en linje från (x0, y0) till (x1, y1) med en specifik färg:
```lua
line(x0, y0, x1, y1, color) 
```
---

Rita en cirkel med centrum (x, y) och radie med en specifik färg: 

```lua
circ(x, y, radius, color)  
```
---

Rita en fylld cirkel med centrum (x, y), radie och en specifik färg: 
```lua
circfill(x, y, r, [col])
```
---

Rita en oval inom rektangeln definierad av (x0, y0) till (x1, y1):
```lua
oval(x0, y0, x1, y1, [col])
```
---

Rita en fylld oval inom rektangeln definierad av (x0, y0) till (x1, y1):
```lua
ovalfill(x0, y0, x1, y1, [col])
```
---

Rita en rektangel från (x0, y0) till (x1, y1) med en specifikfärg:
```lua
rect(x0, y0, x1, y1, color) 
```
---

Rita en fylld rektangel från (x0, y0) till (x1, y1) med en specifik färg: 
```lua
rectfill(x0, y0, x1, y1, [col])   
```
## Sprites 
Rita ut sprite n på position ``(x, y)`` med bredd ``w``, höjd ``h``, och eventuellt ``flip_x`` och ``flip_y``. ``flip_x`` och ``flip_y`` är booleska värden som bestämmer om spriten ska spegelvändas horisontellt eller vertikalt.
```lua
spr(n, x, y, [w, h], [flip_x], [flip_y])  
```
## Text 
Skriva text på skärmen vid (x, y) med färg:
```lua
print("Hej världen!", x, y, color)
```
## Färghantering

### Pico-8s Färgpalett

![Färgpalett pico-8](https://img.itch.zone/aW1hZ2UvMjA4OTMzLzk3OTUzOC5wbmc=/original/8F3XSs.png)


Byta färg c0 till c1. Om p är satt, påverkar det specifik palett (0: skärmpalett, 1: ritat palett):
```lua
pal(c0, c1, [p])
```
Använda en tabell (array) av färgpar för att byta flera färger:
```lua
pal(tbl, [p])
``` 
Sätta genomskinlighet för färg c. Om t är sant, gör färgen genomskinlig; annars inte:
```lua
palt(c, [t])  
``` 
## Ljud 
Spela upp ljudeffekt n på kanal, startar vid offset och varar i längden:
```lua
sfx(n, [channel], [offset], [length])
``` 
## Kartor 
Rita kartan från cell (cell_x, cell_y) till skärmen vid (sx, sy) med bredd cell_w och höjd cell_h. Lagerspecifikationen avgör vilka lager som ska ritas:
```lua
map([cell_x], cell_y, [sx, sy], [cell_w, cell_h], [layers])  
``` 
## Rörelse 
```lua
function _update() 
  if btn(0) then  -- vänster 
    x = x - 1 
  end 

  if btn(1) then  -- höger 
    x = x + 1 
  end 

  if btn(2) then  -- upp 
    y = y - 1 
  end 

  if btn(3) then  -- ner 
    y = y + 1 
  end
end
``` 

## Slump 
Returnera ett slumpmässigt flyttal mellan 0 och x (eller 0 och 1 om x inte är angivet):
```lua 
rnd(x)
``` 
## Vanliga funktioner i Pico-8-spel 
```lua
function _init() 
  -- Detta körs en gång när spelet startar 
end 
``` 
```lua
 function _update() 
  -- Detta körs varje frame för att uppdatera spelet
  -- Ungefär 30 gånger per sekund 
end 
```
```lua
function _draw() 
  -- Detta körs 30 gånger per sekund för att rita spelet
  -- Skillnad från _update() är att _draw() inte uppdaterar spelet
end 
``` 
## Exempelprogram 

### Enkel Spel Loop 
``` lua
function _init() 
  x = 64 
  y = 64 
end 

function _update() 
    if btn(0) then 
        x = x - 1
    end

    if btn(1) then 
        x = x + 1 
    end
    
    if btn(2) then 
        y = y - 1 
    end 

    if btn(3) then 
        y = y + 1 
    end
end 

function _draw() 
  cls() 
  spr(1, x, y) 
end
``` 
