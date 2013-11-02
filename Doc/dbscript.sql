SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `hotelSystem` ;
CREATE SCHEMA IF NOT EXISTS `hotelSystem` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `hotelSystem` ;

-- -----------------------------------------------------
-- Table `hotelSystem`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelSystem`.`user` ;

CREATE TABLE IF NOT EXISTS `hotelSystem`.`user` (
  `userID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NULL,
  `address` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `province` VARCHAR(45) NULL,
  `country` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  `userType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`userID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelSystem`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelSystem`.`customer` ;

CREATE TABLE IF NOT EXISTS `hotelSystem`.`customer` (
  `customerID` INT NOT NULL AUTO_INCREMENT,
  `userID` INT NOT NULL,
  PRIMARY KEY (`customerID`),
  INDEX `customerUserID_idx` (`userID` ASC),
  CONSTRAINT `customerUserID`
    FOREIGN KEY (`userID`)
    REFERENCES `hotelSystem`.`user` (`userID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelSystem`.`reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelSystem`.`reservation` ;

CREATE TABLE IF NOT EXISTS `hotelSystem`.`reservation` (
  `reservationID` INT NOT NULL,
  `dateCreated` DATE NULL,
  `dateFor` DATE NOT NULL,
  `customerID` INT NOT NULL,
  `reservationType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`reservationID`),
  INDEX `reservationCustomerID_idx` (`customerID` ASC),
  CONSTRAINT `reservationCustomerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `hotelSystem`.`customer` (`customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelSystem`.`staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelSystem`.`staff` ;

CREATE TABLE IF NOT EXISTS `hotelSystem`.`staff` (
  `employeeID` INT NOT NULL AUTO_INCREMENT,
  `userID` INT NOT NULL,
  `hireDate` DATE NULL,
  `accessLevel` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`employeeID`),
  INDEX `staffUserID_idx` (`userID` ASC),
  CONSTRAINT `staffUserID`
    FOREIGN KEY (`userID`)
    REFERENCES `hotelSystem`.`user` (`userID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelSystem`.`room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelSystem`.`room` ;

CREATE TABLE IF NOT EXISTS `hotelSystem`.`room` (
  `roomID` INT NOT NULL,
  `isLakeview` BIT NOT NULL DEFAULT 0,
  `isSuite` BIT NOT NULL DEFAULT 0,
  `numBeds` INT NOT NULL,
  `locked` VARCHAR(45) NOT NULL DEFAULT 0,
  PRIMARY KEY (`roomID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelSystem`.`roomReservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelSystem`.`roomReservation` ;

CREATE TABLE IF NOT EXISTS `hotelSystem`.`roomReservation` (
  `reservationID` INT NOT NULL,
  `checkOutDate` DATE NOT NULL,
  `roomID` INT NOT NULL,
  PRIMARY KEY (`reservationID`),
  INDEX `roomReservationRoomID_idx` (`roomID` ASC),
  CONSTRAINT `roomReservationID`
    FOREIGN KEY (`reservationID`)
    REFERENCES `hotelSystem`.`reservation` (`reservationID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `roomReservationRoomID`
    FOREIGN KEY (`roomID`)
    REFERENCES `hotelSystem`.`room` (`roomID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
