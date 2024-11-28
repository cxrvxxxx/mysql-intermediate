-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: dbwildpark
-- ------------------------------------------------------
-- Server version	9.0.1

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
-- Table structure for table `tblaccount`
--

DROP TABLE IF EXISTS `tblaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblaccount` (
  `id` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblaccount`
--

LOCK TABLES `tblaccount` WRITE;
/*!40000 ALTER TABLE `tblaccount` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblbooking`
--

DROP TABLE IF EXISTS `tblbooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblbooking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `parking_area_id` int DEFAULT NULL,
  `vehicle_id` int DEFAULT NULL,
  `booker_id` int DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parking_area_id` (`parking_area_id`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `booker_id` (`booker_id`),
  CONSTRAINT `tblbooking_ibfk_1` FOREIGN KEY (`parking_area_id`) REFERENCES `tblparkingarea` (`id`),
  CONSTRAINT `tblbooking_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `tblvehicle` (`id`),
  CONSTRAINT `tblbooking_ibfk_3` FOREIGN KEY (`booker_id`) REFERENCES `tblaccount` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblbooking`
--

LOCK TABLES `tblbooking` WRITE;
/*!40000 ALTER TABLE `tblbooking` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblbooking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblparkingarea`
--

DROP TABLE IF EXISTS `tblparkingarea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblparkingarea` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slots` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblparkingarea`
--

LOCK TABLES `tblparkingarea` WRITE;
/*!40000 ALTER TABLE `tblparkingarea` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblparkingarea` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblvehicle`
--

DROP TABLE IF EXISTS `tblvehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblvehicle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `color` varchar(255) DEFAULT NULL,
  `make` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `plate_number` varchar(255) DEFAULT NULL,
  `owner_id` int DEFAULT NULL,
  `parking_area_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  KEY `parking_area_id` (`parking_area_id`),
  CONSTRAINT `tblvehicle_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `tblaccount` (`id`),
  CONSTRAINT `tblvehicle_ibfk_2` FOREIGN KEY (`parking_area_id`) REFERENCES `tblparkingarea` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblvehicle`
--

LOCK TABLES `tblvehicle` WRITE;
/*!40000 ALTER TABLE `tblvehicle` DISABLE KEYS */;
/*!40000 ALTER TABLE `tblvehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_accountstatistics`
--

DROP TABLE IF EXISTS `vw_accountstatistics`;
/*!50001 DROP VIEW IF EXISTS `vw_accountstatistics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_accountstatistics` AS SELECT 
 1 AS `id`,
 1 AS `firstname`,
 1 AS `lastname`,
 1 AS `No. of Owned Vehicles`,
 1 AS `No. of Bookings`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_bookingdetails`
--

DROP TABLE IF EXISTS `vw_bookingdetails`;
/*!50001 DROP VIEW IF EXISTS `vw_bookingdetails`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_bookingdetails` AS SELECT 
 1 AS `booking_id`,
 1 AS `date`,
 1 AS `status`,
 1 AS `booker_id`,
 1 AS `booker_firstname`,
 1 AS `booker_lastname`,
 1 AS `vehicle_id`,
 1 AS `plate_number`,
 1 AS `parking_area_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_vehicleswithowners`
--

DROP TABLE IF EXISTS `vw_vehicleswithowners`;
/*!50001 DROP VIEW IF EXISTS `vw_vehicleswithowners`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_vehicleswithowners` AS SELECT 
 1 AS `vehicle_id`,
 1 AS `color`,
 1 AS `make`,
 1 AS `model`,
 1 AS `plate_number`,
 1 AS `owner_id`,
 1 AS `owner_firstname`,
 1 AS `owner_lastname`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_accountstatistics`
--

/*!50001 DROP VIEW IF EXISTS `vw_accountstatistics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_accountstatistics` AS select `a`.`id` AS `id`,`a`.`firstname` AS `firstname`,`a`.`lastname` AS `lastname`,(select count(0) from `tblvehicle` `v` where (`v`.`owner_id` = `a`.`id`)) AS `No. of Owned Vehicles`,(select count(0) from `tblbooking` `b` where (`b`.`booker_id` = `a`.`id`)) AS `No. of Bookings` from `tblaccount` `a` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_bookingdetails`
--

/*!50001 DROP VIEW IF EXISTS `vw_bookingdetails`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_bookingdetails` AS select `b`.`id` AS `booking_id`,`b`.`date` AS `date`,`b`.`status` AS `status`,`a`.`id` AS `booker_id`,`a`.`firstname` AS `booker_firstname`,`a`.`lastname` AS `booker_lastname`,`v`.`id` AS `vehicle_id`,`v`.`plate_number` AS `plate_number`,`pa`.`id` AS `parking_area_id` from (((`tblbooking` `b` join `tblaccount` `a` on((`b`.`booker_id` = `a`.`id`))) join `tblvehicle` `v` on((`b`.`vehicle_id` = `v`.`id`))) join `tblparkingarea` `pa` on((`b`.`parking_area_id` = `pa`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_vehicleswithowners`
--

/*!50001 DROP VIEW IF EXISTS `vw_vehicleswithowners`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_vehicleswithowners` AS select `v`.`id` AS `vehicle_id`,`v`.`color` AS `color`,`v`.`make` AS `make`,`v`.`model` AS `model`,`v`.`plate_number` AS `plate_number`,`a`.`id` AS `owner_id`,`a`.`firstname` AS `owner_firstname`,`a`.`lastname` AS `owner_lastname` from (`tblvehicle` `v` join `tblaccount` `a` on((`v`.`owner_id` = `a`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-28 16:43:29
