CREATE DATABASE  IF NOT EXISTS `hw4q3` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hw4q3`;
-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: hw4q3
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
-- Table structure for table `admin_staff`
--

DROP TABLE IF EXISTS `admin_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_staff` (
  `staffNo` int NOT NULL,
  `if_simple_officework` tinyint(1) NOT NULL,
  `if_answering_phone` tinyint(1) NOT NULL,
  `if_maintain_cleanschedule` tinyint(1) NOT NULL,
  `if_maintain_equipment` tinyint(1) NOT NULL,
  PRIMARY KEY (`staffNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_staff`
--

LOCK TABLES `admin_staff` WRITE;
/*!40000 ALTER TABLE `admin_staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clean_group`
--

DROP TABLE IF EXISTS `clean_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clean_group` (
  `group_No` int NOT NULL,
  PRIMARY KEY (`group_No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clean_group`
--

LOCK TABLES `clean_group` WRITE;
/*!40000 ALTER TABLE `clean_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `clean_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clean_job`
--

DROP TABLE IF EXISTS `clean_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clean_job` (
  `job_No` int NOT NULL,
  `cleaning_hour` int NOT NULL,
  `related_requirement` int DEFAULT NULL,
  `ademinister` int DEFAULT NULL,
  PRIMARY KEY (`job_No`),
  KEY `related_requirement` (`related_requirement`),
  KEY `ademinister` (`ademinister`),
  CONSTRAINT `clean_job_ibfk_1` FOREIGN KEY (`related_requirement`) REFERENCES `requirement` (`reqNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `clean_job_ibfk_2` FOREIGN KEY (`ademinister`) REFERENCES `admin_staff` (`staffNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clean_job`
--

LOCK TABLES `clean_job` WRITE;
/*!40000 ALTER TABLE `clean_job` DISABLE KEYS */;
/*!40000 ALTER TABLE `clean_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clean_staff`
--

DROP TABLE IF EXISTS `clean_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clean_staff` (
  `staffNo` int NOT NULL,
  `group_No` int DEFAULT NULL,
  PRIMARY KEY (`staffNo`),
  KEY `group_No` (`group_No`),
  CONSTRAINT `clean_staff_ibfk_1` FOREIGN KEY (`group_No`) REFERENCES `clean_group` (`group_No`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clean_staff`
--

LOCK TABLES `clean_staff` WRITE;
/*!40000 ALTER TABLE `clean_staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `clean_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client` (
  `clientNo` int NOT NULL,
  PRIMARY KEY (`clientNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment` (
  `equip_No` int NOT NULL,
  `discription` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`equip_No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_inchargeof_job`
--

DROP TABLE IF EXISTS `group_inchargeof_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_inchargeof_job` (
  `job_No` int NOT NULL,
  `group_No` int NOT NULL,
  PRIMARY KEY (`job_No`,`group_No`),
  KEY `group_No` (`group_No`),
  CONSTRAINT `group_inchargeof_job_ibfk_1` FOREIGN KEY (`job_No`) REFERENCES `clean_job` (`job_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `group_inchargeof_job_ibfk_2` FOREIGN KEY (`group_No`) REFERENCES `clean_group` (`group_No`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_inchargeof_job`
--

LOCK TABLES `group_inchargeof_job` WRITE;
/*!40000 ALTER TABLE `group_inchargeof_job` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_inchargeof_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_need_equip`
--

DROP TABLE IF EXISTS `job_need_equip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_need_equip` (
  `job_No` int NOT NULL,
  `equip_No` int NOT NULL,
  PRIMARY KEY (`job_No`,`equip_No`),
  KEY `equip_No` (`equip_No`),
  CONSTRAINT `job_need_equip_ibfk_1` FOREIGN KEY (`job_No`) REFERENCES `clean_job` (`job_No`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_need_equip_ibfk_2` FOREIGN KEY (`equip_No`) REFERENCES `equipment` (`equip_No`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_need_equip`
--

LOCK TABLES `job_need_equip` WRITE;
/*!40000 ALTER TABLE `job_need_equip` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_need_equip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirement`
--

DROP TABLE IF EXISTS `requirement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement` (
  `reqNo` int NOT NULL,
  `related_client` int DEFAULT NULL,
  `requirement_discription` varchar(128) NOT NULL,
  PRIMARY KEY (`reqNo`),
  KEY `related_client` (`related_client`),
  CONSTRAINT `requirement_ibfk_1` FOREIGN KEY (`related_client`) REFERENCES `client` (`clientNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirement`
--

LOCK TABLES `requirement` WRITE;
/*!40000 ALTER TABLE `requirement` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_supervise_group`
--

DROP TABLE IF EXISTS `staff_supervise_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_supervise_group` (
  `staffNo` int NOT NULL,
  `group_No` int NOT NULL,
  PRIMARY KEY (`staffNo`,`group_No`),
  UNIQUE KEY `staffNo` (`staffNo`),
  UNIQUE KEY `group_No` (`group_No`),
  CONSTRAINT `staff_supervise_group_ibfk_1` FOREIGN KEY (`staffNo`) REFERENCES `clean_staff` (`staffNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_supervise_group_ibfk_2` FOREIGN KEY (`group_No`) REFERENCES `clean_group` (`group_No`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_supervise_group`
--

LOCK TABLES `staff_supervise_group` WRITE;
/*!40000 ALTER TABLE `staff_supervise_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_supervise_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-11 10:44:34
