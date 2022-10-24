DROP DATABASE IF EXISTS foodordersystem;
CREATE DATABASE IF NOT EXISTS foodordersystem;
USE foodordersystem;

-- DROP TABLE IF EXISTS restaurant;
CREATE TABLE restaurant (
	res_Id int primary key auto_increment,
    res_name varchar(64) not null,
    rating float,
    num_sales int 
);

-- DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	cus_Id int primary key auto_increment,
    cus_name varchar(64) default null,
    phone_number int default null,
    user_name varchar(64) unique,
    pass_word varchar(64),
    address varchar(128),
    zip_code int
);

-- DROP TABLE IF EXISTS delivery_address;
CREATE TABLE delivery_address (
	address_Id int primary key auto_increment,
    cus_Id int,
    recipient_name varchar(64),
    call_number int,
    address varchar(128),
    zip_code int,
    foreign key (cus_Id) references customer(cus_Id)
    on update cascade on delete cascade
);

-- DROP TABLE IF EXISTS driver;
CREATE TABLE driver (
	driver_Id int primary key auto_increment,
    d_name varchar(64) not null,
    phone_number int not null,
    current_status varchar(64) default 'free'
);

-- DROP TABLE IF EXISTS cuisine;
CREATE TABLE cuisine (
	cuisine_Id int primary key auto_increment,
    res_Id int,
    cuisine_name varchar(64) not null,
    unit_price real not null,
    num_sales int,
    foreign key (res_Id) references restaurant(res_Id)
     on update cascade on delete cascade
);

-- DROP TABLE IF EXISTS food_order;
CREATE TABLE food_order (
	order_Id int primary key auto_increment,
    est_delivery_time time,
    res_Id int,
    cus_Id int,
    driver_Id int,
    address_Id int,
    total_price real default 0,
    current_status varchar(128),
    foreign key (res_Id) references restaurant(res_Id)
    on update cascade on delete cascade,
    foreign key (cus_Id) references customer(cus_Id)
    on update cascade on delete cascade,
    foreign key (driver_Id) references driver(driver_Id)
    on update cascade on delete cascade,
    foreign key (address_Id) references delivery_address(address_Id)
    on update cascade on delete cascade
);

DROP TABLE IF EXISTS cus_comment;
CREATE TABLE cus_comment (
	com_Id int primary key auto_increment,
    rating real not null,
    cus_Id int,
    com_description varchar(256) not null,
    order_Id int,
    res_Id int,
    foreign key (res_Id) references restaurant(res_Id)
    on update cascade on delete cascade,
    foreign key (order_Id) references food_order(order_Id)
    on update cascade on delete cascade,
    foreign key (cus_Id) references customer(cus_Id)
    on update cascade on delete cascade
);

DROP TABLE IF EXISTS order_detail;
CREATE TABLE order_detail (
	order_Id int,
    cuisine_Id int,
    quantity int,
    foreign key (order_Id) references food_order(order_Id)
    on update cascade on delete cascade, 
    foreign key (cuisine_Id) references cuisine(cuisine_Id)
    on update cascade on delete set null
);

