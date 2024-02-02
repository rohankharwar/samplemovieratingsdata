//CREATE CONSTRAINTS
CREATE CONSTRAINT movieId_const IF NOT EXISTS
FOR (p:Movie)
REQUIRE p.id IS UNIQUE;

CREATE CONSTRAINT personId_const IF NOT EXISTS
FOR (p:Person)
REQUIRE p.id IS UNIQUE;

//LOAD SCRIPTS

//Load movies
LOAD CSV FROM "file:///movies.csv" AS line FIELDTERMINATOR "^"
with line as r    
call {
	with r
	MERGE (m:Movie {id:toInteger(r[0])})
	ON CREATE SET m.title = r[1], category=r[2]
} IN TRANSACTIONS of 1000 ROWS;

//Added 10681 labels, created 10681 nodes, set 32043 properties, completed after 1144 ms.

//Load Person
:auto LOAD CSV FROM "file:///ratings.csv" AS line FIELDTERMINATOR "^"
with line as r    
call {
	with r
	MERGE (m:Person {id:toInteger(r[0])})
	ON CREATE SET m.name =  "JohnWick"+toInteger(r[0])
} IN TRANSACTIONS of 1000 ROWS;

//Added 69878 labels, created 69878 nodes, set 139756 properties, completed after 96645 ms.


//Load Ratings relationship between Person and Movie. 
:auto LOAD CSV FROM "file:///ratings.csv" AS line FIELDTERMINATOR "^"
with line as r    
call {
	WITH r
	MATCH (m:Movie {id:toInteger(r[1])})
	MATCH (p:Person {id:toInteger(r[0])})
	MERGE (p)-[:RATED{ratings:r[2], timestamp:toInteger(r[3])}]->(m)
	} IN TRANSACTIONS OF 1000 ROWS;


//Set 20000108 properties, created 10000054 relationships, completed after 581986 ms.


