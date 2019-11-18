-- Alap relációs algebra és SQL SELECT utasítás --
        -- Többtáblás lekérdezések -- 
---------------------------------------------------
--Tábla------
DROP TABLE Fiz_Kategoria;
DROP TABLE Dolgozo;
DROP TABLE Osztaly;

ALTER SESSION SET NLS_DATE_LANGUAGE = ENGLISH;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

CREATE TABLE Osztaly
    (OAZON             NUMBER(2) NOT NULL,
     ONEV              VARCHAR2(14),
     TELEPHELY         VARCHAR2(13),
     CONSTRAINT OSZT_PK PRIMARY KEY (OAZON));

INSERT INTO Osztaly VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO Osztaly VALUES (20,'RESEARCH','DALLAS');
INSERT INTO Osztaly VALUES (30,'SALES','CHICAGO');
INSERT INTO Osztaly VALUES (40,'OPERATIONS','BOSTON');

CREATE TABLE Dolgozo
    (DKOD               NUMBER(4) NOT NULL,
     DNEV               VARCHAR2(10),
     FOGLALKOZAS        VARCHAR2(9),
     FONOKE             NUMBER(4) CONSTRAINT DOLG_SELF_KEY REFERENCES Dolgozo (DKOD),
     BELEPES            DATE,
     FIZETES            NUMBER(7,2),
     JUTALEK            NUMBER(7,2),
     OAZON              NUMBER(2),
     CONSTRAINT DOLG_FK FOREIGN KEY (OAZON) REFERENCES Osztaly (OAZON),
     CONSTRAINT DOLG_PK PRIMARY KEY (DKOD));

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
-------------------------------------------
-- 1.  Adjuk meg a dolgozók között előforduló foglalkozások neveit! (select lista)
select foglalkozas from dolgozo;

-- 2.  Adjuk meg a dolgozók között előforduló foglalkozások neveit (DISTINCT is),
--     az eredmény halmaz legyen, vagyis minden foglalkozást csak egyszer írjuk ki!
select distinct NVL(foglalkozas,'Ismeretlen') from dolgozo;

-- 3. Adjuk meg a dolgozók kódját, nevét és az éves fizetését, amikor kifejezést
--     használunk az oszlopnevek helyén, ott adjunk új oszlopnevet ("éves fizetés")
select dkod dolgozó_kódja, dnev név, fizetes+nvl(jutalek,0) éves_fizetes_jutalékkal from dolgozo;
   

-- 4. Kik azok a dolgozók, akiknek a fizetése > 2800? (kiválasztás, elemi feltétel)
select fizetes, dnev név from dolgozo where fizetes > 2800;

-- 5. Írjuk ki a 'KING' nevű dolgozó(k) adatait! (kar.tip.konstans megadása 'KING')
select * from dolgozo where dnev = 'KING';

-- 6. Kik azok a dolgozók, akiknek a fizetése 2000 és 4500 között van?
--     (1.mo: kiválasztás, összetett feltétel; 2.mo: where-ben: intervallum)
select * from dolgozo where fizetes between 2000 and 4500;

-- 7. Kik azok a dolgozók, akik a 10-es vagy a 20-as osztályon dolgoznak?
--     (1.mo: kiválasztás, összetett feltétel; 2.mo: where-ben: in értékek)
select * from dolgozo where oazon = 10 or oazon = 20;

-- 8. Adjuk meg azon dolgozókat, akik nevének második betűje 'A' (where: like)
select * from dolgozo where dnev like '_A%';

-- 9. Kik azok a dolgozók, akiknek a jutaléka nagyobb, mint 600?
select * from dolgozo where jutalek > 600;

--10. Kik azok a dolgozók, akiknek a jutaléka kisebb-vagy-egyenlő, mint 600?
select * from dolgozo where jutalek <= 600;

--11. Kik azok a dolgozók, akiknek a jutaléka ismeretlen (hiányzó adat, nincs kitöltve)
select * from dolgozo where jutalek is NULL;

--12. Kik azok a dolgozók, akiknek a jutaléka ismert (vagyis nem NULL)
select * from dolgozo where jutalek is not NULL;

--13. Listázzuk ki a dolgozókat foglalkozásonként, azon belül nevenként rendezve.
select * from dolgozo order by foglalkozas ASC; 

--14. Listázzuk ki a dolgozókat fizetés szerint csökkenőleg rendezve.
select * from dolgozo order by fizetes DESC;

--15. Kik azok a dolgozók, akiknek nincs főnöke?
select * from dolgozo
where fonoke is NULL;

--  16. Kik azok a dolgozók, akiknek a főnöke KING? 
select * from dolgozo
where fonoke in (select dkod from dolgozo where dnev = 'KING');

--  17. Adjuk meg azoknak a főnököknek a nevét, akiknek a foglalkozása nem 'MANAGER'.
select dnev from dolgozo
where fonoke not in(select dkod from dolgozo where foglalkozas = 'MANAGETR');

--  18. Adjuk meg azokat a dolgozókat, akik többet keresnek a főnöküknél.
select fizetes from dolgozo where (select fizetes from dolgozo) >        ---------------------------------
(select fizetes from dolgozo where dkod in (select fonoke from dolgozo));

--  19. Kik azok a dolgozók, akik főnökének a főnöke KING?
select dnev from dolgozo where select fizetes from dolgozo where dkod in (select fonoke from dolgozo);

--  20. Kik azok a dolgozók, akik osztályának telephelye DALLAS vagy CHICAGO?
select * from dolgozo
where oazon in 
(select oazon from osztaly 
where telephely = 'DALLAS' or telephely = 'CHICAGO');

--  21. Kik azok a dolgozók, akik osztályának telephelye nem DALLAS és nem CHICAGO?
select * from dolgozo
where oazon not in 
(select oazon from osztaly 
where telephely = 'DALLAS' or telephely = 'CHICAGO');

-- 22. Adjuk meg azoknak a nevét, akiknek a fizetése > 2000 vagy a CHICAGO-i osztályon dolgoznak.
select dnev from dolgozo
where fizetes > 2000 or
dolgozo.oazon in (select oazon from osztaly
where telephely = 'DALLAS');

--  23. Melyik osztálynak nincs dolgozója?

select onev from osztaly
where oazon not in (select distinct fizetes, kategoria
from fiz_kategoria f, dolgozo d
where fizetes in (select min(fizetes) from dolgozo where dkod in (select fonoke from dolgozo))
and d.fizetes between f.also and f.felso;

    select oazon from dolgozo where dkod is NULL);

--  24. Adjuk meg azokat a dolgozókat, akiknek van 2000-nél nagyobb fizetésű beosztottja.
select dnev from dolgozo where fizetes > 2000
minus
select dnev from dolgozo where dkod in(select fonoke from dolgozo);
--  25. Adjuk meg azokat a dolgozókat, akiknek nincs 2000-nél nagyobb fizetésű beosztottja.
select dnev from dolgozo where fizetes < 2000
minus
select dnev from dolgozo where dkod in(select fonoke from dolgozo);