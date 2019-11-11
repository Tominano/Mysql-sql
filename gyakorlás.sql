-- 1. Mennyi a legnagyobb fizetés a dolgozók között? (max) és a legkisebb? (min)

SELECT 
    MAX(fizetes) legnagyobb, MIN(fizetes) legkisebb
FROM dolgozo;

-- 2. Mennyi a dolgozók összfizetése? (sum)

SELECT
    SUM(fizetes) osszesfizetes
FROM dolgozo;

-- 3. Adjuk meg, hogy hány különböző foglalkozás fordul elo a dolgozók között! (count)
SELECT
    COUNT(foglalkozas)
FROM dolgozo;

-- 4. Mennyi a 20-as osztályon az átlagfizetés? (avg)
SELECT
AVG(fizetes) átlagfizetes
FROM dolgozo
WHERE oazon = '20';
-- 5. Adjuk meg osztályonként az átlagfizetést! (csoportosítása: group by)
SELECT
round(AVG(fizetes),2) átlagfizetes, nvl(oazon, 0) osztályazonosító
from dolgozo
GROUP BY oazon;
-- 6. Adjuk meg azokra az osztályokra az átlagfizetést, ahol ez nagyobb mint 2000.

select oazon, round(avg(fizetes),2)
from dolgozo
group by oazon
having round(avg(fizetes),2) > 2000;

-- 7. Melyek azok az osztályok, ahol legalább hárman dolgoznak és mennyi az itt
--     dolgozók átlagfizetése?

SELECT
    oazon osztályok, round(AVG(fizetes),2) átlagfizetés
FROM dolgozo
group by oazon
having count(dkod)>=3;

-- 8. Adjuk meg osztályonként az ott dolgozó hivatalnokok (FOGLALKOZAS='CLERK')
--     átlagfizetését, de csak azokon az osztályokon, ahol legalább két hivatalnok dolgozik!

SELECT
    oazon osztályazonosító, AVG(fizetes) átlagfizetés
FROM dolgozo
where foglalkozas = 'CLERK'
group by oazon
HAVING count(dkod)>=2;

-- 9. Adjuk meg osztályonként a minimális fizetést, de csak azokat az osztályokét, ahol
--    a minimális fizetés nagyobb, mint a 30-as osztályon dolgozók minimális fizetése.

select oazon, min(fizetes)
from dolgozo
GROUP by oazon
having min(fizetes) > 
(select min(fizetes)
    from dolgozo
    where oazon = 30);
    
--10. Adjuk meg a legmagasabb osztályonkénti átlagfizetést!
select nvl(oazon, 0) oazon, max(fizetes) fizetes
from dolgozo
group by oazon;


--FELADATSOR-A/5.rész: dolgozo, osztaly (több táblára teljes select utasítás)
-- 1. Adjuk meg osztályonként a telephelyet és az átlagfizetést.

select telephely, oazon, round(avg(fizetes),2)
from dolgozo NATURAL JOIN osztaly
group by oazon, telephely;

-- 2. Kik azok és milyen munkakörben dolgoznak a legnagyobb fizetésű dolgozók?

select nvl(foglalkozas, 'Nem Ismert'), fizetes
from dolgozo
where fizetes in(
select max(fizetes)
from dolgozo
group by oazon);


-- 3. Adjuk meg, hogy mely dolgozók fizetése jobb, mint a saját osztályán (vagyis
--     azon az osztályon, ahol dolgozik az ott) dolgozók átlagfizetése!
-- 4. Adjuk meg azokat a foglalkozásokat, amelyek csak egyetlen osztályon fordulnak elő,
--     és adjuk meg hozzájuk azt az osztályt is, ahol van ilyen foglalkozású dolgozó.
-- 5. Adjuk meg osztályonként a legnagyobb fizetésu dolgozó(ka)t, és a fizetést.
-- 6. Adjuk meg, hogy az egyes osztályokon hány ember dolgozik (azt is, ahol 0=senki).
-- 7. Adjuk meg azokat a fizetési kategóriákat, amelyekbe beleesik legalább három
--     olyan dolgozónak a fizetése, akinek nincs beosztottja.
-- 8. Adjuk meg a legrosszabbul kereső főnök fizetését, és fizetési kategóriáját. 
-- 9. Adjuk meg, hogy (kerekítve) hány hónapja dolgoznak a cégnél azok a dolgozók,
--     akiknek a DALLAS-i telephelyű osztályon a legnagyobb a fizetésük.
--10. Adjuk meg azokat a foglalkozásokat, amelyek csak egyetlen osztályon fordulnak elő,
--     és adjuk meg hozzájuk azt az osztályt is, ahol van ilyen foglalkozású dolgozó.
--11. Adjuk meg azoknak a dolgozóknak a nevét és fizetését, akik fizetése a 10-es és
--     20-as osztályok átlagfizetése közé esik. (Nem tudjuk, hogy melyik átlag a nagyobb!)
--12. Adjuk meg osztályonként a dolgozók összfizetését az osztály nevét megjelenítve
--     ONEV, SUM(FIZETES) formában, és azok az osztályok is jelenjenek meg ahol
--    nem dolgozik senki, ott az összfizetés 0 legyen. Valamint ha van olyan dolgozó,
--     akinek nincs megadva, hogy mely osztályon dolgozik, azokat a dolgozókat
--     egy 'FIKTIV' nevű osztályon gyűjtsük össze. Minden osztályt a nevével plusz
--     ezt a 'FIKTIV' osztált is jelenítsük meg az itt dolgozók összfizetésével együtt. 