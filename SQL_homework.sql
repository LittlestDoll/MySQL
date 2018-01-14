USE sakila;

/* 1a. Display the first and last names of all actors from the table actor. */

SELECT first_name, last_name
FROM actor;

/*1b. Display the first and last name of each actor in a single column in upper case letters. 
Name the column Actor Name. */

ALTER TABLE actor 
ADD `Actor Name` VARCHAR(255);
UPDATE actor SET `Actor Name` = UPPER(CONCAT(first_name, ' ', last_name));

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information? */

SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe';

/* 2b. Find all actors whose last name contain the letters GEN: */

SELECT first_name, last_name FROM actor
WHERE last_name = '%GEN%';

/* 2c. Find all actors whose last names contain the letters LI. 
This time, order the rows by last name and first name, in that order: */

SELECT last_name, first_name FROM actor
WHERE last_name = '%LI%';

/* 2d. Using IN, display the country_id and country columns of the following countries: 
Afghanistan, Bangladesh, and China: */

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

/* 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
Hint: you will need to specify the data type. */

ALTER TABLE actor 
ADD middle_name VARCHAR(45)
AFTER first_name;

/* 3b. You realize that some of these actors have tremendously long last names. 
Change the data type of the middle_name column to blobs. */

ALTER TABLE actor
MODIFY middle_name BLOB;

/* 3c. Now delete the middle_name column. */

ALTER TABLE actor DROP COLUMN middle_name;

/* 4a. List the last names of actors, as well as how many actors have that last name. */

SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

/* 4b. List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors */

SELECT last_name, COUNT(*)
FROM actor 
GROUP BY last_name
HAVING COUNT(*) > 1;

/* 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as 
GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. 
Write a query to fix the record. */

UPDATE actor
SET first_name = REPLACE(first_name, 'GROUCHO', 'HARPO')
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, 
change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, 
as that is exactly what the actor will be with the grievous error. 
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
(Hint: update the record using a unique identifier.) */

SELECT first_name,
CASE 
    WHEN first_name = 'HARPO' THEN REPLACE(first_name, 'HARPO', 'GROUCHO')
    ELSE REPLACE(first_name, 'HARPO', 'MUCHO GROUCHO')
END 
FROM actor;   

/* 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? */

SELECT `table_schema` 
FROM `information_schema`.`tables` 
WHERE `table_name` = 'address';

/* 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
Use the tables staff and address: */

SELECT s.first_name, s.last_name, a.address
FROM address a
    JOIN staff s
ON a.address_id = s.address_id;    

/* 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
Use tables staff and payment. */

SELECT s.first_name, s.last_name, SUM(p.amount) AS gross
	FROM payment p
	JOIN staff s ON (s.staff_id = p.staff_id)
    GROUP BY s.staff_id, DATE_FORMAT(p.payment_date, '%2005%August');    

/* 6c. List each film and the number of actors who are listed for that film. 
Use tables film_actor and film. Use inner join. */

SELECT f.title, COUNT(actor_id) AS Actors 
    FROM film f
    INNER JOIN film_actor fa ON f.film_id = fa.film_id 
    GROUP BY f.title;

/* 6d. How many copies of the film Hunchback Impossible exist in the inventory system? */

SELECT COUNT(*)
FROM inventory
WHERE film_id IN
(
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

/* 6e. Using the tables payment and customer and the JOIN command, 
list the total paid by each customer. 
List the customers alphabetically by last name: */

SELECT c.first_name, c.last_name, SUM(p.amount) AS gross 
    FROM payment p 
    JOIN customer c ON (c.customer_id = p.customer_id)
	GROUP BY c.customer_id
    ORDER BY c.last_name ASC;

/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. */

SELECT title 
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film
    WHERE (title LIKE 'Q%' OR title LIKE 'K%')
);

/* 7b. Use subqueries to display all actors who appear in the film Alone Trip. */

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
    SELECT film_id
    FROM film
    WHERE title = 'ALONE TRIP'
  )
);

/* 7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information. */

DROP TABLE IF EXISTS cust_country;

CREATE TABLE cust_country
SELECT c.first_name, c.last_name, c.email
FROM customer c 
    JOIN address a ON (c.address_id = a.address_id)
    JOIN city ON (a.city_id = city.city_id)
    JOIN country ON (city.country_id = country.country_id)
    WHERE country.country = 'Canada';

/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as famiy films. */

SELECT title
FROM film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id IN
  (
    SELECT category_id
    FROM category
    WHERE name = 'FAMILY'
  )
);

/* 7e. Display the most frequently rented movies in descending order. */



/* 7f. Write a query to display how much business, in dollars, each store brought in. */



/* 7g. Write a query to display for each store its store ID, city, and country. */



/* 7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) */



/* 8a. In your new role as an executive, you would like to have an easy way of viewing the 
Top five genres by gross revenue. 
Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view. */



/* 8b. How would you display the view that you created in 8a? */



/* 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. */