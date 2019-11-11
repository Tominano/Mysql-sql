-Ki szereti csak az almát-

select nev from szeret
minus
select nev from szeret
where gyumolcs = 'alma';

-Másik megoldás-

select nev from szeret
where nev not in 
(select nev from szeret
where gyumolcs = 'alma');

-Vagy az almát vagy a körtét-
select nev from szeret
where gyumolcs = 'körte'
union
select nev from szeret
where gyumolcs = 'alma'

-Egyszerűbb-
select distinct nev from szeret
where gyumolcs = 'alma' or gyumolcs = 'körte';

select distinct nev from szeret
where gyumolcs in ('alma','körte');

-alma és körte is-

select nev from szeret
where gyumolcs = 'körte'
intersect
select nev from szeret
where gyumolcs = 'alma';

-szorzással is megoldhatom-
-s1,s2 nem lehet ugyanabban a sorban 2 gyümölcs igy szétszedem hogy össze tudjam hasonlítani-

select s1.nev from szeret s1, szeret s2
where s1.nev=s2.nev and
s1.gyumolcs = 'alma' and s2.gyumolcs ='körte';

select * from szeret
where nev in
(select nev from szeret
where gyumolcs = 'alma')
and gyumolcs = 'körte';

-szereti az almát de a körtét nem-

select * from szeret
where nev not in
(select nev from szeret
where gyumolcs = 'alma')
and gyumolcs = 'körte';

-Legalább kétféle gyümölcs-

select distinct s1.nev from szeret s1, szeret s2
where s1.nev=s2.nev and
s1.gyumolcs <> s2.gyumolcs;
