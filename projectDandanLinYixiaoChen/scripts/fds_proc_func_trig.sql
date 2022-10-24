use foodordersystem;

#### 用户登录以及基本信息相关操作 ####
-- 1. test if username exists in the database 创建用户时检查用户名是否存在
DROP FUNCTION IF EXISTS check_username;
DELIMITER //
CREATE FUNCTION check_username(input_username varchar(64))
RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
	DECLARE res VARCHAR(64) DEFAULT 'NULL';
    SELECT user_name INTO res
		FROM customer WHERE user_name = input_username;
	IF res != 'NULL'
		THEN RETURN 1;
	END IF;
    RETURN 0;
END //
DELIMITER ;

-- SELECT user_name FROM customer WHERE user_name = 'test';
-- SELECT check_username('bob') AS result;
-- SELECT check_username('test') AS result;
-- SELECT check_username('whatever') AS result;

-- 2. login check username & pass word 登录检查用户名密码 登录成功返回用户Id
DROP FUNCTION IF EXISTS check_username_password;
DELIMITER //
CREATE FUNCTION check_username_password(input_username VARCHAR(64),input_password VARCHAR(64))
RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
	DECLARE res VARCHAR(16) DEFAULT 'NULL';
    SELECT user_name INTO res
		FROM customer WHERE user_name = input_username AND pass_word = input_password;
	IF res != 'NULL'
		THEN return (select cus_Id FROM customer WHERE user_name = input_username);
	END IF;
    RETURN 1;
END //
DELIMITER ;

-- CALL check_username_password('test', '12', @login_status);
-- SELECT check_username_password('test', '12') as result;
-- SET @login_status = 1;
-- select check_username_password('bob', 'success');
-- SELECT @login_status;


-- 3. create new user 创建新用户
DROP PROCEDURE IF EXISTS create_newuser;
DELIMITER //
CREATE PROCEDURE create_newuser(
IN input_username VARCHAR(64), 
IN input_password VARCHAR(64), 
IN input_name VARCHAR(64), 
IN input_phonenumber INT, 
IN input_address VARCHAR(128),
IN input_zipcode INT)
BEGIN
	INSERT INTO customer (user_name, pass_word, cus_name, phone_number, address, zip_code) 
		VALUES (input_username, input_password, input_name, input_phonenumber, input_address, input_zipcode);
END //
DELIMITER ;

-- CALL create_newuser('new_user','new_pwd','new_name', 1234567890, 'cs5200@northeaster.edu','new_address', '12345');
-- SELECT * FROM customer;

/*
-- 4. function to get cus_Id 为系统获取用户Id
DROP FUNCTION IF EXISTS get_userId;
DELIMITER //
CREATE FUNCTION get_userId (current_username VARCHAR(64))
RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
	RETURN (select cus_Id FROM customer WHERE user_name = current_username);
END // 
*/

-- 5. triger to update delivery address 创建用户后自动添加默认地址
DROP TRIGGER IF EXISTS set_default_address;
DELIMITER //
CREATE TRIGGER set_default_address
AFTER INSERT ON customer 
FOR EACH ROW
BEGIN
	INSERT INTO delivery_address(cus_Id, recipient_name, call_number, address, zip_code) 
		VALUES (new.cus_Id, new.cus_name, new.phone_number, new.address, new.zip_code);
END //
DELIMITER ;

-- SELECT * FROM delivery_address;


-- 6. procedure to check current availabe address 查询当前储存的寄送地址
DROP PROCEDURE IF EXISTS check_deliver_address;
DELIMITER //
CREATE PROCEDURE check_deliver_address(IN current_userId VARCHAR(64))
BEGIN 
	SELECT address_Id, recipient_name, call_number, address, zip_code
	FROM delivery_address WHERE cus_Id = current_userId;
END //

DELIMITER ; 

-- CALL check_deliver_address(4);

-- 7. porcedure to create new address 允许用户创建新的配送地址
DROP PROCEDURE IF EXISTS create_new_address; 
DELIMITER //
CREATE PROCEDURE create_new_address(
IN current_userId VARCHAR(64),
IN new_name VARCHAR(64),
IN new_number INT,
IN new_address VARCHAR(64),
IN new_zipcode INT)
BEGIN 
	INSERT INTO delivery_address (cus_Id, recipient_name, call_number, address, zip_code)
		VALUES (current_userId, new_name, new_number, new_address, new_zipcode);
END //
DELIMITER ;

-- CALL create_new_address(4, 'same_user', '0987654321','add_address1','54321');
-- CALL check_deliver_address(4);

-- 8. func to delete an current address 允许用户删除对应地址
DROP PROCEDURE IF EXISTS delete_current_address;
DELIMITER //
CREATE PROCEDURE delete_current_address(current_userId VARCHAR(64), target_Id INT)
BEGIN 
	DELETE FROM delivery_address WHERE cus_Id = current_userId AND address_Id = target_Id;
    CALL check_deliver_address(current_userId);
END //
DELIMITER ;

-- CALL delete_current_address(4, 5);

