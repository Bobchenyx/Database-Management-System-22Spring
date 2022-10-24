##### HW3 YIXIAO CHEN #####
##### PROBLEM 2 #####
##### a. How many databases are created by the script? #####
-- 3

##### b. List the database names and the tables created for each database. #####
-- database [ap] 7 tables
-- general_ledger_accounts | terms | vendors | invoices 
-- invoice_line_items | vendor_contacts | invoice_archive

-- database [ex] 11 tables
-- null_sample | departments | employees | projects | customers
-- color_sample | string_sample | float_sample | date_sample
-- active_invoices | paid_invoices

-- database [om] 4 tables
-- customers | items | orders | order_details 

##### c. How many records does the script insert into the om.order_details table? #####
-- 68

##### d. How many records does the script insert into the ap.invoices table? #####
-- 114

##### e. How many records does the script insert into the ap.vendors table? #####
-- 122

##### f. Is there a foreign key between the ap.invoices and the ap.vendors table? #####
-- YES(TRUE)

##### g. How many foreign keys does the ap.vendors table have? #####
-- 2

##### h. What is the primary key for the om.customers table? #####
-- customer_id

##### i. Write a SQL command that will retrieve all values for all fields from the orders table ##### 
USE om;
SELECT * FROM orders;

##### j. Write a SQL command that will retrieve the fields: title and artist from the om.items table #####
USE om;
SELECT title,artist FROM items;

##### PROBLEM 5 #####
##### a. How many tables are created by the script? 
-- 11

##### b. List the names of the tables created for the Chinook database. 
-- Album | Artist | Customer | Employee | Genre | Invoice
-- InvoiceLine | MediaType | Playlist | PlaylistTrack | Track

##### c. How many records does the script insert into the Album table? 
-- 347

##### d. What is the primary key for the Album table? 
-- AlbumId

##### e. Write a SQL SELECT command to retrieve all data from all columns and rows in the Artist table. 
USE Chinook;
SELECT * FROM Artist;

##### f. Write a SQL SELECT command to retrieve the fields FirstName, LastName and Title from the Employee table
USE Chinook;
SELECT FirstName, LastName, Title FROM Employee;

