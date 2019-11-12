-- 1. Mennyi a legnagyobb fizetés a dolgozók között? (max) és a legkisebb? (min)

SELECT 
    MAX(fizetes) legmagasabbfizetes, MIN(fizetes) legalacsonyabbfizetes
FROM dolgozo;

-- 2. Mennyi a dolgozók összfizetése? (sum)

SELECT
    SUM(fizetes) osszesfizetes
FROM dolgozo;

-- 3. Adjuk meg, hogy hány különböző foglalkozás fordul elo a dolgozók között! (count)
SELECT
    COUNT(distinct(foglalkozas)) foglalkozások_száma
FROM dolgozo;

-- 4. Mennyi a 20-as osztályon az átlagfizetés? (avg)
SELECT
AVG(fizetes) átlagfizetes
FROM dolgozo
WHERE oazon = '20';
-- 5. Adjuk meg osztályonként az átlagfizetést! (csoportosítása: group by)
SELECT
round(AVG(fizetes),2) átlagfizetes, nvl(TO_CHAR(oazon),'NINCS OSZTÁLYA') osztályazonosító
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
select foglalkozas, dnev, fizetes
from dolgozo d1
where fizetes >= 
(select avg(fizetes) from dolgozo
where oazon = d1.oazon);


-- 4. Adjuk meg azokat a foglalkozásokat, amelyek csak egyetlen osztályon fordulnak elő,
--     és adjuk meg hozzájuk azt az osztályt is, ahol van ilyen foglalkozású dolgozó.
select nvl(oazon, 0), foglalkozas
from dolgozo
where foglalkozas in
    (select foglalkozas
    from dolgozo
    group by foglalkozas
    having count(oazon) <= 4);


-- 5. Adjuk meg osztályonként a legnagyobb fizetésu dolgozó(ka)t, és a fizetést.
select dnev , fizetes
from dolgozo
where fizetes in (
    select max(fizetes)
    from dolgozo
    group by oazon);
    
-- 6. Adjuk meg, hogy az egyes osztályokon hány ember dolgozik (azt is, ahol 0=senki).
select nvl(count(dkod), 0) dolgozók_száma, nvl(oazon, 0)
from dolgozo
group by oazon; 

-- 7. Adjuk meg azokat a fizetési kategóriákat, amelyekbe beleesik legalább három
--     olyan dolgozónak a fizetése, akinek nincs beosztottja.
select * from dolgozo, fiz_kategoria;

select kategoria
from fiz_kategoria, dolgozo
where (fizetes in (select fizetes from dolgozo where dkod in(
select dkod from dolgozo where dkod not in(
select dkod from dolgozo where dkod in (select fonoke from dolgozo))))) between fiz_kategoria.also and fiz_kategoria.felso;

-- 8. Adjuk meg a legrosszabbul kereső főnök fizetését, és fizetési kategóriáját.
select distinct fizetes, kategoria
from fiz_kategoria f, dolgozo d
where fizetes in (select min(fizetes) from dolgozo where dkod in (select fonoke from dolgozo))
and d.fizetes between f.also and f.felso;

-- 9. Adjuk meg, hogy (kerekítve) hány hónapja dolgoznak a cégnél azok a dolgozók,
--     akiknek a DALLAS-i telephelyű osztályon a legnagyobb a fizetésük.
select dkod, dnev, fizetes,
round(MONTHS_BETWEEN(sysdate,belepes),0) ledolgozott_hónapok_száma
from dolgozo d, osztaly o
where d.oazon = o.oazon
and o.telephely = 'DALLAS'
and fizetes = (select max(fizetes)
                from dolgozo d, osztaly o
                where d.oazon = o.oazon
                and o.telephely = 'DALLAS');
                
--10. Adjuk meg azokat a foglalkozásokat, amelyek csak egyetlen osztályon fordulnak elő,
--     és adjuk meg hozzájuk azt az osztályt is, ahol van ilyen foglalkozású dolgozó.

select oazon, foglalkozas
from dolgozo
where foglalkozas in
    (select foglalkozas
    from dolgozo
    group by foglalkozas
    having count(oazon) <= 4);
--11. Adjuk meg azoknak a dolgozóknak a nevét és fizetését, akik fizetése a 10-es és
--     20-as osztályok átlagfizetése közé esik. (Nem tudjuk, hogy melyik átlag a nagyobb!)

select dnev, fizetes
from dolgozo
where fizetes between (select round(avg(fizetes),2) from dolgozo where oazon = 10) and 
(select round(avg(fizetes),2) from dolgozo where oazon = 20);--- itt egynek kellene lennie

