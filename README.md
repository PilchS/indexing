## 1-ascii.sql and 3-ascii.sql are files with data

## 1. Hash-based indexes
Execute a query which displays all orders for the buk1 composition. Check the execution plan and take note of the execution times.

Add a hash-based index which can accelerate the aforementioned query to the orders table. Take note of the plan and execution plan.

## 2. B-tree indexes
Important: in this exercise, use comparison operators, not pattern matching.

Delete the index created in the previous exercise and create a similar one, but using B-trees. Repeat the previous query and take a note of the results.

Execute a query displaying orders of all compositions with IDs beginning with letters appearing before the letter 'c' in the alphabet. Is the index in use?

Run another query, displaying the remaining orders (beginning with 'c' and so on). Is the index in use now?

Try forcing the use of indexes by switching the enable_seqscan parameter:

SET ENABLE_SEQSCAN TO OFF;
This will "encourage" PostgreSQL to use indexes – this kind of optimisation may be useful when using mass storage with short seek times, such as SSD drives. Repeat the two queries and compare their execution plans and times.

## 3. Indexes and pattern matching
Create an index for the remarks column and query the database for all orders with remarks beginning with the "do" string. Is the index in use?

Delete the index and create a new one, but this time explicitly set its operator class (varchar_pattern_ops):

CREATE INDEX orders_remarks_idx ON orders (remarks varchar_pattern_ops);
Repeat the exercise and compare the results.

## 4. Multi-column indexes
Create a multi-column index covering the client_id, recipient_id and composition_id columns.

Choose one value existing in these columns and run:

a query which joins the constraints for the three columns using the AND operator,
a similar query, but using OR.
Compare the execution plans.

Now query the database for all orders of the buk1 composition.

Remove the index and create separate indexes for each of the three columns. Re-run the previous queries and compare the results.

Do not remove any indexes before the next exercise.

## 5. Indexes and sorting
Run a query which returns all orders sorted by their composition ID. Is the index in use?

Now delete the index and repeat the query. Compare results.

Drop all indexes.

## 6. Partial indexes
Create an index on the client_id column, but only for orders which have been paid. Check it by retrieving all paid orders for a given client. Repeat the query for unpaid orders.

Now calculate the sum of all unpaid orders. Is the index in use?

## 7. Indexes on expressions
Create an index and write a query which retrieves clients living in a city which begins with a given string (e.g. "krak"), regardless of the case (e.g. "krak"="Krak"="KRAK", etc.).

Check if the index runs properly.

## 8. GiST indexes
Add a column called location of type point to the orders table. Populate this column with random data within the (0,0)–(100,100) range:

ALTER TABLE orders ADD COLUMN location point;
UPDATE orders SET location=point(random()*100, random()*100);
Write queries, which:

retrieve all orders within 10 units from the city centre (50, 50),
retrieve all orders for the north-west quarter of the city.
Check the execution plan and times.