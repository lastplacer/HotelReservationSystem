SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `hotelsystem` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `hotelsystem` ;

-- -----------------------------------------------------
-- Table `hotelsystem`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelsystem`.`user` ;

CREATE TABLE IF NOT EXISTS `hotelsystem`.`user` (
  `userID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NULL,
  `address` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `province` VARCHAR(45) NULL,
  `country` VARCHAR(45) NULL,
  `postalCode` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  `userType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`userID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelsystem`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelsystem`.`customer` ;

CREATE TABLE IF NOT EXISTS `hotelsystem`.`customer` (
  `customerID` INT NOT NULL AUTO_INCREMENT,
  `userID` INT NOT NULL,
  PRIMARY KEY (`customerID`),
  INDEX `customerUserID_idx` (`userID` ASC),
  CONSTRAINT `customerUserID`
    FOREIGN KEY (`userID`)
    REFERENCES `hotelsystem`.`user` (`userID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelsystem`.`reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelsystem`.`reservation` ;

CREATE TABLE IF NOT EXISTS `hotelsystem`.`reservation` (
  `reservationID` INT NOT NULL AUTO_INCREMENT,
  `dateCreated` DATE NULL,
  `dateFor` DATE NOT NULL,
  `customerID` INT NOT NULL,
  `reservationType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`reservationID`),
  INDEX `reservationCustomerID_idx` (`customerID` ASC),
  CONSTRAINT `reservationCustomerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `hotelsystem`.`customer` (`customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelsystem`.`staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelsystem`.`staff` ;

CREATE TABLE IF NOT EXISTS `hotelsystem`.`staff` (
  `employeeID` INT NOT NULL AUTO_INCREMENT,
  `userID` INT NOT NULL,
  `hireDate` DATE NULL,
  `accessLevel` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`employeeID`),
  INDEX `staffUserID_idx` (`userID` ASC),
  CONSTRAINT `staffUserID`
    FOREIGN KEY (`userID`)
    REFERENCES `hotelsystem`.`user` (`userID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelsystem`.`room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelsystem`.`room` ;

CREATE TABLE IF NOT EXISTS `hotelsystem`.`room` (
  `roomID` INT NOT NULL,
  `isLakeview` BIT NOT NULL DEFAULT 0,
  `isSuite` BIT NOT NULL DEFAULT 0,
  `numBeds` INT NOT NULL,
  `locked` VARCHAR(45) NOT NULL DEFAULT 0,
  PRIMARY KEY (`roomID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hotelsystem`.`roomReservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotelsystem`.`roomReservation` ;

CREATE TABLE IF NOT EXISTS `hotelsystem`.`roomReservation` (
  `roomReservationID` INT NOT NULL AUTO_INCREMENT,
  `reservationID` INT NOT NULL,
  `checkOutDate` DATE NOT NULL,
  `roomID` INT NOT NULL,
  PRIMARY KEY (`roomReservationID`),
  INDEX `roomReservationRoomID_idx` (`roomID` ASC),
  CONSTRAINT `reservationID`
    FOREIGN KEY (`reservationID`)
    REFERENCES `hotelsystem`.`reservation` (`reservationID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `roomReservationRoomID`
    FOREIGN KEY (`roomID`)
    REFERENCES `hotelsystem`.`room` (`roomID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
