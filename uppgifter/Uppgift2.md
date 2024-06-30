# Steg-för-steg-instruktion för att skapa Fånga fyrkanten i Pico-8 

### Så här fungerar spelet: 

Spelaren styr en figur som ska försöka fånga ett fallande objekt genom att flytta sig till vänster och höger med piltangenterna. Varje gång spelaren fångar ett objekt, ökar deras poäng. Målet är att få så hög poäng som möjligt innan spelet är över. 

## Så här bygger du spelet: 

### Steg 1: Starta pico-8 och ta fram kod-editorn. 

### Steg 2: Skapa spelobjekten och variabler 

**Spelobjekt och variabler:** Vi behöver bestämma vad som ska vara med i vårt spel och vilka saker som kommer att röra sig på skärmen. 

**Spelobjekt:** Det är de olika delarna i spelet som spelaren kontrollerar och interagerar med. I vårt spel har vi två spelobjekt: spelaren och saken. 

**Variabler:** Dessa är som små lådor där vi kan spara information. Vi använder variabler för att komma ihåg saker som spelarens position och poäng. 

I vårt spel kommer vi att ha följande objekt och skapa variabler för dessa: 

**Spelaren:** Det är du! En vit fyrkant som du kan styra med pilarna. 

**Saken:** En annan röd fyrkant som kommer att falla neråt från skärmens topp. 

**Score:** Vi kommer också att hålla reda på hur många röda fyrkanter du fångar och att du får poäng för varje fyrkant som du har fångat. 

Börja med att skriva följande kod: 
```lua
function _init() 
  spelare_x = 60 
  spelare_y = 110 
  score = 0 
  sak_x = 60 
  sak_y = 0 
end 
```
**Förstå koden:** 

Varför vi ger variablerna deras värden: 

- spelare_x = 60 och spelare_y = 110: Vi sätter spelarens startposition till (60, 110) på skärmen. Det är där spelaren börjar. 

- poäng = 0: När spelet börjar, har du inte fångat några saker ännu, så din poäng är 0. 

- sak_x = 60 och sak_y = 0: Saken börjar falla från toppen av skärmen vid (60, 0). Vi börjar med att placera den där. 

### Steg 3: Uppdatera spelaren och kolla kollision 

#### Del 1: Styr spelaren 

**Styr Spelaren:** Vi behöver låta spelaren kunna röra sig vänster och höger på skärmen för att fånga saken när den faller. 

**Piltangenterna:** Genom att använda vänster eller höger piltangent, kan du styra spelarens position. Om vänsterpil trycks, flyttas spelaren vänster. Om högerpil trycks, flyttas spelaren höger. 

Fortsätt genom att skriva följande kod längst ned:
```lua
function _update()
    -- Flytta spelaren till vänster om du trycker på vänsterpil 
    if (btn(0)) then 
        spelare_x -= 1    
    end
    -- Flytta spelaren till höger om du trycker på högerpil 
    if (btn(1)) then 
        spelare_x += 1 
    end 
end 
```
#### Del 2: Låt saken falla och kolla kollision

**Låt saken falla:** Saken behöver börja falla neråt från toppen av skärmen så att spelaren kan försöka fånga den. Vi gör detta genom att se till så att Sakens y-position ökar med 1 varje gång ``` _update()``` körs, vilket får den att röra sig nedåt på skärmen. Uppdatera koden ```_update()```- funktionen så att det ser ut så här: 
```lua
function _update()
    -- Flytta spelaren till 	vänster om du trycker på vänsterpil
    if (btn(0)) then
        spelare_x -= 1 
    end
    -- Flytta spelaren till 	höger om du trycker på högerpil
    if (btn(1)) then 
        spelare_x += 1 
    end 

    sak_y += 1 -- Låt saken falla neråt 
end 
````
**Kolla kollision med saken:** Vi måste kontrollera om spelaren och saken är på samma plats för att öka poängen när de kolliderar. Uppdatera koden i ```_update()``` - funktionen: 

```lua
function _update()
    -- Flytta spelaren till 	vänster om du trycker på vänsterpil
    if (btn(0)) then
        spelare_x -= 1 
    end
    -- Flytta spelaren till 	höger om du trycker på högerpil
    if (btn(1)) then 
        spelare_x += 1 
    end 

    sak_y += 1 -- Låt saken falla neråt 

    -- Om spelaren fångar saken 
    if (sak_y > 105 and sak_x > spelare_x and sak_x < spelare_x + 8) 	then
        poäng += 1 
        sak_y = 0 
        sak_x = rnd(120) 
    end 

    -- Om saken når botten av skärmen 
    if (sak_y > 120) then 
        sak_y = 0 
        sak_x = rnd(120) 
    end 
