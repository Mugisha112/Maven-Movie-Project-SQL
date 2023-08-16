/*My partner and I want to come by each of the stores in person and meet the managers. Please send over
the managers’ names at each store, with the full address of each property (street address, district, city, and
country please).*/
SELECT 
    s.store_id,
    CONCAT(first_name, ' ', last_name) AS Manager_name,
    CONCAT(address, ', ', city, ', ', district, ', ', country) AS Store_full_address
FROM
    store as s
        JOIN
    staff as st ON s.manager_staff_id = st.staff_id
        JOIN
    address as a ON s.address_id = a.address_id
        JOIN
    city as c ON c.city_id = a.city_id
        JOIN
    country as co ON co.country_id = c.country_id
    
/*I would like to get a better understanding of all of the inventory that would come along with the business.
Please pull together a list of each inventory item you have stocked, including the store_id number, the
inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost.*/
SELECT 
    i.store_id,
    i.inventory_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
FROM
    inventory AS i
        JOIN
    film AS f ON f.film_id = i.film_id
ORDER BY store_id

/*From the same list of films you just pulled, please roll that data up and provide a summary level overview of
your inventory. We would like to know how many inventory items you have with each rating at each store.*/
SELECT 
    i.store_id,
    f.rating,
    COUNT(i.inventory_id) AS Total_inventory
FROM
    film AS f
        JOIN
    inventory AS i ON f.film_id = i.film_id
GROUP BY 1, 2
ORDER BY store_id

/*Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement
cost, sliced by store and film category.*/
SELECT 
    i.store_id,
    c.name Category,
    COUNT(i.inventory_id) AS Number_of_films,
    ROUND(AVG(replacement_cost), 2) AS Average_replacement_cost,
    SUM(replacement_cost) AS Total_replacement_cost
FROM
    film AS f
        JOIN
    inventory AS i ON f.film_id = i.film_id
        JOIN
    film_category AS fc ON i.film_id = fc.film_id
        JOIN
    category AS c ON fc.category_id = c.category_id
GROUP BY 1, 2
ORDER BY 1

/*We want to make sure you folks have a good handle on who your customers are. Please provide a list
of all customer names, which store they go to, whether or not they are currently active, and their full
addresses – street address, city, and country.*/
SELECT 
    CONCAT(first_name, ' ', last_name) AS Customer_name,
    c.store_id,
    CASE WHEN active = 1 THEN 'Active' ELSE 'Inactive' END AS Status,
    CONCAT(address, ', ', city, ', ', country) AS Customer_full_address
FROM
    customer AS c
        JOIN
    address AS a ON c.address_id = a.address_id
        JOIN
    city AS ct ON a.city_id = ct.city_id
        JOIN
    country AS co ON co.country_id = ct.country_id
ORDER BY 2, 3

/*We would like to understand how much your customers are spending with you, and also to know who your
most valuable customers are. Please pull together a list of customer names, their total lifetime rentals, and the
sum of all payments you have collected from them. It would be great to see this ordered on total lifetime value,
with the most valuable customers at the top of the list.*/
SELECT 
    CONCAT(first_name, ' ', last_name) AS Customer_name,
    COUNT(p.rental_id) AS Lifetime_rentals,
    SUM(p.amount) AS Total_payments
FROM
    customer AS c
        JOIN
    payment AS p ON c.customer_id = p.customer_id
GROUP BY Customer_name
ORDER BY Total_payments DESC

/*My partner and I would like to get to know your board of advisors and any current investors. Could you
please provide a list of advisor and investor names in one table? Could you please note whether they are an
investor or an advisor, and for the investors, it would be good to include which company they work with.*/
SELECT 
    'Advisor' AS Title,
    CONCAT(first_name, ' ', last_name) AS Full_name,
    Null As Company_name
FROM
    advisor 
UNION SELECT 
    'Investor',
    CONCAT(first_name, ' ', last_name) AS Full_name,
    company_name
FROM
    investor
    
    /*We're interested in how well you have covered the most-awarded actors. Of all the actors with three types of
awards, for what % of them do we carry a film? And how about for actors with two types of awards? Same
questions. Finally, how about actors with just one award?*/
SELECT 
    CASE WHEN awards = 'Emmy, Oscar, Tony ' THEN '3 awards' WHEN awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards' 
    ELSE '1 award' END  'Number of awards', (COUNT(actor_id)/COUNT(actor_award_id)) * 100 '% of awarded actors we carry film'
FROM
    actor_award AS a
    Group by Case when awards = 'Emmy, Oscar, Tony ' THEN '3 awards' When awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') then '2 awards' 
    ELSE '1 award' END
Order by 1
