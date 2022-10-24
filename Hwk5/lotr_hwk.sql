CREATE DATABASE  IF NOT EXISTS `lotrfinal_1`
 /*!40100 DEFAULT CHARACTER SET utf8mb4 */ 
 /*!80016 DEFAULT ENCRYPTION='N' */;
USE `lotrfinal_1`;
-- MySQL dump 10.13  Distrib 8.0.16, for macos10.14 (x86_64)
--
-- Host: localhost    Database: lotrfinal_hwk4
-- ------------------------------------------------------
-- Server version	8.0.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `lotr_book`
--

DROP TABLE IF EXISTS `lotr_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `lotr_book` (
  `book_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`book_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lotr_book`
--

LOCK TABLES `lotr_book` WRITE;
/*!40000 ALTER TABLE `lotr_book` DISABLE KEYS */;
INSERT INTO `lotr_book` VALUES (1,'the fellowship of the ring'),(2,'the two towers'),(3,'the return of the king');
/*!40000 ALTER TABLE `lotr_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lotr_character`
--

DROP TABLE IF EXISTS `lotr_character`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `lotr_character` (
  `character_name` varchar(255) NOT NULL,
  `species` varchar(255) DEFAULT NULL,
  `homeland` varchar(255) DEFAULT NULL,
  `royalty` tinyint(1) DEFAULT NULL,
  `fellowship` tinyint(1) DEFAULT NULL,
  `survive` tinyint(1) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `book_number_introduction` int(11) DEFAULT NULL,
  PRIMARY KEY (`character_name`),
  KEY `character_species_fk` (`species`),
  KEY `character_region_fk` (`homeland`),
  CONSTRAINT `character_region_fk` FOREIGN KEY (`homeland`) REFERENCES `lotr_region` (`region_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `character_species_fk` FOREIGN KEY (`species`) REFERENCES `lotr_species` (`species_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lotr_character`
--

LOCK TABLES `lotr_character` WRITE;
/*!40000 ALTER TABLE `lotr_character` DISABLE KEYS */;
INSERT INTO `lotr_character` VALUES ('Aragorn','human','gondor',1,1,1,'strider',1),('Elrond','elf','rivendell',1,0,1,'lord of rivendell',1),('Eowyn','human','rohan',1,0,1,'white lady of rohan',2),('Faramir','human','gondor',1,0,1,'captain of the white tower',3),('Frodo','hobbit','shire',0,1,1,'bearer of the one ring',1),('Gandalf','maiar','undying lands',0,1,1,'greybeard',1),('Gimli','dwarf','lonely mountain',0,1,1,'lockbearer',1),('Legolas','elf','mirkwood',1,1,1,'prince of the woodlands',1),('Saruman','maiar','isengard',0,0,0,'saruman the white',1),('Sauron','maiar','mordor',0,0,0,'dark lord',1);
/*!40000 ALTER TABLE `lotr_character` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lotr_first_encounter`
--

DROP TABLE IF EXISTS `lotr_first_encounter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `lotr_first_encounter` (
  `character1_name` varchar(255) NOT NULL,
  `character2_name` varchar(255) NOT NULL,
  `book_id` int(11) DEFAULT NULL,
  `region_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`character1_name`,`character2_name`),
  KEY `encounter_fk3` (`book_id`),
  KEY `encounter_fk2` (`character2_name`),
  KEY `encounter_fk4` (`region_name`),
  CONSTRAINT `encounter_fk1` FOREIGN KEY (`character1_name`) REFERENCES `lotr_character` (`character_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `encounter_fk2` FOREIGN KEY (`character2_name`) REFERENCES `lotr_character` (`character_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `encounter_fk3` FOREIGN KEY (`book_id`) REFERENCES `lotr_book` (`book_id`),
  CONSTRAINT `encounter_fk4` FOREIGN KEY (`region_name`) REFERENCES `lotr_region` (`region_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lotr_first_encounter`
--

LOCK TABLES `lotr_first_encounter` WRITE;
/*!40000 ALTER TABLE `lotr_first_encounter` DISABLE KEYS */;
INSERT INTO `lotr_first_encounter` VALUES ('aragorn','eowyn',2,'rohan'),('faramir','frodo',3,'mordor'),('frodo','aragorn',1,'bree'),('frodo','elrond',1,'rivendell'),('gandalf','frodo',1,'shire'),('gimli','elrond',1,'rivendell'),('gimli','legolas',1,'rivendell'),('saruman','aragorn',2,'isengard'),('sauron','frodo',1,'bree');
/*!40000 ALTER TABLE `lotr_first_encounter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lotr_region`
--

DROP TABLE IF EXISTS `lotr_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `lotr_region` (
  `region_name` varchar(255) NOT NULL,
  `major_species` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `middle_earth_location` varchar(255) DEFAULT NULL,
  `leader` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`region_name`),
  KEY `region_species_fk` (`major_species`),
  CONSTRAINT `region_species_fk` FOREIGN KEY (`major_species`) REFERENCES `lotr_species` (`species_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lotr_region`
--

LOCK TABLES `lotr_region` WRITE;
/*!40000 ALTER TABLE `lotr_region` DISABLE KEYS */;
INSERT INTO `lotr_region` VALUES ('bree','human','village','north on the crossroads','none'),('gondor','human','mountainous terrain','south','Kings of Gondor'),('isengard','orc','broad plain containing the tower of Orthanc','south','Saruman'),('lonely mountain','dwarf','cave','northeast','Durin folk'),('mirkwood','elf','forested elven village','east','Thranduil'),('mordor','orc','volcanic plain','southeast','Sauron'),('rivendell','elf','well hidden elf village in the foothills of the Misty Mountains','','Elrond'),('rohan','human','green and fertile area','south','King of Rohan'),('shire','hobbit','grassy rolling hills','northwest','King of Arthedain'),('undying lands','Maiar','beyond middle earth','outside middle earth','none');
/*!40000 ALTER TABLE `lotr_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lotr_species`
--

DROP TABLE IF EXISTS `lotr_species`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `lotr_species` (
  `species_name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  PRIMARY KEY (`species_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lotr_species`
--

LOCK TABLES `lotr_species` WRITE;
/*!40000 ALTER TABLE `lotr_species` DISABLE KEYS */;
INSERT INTO `lotr_species` VALUES ('balrog','Ancient evil creatures',5),('dwarf','Dwellers of the mountains of middle earth mines for precious metals',2),('elf','Fairest and wisest species',4),('ent','Ancient beings inhabiting trees that protect the forest',6),('hobbit','Also known as halflings; mortal ancient creatures that enjoy the simple life.',1),('human','Created during the first age of middle earth; three ages after elves and other middle earth species. Mortal creatures.',3),('maiar','Holy ones with mystical powers',0),('orc','Enslaved elves that were tortured and generated a new evil species',3);
/*!40000 ALTER TABLE `lotr_species` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-01 19:09:56
