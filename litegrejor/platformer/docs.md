Hur lägger jag till ett event som körs när ett dynamiskt objekt nuddar spelaren? `coldyn` gör exakt detta!

exempel på en colision med en dynamisk objekt:
```lua
-- dynamic object colisions
 coin_col = coldyn("coin")
 if coin_col > -1 then
  score += objs[coin_col].p
  sfx(0)
  objs[coin_col].active = false
  objs[coin_col].show = false
 end
```
notera att detta också kräver att det finns ett objekt med namnet "coin" i spelet. Alltså detta innuti `stand_objs`:

```lua
{
   tag = "coin",
   sp = {6,7}, -- de sprites som ska användas
   active = true, -- om objektet är aktivt
   show = true,   -- om objektet ska visas
   p = 10,        -- poängen som spelaren får när den plockar upp objektet
   an_speed = 10, -- animation speed
   speed = 0,     -- hastigheten på objektet
   moveable = false -- om objektet kan röra sig (alltså med simpel AI)
  }
  ```



## Exempel på game over:

Längst upp i draw, under ``cls()`` så kan man skriva detta:

```lua
 if game_state == "gameover" then
  printText("game over", 64 - (4*4), 20, 7)
  return 0
 end
```

notera att
```lua
 if health < 1 then
  game_state = "gameover"
 end
```
måste finnas i update för att det ska fungera.



