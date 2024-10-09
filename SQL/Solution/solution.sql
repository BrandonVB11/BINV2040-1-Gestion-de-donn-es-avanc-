/*=============================== Solution =======================*/
/* 2.a.ii*/
--1

/* 2.b.iv*/
--1

/* 2.d.ii*/
--1
SELECT AVG(ti.price)
FROM titles ti, publishers pu
WHERE pu.pub_id = ti.pub_id
AND pu.pub_name = 'Algodata Infosystems';

--2
SELECT a.au_id, a.au_fname, a.au_lname, AVG(t.price) AS prix_moyen
FROM authors a LEFT OUTER JOIN titleauthor ta
ON a.au_id = ta.au_id LEFT OUTER JOIN titles t
ON ta.title_id = t.title_id
GROUP BY a.au_id, a.au_fname, a.au_lname;

--3
SELECT t.price, coalesce(count(ta.au_id),0), t.title, t.title_id
FROM titleauthor ta RIGHT JOIN titles t
ON ta.title_id = t.title_id
WHERE t.pub_id IN (SELECT p.pub_id
                   FROM publishers p
                   WHERE p.pub_name = 'Algodata Infosystems')
GROUP BY t.price, t.title, t.title_id;

--4
SELECT t.title_id, t.title, t.price, count(distinct sd.stor_id)
FROM titles t LEFT OUTER JOIN salesdetail sd
ON t.title_id = sd.title_id
GROUP BY t.title, t.price, t.title_id;

--5
SELECT t.title_id, t.title
FROM titles t, salesdetail sd
WHERE t.title_id = sd.title_id
GROUP BY t.title_id, t.title
HAVING count(DISTINCT sd.stor_id) > 1;

--6
SELECT t.type, count(t.title_id), avg(t.price)
FROM titles t
WHERE t.type IS NOT NULL
GROUP BY t.type;

--7
SELECT t.title_id, t.total_sales, sum(sd.qty)
FROM titles t LEFT OUTER JOIN salesdetail sd
ON t.title_id = sd.title_id
GROUP BY t.title_id, t.total_sales;

--8
SELECT t.title_id, t.total_sales, sum(sd.qty)
FROM titles t LEFT OUTER JOIN salesdetail sd
ON t.title_id = sd.title_id
GROUP BY t.title_id, t.total_sales
HAVING COALESCE(t.total_sales, 0) <> COALESCE(sum(sd.qty), 0);

--9
SELECT t.title_id, t.title
FROM titles t, titleauthor ta
WHERE t.title_id = ta.title_id
GROUP BY t.title_id, t.title
HAVING count(ta.au_id) >= 3;

--10
SELECT sum(sd.qty)
FROM titles t, publishers p, salesdetail sd, stores st
WHERE t.pub_id = p.pub_id
AND t.title_id IN (SELECT ta.title_id
                   FROM titleauthor ta, authors a
                   WHERE ta.au_id = a.au_id
                   AND a.state = 'CA')
AND t.title_id = sd.title_id
AND sd.stor_id = st.stor_id
AND p.state = 'CA'
AND st.state = 'CA';

/* 2.e.iv*/
/*1.Quel est le livre le plus cher publié par l'éditeur "Algodata Infosystems" ?*/
SELECT t.title_id, t.price
FROM titles t, publishers p
WHERE t.pub_id = p.pub_id
AND p.pub_name = 'Algodata Infosystems'
AND t.price >= ALL(SELECT t2.price
               FROM titles t2
               WHERE t2.price IS NOT NULL
               AND t2.pub_id = p.pub_id);

/*2.Quels sont les livres qui ont été vendus dans plusieurs magasins ?*/
SELECT t.title_id,t.title
FROM titles t, salesdetail sd
WHERE t.title_id = sd.title_id
GROUP BY t.title_id, t.title
HAVING count(DISTINCT sd.stor_id) > 1;

/*3. Quels sont les livres dont le prix est supérieur à une fois et demi le prix moyen des livres du
même type ?*/
SELECT t1.title_id, t1.title
FROM titles t1
WHERE t1.price > (SELECT 1.5 * avg(t2.price)
                  FROM titles t2
                  WHERE t2.type = t1.type);

/*4. Quels sont les auteurs qui ont écrit un livre (au moins), publié par un éditeur localisé dans le
même état ?*/
SELECT DISTINCT au.au_id, au.au_fname, au.au_lname
FROM authors au, titleauthor ta, titles t
WHERE au.au_id = ta.au_id
AND ta.title_id = t.title_id
AND au.state IN (SELECT p.state
                 FROM publishers p
                 WHERE p.pub_id = t.pub_id);

/*5. Quels sont les éditeurs qui n'ont rien édité ?*/
SELECT p.pub_id, p.pub_name
FROM publishers p
WHERE p.pub_id NOT IN (SELECT t.pub_id
                        FROM titles t);

/*6. Quel est l'éditeur qui a édité le plus grand nombre de livres ?*/
WITH nombreDeLivre AS (SELECT count(t2.title_id) FROM titles t2 GROUP BY t2.pub_id)
SELECT p.pub_id, p.pub_name
FROM publishers p, titles t
WHERE t.pub_id = p.pub_id
GROUP BY p.pub_id
HAVING count(t.title_id) >= (SELECT max(n.count)
                             FROM nombreDeLivre n);

