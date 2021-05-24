https://postgres.devmountain.com/

-- JOINS
--Get all invoices where the unit_price on the  invoice_line is greater than $0.99.
SELECT *
FROM invoice  shrek
JOIN invoice_line donkey ON shrek.invoice_id = donkey.invoice_id
WHERE donkey.unit_price > 0.99

-- Get the invoice_date, customer first_name and last_name, and total from all invoices.
SELECT invoice.invoice_date, customer.first_name, customer.last_name, invoice.total
FROM invoice
JOIN customer ON invoice.customer_id = customer.customer_id

-- Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e 
ON e.employee_id = c.support_rep_id

-- Get the album title and the artist name from all albums.
SELECT album.title, artist.name
FROM artist
JOIN album ON
album.artist_id = artist.artist_id  

-- Get all playlist_track track_ids where the playlist name is Music.
SELECT *
FROM playlist pl
JOIN playlist_track pt
ON pl.playlist_id = pt.playlist_id
WHERE pl.name = 'Music'

-- Get all track names for playlist_id 5.
SELECT t.name
FROM track t
JOIN playlist_track pt  
ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5

-- Get all track names and the playlist name that they're on ( 2 joins ).
SELECT t.name, pl.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist pl ON pt.playlist_id = pl.playlist_id

-- Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
SELECT t.name, al.title
FROM album al
JOIN track t ON t.album_id = al.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk'

-- *** BLACK DIAMOND*** I'M AMAZING!!!! 
-- Get all tracks on the playlist(s) called Music and show their name, genre name, album name, and artist name.
-- At least 5 joins.

SELECT *
FROM track t
JOIN playlist_track pt
ON t.track_id = pt.track_id
JOIN playlist pl
ON pt.playlist_id = pl.playlist_id
JOIN album al
ON t.album_id = al.album_id
JOIN artist ar
on al.artist_id = ar.artist_id
JOIN genre g
ON g.genre_id = t.genre_id
WHERE pl.name = 'Music'


--NESTED QUERIES
--Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT *
FROM invoice
WHERE invoice_id IN 
(SELECT invoice_id
 FROM invoice_line 
WHERE unit_price > 0.99)

-- Get all playlist tracks where the playlist name is Music.
SELECT *
FROM playlist_track
WHERE playlist_id IN
(SELECT playlist_id 
 FROM playlist 
 WHERE name = 'Music')

-- Get all track names for playlist_id 5.
SELECT name
FROM track
WHERE track_id IN 
(SELECT track_id 
 FROM playlist_track 
 WHERE playlist_id = 5 );

-- Get all tracks where the genre is Comedy.
SELECT *
FROM track
WHERE genre_id IN
(SELECT genre_id
 FROM genre 
 WHERE name = 'Comedy')

-- Get all tracks where the album is Fireball.
SELECT *
FROM track
WHERE album_id IN
(SELECT album_id
FROM album
WHERE name = 'Fireball')

-- Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT *
FROM track
WHERE album_id IN 
(SELECT album_id FROM album WHERE artist_id IN 
 (SELECT artist_id FROM artist WHERE name = 'Queen')); 

--UPDATING ROWS
-- Find all customers with fax numbers and set those numbers to null.
UPDATE customer
SET fax = null
WHERE fax IS NOT null

SELECT fax
FROM customer

-- Find all customers with no company (null) and set their company to "Self".
UPDATE customer
SET company = 'self'
WHERE company IS null

-- Find the customer Julia Barnett and change her last name to Thompson.
SELECT *
FROM customer
WHERE last_name = 'Thompson'

UPDATE customer 
SET last_name = 'Thompson'
WHERE last_name = 'Barnett'
-- Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl'

SELECT *
FROM customer
WHERE email = 'luisrojas@yahoo.cl'

-- Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = ( SELECT genre_id 
FROM genre 
WHERE name = 'Metal' )
AND composer IS null;