-- 9. 用户修改密码 
DROP PROCEDURE IF EXISTS change_password;
DELIMITER //
CREATE PROCEDURE change_password(
IN current_userId INT, 
IN current_password VARCHAR(64), 
IN new_password VARCHAR(64))
BEGIN 
	DECLARE check_signal VARCHAR(64) DEFAULT 'NULL';
	SELECT pass_word INTO check_signal FROM customer
		WHERE (cus_Id = current_userId AND pass_word = current_password);
	IF check_signal != 'NULL' THEN
		SELECT ('0') as result;
		UPDATE customer SET pass_word = new_password
			WHERE (cus_Id = current_userId AND pass_word = current_password);
	ELSE 
		SELECT ('1') as result;
	END IF;
END //
DELIMITER ;

-- CALL change_password('6','wzrylb','wzry');

-- CALL change_password('3', 'TEST','123','12');

-- 10. 用户修改地址 暂时可以通过删除和新建地址替代

#### 用户订单相关操作 ####

-- 1. 用户浏览店铺名单
DROP PROCEDURE IF EXISTS list_restaurant;
DELIMITER //
CREATE PROCEDURE list_restaurant()
BEGIN
	SELECT res_Id, res_name, rating, num_sales FROM restaurant;
END //
DELIMITER ;

-- CALL list_restaurant();

-- 2. 用户查询历史订单
DROP PROCEDURE IF EXISTS list_order;
DELIMITER //
CREATE PROCEDURE list_order(IN current_userId INT)
BEGIN
	SELECT order_Id, food_order.current_status, est_delivery_time, res_name as restaurant, address, recipient_name, call_number as contact_number, total_price
		FROM food_order 
        -- JOIN driver USING (driver_Id)
		JOIN restaurant USING (res_Id)
        JOIN delivery_address USING (address_Id)
        WHERE food_order.cus_Id = current_userId
        order by order_Id desc
        LIMIT 5;
END //
DELIMITER ;

-- CALL list_order(6);

-- 3. 显示用户当前可以评论的订单信息
DROP PROCEDURE IF EXISTS available_to_evaluate;
DELIMITER //
CREATE PROCEDURE available_to_evaluate(IN current_userId INT)
BEGIN 
	SELECT order_Id, res_name as restaurant, recipient_name, total_price
		FROM food_order 
        JOIN restaurant USING (res_Id)
        JOIN delivery_address USING (address_Id)
        WHERE food_order.cus_Id = current_userId AND current_status = 'Order has been delivered';
END //
DELIMITER ;

-- CALL available_to_evaluate(4);

-- 4. 查询当前餐馆近期评论
DROP PROCEDURE IF EXISTS check_recent_comment;
DELIMITER //
CREATE PROCEDURE check_recent_comment(IN selected_res INT)
BEGIN 
	SELECT com_Id, com_description, rating FROM cus_comment
		WHERE res_Id = selected_res
        order by com_Id desc
        limit 5;
END //
DELIMITER ;

-- CALL check_recent_comment(1);

-- 5. 用户给已完成订单写评论
DROP PROCEDURE IF EXISTS write_comment;
DELIMITER //
CREATE PROCEDURE write_comment(IN current_userId INT, IN input_orderId INT, IN rating real, IN content VARCHAR(256))
BEGIN
	DECLARE check_order INT DEFAULT 0;
	DECLARE related_res INT;
    SELECT order_Id INTO check_order FROM food_order WHERE cus_Id = current_userId AND current_status = 'Order has been delivered';
    IF check_order != 0 THEN 
		SELECT res_Id INTO related_res FROM food_order WHERE order_Id = input_orderId;
        SELECT (related_res) as result;
		INSERT INTO cus_comment(cus_Id, rating, com_description, order_Id, res_Id)
			VALUES (current_userId, rating, content, input_orderId, related_res);
		-- CALL check_recent_comment(input_orderId);
    ELSE 
		SELECT (0) as result;
    END IF;
END //
DELIMITER ;

-- SELECT * FROM food_order;
-- CALL write_comment(4, 2, 5, 'wonderful');
-- DELETE FROM cus_comment WHERE com_Id < 10;
-- SELECT * FROM cus_comment;

-- 6.评价更新后的trigger
DROP TRIGGER IF EXISTS after_comment_insert;
DELIMITER //
CREATE TRIGGER after_comment_insert
AFTER INSERT ON cus_comment FOR EACH ROW
BEGIN
	UPDATE restaurant 
		SET rating = (SELECT sum(rating)/count(rating) FROM cus_comment WHERE res_Id = new.res_Id),
			num_sales = (SELECT count(rating) FROM cus_comment WHERE res_Id = new.res_Id)
        WHERE res_Id = new.res_Id;
	UPDATE food_order 
		SET current_status = 'Evaluation completed'
        WHERE order_Id = new.order_Id;
END //
DELIMITER ;
-- SELECT * FROM restaurant;

-- 7. 用户查询当前店铺商品
DROP PROCEDURE IF EXISTS Browse_the_menu;
DELIMITER //
CREATE PROCEDURE Browse_the_menu(IN selected_res INT)
BEGIN
	SELECT cuisine_Id, cuisine_name, unit_price, num_sales FROM cuisine WHERE res_Id = selected_res;