/*7. Quels sont les éditeurs dont on n'a vendu aucun livre ?*/
SELECT p.pub_id, p.pub_name
FROM publishers p
WHERE pub_id NOT IN (SELECT t.pub_id
                     FROM salesdetail sd, titles t
                     WHERE t.title_id = sd.title_id);

/*8. Quels sont les différents livres écrits par des auteurs californiens, publiés par des éditeurs
californiens, et qui n'ont été vendus que dans des magasins californiens ?
*/
SELECT DISTINCT t.title
FROM publishers p, titles t, titleauthor ta, salesdetail sd, authors a
WHERE a.au_id = ta.au_id
AND p.pub_id = t.pub_id
AND t.title_id = ta.title_id
AND t.title_id = sd.title_id
AND p.state = 'CA'
AND a.state = 'CA'
AND NOT EXISTS(
    SELECT *
    FROM salesdetail sd, stores st
    WHERE t.title_id = sd.title_id
    AND sd.stor_id = st.stor_id
    AND st.state <>'CA');

/*9. Quel est le titre du livre vendu le plus récemment ? (S'il a des ex-aequo, donnez-les tous.)*/
SELECT DISTINCT t.title, t.title_id
FROM titles t, salesdetail sd, sales s
WHERE t.title_id = sd.title_id
AND s.stor_id = sd.stor_id
AND s.ord_num = sd.ord_num
AND s.date = (SELECT MAX(s2.date)
              FROM sales s2);

/*10. Quels sont les magasins où l'on a vendu (au moins) tous les livres vendus par le magasin
"Bookbeat" ?
*/
SELECT st.stor_id, st.stor_name
FROM stores st
WHERE NOT EXISTS(SELECT *
                 FROM stores st2, salesdetail sd
                 WHERE sd.stor_id = st2.stor_id
                 AND st2.stor_name = 'Bookbeat'
                 AND NOT EXISTS(SELECT *
                                FROM salesdetail sd2
                                WHERE sd2.title_id = sd.title_id
                                AND sd2.stor_id = st.stor_id))
AND st.stor_name <> 'Bookbeat';

/*11. Quelles sont les villes de Californie où l'on peut trouver un auteur, mais aucun magasin ?*/
SELECT DISTINCT a.city
FROM authors a
WHERE a.state = 'CA'
AND a.city NOT IN (SELECT st.city
                   FROM stores st
                   WHERE st.city IS NOT NULL
                   AND st.state = 'CA');

--OU
SELECT DISTINCT a.city
FROM authors a
WHERE a.state = 'CA'
AND NOT EXISTS(SELECT st.city
               FROM stores st
               WHERE st.city = a.city AND st.state = 'CA')
AND a.city IS NOT NULL;

/*12. Quels sont les éditeurs localisés dans la ville où il y a le plus d'auteurs ?
*/
SELECT p.pub_id, p.pub_name
FROM publishers p, authors a
WHERE p.city = a.city
AND a.state = p.state
GROUP BY p.pub_id, p.pub_name
HAVING count(a.au_id) >= ALL(SELECT count(a2.au_id)
                             FROM authors a2
                             GROUP BY a2.city, a2.state);

/*13. Donnez les titres des livres dont tous les auteurs sont californiens.
*/
SELECT DISTINCT t1.title_id, t1.title
FROM titles t1, titleauthor ta
WHERE NOT EXISTS(SELECT ta1.au_id
                 FROM titleauthor ta1
                 INNER JOIN authors a1
                 ON ta1.au_id = a1.au_id
                 WHERE t1.title_id = ta1.title_id
                 AND a1.state <> 'CA')
AND t1.title_id = ta.title_id;


/*14. Quels sont les livres qui n'ont été écrits par aucun auteur californien ?
*/
SELECT DISTINCT t1.title_id, t1.title
FROM titles t1, titleauthor ta
WHERE NOT EXISTS(SELECT ta1.au_id
                 FROM titleauthor ta1
                 INNER JOIN authors a1
                 ON ta1.au_id = a1.au_id
                 WHERE t1.title_id = ta1.title_id
                 AND a1.state == 'CA')
AND t1.title_id = ta.title_id;

/*15. Quels sont les livres qui n'ont été écrits que par un seul auteur ?*/
SELECT t.title_id, t.title
FROM titles t, titleauthor ta
WHERE t.title_id = ta.title_id
GROUP BY t.title_id, t.title
HAVING count(ta.au_id) = 1;

/*16. Quels sont les livres qui n'ont qu'un auteur, et tels que cet auteur soit californien ?*/
SELECT t.title_id, t.title
FROM titles t, titleauthor ta, authors a
WHERE t.title_id = ta.title_id
AND ta.au_id = a.au_id
AND a.state = 'CA'
GROUP BY t.title_id, t.title
HAVING count(ta.au_id) = 1;

--OU
SELECT t.title_id, t.title
FROM titles t, titleauthor ta, authors a
WHERE t.title_id = ta.title_id
AND a.au_id = ta.au_id
AND a.state = 'CA'
AND t.title_id IN(SELECT ta2.title_id
                  FROM titleauthor ta2
                  GROUP BY ta2.title_id
                  HAVING count(ta2.au_id) = 1);

/*=========================================================================*/