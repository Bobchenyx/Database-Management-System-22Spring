CREATE DATABASE  IF NOT EXISTS `om` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `om`;
-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: om
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
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL,
  `customer_first_name` varchar(50) DEFAULT NULL,
  `customer_last_name` varchar(50) NOT NULL,
  `customer_address` varchar(255) NOT NULL,
  `customer_city` varchar(50) NOT NULL,
  `customer_state` char(2) NOT NULL,
  `customer_zip` varchar(20) NOT NULL,
  `customer_phone` varchar(30) NOT NULL,
  `customer_fax` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Korah','Blanca','1555 W Lane Ave','Columbus','OH','43221','6145554435','6145553928'),(2,'Yash','Randall','11 E Rancho Madera Rd','Madison','WI','53707','2095551205','2095552262'),(3,'Johnathon','Millerton','60 Madison Ave','New York','NY','10010','2125554800','NULL'),(4,'Mikayla','Damion','2021 K Street Nw','Washington','DC','20006','2025555561','NULL'),(5,'Kendall','Mayte','4775 E Miami River Rd','Cleves','OH','45002','5135553043','NULL'),(6,'Kaitlin','Hostlery','3250 Spring Grove Ave','Cincinnati','OH','45225','8005551957','8005552826'),(7,'Derek','Chaddick','9022 E Merchant Wy','Fairfield','IA','52556','5155556130','NULL'),(8,'Deborah','Damien','415 E Olive Ave','Fresno','CA','93728','5595558060','NULL'),(9,'Karina','Lacy','882 W Easton Wy','Los Angeles','CA','90084','8005557000','NULL'),(10,'Kurt','Nickalus','28210 N Avenue Stanford','Valencia','CA','91355','8055550584','055556689'),(11,'Kelsey','Eulalia','7833 N Ridge Rd','Sacramento','CA','95887','2095557500','2095551302'),(12,'Anders','Rohansen','12345 E 67th Ave NW','Takoma Park','MD','24512','3385556772','NULL'),(13,'Thalia','Neftaly','2508 W Shaw Ave','Fresno','CA','93711','5595556245','NULL'),(14,'Gonzalo','Keeton','12 Daniel Road','Fairfield','NJ','07004','2015559742','NULL'),(15,'Ania','Irvin','1099 N Farcourt St','Orange','CA','92807','7145559000','NULL'),(16,'Dakota','Baylee','1033 N Sycamore Ave.','Los Angeles','CA','90038','2135554322','NULL'),(17,'Samuel','Jacobsen','3433 E Widget Ave','Palo Alto','CA','92711','4155553434','NULL'),(18,'Justin','Javen','828 S Broadway','Tarrytown','NY','10591','8005550037','NULL'),(19,'Kyle','Marissa','789 E Mercy Ave','Phoenix','AZ','85038','9475553900','NULL'),(20,'Erick','Kaleigh','Five Lakepointe Plaza, Ste 500','Charlotte','NC','28217','7045553500','NULL'),(21,'Marvin','Quintin','2677 Industrial Circle Dr','Columbus','OH','43260','6145558600','6145557580'),(22,'Rashad','Holbrooke','3467 W Shaw Ave #103','Fresno','CA','93711','5595558625','5595558495'),(23,'Trisha','Anum','627 Aviation Way','Manhatttan Beach','CA','90266','3105552732','NULL'),(24,'Julian','Carson','372 San Quentin','San Francisco','CA','94161','6175550700','NULL'),(25,'Kirsten','Story','2401 Wisconsin Ave NW','Washington','DC','20559','2065559115','NULL');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `item_id` int NOT NULL,
  `title` varchar(50) NOT NULL,
  `artist` varchar(50) NOT NULL,
  `unit_price` decimal(9,2) NOT NULL,
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `title_artist_unq` (`title`,`artist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1,'Umami In Concert','Umami',17.95),(2,'Race Car Sounds','The Ubernerds',13.00),(3,'No Rest For The Weary','No Rest For The Weary',16.95),(4,'More Songs About Structures and Comestibles','No Rest For The Weary',17.95),(5,'On The Road With Burt Ruggles','Burt Ruggles',17.50),(6,'No Fixed Address','Sewed the Vest Pocket',16.95),(7,'Rude Noises','Jess & Odie',13.00),(8,'Burt Ruggles: An Intimate Portrait','Burt Ruggles',17.95),(9,'Zone Out With Umami','Umami',16.95),(10,'Etcetera','Onn & Onn',17.00);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `order_qty` int NOT NULL,
  PRIMARY KEY (`order_id`,`item_id`),
  KEY `order_details_fk_items` (`item_id`),
  CONSTRAINT `order_details_fk_items` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`),
  CONSTRAINT `order_details_fk_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (19,5,1),(29,3,1),(29,10,1),(32,7,1),(70,1,1),(89,4,1),(97,4,1),(97,8,1),(118,1,1),(144,3,1),(158,3,1),(165,4,1),(180,4,1),(231,10,1),(242,1,1),(242,6,1),(264,4,1),(264,7,1),(264,8,1),(298,1,1),(321,10,1),(381,1,1),(392,8,1),(413,10,1),(442,1,1),(479,1,2),(479,4,1),(491,6,1),(494,2,1),(523,9,1),(548,9,1),(550,1,1),(550,4,1),(601,5,1),(601,9,1),(606,8,1),(607,3,1),(607,10,1),(624,7,1),(627,9,1),(630,5,1),(630,6,2),(631,10,1),(651,3,1),(658,1,1),(687,6,1),(687,8,1),(693,6,1),(693,7,3),(693,10,1),(703,4,1),(773,10,1),(778,1,1),(778,3,1),(796,2,1),(796,5,1),(796,7,1),(800,1,1),(800,5,1),(802,2,1),(802,3,1),(824,3,1),(824,7,2),(827,6,1),(829,1,1),(829,2,1),(829,5,1),(829,9,1);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `order_date` date NOT NULL,
  `shipped_date` date DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `orders_fk_customers` (`customer_id`),
  CONSTRAINT `orders_fk_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (19,1,'2012-10-23','2012-10-28'),(29,8,'2012-11-05','2012-11-11'),(32,11,'2012-11-10','2012-11-13'),(45,2,'2012-11-25','2012-11-30'),(70,10,'2012-12-28','2013-01-07'),(89,22,'2013-01-20','2013-01-22'),(97,20,'2013-01-29','2013-02-02'),(118,3,'2013-02-24','2013-02-28'),(144,17,'2013-03-21','2013-03-29'),(158,9,'2013-04-04','2013-04-20'),(165,14,'2013-04-11','2013-04-13'),(180,24,'2013-04-25','2013-05-30'),(231,15,'2013-06-14','2013-06-22'),(242,23,'2013-06-24','2013-07-06'),(264,9,'2013-07-15','2013-07-18'),(298,18,'2013-08-18','2013-09-22'),(321,2,'2013-09-09','2013-10-05'),(381,7,'2013-11-08','2013-11-16'),(392,19,'2013-11-16','2013-11-23'),(413,17,'2013-12-05','2014-01-11'),(442,5,'2013-12-28','2014-01-03'),(479,1,'2014-01-30','2014-03-03'),(491,16,'2014-02-08','2014-02-14'),(494,4,'2014-02-10','2014-02-14'),(523,3,'2014-03-07','2014-03-15'),(548,2,'2014-03-22','2014-04-18'),(550,17,'2014-03-23','2014-04-03'),(601,16,'2014-04-21','2014-04-27'),(606,6,'2014-04-25','2014-05-02'),(607,20,'2014-04-25','2014-05-04'),(624,2,'2014-05-04','2014-05-09'),(627,17,'2014-05-05','2014-05-10'),(630,20,'2014-05-08','2014-05-18'),(631,21,'2014-05-09','2014-05-11'),(651,12,'2014-05-19','2014-06-02'),(658,12,'2014-05-23','2014-06-02'),(687,17,'2014-06-05','2014-06-08'),(693,9,'2014-06-07','2014-06-19'),(703,19,'2014-06-12','2014-06-19'),(773,25,'2014-07-11','2014-07-13'),(778,13,'2014-07-12','2014-07-21'),(796,17,'2014-07-19','2014-07-26'),(800,19,'2014-07-21','2014-07-28'),(802,2,'2014-07-21','2014-07-31'),(824,1,'2014-08-01',NULL),(827,18,'2014-08-02',NULL),(829,9,'2014-08-02',NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-01 22:22:24
