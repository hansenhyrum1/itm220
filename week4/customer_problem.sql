-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`language` ;

CREATE TABLE IF NOT EXISTS `mydb`.`language` (
  `lang` VARCHAR(2) NOT NULL,
  `language` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`lang`),
  INDEX `lang_nk` (`language` ASC) VISIBLE,
  INDEX `lang_pk` (`lang` ASC, `language` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`country` ;

CREATE TABLE IF NOT EXISTS `mydb`.`country` (
  `country_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(45) NULL,
  `lang` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`country_id`),
  INDEX `lang_fk_idx` (`lang` ASC) VISIBLE,
  INDEX `country_nk` (`country_name` ASC, `lang` ASC) VISIBLE,
  INDEX `country_pk` (`country_id` ASC, `country_name` ASC, `lang` ASC) VISIBLE,
  CONSTRAINT `country_fk1`
    FOREIGN KEY (`lang`)
    REFERENCES `mydb`.`language` (`lang`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`state` ;

CREATE TABLE IF NOT EXISTS `mydb`.`state` (
  `state_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `state_name` VARCHAR(45) NOT NULL,
  `country_id` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`state_id`),
  INDEX `state_fk_idx` (`country_id` ASC) VISIBLE,
  INDEX `lang_fk_idx` (`lang` ASC) VISIBLE,
  INDEX `state_nk` (`state_name` ASC, `country_id` ASC, `lang` ASC) VISIBLE,
  INDEX `state_pk` (`state_id` ASC, `state_name` ASC, `country_id` ASC, `lang` ASC) VISIBLE,
  CONSTRAINT `state_fk`
    FOREIGN KEY (`country_id`)
    REFERENCES `mydb`.`country` (`country_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `lang_fk`
    FOREIGN KEY (`lang`)
    REFERENCES `mydb`.`language` (`lang`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`county`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`county` ;

CREATE TABLE IF NOT EXISTS `mydb`.`county` (
  `county_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `county_name` VARCHAR(45) NOT NULL,
  `state_id` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`county_id`),
  INDEX `county_fk_idx` (`state_id` ASC) VISIBLE,
  INDEX `county_nk` (`county_name` ASC, `state_id` ASC) VISIBLE,
  INDEX `lang_fk_idx` (`lang` ASC) VISIBLE,
  INDEX `county_nk` (`county_name` ASC, `state_id` ASC, `lang` ASC) VISIBLE,
  INDEX `county_pk` (`county_id` ASC, `county_name` ASC, `state_id` ASC, `lang` ASC) VISIBLE,
  CONSTRAINT `county_fk1`
    FOREIGN KEY (`state_id`)
    REFERENCES `mydb`.`state` (`state_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `county_fk2`
    FOREIGN KEY (`lang`)
    REFERENCES `mydb`.`language` (`lang`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`city` ;

CREATE TABLE IF NOT EXISTS `mydb`.`city` (
  `city_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(45) NOT NULL,
  `county_id` INT UNSIGNED NOT NULL,
  `state_id` INT UNSIGNED NOT NULL,
  `country_id` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(45) NOT NULL,
  `begin_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `county_fk_idx` (`county_id` ASC) VISIBLE,
  INDEX `state_fk_idx` (`state_id` ASC) VISIBLE,
  INDEX `country_fk_idx` (`country_id` ASC) VISIBLE,
  INDEX `lang_fk_idx` (`lang` ASC) VISIBLE,
  INDEX `city_nk` (`city_id` ASC, `city_name` ASC, `county_id` ASC, `state_id` ASC, `country_id` ASC, `lang` ASC, `begin_date` ASC, `end_date` ASC) VISIBLE,
  INDEX `city_pk` (`city_id` ASC, `city_name` ASC, `county_id` ASC, `state_id` ASC, `country_id` ASC, `lang` ASC, `begin_date` ASC, `end_date` ASC) VISIBLE,
  CONSTRAINT `city_fk1`
    FOREIGN KEY (`county_id`)
    REFERENCES `mydb`.`county` (`county_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `city_fk2`
    FOREIGN KEY (`state_id`)
    REFERENCES `mydb`.`state` (`state_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `city_fk3`
    FOREIGN KEY (`country_id`)
    REFERENCES `mydb`.`country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `city_fk4`
    FOREIGN KEY (`lang`)
    REFERENCES `mydb`.`language` (`lang`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sales_tax`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`sales_tax` ;

CREATE TABLE IF NOT EXISTS `mydb`.`sales_tax` (
  `sales_tax_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tax_rate` DOUBLE NOT NULL,
  `begin_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `county_id` INT UNSIGNED NULL,
  `state_id` INT UNSIGNED NULL,
  PRIMARY KEY (`sales_tax_id`),
  INDEX `county_fk_idx` (`county_id` ASC) VISIBLE,
  INDEX `state_fk_idx` (`state_id` ASC) VISIBLE,
  CONSTRAINT `county_fk`
    FOREIGN KEY (`county_id`)
    REFERENCES `mydb`.`county` (`county_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `state_fk`
    FOREIGN KEY (`state_id`)
    REFERENCES `mydb`.`state` (`state_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`lookup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`lookup` ;

CREATE TABLE IF NOT EXISTS `mydb`.`lookup` (
  `lookup_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `lookup_table` VARCHAR(64) NOT NULL,
  `lookup_column` VARCHAR(64) NOT NULL,
  `lookup_type` VARCHAR(64) NOT NULL,
  `lookup_meaning` VARCHAR(64) NOT NULL,
  `lookup_lang` CHAR(2) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`lookup_id`),
  INDEX `lookup_nk` (`lookup_table` ASC, `lookup_column` ASC, `lookup_type` ASC, `lookup_lang` ASC, `start_date` ASC, `end_date` ASC) VISIBLE,
  INDEX `lookup_pk` (`lookup_id` ASC, `lookup_table` ASC, `lookup_column` ASC, `lookup_type` ASC, `lookup_lang` ASC, `start_date` ASC, `end_date` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`zip_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`zip_code` ;

CREATE TABLE IF NOT EXISTS `mydb`.`zip_code` (
  `zip_code_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `zip_code` VARCHAR(10) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  PRIMARY KEY (`zip_code_id`),
  INDEX `zip_code_nk` (`zip_code` ASC, `start_date` ASC, `end_date` ASC) VISIBLE,
  INDEX `zip_code_pk` (`zip_code_id` ASC, `zip_code` ASC, `start_date` ASC, `end_date` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`address` ;

CREATE TABLE IF NOT EXISTS `mydb`.`address` (
  `address_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `street_address` VARCHAR(45) NOT NULL,
  `unit_number` VARCHAR(45) NULL,
  `city_id` INT UNSIGNED NOT NULL,
  `begin_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `lang` VARCHAR(2) NOT NULL,
  `zip_code_id` INT UNSIGNED NOT NULL,
  `preferred_address_type` INT UNSIGNED NOT NULL,
  `address_type` INT UNSIGNED NOT NULL,
  `ship_to` INT UNSIGNED NOT NULL,
  `bill_to` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`address_id`),
  INDEX `city_fk_idx` (`city_id` ASC) VISIBLE,
  INDEX `lang_fk_idx` (`lang` ASC) VISIBLE,
  INDEX `preferred_address_fk1_idx` (`preferred_address_type` ASC) VISIBLE,
  INDEX `address_fk3_idx` (`address_type` ASC) VISIBLE,
  INDEX `address_fk4_idx` (`ship_to` ASC) VISIBLE,
  INDEX `address_fk5_idx` (`bill_to` ASC) VISIBLE,
  INDEX `address_fk6_idx` (`zip_code_id` ASC) VISIBLE,
  CONSTRAINT `city_fk`
    FOREIGN KEY (`city_id`)
    REFERENCES `mydb`.`city` (`city_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `lang_fk`
    FOREIGN KEY (`lang`)
    REFERENCES `mydb`.`language` (`lang`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `preferred_address_fk1`
    FOREIGN KEY (`preferred_address_type`)
    REFERENCES `mydb`.`lookup` (`lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `address_fk3`
    FOREIGN KEY (`address_type`)
    REFERENCES `mydb`.`lookup` (`lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `address_fk4`
    FOREIGN KEY (`ship_to`)
    REFERENCES `mydb`.`lookup` (`lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `address_fk5`
    FOREIGN KEY (`bill_to`)
    REFERENCES `mydb`.`lookup` (`lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `address_fk6`
    FOREIGN KEY (`zip_code_id`)
    REFERENCES `mydb`.`zip_code` (`zip_code_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`account` ;

CREATE TABLE IF NOT EXISTS `mydb`.`account` (
  `account_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_number` VARCHAR(20) NOT NULL,
  `account_type` VARCHAR(45) NULL,
  `active_flag` VARCHAR(1) NOT NULL,
  `credit_card_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`account_id`),
  INDEX `fk_account_credit_card_idx` (`credit_card_id` ASC) VISIBLE,
  INDEX `account_nk` (`account_id` ASC, `account_number` ASC, `account_type` ASC, `active_flag` ASC) VISIBLE,
  CONSTRAINT `fk_account_lookup`
    FOREIGN KEY (`credit_card_id`)
    REFERENCES `mydb`.`lookup` (`lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`customer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`customer` (
  `customer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_number` VARCHAR(45) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`customer_id`),
  INDEX `customer_1_idx` (`account_id` ASC) VISIBLE,
  INDEX `customer_nk` (`customer_number` ASC, `first_name` ASC, `middle_name` ASC, `last_name` ASC) VISIBLE,
  INDEX `customer_pk` (`customer_id` ASC, `customer_number` ASC, `first_name` ASC, `middle_name` ASC, `last_name` ASC) VISIBLE,
  CONSTRAINT `customer_fk1`
    FOREIGN KEY (`account_id`)
    REFERENCES `mydb`.`account` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`preferred_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`preferred_address` ;

CREATE TABLE IF NOT EXISTS `mydb`.`preferred_address` (
  `preferred_address_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `preferred_address_type` VARCHAR(45) NOT NULL,
  `street_address` VARCHAR(45) NOT NULL,
  `zip_code_id` INT UNSIGNED NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `lang` VARCHAR(45) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`preferred_address_id`),
  INDEX `fk_preferred_address_fk1_idx` (`zip_code_id` ASC) VISIBLE,
  CONSTRAINT `fk_preferred_address_fk1`
    FOREIGN KEY (`zip_code_id`)
    REFERENCES `mydb`.`zip_code` (`zip_code_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`customer_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`customer_address` ;

CREATE TABLE IF NOT EXISTS `mydb`.`customer_address` (
  `customer_address_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` INT UNSIGNED NOT NULL,
  `address_id` INT UNSIGNED NOT NULL,
  `preferred_address_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`customer_address_id`),
  INDEX `customer_address_fk1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `customer_address_fk2_idx` (`address_id` ASC) VISIBLE,
  INDEX `customer_address_fk3_idx` (`preferred_address_id` ASC) VISIBLE,
  CONSTRAINT `customer_address_fk1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `customer_address_fk2`
    FOREIGN KEY (`address_id`)
    REFERENCES `mydb`.`address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `customer_address_fk3`
    FOREIGN KEY (`preferred_address_id`)
    REFERENCES `mydb`.`preferred_address` (`preferred_address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`credit_card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`credit_card` ;

CREATE TABLE IF NOT EXISTS `mydb`.`credit_card` (
  `credit_card_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `credit_card_number` VARCHAR(20) NOT NULL,
  `credit_card_type` INT UNSIGNED NOT NULL,
  `expiration_date` DATE NOT NULL,
  `cvv` VARCHAR(3) NOT NULL,
  `account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`credit_card_id`),
  INDEX `fk_credit_card_lookup_idx` (`credit_card_type` ASC) VISIBLE,
  INDEX `fk_credit_card_account_id_idx` (`account_id` ASC) VISIBLE,
  INDEX `credit_card_nk` (`credit_card_number` ASC, `credit_card_type` ASC, `expiration_date` ASC, `cvv` ASC) VISIBLE,
  INDEX `credit_card_pk` (`credit_card_id` ASC, `credit_card_number` ASC, `credit_card_type` ASC, `expiration_date` ASC, `cvv` ASC) VISIBLE,
  CONSTRAINT `fk_credit_card_lookup`
    FOREIGN KEY (`credit_card_type`)
    REFERENCES `mydb`.`lookup` (`lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_credit_card_account_id`
    FOREIGN KEY (`account_id`)
    REFERENCES `mydb`.`account` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `credit_card_fk1`
    FOREIGN KEY (`account_id`)
    REFERENCES `mydb`.`account` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `address_fk4`
    FOREIGN KEY (`account_id`)
    REFERENCES `mydb`.`account` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
