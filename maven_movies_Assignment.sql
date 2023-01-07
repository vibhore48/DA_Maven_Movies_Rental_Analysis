/*Assignment 1*/

/*Could you pull a list of the first name, last name, and email of each of our customers?”*/
select first_name, last_name, email from customer;

/*Pull the record of the films and see if there are rental duations other then: 3,5 or 7 days*/
select * from film 
where rental_duration not in (3,5,7)
order by rental_duration desc;
/*OR*/
SELECT DISTINCT rental_duration
FROM film;

/*Pull the list of all payments from our first 100 customers*/ 
select * from payment
where customer_id <=100;

/*Pull the list of payments over $5 for those same customers, since Jan-1-2006*/ 
select * from payment
where customer_id <=100
and amount > 5
and payment_date >= '2006-01-01';
/*OR*/
SELECT
	customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
WHERE customer_id BETWEEN 1 AND 100;

/*Pull payments from those specific customers along with payments above $5 from any customer*/
select * from payment
where customer_id  in (42,53,60,75) 
or amount > 5;

/*To understand the special feature in the film record, pull the list of all the films
which include 'Behind the Scenes' as special features*/ 
select * from film 
where special_features like '%Behind the Scenes%';

/*Count of all film titles sliced by rental duration*/ 
select count(title), rental_duration from film 
group by rental_duration
order by rental_duration;

/*Can you help me pull a count of films, along with the average, min, and max rental rate, grouped by replacement cost?”*/
select count(title), avg(rental_rate), min(rental_rate), max(rental_rate), replacement_cost from film 
group by replacement_cost
order by replacement_cost desc;

/*Pull the list of customer_id with less then 15 rentals all time*/ 
select customer_id , count(rental_id) as NoOfRentals from payment
group by customer_id
having NoOfRentals < 15;

/*Pull list of all film titles along with there length and rental rate and sort from longest to shortes*/ 
select title, length, rental_rate from film
order by length desc;

/*Pull a list of the first and last names of all customers and label them 
as either ‘store 1 active’, ‘store 1 inactive’, ‘store 2 active’, or ‘store 2 inactive’?”*/ 
select first_name, last_name, 
(case when store_id=1 then if (active=1,"store 1 active","store 1 inactive")
	 when store_id=2 then if (active=1,"store 2 active","store 2 inactive")
     else "Other Store"
end) as status     
from customer;

/*Create a table to count the number of customers broken down by store_id (in rows), and active status (in columns)?”*/
select store_id, count(customer_id), 
(case
	when active = 0 then "inactive"
    when active = 1 then "active"
    else "Other store"
end) as status
from customer
group by store_id, active
order by store_id;

/*Pull a list of each film we have in inventory. It should have film’s title, description, store_id value associated with each item, and inventory_id.*/
select f.title, f.description, 
count(case when store_id = 1 then inventory_id else null end) as store_1_copies,
count(case when store_id = 2 then inventory_id else null end) as store_2_copies,
GROUP_CONCAT((case when store_id = 1 then inventory_id else null end)) as store_1_inventory_id,
GROUP_CONCAT((case when store_id = 2 then inventory_id else null end)) as store_2_inventory_id
from inventory i
LEFT JOIN film f 
ON i.film_id =  f.film_id
group by f.title
order by i.inventory_id;

/*Pull a list of all titles and figure out how many actors are associated with each title?*/
select f.title, count(fa.actor_id)
from film_actor fa
LEFT JOIN film f
ON fa.film_id = f.film_id
group by f.title
order by fa.film_id;

/*Pull a list of all actors, with each title they appear in.*/
select concat_ws(" ",a.first_name,a.last_name) as actor_name,
group_concat(f.title)
from film_actor fa
LEFT JOIN actor a
ON fa.actor_id = a.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id
group by actor_name;
/*OR*/
SELECT
    a.first_name AS first_name
    , a.last_name AS last_name
    , f.title AS film_title
FROM actor a
    INNER JOIN film_actor fa
        ON a.actor_id = fa.actor_id
    INNER JOIN film f
        ON fa.film_id = f.film_id
ORDER BY
    a.last_name
    , a.first_name;
    
/*Pull a list of distinct titles and their descriptions currently available in the inventory at store 2?*/
select distinct(f.title), f.description 
from inventory i
LEFT JOIN film f
ON i.film_id = f.film_id
where i.store_id = 2;

/*pull a list of all staff and advisor names and include a column noting whether they are staff members or advisors?”*/
select concat_ws(" ",first_name, last_name) as name, ("advisor") as role from advisor
union
select concat_ws(" ",first_name, last_name) as name, ("Staff") as role from staff;



/*Assignment 2*/

/*Pull a list of all staff members, including their first and last names, email addresses, and the store identification number where they work.*/
select first_name, last_name, email, store_id from staff;

