select * from sörök;
select * from hr.employees;

select * from sila.szeret;
-- ha nincsen táblám akkor a sila.'keresett tábla' megtalálom --
select dkod, dnev from dolgozo;
select distinct foglalkozas from dolgozo;

select * from dolgozo
where fizetes>=2800 and fizetes <=4500;

select * from dolgozo
where fizetes between 2000 and 4800;

-- Az elözö kettő ugyanaz--

select * from dolgozo
where dnev = 'KING';
-- Táblatartalomnál fontos, hogy nagy vagy kis betü--

select * from dolgozoselect * from dolgozo
where oazon=10 or oazon=20;

select * from dolgozo
where oazon in (10,20);
-- ez a kettő  is ugyan az
select * from dolgozo
where dnev like 'S%';
-- a % tetszőleges karaktert helyettesít, csak azt tudom hogy s-el kezdődik
select * from dolgozo
where dnev like '_A%';
-- itt a második A betű--

select * from dolgozo
where jutalek >600 or jutalek <=600;
--Ahol nincsen kitöltve ode nem a két érték közül ad, hanem egy harmadikat