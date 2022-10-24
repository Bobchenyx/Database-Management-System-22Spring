CREATE DATABASE  IF NOT EXISTS `hw4q1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hw4q1`;
-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: hw4q1
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
-- Table structure for table `clinic`
--

DROP TABLE IF EXISTS `clinic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic` (
  `clinicNo` int NOT NULL,
  PRIMARY KEY (`clinicNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic`
--

LOCK TABLES `clinic` WRITE;
/*!40000 ALTER TABLE `clinic` DISABLE KEYS */;
/*!40000 ALTER TABLE `clinic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examination`
--

DROP TABLE IF EXISTS `examination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examination` (
  `examNo` int NOT NULL,
  `object_pet` int DEFAULT NULL,
  `perform_staff` int DEFAULT NULL,
  PRIMARY KEY (`examNo`),
  KEY `object_pet` (`object_pet`),
  KEY `perform_staff` (`perform_staff`),
  CONSTRAINT `examination_ibfk_1` FOREIGN KEY (`object_pet`) REFERENCES `pet` (`petNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `examination_ibfk_2` FOREIGN KEY (`perform_staff`) REFERENCES `staff` (`staffNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examination`
--

LOCK TABLES `examination` WRITE;
/*!40000 ALTER TABLE `examination` DISABLE KEYS */;
/*!40000 ALTER TABLE `examination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examination_treatment`
--

DROP TABLE IF EXISTS `examination_treatment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examination_treatment` (
  `examNo` int NOT NULL,
  `treatNo` int NOT NULL,
  PRIMARY KEY (`examNo`,`treatNo`),
  KEY `treatNo` (`treatNo`),
  CONSTRAINT `examination_treatment_ibfk_1` FOREIGN KEY (`examNo`) REFERENCES `examination` (`examNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `examination_treatment_ibfk_2` FOREIGN KEY (`treatNo`) REFERENCES `treatment` (`treatNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examination_treatment`
--

LOCK TABLES `examination_treatment` WRITE;
/*!40000 ALTER TABLE `examination_treatment` DISABLE KEYS */;
/*!40000 ALTER TABLE `examination_treatment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `petNo` int NOT NULL,
  `ownerNo` int DEFAULT NULL,
  `register_clinic` int DEFAULT NULL,
  PRIMARY KEY (`petNo`),
  KEY `ownerNo` (`ownerNo`),
  KEY `register_clinic` (`register_clinic`),
  CONSTRAINT `pet_ibfk_1` FOREIGN KEY (`ownerNo`) REFERENCES `petowner` (`ownerNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pet_ibfk_2` FOREIGN KEY (`register_clinic`) REFERENCES `clinic` (`clinicNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `petowner`
--

DROP TABLE IF EXISTS `petowner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `petowner` (
  `ownerNo` int NOT NULL,
  `clinic_contact` int DEFAULT NULL,
  PRIMARY KEY (`ownerNo`),
  KEY `clinic_contact` (`clinic_contact`),
  CONSTRAINT `petowner_ibfk_1` FOREIGN KEY (`clinic_contact`) REFERENCES `clinic` (`clinicNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `petowner`
--

LOCK TABLES `petowner` WRITE;
/*!40000 ALTER TABLE `petowner` DISABLE KEYS */;
/*!40000 ALTER TABLE `petowner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staffNo` int NOT NULL,
  `workplace` int DEFAULT NULL,
  PRIMARY KEY (`staffNo`),
  KEY `workplace` (`workplace`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`workplace`) REFERENCES `clinic` (`clinicNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_manage_clinic`
--

DROP TABLE IF EXISTS `staff_manage_clinic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_manage_clinic` (
  `clinicNo` int NOT NULL,
  `staffNo` int NOT NULL,
  PRIMARY KEY (`clinicNo`,`staffNo`),
  UNIQUE KEY `clinicNo` (`clinicNo`),
  UNIQUE KEY `staffNo` (`staffNo`),
  CONSTRAINT `staff_manage_clinic_ibfk_1` FOREIGN KEY (`clinicNo`) REFERENCES `clinic` (`clinicNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_manage_clinic_ibfk_2` FOREIGN KEY (`staffNo`) REFERENCES `staff` (`staffNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_manage_clinic`
--

LOCK TABLES `staff_manage_clinic` WRITE;
/*!40000 ALTER TABLE `staff_manage_clinic` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_manage_clinic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treatment`
--

DROP TABLE IF EXISTS `treatment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `treatment` (
  `treatNo` int NOT NULL,
  PRIMARY KEY (`treatNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treatment`
--

LOCK TABLES `treatment` WRITE;
/*!40000 ALTER TABLE `treatment` DISABLE KEYS */;
/*!40000 ALTER TABLE `treatment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-10 19:59:42
