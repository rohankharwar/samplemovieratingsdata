//Query : Number of Ratings by person 
match (p:Person)
RETURN p, count{(p)-[:RATED]->()} as no_of_ratings
ORDER BY no_of_ratings DESC
LIMIT 100

//Started streaming 100 records after 69 ms and completed after 378 ms.