-- GROUP BY
-- Find a count of how many tracks there are per genre. Display the genre name with the count.
SELECT count(*),genre.name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY genre.name

-- Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT COUNT(*),genre.name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Pop' OR genre.name = 'Rock'
GROUP BY genre.name
--tried using AND but it did not work. 

-- Find a list of all artists and how many albums they have.
SELECT COUNT(*), artist.name
FROM album
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY artist.name;

--DISTINCT
-- From the track table find a unique list of all composers.
SELECT DISTINCT composer
FROM track
-- From the invoice table find a unique list of all billing_postal_codes.
SELECT DISTINCT billing_postal_code
FROM invoice;
-- From the customer table find a unique list of all companys.
SELECT DISTINCT company
FROM customer;

--DELETE ROWS
-- Delete all 'bronze' entries from the table.
DELETE 
FROM practice_delete 
WHERE type = 'bronze';

-- Delete all 'silver' entries from the table.
DELETE 
FROM practice_delete 
WHERE type = 'silver';

-- Delete all entries whose value is equal to 150.
DELETE 
FROM practice_delete 
WHERE value = 150;

--eCommerce Simulation--
-- Create 3 tables following the criteria in the summary.
CREATE TABLE users (user_id SERIAL PRIMARY KEY, name VARCHAR (100) NOT NULL, email VARCHAR (100));

CREATE TABLE products (product_id SERIAL PRIMARY KEY, product_name VARCHAR (200) NOT NULL, price NUMERIC NOT NULL);

CREATE TABLE orders (order_id SERIAL PRIMARY KEY, product_name VARCHAR (200), price NUMERIC,   customer_name VARCHAR (100));


-- Add some data to fill up each table. At least 3 users, 3 products, 3 orders.
INSERT INTO users (name, email) VALUES ('Ron Weasley', 'rweasley@hogwarts.edu');
INSERT INTO users (name, email) VALUES ('Hermione Granger', 'hgranger@hogwarts.edu');
INSERT INTO users (name, email) VALUES ('Harry Potter', 'hjpotter@hogwarts.edu');
INSERT INTO users (name, email) VALUES ('Albus Dumbledore', 'adumbledore@hogwarts.faculty.edu');

INSERT INTO products (product_name, price) VALUES ('Wizard Wand', 77.70 )
INSERT INTO products (product_name, price) VALUES ('Nimbus 2000', 500)
INSERT INTO products (product_name, price) VALUES ('Essential Potions Kit', 60.99)
INSERT INTO products (product_name, price) VALUES ('Textbook: History of Magic', 19.50)

INSERT INTO orders (product_name, price, customer_name) VALUES ('Wizard Wand', 77.70, 'Harry Potter');
INSERT INTO orders (product_name, price, customer_name) VALUES ('Nimbus 2000', 500, 'Harry Potter');
INSERT INTO orders (product_name, price, customer_name) VALUES ('Textbook: History of Magic', 19.50, 'Hermione Granger'); 
INSERT INTO orders (product_name, price, customer_name) VALUES ('Essential Potions Kit', 60.99, 'Hermione Granger');
INSERT INTO orders (product_name, price, customer_name) VALUES ('Wizard Wand', 77.70, 'Ron Weasley');

-- Run queries against your data.
-- Get all products for the first order.
ers (product_name, price, customer_name) VALUES ('Wizard Wand', 77.70, 'Ron Weasley');

-- Get all orders.
SELECT *
FROM orders

-- Get the total cost of an order ( sum the price of all products on an order ).
SELECT SUM (price)
from orders
where customer_name = 'Harry Potter';

-- Add a foreign key reference from orders to users.
SELECT * 
FROM orders
JOIN users
ON users.name = orders.name
WHERE users.name = 'Harry Potter';

-- Run queries against your data.
-- Get all orders for a user.
SELECT * FROM orders
WHERE name = 'Hermione Granger';

-- Get how many orders each user has.
SELECT COUNT(*), name
FROM orders
GROUP_BY (name)