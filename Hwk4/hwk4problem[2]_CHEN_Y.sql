CREATE DATABASE  IF NOT EXISTS `hw4q2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hw4q2`;
-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: hw4q2
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
-- Table structure for table `pupil`
--

DROP TABLE IF EXISTS `pupil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pupil` (
  `pupil_Id` int NOT NULL,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `sex` varchar(10) NOT NULL,
  `date_of_birth` date NOT NULL,
  `school_attended` int DEFAULT NULL,
  PRIMARY KEY (`pupil_Id`),
  KEY `school_attended` (`school_attended`),
  CONSTRAINT `pupil_ibfk_1` FOREIGN KEY (`school_attended`) REFERENCES `school` (`school_Id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pupil`
--

LOCK TABLES `pupil` WRITE;
/*!40000 ALTER TABLE `pupil` DISABLE KEYS */;
/*!40000 ALTER TABLE `pupil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pupil_study_subject`
--

DROP TABLE IF EXISTS `pupil_study_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pupil_study_subject` (
  `pupil_Id` int NOT NULL,
  `subjectNo` int NOT NULL,
  PRIMARY KEY (`pupil_Id`,`subjectNo`),
  KEY `subjectNo` (`subjectNo`),
  CONSTRAINT `pupil_study_subject_ibfk_1` FOREIGN KEY (`pupil_Id`) REFERENCES `pupil` (`pupil_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pupil_study_subject_ibfk_2` FOREIGN KEY (`subjectNo`) REFERENCES `subject` (`subjectNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pupil_study_subject`
--

LOCK TABLES `pupil_study_subject` WRITE;
/*!40000 ALTER TABLE `pupil_study_subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `pupil_study_subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school`
--

DROP TABLE IF EXISTS `school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `school` (
  `school_Id` int NOT NULL,
  `s_name` varchar(30) NOT NULL,
  `town` varchar(64) NOT NULL,
  `street` varchar(64) NOT NULL,
  `zipcode` varchar(5) NOT NULL,
  `phone` varchar(10) NOT NULL,
  PRIMARY KEY (`school_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school`
--

LOCK TABLES `school` WRITE;
/*!40000 ALTER TABLE `school` DISABLE KEYS */;
/*!40000 ALTER TABLE `school` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `subjectNo` int NOT NULL,
  `title` varchar(30) NOT NULL,
  `subject_type` varchar(30) NOT NULL,
  PRIMARY KEY (`subjectNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject`
--

LOCK TABLES `subject` WRITE;
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher`
--

DROP TABLE IF EXISTS `teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher` (
  `NIN` int NOT NULL,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `qualification` varchar(64) NOT NULL,
  `work_place` int DEFAULT NULL,
  PRIMARY KEY (`NIN`),
  KEY `work_place` (`work_place`),
  CONSTRAINT `teacher_ibfk_1` FOREIGN KEY (`work_place`) REFERENCES `school` (`school_Id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher`
--

LOCK TABLES `teacher` WRITE;
/*!40000 ALTER TABLE `teacher` DISABLE KEYS */;
/*!40000 ALTER TABLE `teacher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher_manage_school`
--

DROP TABLE IF EXISTS `teacher_manage_school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher_manage_school` (
  `teacher_Id` int NOT NULL,
  `school_Id` int NOT NULL,
  `start_date` date NOT NULL,
  PRIMARY KEY (`teacher_Id`,`school_Id`),
  UNIQUE KEY `teacher_Id` (`teacher_Id`),
  UNIQUE KEY `school_Id` (`school_Id`),
  CONSTRAINT `teacher_manage_school_ibfk_1` FOREIGN KEY (`teacher_Id`) REFERENCES `teacher` (`NIN`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `teacher_manage_school_ibfk_2` FOREIGN KEY (`school_Id`) REFERENCES `school` (`school_Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_manage_school`
--

LOCK TABLES `teacher_manage_school` WRITE;
/*!40000 ALTER TABLE `teacher_manage_school` DISABLE KEYS */;
/*!40000 ALTER TABLE `teacher_manage_school` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher_taught_subject`
--

DROP TABLE IF EXISTS `teacher_taught_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher_taught_subject` (
  `teacher_Id` int NOT NULL,
  `subject_No` int NOT NULL,
  `teaching_hours` int NOT NULL,
  PRIMARY KEY (`teacher_Id`,`subject_No`),
  KEY `subject_No` (`subject_No`),
  CONSTRAINT `teacher_taught_subject_ibfk_1` FOREIGN KEY (`teacher_Id`) REFERENCES `teacher` (`NIN`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `teacher_taught_subject_ibfk_2` FOREIGN KEY (`subject_No`) REFERENCES `subject` (`subjectNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_taught_subject`
--

LOCK TABLES `teacher_taught_subject` WRITE;
/*!40000 ALTER TABLE `teacher_taught_subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `teacher_taught_subject` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-10 20:00:27
