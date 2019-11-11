select * from termek
join nyomtato 
-másik táblából kiválasztjuk  ahozzátartozókat-
using (modell);

-pc modell amelynek sebessége legalább 3.00-
-háromértékű logika tuti lesz a zh ban-

select modell, ar
from PC
where sebesseg >=3.00;

-melyik gyártók készítenek legalább 100 GB méretű win laptopot-

select gyarto 
from termek natural join laptop
where merevlemez >= 100;