END //
DELIMITER ;

-- CALL Browse_the_menu(1);

-- 8. 用户点菜 需要先创建订单
-- SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS create_order;
DELIMITER //
CREATE FUNCTION create_order(customerId INT, restaurantId INT)
RETURNS INT
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
    INSERT INTO food_order (res_Id, cus_Id, current_status) 
		VALUES (restaurantId, customerId, 'order created');
	RETURN (SELECT order_Id FROM food_order WHERE cus_Id = customerId ORDER BY order_Id DESC LIMIT 1);
END //
DELIMITER ;

-- SELECT create_order(4, 1, 4) as ;
-- SELECT * FROM food_order;

-- 9. 显示当前用户菜单
DROP PROCEDURE IF EXISTS load_cart;
DELIMITER //
CREATE PROCEDURE load_cart(IN orderId INT)
BEGIN
	SELECT cuisine_name, quantity 
		FROM order_detail JOIN cuisine USING (cuisine_Id)
		WHERE order_Id = orderId;
END //
DElIMITER ; 

-- call load_cart(18);

-- 10. 用户点菜 加菜进入当前菜单
DROP PROCEDURE IF EXISTS add_cuisine;
DELIMITER //
CREATE PROCEDURE add_cuisine(IN orderId INT, IN cuisineId INT, IN num INT, IN resid INT)
BEGIN
	IF cuisineId IN (SELECT cuisine_Id FROM cuisine WHERE res_Id = resid) THEN
		INSERT INTO order_detail(order_Id, cuisine_Id, quantity) 
			VALUES (orderId, cuisineId, num);
	END IF;
	CALL load_cart(orderId);
END //
DElIMITER ; 

-- INSERT INTO order_detail (order_Id, cuisine_Id, quantity) VALUES (17, 1, 5);
-- select * from order_detail;

-- 11. 用户删除某个商品
DROP PROCEDURE IF EXISTS delete_cuisine;
DELIMITER //
CREATE PROCEDURE delete_cuisine(IN orderId INT, IN cuisineId INT, IN resid INT)
BEGIN
	IF cuisineId IN (SELECT cuisine_Id FROM cuisine WHERE res_Id = resid) THEN
		DELETE FROM order_detail WHERE order_Id = orderId AND cuisine_Id = cuisineId;
	END IF;
    CALL load_cart(orderId);
END //
DELIMITER ;

-- 12. 添加商品后 trigger
DROP TRIGGER IF EXISTS after_cuisine_added;
DELIMITER //
CREATE TRIGGER after_cuisine_added AFTER INSERT 
ON order_detail FOR EACH ROW
BEGIN
	DECLARE unitprice INT DEFAULT 0;
	UPDATE cuisine SET num_sales = num_sales + NEW.quantity
		WHERE cuisine_Id = NEW.cuisine_Id;
	SELECT unit_price INTO unitprice 
		FROM cuisine
        WHERE cuisine_Id = NEW.cuisine_Id;
	UPDATE food_order SET total_price = total_price + unitprice * NEW.quantity WHERE order_Id = New.order_Id;
END //
DELIMITER ;

-- 13. 删除商品后trigger
DROP TRIGGER IF EXISTS after_cuisine_delete;
DELIMITER //
CREATE TRIGGER after_cuisine_delete AFTER DELETE 
ON order_detail FOR EACH ROW
BEGIN
	DECLARE unitprice INT DEFAULT 0;
	UPDATE cuisine SET num_sales = num_sales - OLD.quantity
		WHERE cuisine_Id = OLD.cuisine_Id;
	SELECT unit_price INTO unitprice 
		FROM cuisine
        WHERE cuisine_Id = OLD.cuisine_Id;
	UPDATE food_order SET total_price = total_price - unitprice * OLD.quantity WHERE order_Id = OLD.order_Id;
END //
DELIMITER ;

-- 14. 用户确认地址
DROP PROCEDURE IF EXISTS user_select_address;
DELIMITER //
CREATE PROCEDURE user_select_address(IN ordeId INT, IN addressId INT)
BEGIN
	UPDATE food_order SET address_Id = addressId
		WHERE order_Id = ordeId;
END //
DELIMITER ;

-- 15. 用户确认下单
DROP PROCEDURE IF EXISTS user_confirm_order;
DELIMITER //
CREATE PROCEDURE user_confirm_order(IN orderId INT)
BEGIN
	UPDATE food_order SET current_status = 'order confirmed'
		WHERE order_Id = orderId;
	SELECT order_Id, food_order.current_status as status, est_delivery_time, res_name as restaurant, address, recipient_name, call_number as contact_number, total_price
		FROM food_order 
		JOIN restaurant USING (res_Id)
        JOIN delivery_address USING (address_Id)
        WHERE order_Id = orderId;
END //
DELIMITER ;

-- select * from food_order;
-- SELECT order_Id, food_order.current_status, est_delivery_time, res_name as restaurant, address, recipient_name, call_number as contact_number, total_price
-- 		FROM food_order 
-- 		JOIN restaurant USING (res_Id)
--         JOIN delivery_address USING (address_Id)
--         WHERE order_Id = 15;





