-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema restaurant_reservation
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema restaurant_reservation
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `restaurant_reservation` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `restaurant_reservation` ;

-- -----------------------------------------------------
-- Table `restaurant_reservation`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `restaurant_reservation`.`customers` (
  `customerID` INT NOT NULL AUTO_INCREMENT,
  `customerName` VARCHAR(45) NOT NULL,
  `contactInfo` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE INDEX `customerID` (`customerID` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `restaurant_reservation`.`diningpreferences`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `restaurant_reservation`.`diningpreferences` (
  `preferenceID` INT NOT NULL AUTO_INCREMENT,
  `customerID` INT NOT NULL,
  `favoriteTable` VARCHAR(45) NULL DEFAULT NULL,
  `dietaryRestrictions` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`preferenceID`),
  UNIQUE INDEX `preferenceID` (`preferenceID` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `restaurant_reservation`.`reservations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `restaurant_reservation`.`reservations` (
  `reservationID` INT NOT NULL AUTO_INCREMENT,
  `customerID` INT NOT NULL,
  `reservationTime` DATETIME NOT NULL,
  `numberOfGuests` INT NOT NULL,
  `specialRequests` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`reservationID`),
  UNIQUE INDEX `reservationID` (`reservationID` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `restaurant_reservation` ;

-- -----------------------------------------------------
-- procedure addReservation7
-- -----------------------------------------------------

DELIMITER $$
USE `restaurant_reservation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addReservation7`(in cust_id int, in cust_name varchar(45), in res_id int, in res_date datetime, in num_gst int, in pref_id int)
begin
	if not exists(select 1 from Reservations where customerID=cust_id)then
		insert into Customers(customerID, customerName)
        values(cust_id, cust_name);
        insert into Reservations(reservationID, customerID, reservationTime, numberOfGuests)
        values(res_id, cust_id, res_date, num_gst);
        insert into DiningPreferences(preferenceID, customerID)
        values(pref_id, cust_id);
        
	else
	select 'Customer already has a reservation.';
        
	end if;

end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addSpecialRequest
-- -----------------------------------------------------

DELIMITER $$
USE `restaurant_reservation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addSpecialRequest`(in res_id int, in new_req varchar(200))
begin
	update Reservations 
    set specialRequests=new_req
    where reservationID=res_id;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteReservation
-- -----------------------------------------------------

DELIMITER $$
USE `restaurant_reservation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteReservation`(in cus_id int)
begin
	delete from Reservations
    where customerID=cus_id;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure findReservations
-- -----------------------------------------------------

DELIMITER $$
USE `restaurant_reservation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `findReservations`(in id int)
begin
	select * 
    from Reservations
    where customerID=id;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure searchPreferences
-- -----------------------------------------------------

DELIMITER $$
USE `restaurant_reservation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchPreferences`(in c_id int)
begin
	select *
    from DiningPreferences
    where customerID=c_id;
end$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