--12. Adjuk meg osztályonként a dolgozók összfizetését az osztály nevét megjelenítve
--     ONEV, SUM(FIZETES) formában, és azok az osztályok is jelenjenek meg ahol
--    nem dolgozik senki, ott az összfizetés 0 legyen. Valamint ha van olyan dolgozó,
--     akinek nincs megadva, hogy mely osztályon dolgozik, azokat a dolgozókat
--     egy 'FIKTIV' nevű osztályon gyűjtsük össze. Minden osztályt a nevével plusz
--     ezt a 'FIKTIV' osztált is jelenítsük meg az itt dolgozók összfizetésével együtt. 
select nvl(TO_CHAR(o.oazon),'NOT') oazon, nvl(onev,'FIKTIV') onev, nvl(sum(fizetes),0) SUMfizetes
from dolgozo d1 full join osztaly o on d1.oazon = o.oazon
group by o.oazon,onev;
----------------------------------------------------------------------------------------------------
-- A SZÜKSÉGES TÁBLA---

DROP TABLE Fiz_Kategoria;
DROP TABLE Dolgozo;
DROP TABLE Osztaly;

ALTER SESSION SET NLS_DATE_LANGUAGE = ENGLISH;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE TABLE Osztaly
    (OAZON             NUMBER(2) NOT NULL,
     ONEV              VARCHAR2(14),
     TELEPHELY         VARCHAR2(13));

INSERT INTO Osztaly VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO Osztaly VALUES (20,'RESEARCH','DALLAS');
INSERT INTO Osztaly VALUES (30,'SALES','CHICAGO');
INSERT INTO Osztaly VALUES (40,'OPERATIONS','BOSTON');

CREATE TABLE Dolgozo
    (DKOD               NUMBER(4) NOT NULL,
     DNEV               VARCHAR2(10),
     FOGLALKOZAS        VARCHAR2(9),
     FONOKE             NUMBER(4),
     BELEPES            DATE,
     FIZETES            NUMBER(7,2),
     JUTALEK            NUMBER(7,2),
     OAZON              NUMBER(2));

INSERT INTO Dolgozo VALUES (7839,'KING','PRESIDENT',NULL,'17-NOV-1981',5000,NULL,10);
INSERT INTO Dolgozo VALUES (7698,'BLAKE','MANAGER',7839,'1-MAY-1981',2850,NULL,30);
INSERT INTO Dolgozo VALUES (7782,'CLARK','MANAGER',7839,'9-JUN-1981',2450,NULL,10);
INSERT INTO Dolgozo VALUES (7566,'JONES','MANAGER',7839,'2-APR-1981',2975,NULL,20);
INSERT INTO Dolgozo VALUES (7654,'MARTIN','SALESMAN',7698,'28-SEP-1981',1250,1400,30);
INSERT INTO Dolgozo VALUES (7499,'ALLEN','SALESMAN',7698,'20-FEB-1981',1600,300,30);
INSERT INTO Dolgozo VALUES (7844,'TURNER','SALESMAN',7698,'8-SEP-1981',1500,0,30);
INSERT INTO Dolgozo VALUES (7900,'JAMES','CLERK',7698,'3-DEC-1981',950,NULL,30);
INSERT INTO Dolgozo VALUES (7521,'WARD','SALESMAN',7698,'22-FEB-1981',1250,500,30);
INSERT INTO Dolgozo VALUES (7902,'FORD','ANALYST',7566,'3-DEC-1981',3000,NULL,20);
INSERT INTO Dolgozo VALUES (7369,'SMITH','CLERK',7902,'17-DEC-1980',800,NULL,20);
INSERT INTO Dolgozo VALUES (7788,'SCOTT','ANALYST',7566,'09-DEC-1982',3000,NULL,20);
INSERT INTO Dolgozo VALUES (7876,'ADAMS','CLERK',7788,'12-JAN-1983',1100,NULL,20);
INSERT INTO Dolgozo VALUES (7934,'MILLER','CLERK',7782,'23-JAN-1982',1300,NULL,10);
INSERT INTO Dolgozo VALUES (7877,'LOLA','CLERK',7902,'12-JAN-1981',800,NULL,NULL);
INSERT INTO Dolgozo VALUES (7878,'BLACK',NULL,7902,'01-MAY-1987',1800,300,NULL);

CREATE TABLE Fiz_Kategoria (
 KATEGORIA          NUMBER,
 ALSO               NUMBER,
 FELSO              NUMBER);

INSERT INTO Fiz_Kategoria VALUES (1,700,1200);
INSERT INTO Fiz_Kategoria VALUES (2,1201,1400);
INSERT INTO Fiz_Kategoria VALUES (3,1401,2000);
INSERT INTO Fiz_Kategoria VALUES (4,2001,3000);
INSERT INTO Fiz_Kategoria VALUES (5,3001,9999);

COMMIT; 

GRANT SELECT ON Osztaly TO PUBLIC; 
GRANT SELECT ON Dolgozo TO PUBLIC;
GRANT SELECT ON Fiz_Kategoria TO PUBLIC;

ALTER SESSION SET NLS_DATE_LANGUAGE = HUNGARIAN;
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY.MM.DD';

SELECT * FROM Osztaly;
SELECT * FROM Dolgozo;
SELECT * FROM Fiz_Kategoria;

--DELETE
--  1. Töröljük azokat a dolgozókat, akiknek jutaléka NULL.
delete from dolgozo
where jutalek is NULL;
rollback;

