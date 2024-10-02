/*=============================== Exercice SQL 3 =======================*/
/*Exercice 2.a.ii*/

/*1)	Quels sont les noms des auteurs habitant la ville de Oakland ?*/
SELECT DISTINCT a.au_lname AS Nom_auteurs
FROM authors a
WHERE city = 'Oakland';

--2)Donnez les noms et adresses des auteurs dont le prénom commence par la lettre "A".
SELECT a.au_id, a.au_lname, a.address
FROM authors a
WHERE a.au_fname LIKE 'A%';

--3)	Donnez les noms et adresses complètes des auteurs qui n'ont pas de numéro de téléphone.
SELECT a.au_id,a.au_fname, a.address,a.city,a.state,a.country
FROM authors a
WHERE a.phone IS NULL;

--4)	Y a-t-il des auteurs californiens dont le numéro de téléphone ne commence pas par "415" ?
SELECT a.au_id, a.au_lname, a.au_fname, a.phone, a.address, a.city, a.state, a.country
FROM authors a
WHERE a.state = 'CA'
AND a.phone NOT LIKE '415%';

--5)	Quels sont les auteurs habitant au Bénélux ?
SELECT a.au_id, a.au_lname, a.au_fname, a.phone, a.address, a.city, a.state, a.country
FROM authors a
WHERE a.country = 'BEL'
OR a.country = 'LUX'
OR a.country = 'NED';

--6)	Donnez les identifiants des éditeurs ayant publié au moins un livre de type "psychologie" ?
SELECT DISTINCT ti.pub_id
FROM titles ti
WHERE ti.type = 'psychology';

--7)	Donnez les identifiants des éditeurs ayant publié au moins un livre de type "psychologie", si l'on omet tous les livres dont le prix est compris entre 10 et 25 $ ?
SELECT DISTINCT ti.pub_id
FROM titles ti
WHERE ti.type = 'psychology'
AND ((ti.price > 10.00)
AND (ti.price < 25.00));

--8)	Donnez la liste des villes de Californie où l'on peut trouver un (ou plusieurs) auteur(s) dont le prénom est Albert ou dont le nom finit par "er".
SELECT DISTINCT au.city
FROM authors au
WHERE au.state = 'CA'
AND ((upper(au.au_fname) LIKE 'ALBERT')
OR (upper(au.au_lname) LIKE '%ER'))
AND au.city IS NOT NULL;

--9)	Donnez tous les couples Etat-pays ("state" - "country") de la table des auteurs, pour lesquels l'Etat est fourni, mais le pays est autre que "USA".
SELECT DISTINCT au.state,au.country
FROM authors au
WHERE au.country != 'USA'
AND au.state IS NOT NULL;

--10)	Pour quels types de livres peut-on trouver des livres de prix inférieur à 15 $ ?
SELECT DISTINCT ti.type
FROM titles ti
WHERE ti.price < 15.00
AND ti.type IS NOT NULL;

--Exercice 2.b.iv:

--1)Affichez la liste de tous les livres, en indiquant pour chacun son titre, son prix et le nom de son éditeur.
SELECT l.title_id, l.title, l.price, p.pub_name
FROM titles l, publishers p
WHERE l.pub_id = p.pub_id;

--2)Affichez la liste de tous les livres de psychologie, en indiquant pour chacun son titre, son prix et le nom de son éditeur.
SELECT t.title,t.price, p.pub_name
FROM titles t, publishers p
WHERE t.pub_id = p.pub_id
AND t.type = 'psychology';

--3)Quels sont les auteurs qui ont effectivement écrit un (des) livre(s) présent(s) dans la DB ? Donnez leurs noms et prénoms.
SELECT DISTINCT au.au_id,au.au_lname, au.au_fname, au.au_id
FROM authors au, titleauthor ta
WHERE au.au_id = ta.au_id;

--4)Dans quels Etats y a-t-il des auteurs qui ont effectivement écrit un (des) livre(s) présent(s) dans la DB ?
SELECT DISTINCT au.state
FROM authors au, titleauthor ta
WHERE au.au_id = ta.au_id
AND au.state IS NOT NULL;

--5)Donnez les noms et adresses des magasins qui ont commandé des livres en novembre 1991.
SELECT DISTINCT st.stor_id, st.stor_name, st address
FROM stores st, sales sa
WHERE sa.stor_id = st.stor_id
AND date_part('YEAR',sa.date) = 1991
AND date_part('MONTH',sa.date) = 11;

--6)Quels sont les livres de psychologie de moins de 20 $ édités par des éditeurs dont le nom ne commence pas par "Algo" ?
SELECT t.title_id, t.title
FROM titles t, publishers p
WHERE t.pub_id = p.pub_id
AND t.type = 'psychology'
AND p.pub_name NOT LIKE 'Algo%'
AND t.price < 20;

--7)Donnez les titres des livres écrits par (au moins) un auteur californien (state = "CA").
SELECT DISTINCT t.title_id, t.title
FROM titles t, titleauthor ta, authors au
WHERE t.title_id = ta.title_id
AND ta.au_id = au.au_id
AND au.state = 'CA';

--8)Quels sont les auteurs qui ont écrit un livre (au moins) publié par un éditeur californien ?
SELECT DISTINCT au.au_id, au.au_lname, au.au_fname
FROM authors au, titleauthor ta, titles t, publishers p
WHERE au.au_id = ta.au_id
AND ta.title_id = t.title_id
AND t.pub_id = p.pub_id
AND p.state = 'CA';

