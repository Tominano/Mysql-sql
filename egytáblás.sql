-- Alap relációs algebra és SQL SELECT utasítás --
        --Egytáblás lekérdezések-- 

-- TÁBLA---
DROP TABLE SZERET; 

CREATE TABLE SZERET
    (NEV         VARCHAR2(15),
     GYUMOLCS    VARCHAR2(15));

INSERT INTO SZERET VALUES ('Malacka','alma');
INSERT INTO SZERET VALUES ('Micimackó','alma');
INSERT INTO SZERET VALUES ('Malacka','körte');
INSERT INTO SZERET VALUES ('Micimackó','körte');
INSERT INTO SZERET VALUES ('Kanga','körte');
INSERT INTO SZERET VALUES ('Tigris','körte');
INSERT INTO SZERET VALUES ('Micimackó','málna');
INSERT INTO SZERET VALUES ('Malacka','málna');
INSERT INTO SZERET VALUES ('Kanga','málna');
INSERT INTO SZERET VALUES ('Tigris','málna');
INSERT INTO SZERET VALUES ('Nyuszi','eper');
INSERT INTO SZERET VALUES ('Malacka','eper');

COMMIT; 
-------------------------------
-- 1. Kik szeretik az almát?
select distinct nev, gyumolcs
from szeret 
where gyumolcs = 'alma';

-- 2. Kik nem szeretik az almát? (de valami mást igen)
select nev, gyumolcs
from szeret
MINUS
select nev, gyumolcs
from szeret
where gyumolcs = 'alma';

-- 3. Kik szeretik vagy az almát vagy a körtét?
select nev, gyumolcs
from szeret
where gyumolcs = 'alma'
UNION
select nev, gyumolcs
from szeret
where gyumolcs = 'körte';

select nev, gyumolcs
from szeret
where gyumolcs = 'körte' or gyumolcs = 'alma';
-- 4. Kik szeretik az almát is és a körtét is?
select nev
from szeret
where gyumolcs = 'körte' 
INTERSECT
select nev
from szeret
where gyumolcs = 'alma';

-- 5. Kik azok, akik szeretik az almát, de nem szeretik a körtét?
select * from szeret
where nev in
(select nev from szeret
where gyumolcs = 'alma')
and gyumolcs != 'körte';

-- 6. Kik szeretik vagy az almát vagy a körtét, de csak az egyiket?
select nev from szeret
where gyumolcs = 'alma' or gyumolcs = 'körte'
GROUP by nev
HAVING count(nev)= 1 ;

-- 7. Kik szeretnek legalább kétféle gyümölcsöt?
select nev, gyumolcs
from szeret
where nev in(
select nev from szeret
group by nev
having count(nev) >= 2);

-- 8. Kik szeretnek legalább háromféle gyümölcsöt?
select nev, gyumolcs
from szeret
where nev in(
select nev from szeret
group by nev
having count(nev) >= 3);
-- 9. Kik szeretnek legfeljebb kétféle gyümölcsöt?
select nev, gyumolcs
from szeret
where nev in(
select nev from szeret
group by nev
having count(nev) <= 2);
--10. Kik szeretnek pontosan kétféle gyümölcsöt?  
select nev, gyumolcs
from szeret
where nev in(
select nev from szeret
group by nev
having count(nev) = 2);
--11. Kik szeretnek minden gyümölcsöt?
--    (Kik szeretik az összes olyan gyümölcsöt, amit valaki szeret?)
select nev from szeret
where nev in (select nev from szeret where (selec);
select max(count(gyumolcs)) from szeret group by gyumolcs);

--12. Kik azok, akik legalább azokat a gyümölcsöket szeretik, mint Micimackó?
select nev, gyumolcs from szeret 
where gyumolcs in (select gyumolcs from szeret where nev = 'Micimackó')
intersect
select nev, gyumolcs
from szeret
where nev in(
select nev from szeret
group by nev
having count(nev) >= 3);

--13. Kik azok, akik legfeljebb azokat a gyümölcsöket szeretik, mint Micimackó?
select nev, gyumolcs from szeret 
where gyumolcs in (select gyumolcs from szeret where nev = 'Micimackó');

--14. Kik azok, akik pontosan azokat a gyümölcsöket szeretik, mint Micimackó?
select nev, gyumolcs from szeret 
where gyumolcs in (select gyumolcs from szeret where nev = 'Micimackó') and
nev in(
select nev from szeret
group by nev
having count(*) = 3);