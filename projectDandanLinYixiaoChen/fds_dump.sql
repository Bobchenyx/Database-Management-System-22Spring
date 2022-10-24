-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: foodordersystem
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cuisine`
--

DROP TABLE IF EXISTS `cuisine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuisine` (
  `cuisine_Id` int NOT NULL AUTO_INCREMENT,
  `res_Id` int DEFAULT NULL,
  `cuisine_name` varchar(64) NOT NULL,
  `unit_price` double NOT NULL,
  `num_sales` int DEFAULT NULL,
  PRIMARY KEY (`cuisine_Id`),
  KEY `res_Id` (`res_Id`),
  CONSTRAINT `cuisine_ibfk_1` FOREIGN KEY (`res_Id`) REFERENCES `restaurant` (`res_Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuisine`
--

LOCK TABLES `cuisine` WRITE;
/*!40000 ALTER TABLE `cuisine` DISABLE KEYS */;
INSERT INTO `cuisine` VALUES (1,1,'test_cuisine',5,NULL),(3,2,'test1',13,NULL),(4,2,'test2',3,NULL),(5,2,'test3',15,NULL),(6,3,'cuisine1',13,NULL),(8,5,'cusino1',13,NULL),(10,5,'wrirud',17,NULL),(11,6,'encuwen',13,NULL),(13,6,'sndhgcfd',7,NULL);
/*!40000 ALTER TABLE `cuisine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cus_comment`
--

DROP TABLE IF EXISTS `cus_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cus_comment` (
  `com_Id` int NOT NULL AUTO_INCREMENT,
  `rating` double NOT NULL,
  `cus_Id` int DEFAULT NULL,
  `com_description` varchar(256) NOT NULL,
  `order_Id` int DEFAULT NULL,
  `res_Id` int DEFAULT NULL,
  PRIMARY KEY (`com_Id`),
  KEY `res_Id` (`res_Id`),
  KEY `order_Id` (`order_Id`),
  KEY `cus_Id` (`cus_Id`),
  CONSTRAINT `cus_comment_ibfk_1` FOREIGN KEY (`res_Id`) REFERENCES `restaurant` (`res_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cus_comment_ibfk_2` FOREIGN KEY (`order_Id`) REFERENCES `food_order` (`order_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cus_comment_ibfk_3` FOREIGN KEY (`cus_Id`) REFERENCES `customer` (`cus_Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cus_comment`
--

LOCK TABLES `cus_comment` WRITE;
/*!40000 ALTER TABLE `cus_comment` DISABLE KEYS */;
INSERT INTO `cus_comment` VALUES (7,3,6,'just so so',4,1),(8,4,6,'just have a try',5,1),(9,5,6,'try again',6,1),(10,2,6,'not as expected',8,1),(11,1,6,'last time',9,1),(12,0,6,'so bad',10,1);
/*!40000 ALTER TABLE `cus_comment` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_comment_insert` AFTER INSERT ON `cus_comment` FOR EACH ROW BEGIN
	UPDATE restaurant 
		SET rating = (SELECT sum(rating)/count(rating) FROM cus_comment WHERE res_Id = new.res_Id),
			num_sales = (SELECT count(rating) FROM cus_comment WHERE res_Id = new.res_Id)
        WHERE res_Id = new.res_Id;
	UPDATE food_order 
		SET current_status = 'Evaluation completed'
        WHERE order_Id = new.order_Id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `cus_Id` int NOT NULL AUTO_INCREMENT,
  `cus_name` varchar(64) DEFAULT NULL,
  `phone_number` int DEFAULT NULL,
  `user_name` varchar(64) DEFAULT NULL,
  `pass_word` varchar(64) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `zip_code` int DEFAULT NULL,
  PRIMARY KEY (`cus_Id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (3,NULL,NULL,'test','12',NULL,NULL),(4,'new_name',1234567890,'new_user','new_pwd','new_address',12345),(5,'chen',1234567890,'bob','success','238 hemenway st',2115),(6,'lin',987654321,'ldd','wzrylb','landmark',2116),(7,'liu',123456,'ltr','choubao','160',2118),(8,'chen',34567,'bobchen','final','238 hemenway',2115);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `set_default_address` AFTER INSERT ON `customer` FOR EACH ROW BEGIN
	INSERT INTO delivery_address(cus_Id, recipient_name, call_number, address, zip_code) 
		VALUES (new.cus_Id, new.cus_name, new.phone_number, new.address, new.zip_code);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `delivery_address`
--

DROP TABLE IF EXISTS `delivery_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_address` (
  `address_Id` int NOT NULL AUTO_INCREMENT,
  `cus_Id` int DEFAULT NULL,
  `recipient_name` varchar(64) DEFAULT NULL,
  `call_number` int DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `zip_code` int DEFAULT NULL,
  PRIMARY KEY (`address_Id`),
  KEY `cus_Id` (`cus_Id`),
  CONSTRAINT `delivery_address_ibfk_1` FOREIGN KEY (`cus_Id`) REFERENCES `customer` (`cus_Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_address`
--

LOCK TABLES `delivery_address` WRITE;
/*!40000 ALTER TABLE `delivery_address` DISABLE KEYS */;
INSERT INTO `delivery_address` VALUES (3,3,NULL,NULL,NULL,NULL),(4,4,'new_name',1234567890,'new_address',12345),(6,5,'chen',1234567890,'238 hemenway st',2115),(7,6,'lin',987654321,'landmark',2116),(8,7,'liu',123456,'160',2118),(10,8,'chen',34567,'238 hemenway',2115),(11,6,'zhang',37563,'landmark',8267);
/*!40000 ALTER TABLE `delivery_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `driver`
--

DROP TABLE IF EXISTS `driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `driver` (
  `driver_Id` int NOT NULL AUTO_INCREMENT,
  `d_name` varchar(64) NOT NULL,
  `phone_number` int NOT NULL,
  `current_status` varchar(64) DEFAULT 'free',
  PRIMARY KEY (`driver_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `driver`
--

LOCK TABLES `driver` WRITE;
/*!40000 ALTER TABLE `driver` DISABLE KEYS */;
INSERT INTO `driver` VALUES (1,'driver_test',1234567890,'free'),(2,'driver_test',1234567890,'free'),(3,'driver_test',1234567890,'free'),(4,'driver_test',1234567890,'free'),(5,'driver_test',1234567890,'free'),(6,'driver_test',1234567890,'free'),(7,'driver_test',1234567890,'free'),(8,'driver_test',1234567890,'free');
/*!40000 ALTER TABLE `driver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_order`
--

DROP TABLE IF EXISTS `food_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_order` (
  `order_Id` int NOT NULL AUTO_INCREMENT,
  `est_delivery_time` time DEFAULT NULL,
  `res_Id` int DEFAULT NULL,
  `cus_Id` int DEFAULT NULL,
  `driver_Id` int DEFAULT NULL,
  `address_Id` int DEFAULT NULL,
  `total_price` double DEFAULT '0',
  `current_status` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`order_Id`),
  KEY `res_Id` (`res_Id`),
  KEY `cus_Id` (`cus_Id`),
  KEY `driver_Id` (`driver_Id`),
  KEY `address_Id` (`address_Id`),
  CONSTRAINT `food_order_ibfk_1` FOREIGN KEY (`res_Id`) REFERENCES `restaurant` (`res_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `food_order_ibfk_2` FOREIGN KEY (`cus_Id`) REFERENCES `customer` (`cus_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `food_order_ibfk_3` FOREIGN KEY (`driver_Id`) REFERENCES `driver` (`driver_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `food_order_ibfk_4` FOREIGN KEY (`address_Id`) REFERENCES `delivery_address` (`address_Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_order`
--

LOCK TABLES `food_order` WRITE;
/*!40000 ALTER TABLE `food_order` DISABLE KEYS */;
INSERT INTO `food_order` VALUES (2,NULL,1,4,1,4,45,'Evaluation completed'),(3,NULL,1,4,NULL,4,45,'order created'),(4,NULL,1,6,1,7,45,'Evaluation completed'),(5,NULL,1,6,1,7,45,'Evaluation completed'),(6,NULL,1,6,1,7,45,'Evaluation completed'),(7,NULL,1,4,1,4,45,'Order has been delivered'),(8,NULL,1,6,1,7,45,'Evaluation completed'),(9,NULL,1,6,1,7,45,'Evaluation completed'),(10,NULL,1,6,1,7,45,'Evaluation completed'),(11,NULL,1,6,NULL,NULL,45,'order confirmed'),(12,NULL,1,6,NULL,NULL,45,'order created'),(13,NULL,1,6,NULL,NULL,45,'order created'),(15,NULL,1,6,NULL,7,15,'order confirmed'),(16,NULL,1,6,NULL,7,0,'order confirmed'),(17,NULL,1,6,NULL,NULL,25,'order created'),(19,NULL,1,6,NULL,7,35,'order confirmed'),(20,NULL,1,6,NULL,7,30,'order confirmed'),(21,NULL,2,6,NULL,NULL,0,'order created'),(22,NULL,2,6,NULL,NULL,0,'order created'),(23,NULL,2,6,NULL,11,0,'order confirmed'),(24,NULL,2,6,NULL,NULL,0,'order created'),(26,NULL,3,6,NULL,11,0,'order confirmed'),(27,NULL,5,6,NULL,7,0,'order confirmed'),(28,NULL,6,6,NULL,11,0,'order confirmed');
/*!40000 ALTER TABLE `food_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `order_Id` int DEFAULT NULL,
  `cuisine_Id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  KEY `order_Id` (`order_Id`),
  KEY `cuisine_Id` (`cuisine_Id`),
  CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`order_Id`) REFERENCES `food_order` (`order_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`cuisine_Id`) REFERENCES `cuisine` (`cuisine_Id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (23,3,5),(23,4,3),(26,6,3),(27,8,3),(28,11,3);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `res_Id` int NOT NULL AUTO_INCREMENT,
  `res_name` varchar(64) NOT NULL,
  `rating` float DEFAULT NULL,
  `num_sales` int DEFAULT NULL,
  `user_name` varchar(45) DEFAULT NULL,
  `pass_word` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`res_Id`),
  UNIQUE KEY `user_name_UNIQUE` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (1,'res_test',2.5,6,NULL,NULL),(2,'res_test',NULL,NULL,'try','lalala'),(3,'restaurant',NULL,NULL,'present','password'),(4,'cs5200',NULL,NULL,'database','5200'),(5,'wgxjwgx',NULL,NULL,'databasecoure','pwd'),(6,'cs5200project',NULL,NULL,'databaseproject','password');
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'foodordersystem'
--

--
-- Dumping routines for database 'foodordersystem'
--
/*!50003 DROP FUNCTION IF EXISTS `check_username` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_username`(input_username varchar(64)) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE res VARCHAR(64) DEFAULT 'NULL';
    SELECT user_name INTO res
		FROM customer WHERE user_name = input_username;
	IF res != 'NULL'
		THEN RETURN 1;
	END IF;
    RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_username_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_username_password`(input_username VARCHAR(64),input_password VARCHAR(64)) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE res VARCHAR(16) DEFAULT 'NULL';
    SELECT user_name INTO res
		FROM customer WHERE user_name = input_username AND pass_word = input_password;
	IF res != 'NULL'
		THEN return (select cus_Id FROM customer WHERE user_name = input_username);
	END IF;
    RETURN 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `create_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `create_order`(customerId INT, restaurantId INT) RETURNS int
    MODIFIES SQL DATA
BEGIN
    INSERT INTO food_order (res_Id, cus_Id, current_status) 
		VALUES (restaurantId, customerId, 'order created');
	RETURN (SELECT order_Id FROM food_order WHERE cus_Id = customerId ORDER BY order_Id DESC LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `res_check_username` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `res_check_username`(input_username varchar(64)) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE res VARCHAR(64) DEFAULT 'NULL';
    SELECT user_name INTO res
		FROM restaurant WHERE user_name = input_username;
	IF res != 'NULL'
		THEN RETURN 1;
	END IF;
    RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `res_check_username_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `res_check_username_password`(input_username VARCHAR(64), input_password VARCHAR(64)) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE res VARCHAR(64) DEFAULT 'NULL';
    SELECT user_name INTO res
		FROM restaurant WHERE user_name = input_username AND pass_word = input_password;
	IF res != 'NULL'
		THEN return (select res_Id FROM restaurant WHERE user_name = input_username);
	END IF;
    RETURN 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_cuisine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_cuisine`(IN orderId INT, IN cuisineId INT, IN num INT, IN resid INT)
BEGIN
	IF cuisineId IN (SELECT cuisine_Id FROM cuisine WHERE res_Id = resid) THEN
		INSERT INTO order_detail(order_Id, cuisine_Id, quantity) 
			VALUES (orderId, cuisineId, num);
	END IF;
	CALL load_cart(orderId);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `available_to_evaluate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `available_to_evaluate`(IN current_userId INT)
BEGIN 
	SELECT order_Id, res_name as restaurant, recipient_name, total_price
		FROM food_order 
        JOIN restaurant USING (res_Id)
        JOIN delivery_address USING (address_Id)
        WHERE food_order.cus_Id = current_userId AND current_status = 'Order has been delivered';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Browse_the_menu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Browse_the_menu`(IN selected_res INT)
BEGIN
	SELECT cuisine_Id, cuisine_name, unit_price, num_sales FROM cuisine WHERE res_Id = selected_res;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `change_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_password`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_deliver_address` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_deliver_address`(IN current_userId VARCHAR(64))
BEGIN 
	SELECT address_Id, recipient_name, call_number, address, zip_code
	FROM delivery_address WHERE cus_Id = current_userId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_recent_comment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_recent_comment`(IN selected_res INT)
BEGIN 
	SELECT com_Id, com_description, rating FROM cus_comment
		WHERE res_Id = selected_res
        order by com_Id desc
        limit 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_newuser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_newuser`(
IN input_username VARCHAR(64), 
IN input_password VARCHAR(64), 
IN input_name VARCHAR(64), 
IN input_phonenumber INT, 
IN input_address VARCHAR(128),
IN input_zipcode INT)
BEGIN
	INSERT INTO customer (user_name, pass_word, cus_name, phone_number, address, zip_code) 
		VALUES (input_username, input_password, input_name, input_phonenumber, input_address, input_zipcode);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_new_address` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_new_address`(
IN current_userId VARCHAR(64),
IN new_name VARCHAR(64),
IN new_number INT,
IN new_address VARCHAR(64),
IN new_zipcode INT)
BEGIN 
	INSERT INTO delivery_address (cus_Id, recipient_name, call_number, address, zip_code)
		VALUES (current_userId, new_name, new_number, new_address, new_zipcode);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_cuisine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_cuisine`(IN orderId INT, IN cuisineId INT, IN resid INT)
BEGIN
	IF cuisineId IN (SELECT cuisine_Id FROM cuisine WHERE res_Id = resid) THEN
		DELETE FROM order_detail WHERE order_Id = orderId AND cuisine_Id = cuisineId;
	END IF;
    CALL load_cart(orderId);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_current_address` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_current_address`(current_userId VARCHAR(64), target_Id INT)
BEGIN 
	DELETE FROM delivery_address WHERE cus_Id = current_userId AND address_Id = target_Id;
    CALL check_deliver_address(current_userId);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `list_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_order`(IN current_userId INT)
BEGIN
	SELECT order_Id, food_order.current_status, est_delivery_time, res_name as restaurant, address, recipient_name, call_number as contact_number, total_price
		FROM food_order 
        -- JOIN driver USING (driver_Id)
		JOIN restaurant USING (res_Id)
        JOIN delivery_address USING (address_Id)
        WHERE food_order.cus_Id = current_userId
        order by order_Id desc
        LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `list_restaurant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_restaurant`()
BEGIN
	SELECT res_Id, res_name, rating, num_sales FROM restaurant;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `load_cart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `load_cart`(IN orderId INT)
BEGIN
	SELECT cuisine_name, quantity 
		FROM order_detail JOIN cuisine USING (cuisine_Id)
		WHERE order_Id = orderId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `res_add_cuisine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `res_add_cuisine`(IN resid INT, IN newname VARCHAR(64), IN unitprice double)
BEGIN
	INSERT INTO cuisine(res_Id, cuisine_name, unit_price)
    VALUES (resid, newname, unitprice);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `res_assign_driver` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `res_assign_driver`(IN orderid INT, IN riderid INT)
BEGIN
	DECLARE if_free INT DEFAULT 0;
	SELECT driver_Id INTO if_free FROM driver WHERE driver_Id = riderid AND current_status = 'free';
    IF if_free != 0 THEN
		UPDATE food_order SET driver_Id = riderid WHERE order_id = orderid;
        UPDATE driver SET current_status = 'busy' WHERE driver_Id = riderid;
        UPDATE food_order SET current_status = 'on for delivery' WHERE order_Id = orderid;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `res_change_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `res_change_password`(
IN current_userId INT, 
IN current_password VARCHAR(64), 
IN new_password VARCHAR(64))
BEGIN 
	DECLARE check_signal VARCHAR(64) DEFAULT 'NULL';
	SELECT pass_word INTO check_signal FROM restaurant
		WHERE (res_Id = current_userId AND pass_word = current_password);
	IF check_signal != 'NULL' THEN
		SELECT ('0') as result;
		UPDATE restaurant SET pass_word = new_password
			WHERE (res_Id = current_userId AND pass_word = current_password);
	ELSE 
		SELECT ('1') as result;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `res_check_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `res_check_order`(IN restaurantId INT)
BEGIN
	SELECT order_Id, cus_name as last_name, delivery_address.address, total_price
		FROM food_order 
        JOIN customer USING(cus_Id)
        JOIN delivery_address USING(address_Id)
        WHERE res_Id = restaurantId AND current_status = 'order confirmed';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `res_check_rider` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `res_check_rider`()
BEGIN 
	SELECT driver_Id, d_name as last_name, phone_number as mobile
		FROM driver WHERE current_status = 'free';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `res_create_newuser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `res_create_newuser`(
IN input_username VARCHAR(64), 
IN input_password VARCHAR(64), 
IN input_name VARCHAR(64))
BEGIN
	INSERT INTO restaurant (user_name, pass_word, res_name) 
		VALUES (input_username, input_password, input_name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `res_delete_cuisine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `res_delete_cuisine`(IN resid INT, IN cuisineid INT)
BEGIN
	DELETE FROM cuisine WHERE res_Id = resid AND cuisine_Id = cuisineid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_confirm_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_confirm_order`(IN orderId INT)
BEGIN
	UPDATE food_order SET current_status = 'order confirmed'
		WHERE order_Id = orderId;
	SELECT order_Id, food_order.current_status as status, est_delivery_time, res_name as restaurant, address, recipient_name, call_number as contact_number, total_price
		FROM food_order 
		JOIN restaurant USING (res_Id)
        JOIN delivery_address USING (address_Id)
        WHERE order_Id = orderId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_select_address` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_select_address`(IN ordeId INT, IN addressId INT)
BEGIN
	UPDATE food_order SET address_Id = addressId
		WHERE order_Id = ordeId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `write_comment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `write_comment`(IN current_userId INT, IN input_orderId INT, IN rating real, IN content VARCHAR(256))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-04 10:31:50
