use foodordersystem;

SELECT * FROM foodordersystem.customer;
DELETE FROM foodordersystem.customer WHERE user_name = 'test';
INSERT INTO foodordersystem.customer(user_name, pass_word) VALUES ('test','123');

SELECT * FROM delivery_address;

INSERT INTO restaurant(res_name, rating, num_sales) VALUES ('res_test', 0, 0);
INSERT INTO driver(d_name, phone_number, rating, current_status) VALUES ('driver_test', '1234567890', 0, 'free');
INSERT INTO food_order(res_Id, cus_Id, driver_Id, address_Id, total_price, current_status) 
	VALUES(1, 4, 1, 4, 0, 'Order has been delivered');

DELETE FROM food_order WHERE order_Id = 1;
SELECT * FROM food_order;

INSERT INTO cuisine (res_Id, cuisine_name, unit_price) VALUES (1, 'test_cuisine', 5);
SELECT * from cuisine; 

select * from customer;
select * from food_order;

select * from delivery_address;
INSERT INTO food_order(res_Id, cus_Id, driver_Id, address_Id, total_price, current_status) 
	VALUES(1, 6, 1, 7, 0, 'Order has been delivered');
    
select * from restaurant;
select * from cus_comment;

INSERT INTO driver(d_name, phone_number, current_status) VALUES ('driver_test', '1234567890', 'free');