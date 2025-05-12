/* DataProject: LógicaConsultasSQL
 * Autor: Noa Satorre Llopis
 */

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
select "title" as "titulo_peli"
from "film" 
where "rating" = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
select concat ("first_name",' ', "last_name") as "nombre_actor"
from "actor" 
where "actor_id" between 30 and 40

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select "original_language_id"
from "film"
where "original_language_id" = "language_id";

-- 5. Ordena las películas por duración de forma ascendente.
select "title" as "titulo_peli" 
from "film"
order by "length" asc;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
select concat ("first_name", ' ' ,  "last_name") as "nombre_actor"
from "actor"
where "last_name" = 'ALLEN';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
select "rating" , count (*) as "total_peli"
from "film"
group by "rating";

-- 8. Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una duración mayor a 3 horas en la tabla film.
select "title" as "titulo_peli" , "rating", "length"
from "film"
where "rating" = 'PG-13' or "length" > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select variance ("replacement_cost")
from "film";

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select MAX("length") as "duracion_max", MIN("length") as "duracion_min"
from "film";

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select "amount" as "antepenúltimo_alquiler"
from "payment"
order by "payment_date" desc
limit 1 offset 2;

--12.  Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
select "title" as "titulo_peli"
from "film"
where "rating" not in ('NC-17' , 'G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
select avg ("length") as "prom_duracion" , "rating" as "clasificación"
from "film"
group by "rating";

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select "title" as "titulo_peli"
from "film"
where "length" > 180;
d
-- 15. ¿Cuánto dinero ha generado en total la empresa?
select sum ("amount") as "dinero_generado"
from "payment"

-- 16. Muestra los 10 clientes con mayor valor de id.
select concat ("first_name" , ' ' , "last_name") as "nombre_cliente"
from "customer"
order by "customer_id" desc
limit 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
select concat ("first_name" , ' ' , "last_name") as "nombre_actor"
from "actor" a
join "film_actor" fa on a."actor_id" = fa."actor_id"
join "film" f on f."film_id" = fa."film_id"
where f."title" = 'EGG IGBY';

-- 18. Selecciona todos los nombres de las películas únicos.
select "title" as "titulo_peli"
from "film"
group by "title"
having count (*) = 1

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
select "title" as "titulo_peli"
from "film" f
join "film_category" fc  on f."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Comedy' and f."length" > 180

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
select avg ("length") as "promedio_duración" , c."name" as "categoría"
from "film" f
join "film_category" fc  on f."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
group by c."name"
having avg ("length") > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
select avg("return_date"-"rental_date") as "media_duración_alquiler"
from "rental"

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat ("first_name" , ' ' , "last_name") as "nombre_actor"
from "actor" a;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select date ("rental_date") as "dia" , count(*) as "cantidad_alquiler"
from "rental"
group by date ("rental_date")
order by "cantidad_alquiler" desc;

-- 24. Encuentra las películas con una duración superior al promedio.
select "title" as "titulo_peli"
from "film"
where "length" > (
	select AVG("length") 
	from "film"
);

-- 25. Averigua el número de alquileres registrados por mes.
select extract (month from "rental_date") as  "mes" , count(*) as "cantidad_alquiler"
from "rental"
group by extract (month from ("rental_date"));

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select avg("amount") , stddev ("amount") , variance ("amount")
from "payment";

-- 27. ¿Qué películas se alquilan por encima del precio medio?
select "title" as "titulo_peli"
from "film" f
join "inventory" i on f."film_id"  = i."film_id"
join "rental" r on i."inventory_id" = r."inventory_id"
join "payment" p on r."rental_id" = p."rental_id"
where p."amount" > (
	select avg ("amount")
	from "payment"
);

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
select "actor_id"
from "film_actor"
group by "actor_id"
having count("film_id") > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select f.title AS titulo_peli,
   COUNT(i.inventory_id) filter (
        where r.rental_id is null or r.return_date is not null) as cantidad_disponible
from  film f
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id and r.return_date is null 
group by f.film_id, f.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
select concat("first_name" , ' ' , "last_name") as "nombre_actor" , count (fa.film_id) as "numero_pelis"
from "actor" a
join "film_actor" fa on a."actor_id" = fa."actor_id"
group by fa."actor_id" , "nombre_actor";

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select f."title" as "titulo_peli" , concat(a."first_name" , ' ' , a."last_name") as "nombre_actor"
from "film" f
left join "film_actor" fa on f."film_id" = fa."film_id"
left join "actor" a on fa."actor_id" = a."actor_id"
order by f."title";

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select concat(a."first_name" , ' ' , a."last_name") as "nombre_actor" , f."title" as "titulo_peli"
from "actor" a
left join "film_actor" fa on a."actor_id" = fa."actor_id"
left join "film" f on fa."film_id" = f."film_id";

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select "title" as "titulo_peli" , r."rental_id" ,  r."rental_date" as "fecha_alquiler" , r."return_date" as "fecha_devolución"
from "film" f
left join "inventory" i on f."film_id" = i."film_id"
left join "rental" r on i."inventory_id" = r."inventory_id"

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select concat(c."first_name" , ' ' , c."last_name") as "nombre_cliente" , sum(p."amount") as "total_pagado"
from "customer" c
left join "payment" p on c."customer_id" = p."customer_id"
group by c."customer_id" , "nombre_cliente"
order by "total_pagado" desc
limit 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select concat(a."first_name" , ' ' , a."last_name") as "nombre_actor"
from "actor" a
where a."first_name" = 'JOHNNY';

-- 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
select "first_name" as "Nombre" , "last_name" as "Apellido"
from "actor";

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select min("actor_id") as id_minimo , max("actor_id") as id_maximo
from "actor";

-- 38. Cuenta cuántos actores hay en la tabla “actorˮ.
select count("actor_id") as "recuento_actores"
from "actor";

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select concat("first_name" , ' ' , "last_name") as "nombre_actor"
from "actor"
order by "last_name" asc;

-- 40. Selecciona las primeras 5 películas de la tabla “filmˮ.
select "title" as "titulo_peli"
from "film"
limit 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select "first_name" as "nombre_más_repetido" , count(*) as "cantidad"
from "actor"
group by "first_name"
order by "cantidad" desc
limit 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r."rental_id" , concat(c."first_name", ' ' , c."last_name") as "nombre_cliente"
from "rental" r
left join "customer" c on r."customer_id" = c."customer_id";

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select concat(c."first_name", ' ' , c."last_name") as "nombre_cliente" , r."rental_id"
from "customer" c 
left join "rental" r on c."customer_id" = r."customer_id";

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select f.title as titulo_pelicula, c.name as nombre_categoria
from film f
cross join category c;

-- La consulta no aporta valor ya que nos esta mostrando el nombre de la misma pelicula con todas las categorias possibles.

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select concat (a."first_name" , ' ' , a."last_name") as "nombre_actor"
from "actor" a
left join "film_actor" fa on a."actor_id" = fa."actor_id"
left join "film_category" fc on fa."film_id" = fc."film_id"
left join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Action';

-- 46. Encuentra todos los actores que no han participado en películas.
select concat (a."first_name" , ' ' , a."last_name") as "nombre_actor"
from "actor" a
left join "film_actor" fa on a."actor_id" = fa."actor_id"
where fa."film_id" IS NULL;

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado. 
select concat (a."first_name" , ' ' , a."last_name") as "nombre_actor" , count (fa."film_id") as "numero_peliculas"
from "actor" a
left join "film_actor" fa on a."actor_id" = fa."actor_id"
group by a."actor_id" , "nombre_actor"
order by "numero_peliculas" desc;

-- 48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
create view "actor_num_peliculas" as 
select concat (a."first_name" , ' ' , a."last_name") as "nombre_actor" , count (fa."film_id") as "num_peliculas"
from "actor" a
left join "film_actor" fa on a."actor_id" = fa."actor_id"
group by a."actor_id" , "nombre_actor"
order by "num_peliculas" desc;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select concat (c."first_name" , ' ' , c."last_name") as "nombre_cliente" , count (r."rental_id") as "num_alquileres"
from "customer" c
left join "rental" r on c."customer_id" = r."customer_id"
group by c."customer_id" , "nombre_cliente"
order by "num_alquileres" desc;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select sum (f."length") as "duracion_total"
from "film" f
left join "film_category" fc on fc."film_id" = f."film_id"
left join "category" c on c."category_id" = fc."category_id"
where c."name" = 'Action';

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
with "cliente_rentas_temporal" as(
	select concat (c."first_name" , ' ' , c."last_name") as "nombre_cliente" , count (r."rental_id") as "num_alquileres"
	from "customer" c
	left join "rental" r on c."customer_id" = r."customer_id"
	group by c."customer_id" , "nombre_cliente"
	order by "num_alquileres" desc
)
select *
from "cliente_rentas_temporal";

-- 52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.
with "peliculas_alquiladas" as(
	select f."title" as "nombre_pelicula"
	from "film" f
	left join "inventory" i on f."film_id" = i."film_id"
	left join "rental" r on i."inventory_id" = r."inventory_id"
	group by f."film_id" , f."title"
	having count(rental_id) >= 10
)
select *
from "peliculas_alquiladas";

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
select f."title"
from "film" f
join "inventory" i on f."film_id" = i."film_id"
join "rental" r on i."inventory_id" = r."inventory_id"
join "customer" c on r."customer_id" = c."customer_id"
where concat(c."first_name" , ' ' , c."last_name") = 'TAMMY SANDERS' and r."return_date" is null
order by f."title" asc;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.
select distinct concat (a."first_name" , ' ' , a."last_name") as "nombre_actor"
from "actor" a
join "film_actor" fa on a."actor_id" = fa."actor_id"
join "film_category" fc on fa."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Sci-Fi'
order by a."last_name" asc;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM film f2
    JOIN inventory i2 ON f2.film_id = i2.film_id
    JOIN rental r2 ON i2.inventory_id = r2.inventory_id
    WHERE f2.title = 'Spartacus Cheaper'
)
ORDER BY a.last_name, a.first_name;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.
select distinct concat (a."first_name" , ' ' , a."last_name") as "nombre_actor"
from "actor" a
where a."actor_id" not in (
	select fa."actor_id"
	from "film_actor" fa
	join "film_category" fc on fa."film_id" = fc."film_id"
	join "category" c on fc."category_id" = c."category_id"
	where c."name" = 'Music'
)
order by "nombre_actor";

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select f."title" as "titulo_pelicula"
from "film" f
join "inventory" i on f."film_id" = i."film_id"
join "rental" r on i."inventory_id" = r."inventory_id"
where extract (day from (r."return_date" - r."rental_date")) > 8 ;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.
select f."title" as "titulo_pelicula"
from "film" f
join "film_category" fc on f."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Animation';

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.
select f."title" as "titulo_pelicula"
from "film" f
where "length" = (
	select "length"
	from "film"
	where "title" = 'DANCING FEVER'
)
order by "titulo_pelicula";

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select concat(c."first_name" , ' ' , c."last_name") as "nombre_cliente"
from "customer" c
join "rental" r on c."customer_id" = r."customer_id"
group by "nombre_cliente"
having count(r."rental_id") >= 7
order by "nombre_cliente";

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
select c."name" as "categoria" , count(r."rental_id") as "recuento_peliculas_alq"
from "rental" r 
join "inventory" i on r."inventory_id" = i."inventory_id"
join "film_category" fc on i."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
group by c."name"
order by "recuento_peliculas_alq" desc;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select c."name" as "categoria" , count(r."rental_id") as "peliculas_2006"
from "rental" r 
join "inventory" i on r."inventory_id" = i."inventory_id"
join "film" f on i."film_id" = f."film_id"
join "film_category" fc on f."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where f."release_year" = 2006
group by c."name"
order by "peliculas_2006" desc;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select concat(s."first_name" , ' ' , s."last_name") as "nombre_trabajador" , t."store_id" as "tienda"
from "staff" s
cross join "store" t
order by "nombre_trabajador";

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select c."customer_id" , concat(c."first_name" , ' ' , c."last_name") as "nombre_cliente", count(r."rental_id") as "recuento_alq"
from "customer" c
join "rental" r on c."customer_id" = r."customer_id"
group by c."customer_id"
order by "recuento_alq" desc;
