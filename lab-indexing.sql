
\o exercise1.txt
EXPLAIN SELECT * FROM orders WHERE composition_id = 'buk1';
CREATE INDEX idx_orders_buk1 ON orders USING hash (composition_id);
EXPLAIN SELECT * FROM orders WHERE composition_id = 'buk1';
\o

\o exercise2.txt
DROP INDEX idx_orders_buk1;
CREATE INDEX idx_orders_buk1 ON orders (composition_id);
EXPLAIN SELECT * FROM orders WHERE composition_id = 'buk1';
EXPLAIN SELECT * FROM orders WHERE composition_id < 'c%';
EXPLAIN SELECT * FROM orders WHERE composition_id >= 'c%';
SET ENABLE_SEQSCAN TO OFF;
EXPLAIN SELECT * FROM orders WHERE composition_id < 'c%';
EXPLAIN SELECT * FROM orders WHERE composition_id >= 'c%';
DROP INDEX idx_orders_buk1;
\o

\o exercise3.txt
CREATE INDEX idx_orders_remarks ON orders (remarks);
EXPLAIN SELECT * FROM orders WHERE remarks LIKE 'do%';
DROP INDEX idx_orders_remarks;
CREATE INDEX idx_orders_remarks ON orders (remarks varchar_pattern_ops);
EXPLAIN SELECT * FROM orders WHERE remarks LIKE 'do%'; 
\o

\o exercise4.txt
CREATE INDEX index3_4 ON orders (client_id, recipient_id, composition_id);
EXPLAIN SELECT * FROM orders WHERE client_id LIKE ‘mmisiek’ AND composition_id = ‘buk2’ AND recipient_id = 2;
EXPLAIN SELECT * FROM orders WHERE client_id LIKE ‘mmisiek’ OR composition_id = ‘buk2’ OR recipient_id = 2;
EXPLAIN SELECT * FROM orders WHERE composition_id = ‘buk1’;
DROP INDEX index3_4;
CREATE INDEX idx_orders_client_id ON orders (client_id);
CREATE INDEX idx_orders_recipient_id ON orders (recipient_id);
CREATE INDEX idx_orders_composition_id ON orders (composition_id);
\o

\o exercise5.txt
EXPLAIN SELECT * FROM orders ORDER BY composition_id ASC;
DROP INDEX idx_orders_composition_id;
EXPLAIN SELECT * FROM orders ORDER BY composition_id ASC;
DROP INDEX idx_orders_client_id;
DROP INDEX idx_orders_recipient_id;
\o

\o exercise6.txt
CREATE INDEX idx_orders_client_id ON orders (client_id) WHERE NOT paid = ‘n’;
EXPLAIN SELECT * FROM orders WHERE paid = ‘t’ AND client_id = ‘caro’;
EXPLAIN SELECT * FROM orders WHERE paid = ‘f’ AND client_id = ‘amanda’;
EXPLAIN SELECT SUM(price) FROM orders WHERE paid = ‘f’;
\o

\o exercise7.txt
CREATE INDEX idx_clients_city ON clients(lower(city));
EXPLAIN SELECT name, city FROM clients WHERE lower(city) LIKE lower(‘krak%’);
DROP INDEX idx_clients_city;
\o

\o exercise8.txt
ALTER TABLE orders ADD COLUMN location point;
UPDATE orders SET location=point(random()*100, random()*100);
EXPLAIN SELECT *FROM orders WHERE location <-> point(50, 50) < 10;
EXPLAIN SELECT *FROM orders WHERE location <-> point(0, 100) < 50;
CREATE INDEX idx_orders_location ON orders USING GIST (location);
EXPLAIN SELECT *FROM orders WHERE location <-> point(50, 50) < 10;
EXPLAIN SELECT *FROM orders WHERE location <-> point(0, 100) < 50;
DROP INDEX idx_orders_location;
\o