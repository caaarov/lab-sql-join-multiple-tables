use sakila;

# Lab | SQL Joins on multiple tables

#In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals.

### Instructions
#1. Write a query to display for each store its store ID, city, and country.
Select s.store_id, a.address, c.city, co.country
from sakila.store as s
	left join sakila.address as a
	on s.address_id=a.address_id
    left join sakila.city as c
    on a.city_id=c.city_id
	left join sakila.country as co
    on c.country_id=co.country_id;
    
#2. Write a query to display how much business, in dollars, each store brought in.
Select s.store_id, sum(p.amount) as business
from sakila.staff as s
    join sakila.payment as p
    on s.staff_id=p.staff_id
group by s.store_id, p.staff_id;

#3. What is the average running time of films by category?
Select c.category_id, c.name, avg(fi.length) as avg_length 
from sakila.category as c
join sakila.film_category as f
on c.category_id=f.category_id
join sakila.film as fi
on f.film_id=fi.film_id
group by c.category_id, c.name
order by avg_length desc;

#4. Which film categories are longest?
create temporary table length_category
Select c.category_id, c.name, round(avg(fi.length),2) as avg_length 
from sakila.category as c
join sakila.film_category as f
on c.category_id=f.category_id
join sakila.film as fi
on f.film_id=fi.film_id
group by c.category_id, c.name
order by avg_length desc;

Select *from sakila.length_category;
Select category_id, name, max(avg_length) from sakila.length_category
group by category_id, name
Limit 1;

#5. Display the most frequently rented movies in descending order.
select count(r.rental_id) as n_rents, i.film_id, f.title 
from sakila.rental as r
left join sakila.inventory as i
on r.inventory_id=i.inventory_id
left join sakila.film as f
on i.film_id=f.film_id
group by i.film_id, f.title
order by n_rents desc;

#6. List the top five genres in gross revenue in descending order.
select * from film;

create temporary table revenue_film
select count(r.rental_id)*rental_rate as gross_revenue, i.film_id, f.title 
from sakila.rental as r
left join sakila.inventory as i
on r.inventory_id=i.inventory_id
left join sakila.film as f
on i.film_id=f.film_id
group by i.film_id, f.title
order by gross_revenue desc;

select*from revenue_film;

select fc.category_id, sum(rf.gross_revenue) as cat_revenue from revenue_film as rf
join film_category as fc
on rf.film_id=fc.film_id
group by fc.category_id
order by cat_revenue desc;

#7. Is "Academy Dinosaur" available for rent from Store 1?
select s.store_id , f.title
from store as s
join inventory as i
on s.store_id=i.store_id
join film as f
on f.film_id=i.film_id
where f.title = "Academy Dinosaur" and s.store_id= "1";
