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