end 
 ```
**Förstå koden:** Vi kollar om sakens y-position är nära spelarens y-position och om sakens x-position ligger inom spelarens x-position för att avgöra om de har kolliderat. 

**Återställ saken om den når botten:** Om saken når botten av skärmen, börjar den falla igen från en slumpmässig x-position. När saken når y-position 120, återställs dess position till toppen (y = 0) och en ny slumpmässig x-position väljs för den. 

### Steg 4: Rita Spelobjekten och Poängräknaren 

**Rita spelaren och saken:** Nu ska vi rita ut hur spelaren och saken ser ut på skärmen. 

**Vit kvadrat:** Spelaren ritas som en vit fyrkant. 

**Röd kvadrat:** Saken ritas som en rödfyrkant. 

**Visa poängen:** Vi ska också visa hur många saker du har fångat på skärmen. 

**Text på skärmen:** Poängen kommer att visas på skärmen så att du kan se hur bra du gör. 

Skriv längst ned i ditt program denna kod:
```lua
function _draw() 
    -- Rensa skärmen för att börja på nytt 
    cls()
    -- Ritar spelaren som en röd fyrkant 
    rectfill(spelare_x, spelare_y, spelare_x + 8, spelare_y + 8, 7) 
    -- Ritar saken som en röd fyrkant 
    rectfill(sak_x, sak_y, sak_x + 8, 
    sak_y + 8, 8) 
    --Visa score på skärmen
    print("Score: "..score, 0, 0) 
end 
```
### Steg 5: Prova ditt spel 

**Testa Ditt spel:** Nu är det dags att testa ditt spel! 

**Piltangenter:** Prova att använda vänster och höger pil för att flytta spelaren. 

**Fånga Saken:** Försök fånga saken när den faller neråt för att öka din poäng. 

**Ändra och Prova:** Om du vill ändra något, som hur snabbt saken faller eller hur stor spelaren är, kan du ändra i koden och testa igen. 

Det här är det grundläggande spelet! Du kan fortsätta att experimentera och göra det ännu mer roligt genom att lägga till ljud eller ändra färgerna på spelaren och saken. Ha roligt med din spelutveckling och var kreativ! 

#### Här är den fullständiga koden: 
```lua
function _init() 

  spelare_x = 60 
  spelare_y = 110 
  score = 0 
  sak_x = 60 
  sak_y = 0 

end 

function _draw() 

    cls()
    rectfill(spelare_x, spelare_y, spelare_x + 8, spelare_y + 8, 7) 
    rectfill(sak_x, sak_y, sak_x + 8, 
    sak_y + 8, 8) 
    print("Score: "..score, 0, 0) 

end 

function _update()

    if (btn(0)) then
        spelare_x -= 1 
    end
    if (btn(1)) then 
        spelare_x += 1 
    end

    sak_y += 1

    if (sak_y > 105 and sak_x > spelare_x and sak_x < spelare_x + 8) 	then
        poäng += 1 
        sak_y = 0 
        sak_x = rnd(120) 
    end 

    if (sak_y > 120) then 
        sak_y = 0 
        sak_x = rnd(120) 
    end 
    
end 
 ```