--9)Quels sont les auteurs qui ont écrit un livre (au moins) publié par un éditeur localisé dans leur Etat ?
SELECT DISTINCT au.au_id, au.au_lname, au.au_fname
FROM authors au, titleauthor ta, titles t, publishers p
WHERE au.au_id = ta.au_id
AND ta.title_id = t.title_id
AND t.pub_id = p.pub_id
AND au.state = p.state;

--10)Quels sont les éditeurs dont on a vendu des livres entre le 1/11/1990 et le 1/3/1991 ?
SELECT DISTINCT p.pub_id, p.pub_id, p.pub_name, p.city, p.state
FROM publishers p , titles t, salesdetail sd, sales sa
WHERE t.pub_id = p.pub_id
AND t.title_id = sd.title_id
AND sd.stor_id = sa.stor_id
AND sd.ord_num = sa.ord_num
AND sa.date BETWEEN '1990-11-1' AND '1991-3-1';
11)	Quels magasins ont vendu des livres contenant le mot "cook" (ou "Cook") dans leur titre ?
SELECT DISTINCT st.stor_id, st.stor_name, st.stor_address
FROM stores st, salesdetail sd, titles t
WHERE st.stor_id = sd.stor_id
AND sd.title_id = t.title_id
AND (t.title LIKE '%Cook%' OR lower(t.title) LIKE '%cook%');

/* OR */

SELECT DISTINCT st.stor_id, st.stor_name, st.stor_address
FROM stores st, salesdetail sd, titles t
WHERE st.stor_id = sd.stor_id
AND sd.title_id = t.title_id
AND t.title_id SIMILAR TO '%[cC]ook%';

--12)Y a-t-il des paires de livres publiés par le même éditeur à la même date ?
SELECT t1.title, t2.title, t1.title_id, t2.title_id
FROM titles t1, titles t2
WHERE t1.pub_id = t2.pub_id
AND t1.title_id < t2.title_id
AND t1.pubdate = t2.pubdate;

--13)Y a-t-il des auteurs n'ayant pas publié tous leurs livres chez le même éditeur ?
SELECT au.au_id, au.au_fname, au.au_lname
FROM authors au, titleauthor ta, titles t
WHERE au.au_id = ta.au_id
AND ta.title_id = t.title_id
GROUP BY au.au_id, au.au_fname, au.au_lname
HAVING count (Distinct t.pub_id) > 1;

--14)Y a-t-il des livres qui ont été vendus avant leur date de parution ?
SELECT DISTINCT t.title_id, t.title
FROM titles t, salesdetail sd, sales sa
WHERE t.title_id = sd.title_id
AND sd.stor_id = sa.stor_id
AND sd.ord_num = sa.ord_num
AND t.pubdate > sa.date;

--15)Quels sont les magasins où l'on a vendu des livres écrits par Anne Ringer ?
SELECT DISTINCT st.stor_id, st.stor_name
FROM stores st, salesdetail sd, titles t, titleauthor ta, authors au
WHERE au.au_id = ta.au_id
AND ta.title_id = t.title_id
AND st.stor_id = sd.stor_id
AND sd.title_id = t.title_id
AND au.au_fname = 'Anne'
AND au.au_lname = 'Ringer';

--16)Quels sont les Etats où habite au moins un auteur dont on a vendu des livres en Californie en février 1991 ?
SELECT au.state
FROM titleauthor ta, authors au, salesdetail sd, sales sa, stores st
WHERE au.au_id = ta.au_id
AND ta.title_id = sd.title_id
AND sd.ord_num = sa.ord_num
AND sd.stor_id = sa.stor_id
AND sa.stor_id = st.stor_id
AND st.state = 'CA'
AND sa.date BETWEEN '1991-02-1' AND '1991-02-28'
AND au.state IS NOT NULL;

--17)Y a-t-il des paires de magasins situés dans le même Etat, où l'on a vendu des livres du même auteur ?
SELECT st.stor_id, st.stor_name, st2.stor_id, st2.stor_name
FROM stores st, stores st2, salesdetail sd,salesdetail sd2, titleauthor ta, titleauthor ta2
WHERE st.stor_id = sd.stor_id
AND st2.stor_id = sd2.stor_id
AND sd.title_id = ta.title_id
AND sd2.title_id = ta2.title_id
AND st.stor_id < st2.stor_id
AND ta.au_id = ta2.au_id
AND st.state = st2.state;

--18)Trouvez les paires de co-auteurs.
SELECT DISTINCT au1.au_id, au1.au_lname, au2.au_id, au2.au_lname
FROM authors au1, authors au2, titleauthor ta, titleauthor ta2
WHERE au1.au_id = ta.au_id
AND au2.au_id = ta2.au_id
AND au1.au_id < au2.au_id;

--19)Pour chaque détail de vente, donnez le titre du livre, le nom du magasin, le prix unitaire, le nombre d'exemplaires vendus, le montant total et le montant de l'éco-taxe totale (qui s'élève à 2% du chiffre d'affaire)
SELECT sd.stor_id, sd.ord_num, sd.title_id, t.title, st.stor_name, t.price, sd.qty, t.price*sd.qty AS montantTotal,
       t.price*sd.qty*0.02 AS montantEcoTaxe
FROM titles t, stores st, salesdetail sd
WHERE sd.title_id = t.title_id
AND sd.stor_id = st.stor_id;

==========================================================================================