--  2. Töröljük azokat a dolgozókat, akiknek a belépési dátuma 1982 előtti.
delete from dolgozo 
where belepes < '1982.01.01';
rollback;
--  3. Töröljük azokat a dolgozókat, akik osztályának telephelye DALLAS.
delete from dolgozo
where oazon in (
select oazon from osztaly where telephely = 'DALLAS');
rollback;
--  4. Töröljük azokat a dolgozókat, akiknek a fizetése kisebb, mint az átlagfizetés.
delete from dolgozo
where fizetes < (select avg(fizetes) from dolgozo);
rollback;
--  5. Töröljük ki azokat az osztályokat, akiknek van olyan dolgozója,  aki a 2-es
--      fizetési kategóriába esik (vagyis az alkérdésben adjuk meg azon osztályok
--      nevét, amelyeknek van olyan dolgozója,  aki a 2-es fizetési kategóriába esik)
delete from osztaly
where oazon in(
    select oazon from dolgozo, fiz_kategoria f where fizetes between f.also and f.felso and kategoria = 2);
rollback;

    
--  6. Töröljük ki azon osztályokat, amelyeknek 2 olyan dolgozója van, aki a 2-es
--      fizetési kategóriába esik.
delete from osztaly
where oazon in(
    select oazon 
    from dolgozo, fiz_kategoria f 
    where fizetes between f.also and f.felso 
    and kategoria = 2 
    group by oazon
    having count(*) >= 2);
rollback;


--INSERT
--  7. Vigyünk fel egy 'Kovacs' nevű új dolgozót a 10-es osztályra a következő
--      értékekkel: dkod=1, dnev='Kovacs', oazon=10, belépés=aktuális dátum,
--      fizetés=a 10-es osztály átlagfizetése. A többi oszop legyen NULL.
INSERT INTO dolgozo (dkod, dnev, oazon, belepes, fizetes) 
    VALUES (1, 'Kovacs', 10, '2019.10.11' ,(select avg(fizetes) from dolgozo where oazon = 10));
select * from dolgozo where belepes = '2019.10.11';

--  8. Több sor felvitele: Hozzunk létre egy UjOsztaly nevű táblát, amelynek
--      attribútumai megegyeznek az Osztály tábla oszlopaival, plusz van még egy
--      numerikus típusú Letszam nevű attribútuma. Ebbe az UjOsztaly táblába az
--      insert utasítás 2. alakjával (alkérdéssel ) vigyünk fel új sorokat az osztály és
--     dolgozó táblák aktuális tartalmának felhasználásával minden osztály adatát
--      kiegészítve az adott osztályon dolgozók létszámával. Azok az osztályok is
--     jelenjenek meg ahol nem dolgozik senki, ott a létszám 0 legyen. Továbbá
--      ha vannak olyan dolgozók, akiknek nincs (nem ismert) az osztályuk, azok
--      létszámát egy oazon=0, onev= 'FIKTIV' és telephely='ISMERETLEN'
--      adatokkal rendelkező sorba írjuk be.

--UPDATE
--  9. Növeljük meg a 20-as osztályon a dolgozók fizetését 20%-kal.
update dolgozo
set fizetes = fizetes*1.2 --ez kell hogy mit változtatunk meg
where oazon = 20;

--10. Növeljük meg azok fizetését 500-zal, akik jutaléka NULL vagy
 --     a fizetésük kisebb az átlagnál.
 update dolgozo
 set fizetes = fizetes + 500
 where jutalek is NULL or fizetes < (select avg(fizetes) from dolgozo);
 
--11. Növeljük meg mindenkinek a jutalékát a jelenlegi maximális jutalékkal.

update dolgozo
set jutalek = nvl(jutalek,0) +
(select max(jutalek) from dolgozo);

--12. Módosítsuk 'Loser'-re a legrosszabbul kereső dolgozó nevét.
update dolgozo
set dnev = 'Loser'
where fizetes in(
    select min(fizetes) from dolgozo);

--13. Növeljük meg azoknak a dolgozóknak a jutalékát 3000-rel, akiknek
--      legalább 2 közvetlen beosztottjuk van.
 --     Az ismeretlen (NULL) jutalékot vegyük úgy, mintha 0 lenne.
update dolgozo
set jutalek = nvl(jutalek,0) + 3000-- ha NULL akkor 0 nak vesszük
where dkod in
(select fonoke from dolgozo
group by fonoke
having count(*)>=2);

--14. Növeljük meg azoknak a dolgozóknak a fizetését, akiknek van olyan
--      beosztottja, aki minimális fizetéssel rendelkezik.
update dolgozo
set fizetes = fizetes +1000
where dkod in(select fonoke from dolgozo) and fizetes = (select min(also) from fiz_kategoria);

--15. Növeljük meg a nem főnökök fizetését a saját osztályuk átlagfizetésével.
update dolgozo
set fizetes = fizetes + (select avg(fizetes) from dolgozo d where d.oazon = oazon)
where dkod in(select fonoke from dolgozo);
