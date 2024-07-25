USE film_rental;


-- 1.	What is the total revenue generated from all rentals in the database? (2 Marks)
SELECT SUM(amount) 
FROM payment;

-- 2.	How many rentals were made in each month_name? (2 Marks)
SELECT MONTH(r.rental_date)AS MONTH_, SUM(p.amount) AS TOTAL
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY MONTH_;


-- 3.	What is the rental rate of the film with the longest title in the database? (2 Marks)
SELECT f.title, length(f.title)
FROM film f 
join payment p ON f.last_update = p.last_update
WHERE length(f.title) = (select max(length(f.title)) from film f)
;
select*from film;


-- 4.	What is the average rental rate for films that were taken from the last 30 days from the date("2005-05-05 22:04:30")? (2 Marks)


SELECT AVG(film.rental_rate) AS average_rental_rate
FROM film 
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN rental ON inventory.film_id = film.film_id
WHERE rental.rental_date BETWEEN DATE_SUB('2005-05-05 22:04:30', INTERVAL 30 DAY) AND date('2005-05-05 22:04:30');


-- 5.	What is the most popular category of films in terms of the number of rentals? (3 Marks)

SELECT category.name AS category_name, COUNT(rental.rental_id) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY rental_count DESC
LIMIT 1;

-- 6.	Find the longest movie duration from the list of films that have not been rented by any customer. (3 Marks)

SELECT film.title AS film_title, film.length AS film_length
FROM film
WHERE film.film_id NOT IN (
  SELECT DISTINCT inventory.film_id
  FROM inventory
  JOIN rental ON inventory.inventory_id = rental.inventory_id
)
ORDER BY film_length DESC
LIMIT 1;

-- 7.	What is the average rental rate for films, broken down by category? (3 Marks)

SELECT category.name AS category_name, subquery.average_rental_rate
FROM category
JOIN (
  SELECT film_category.category_id, AVG(film.rental_rate) AS average_rental_rate
  FROM film
  JOIN film_category ON film.film_id = film_category.film_id
  GROUP BY film_category.category_id
) AS subquery ON category.category_id = subquery.category_id
ORDER BY subquery.average_rental_rate DESC;

-- 8.	What is the total revenue generated from rentals for each actor in the database? (3 Marks)
SELECT actor.first_name AS actor_first_name, actor.last_name AS actor_last_name, SUM(film.rental_rate) AS total_revenue
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY actor.actor_id
ORDER BY total_revenue DESC;


-- 9.	Show all the actresses who worked in a film having a "Wrestler" in the description. (3 Marks)
SELECT actor.first_name AS actress_first_name, actor.last_name AS actress_last_name
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE film.description LIKE '%Wrestler%';


-- 10.	Which customers have rented the same film more than once? (3 Marks)
SELECT customer.first_name AS customer_first_name, customer.last_name AS customer_last_name, film.title AS film_title, COUNT(rental.rental_id) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN customer ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id, film.film_id
HAVING rental_count > 1
ORDER BY rental_count DESC;


-- 11.	How many films in the comedy category have a rental rate higher than the average rental rate? (3 Marks)
SELECT COUNT(film.film_id) AS comedy_count
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy' AND film.rental_rate > (
  SELECT AVG(film.rental_rate) AS average_rental_rate
  FROM film
);



-- 12.	Which films have been rented the most by customers living in each city? (3 Marks)
SELECT city.city AS city_name, film.title AS film_title, COUNT(rental.rental_id) AS rental_count
FROM rental
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY city.city_id, film.film_id
ORDER BY city.city, rental_count DESC;


-- 13.	What is the total amount spent by customers whose rental payments exceed $200? (3 Marks)
SELECT customer.first_name AS customer_first_name, customer.last_name AS customer_last_name, SUM(payment.amount) AS total_amount
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
HAVING total_amount > 200
ORDER BY total_amount DESC;


-- 14.	Display the fields which are having foreign key constraints related to the "rental" table. [Hint: using Information_schema] (2 Marks)
SELECT constraint_name, table_name, column_name, referenced_table_name, referenced_column_name
FROM information_schema.key_column_usage
WHERE table_name = 'rental';


-- 15.	Create a View for the total revenue generated by each staff member, broken down by store city with the country name. (4 Marks)


-- 16.	Create a view based on rental information consisting of visiting_day, customer_name, the title of the film,  no_of_rental_days, the amount paid by the customer along with the percentage of customer spending. (4 Marks)


-- 17.	Display the customers who paid 50% of their total rental costs within one day. (5 Marks)