/*Pull separate counts of inventory items held at your two stores.*/ 
select store_id, count(inventory_id) as inventory_items
from inventory
group by store_id;

/*Pull a list of count of active customers for each store separately.*/
select store_id, count(active) as active_customers
from customer
where active = 1
group by store_id;

/*To assess the liability of a data breach, Pull a list of count of all customer email addresses stored in the database.*/
select count(email) as email_addresses from customer;

/*Pull a list of count of unique film titles in inventory at each store and then provide a count of the unique categories of films you provide.*/
select store_id, COUNT(DISTINCT film_id) AS unique_films
from inventory
group by store_id; 
	
select COUNT(DISTINCT name) AS unique_categories
from category;

/*Pull a list of the replacement cost for the least expensive film, the most expensive to replace, and the average of all films you carry.*/
select min(replacement_cost),max(replacement_cost), avg(replacement_cost)
from film;

/*Pull a list of the average payment you process and the maximum payment you have processed.”*/
select avg(amount) as avg_payment, max(amount) as max_payment 
from payment;

/*Pull a list of all customer identification values, with a count of rentals they have made all time, with your highest volume customers at the top of the list.*/
select customer_id, count(rental_id) as rentals
from rental
group by customer_id
order by rentals desc;
/*OR*/
select customer_id, COUNT(rental_id) AS total_rental
from payment
group by customer_id
order by total_rental desc;



/*Assignment 3*/

/*Pull a list of the managers’ names at each store, with the full address of each property (street address, district, city, and country)*/
select concat_ws(" ", s.first_name, s.last_name) as manager_name, s.store_id, concat_ws(", ", a.address,a.district,ci.city,co.country) as full_address
from staff s
inner join address a
on s.address_id = a.address_id
inner join city ci
on a.city_id = ci.city_id
inner join country co
on ci.country_id = co.country_id;

/*Pull a list of each item you have stocked, including the store_id number, the inventory_id, the name of the film, the film’s rating, its rental rate, and replacement cost.*/
select f.title,
count(case when store_id=1 then i.inventory_id else null end) as store_1_stock, 
count(case when store_id=2 then i.inventory_id else null end) as store_2_stock,
group_concat(i.inventory_id) as inventory_id,
f.rating, f.rental_rate, f.replacement_cost
from inventory i
inner join film f
on i.film_id = f.film_id
group by i.film_id;

/*How many inventory items you have with each rating at each store.*/
select f.rating, i.store_id, count(i.inventory_id) as inventory_items
from inventory i  
inner join film f 
on i.film_id = f.film_id
group by f.rating, i.store_id;

/*Pull a list of number of films, the average replacement cost, and the total replacement cost, sliced by store and film category.*/
select i.store_id, c.name as category, 
count(i.film_id) as number_of_films, 
avg(f.replacement_cost) as avg_replacement_cost, 
sum(f.replacement_cost) as total_replacement_cost 
from film_category fc
inner join film f
on fc.film_id = f.film_id
inner join inventory i
on i.film_id = f.film_id
inner join category c
on fc.category_id = c.category_id
group by i.store_id, c.name;

/*Pull a list of all customer names, which store they go to, whether or not they are currently active, and their full addresses (street address, city, and country).*/
select concat_ws(" ", c.first_name, c.last_name) as customer_name, 
c.store_id, 
(case when c.active = 1 then "active" else "inactive" end) as status , 
concat_ws(", ",a.address,ci.city,a.district,co.country) as full_address
from customer c
inner join address a
on c.address_id = a.address_id
inner join city ci
on a.city_id = ci.city_id
inner join country co
on ci.country_id = co.country_id
order by customer_name;

/*Pull a list of customer names, their total lifetime rentals, and the sum of all payments till now ordered on total lifetime value, with the most valuable customers at the top of the list.”*/
select concat_ws(" ", c.first_name, c.last_name) as customer_name,
count(p.rental_id) as total_lifetime_rentals,
sum(p.amount) as total_lifetime_value
from payment p
inner join customer c
on p.customer_id = c.customer_id
inner join rental r
on p.rental_id = r.rental_id
group by p.customer_id
order by total_lifetime_value desc;

/*List advisor and investor names in one table noting whether they are an investor or an advisor. For investors include which company they work with.*/
select concat_ws(" ", first_name, last_name) as name,
 "investor" as member_type,
company_name
from investor
union
select concat_ws(" ", first_name, last_name) as name,
 "advisor" as member_type,
"Maven Movies" as company_name
from advisor;

/*We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? */
select (case 
		when awards = 'Emmy, Oscar, Tony ' THEN '3 Awards'
        when awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 Awards'
		else '1 Award'
	end) as actor_awards, 
    round(AVG(CASE WHEN actor_id IS NULL THEN 0 ELSE 1 END)*100,2) AS percent_who_carry_film
from actor_award
group by actor_awards;