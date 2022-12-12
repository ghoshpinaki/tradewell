-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema tradewell_data
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tradewell_data
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tradewell_data` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `tradewell_data` ;

-- -----------------------------------------------------
-- Table `tradewell_data`.`accounting_period`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`accounting_period` (
  `FINANCIAL_YEAR` VARCHAR(5) NOT NULL,
  `START_DATE` DATE NULL DEFAULT NULL,
  `END_DATE` DATE NULL DEFAULT NULL,
  `STATUS` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`FINANCIAL_YEAR`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`organization_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`organization_master` (
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `ORGANIZATION_NAME` VARCHAR(100) NOT NULL,
  `ORGANIZATION_GROUP` VARCHAR(25) NOT NULL,
  `ORGANIZATION_TYPE` VARCHAR(20) NOT NULL,
  `PRIMARY_ORGANIZATION` CHAR(1) NOT NULL,
  `GST_IN` VARCHAR(20) NOT NULL,
  `GST_TYPE` VARCHAR(10) NOT NULL,
  `ADDRESS` VARCHAR(100) NULL DEFAULT NULL,
  `CITY` VARCHAR(50) NULL DEFAULT NULL,
  `PIN` INT UNSIGNED NULL DEFAULT NULL,
  `CONTACT_PERSON` VARCHAR(100) NULL DEFAULT NULL,
  `CONTACT_NO` VARCHAR(11) NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`ORGANIZATION_CODE`),
  UNIQUE INDEX `OMUK` (`ORGANIZATION_NAME` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`vendor_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`vendor_master` (
  `VENDOR_CODE` VARCHAR(12) NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `VENDOR_NAME` VARCHAR(100) NOT NULL,
  `GST_APPLICABLE` CHAR(1) NOT NULL,
  `GST_IN` VARCHAR(20) NULL DEFAULT NULL,
  `WITHIN_STATE` CHAR(1) NOT NULL,
  `ADDRESS` VARCHAR(100) NULL DEFAULT NULL,
  `CITY` VARCHAR(50) NULL DEFAULT NULL,
  `PIN` INT UNSIGNED NULL DEFAULT NULL,
  `CONTACT_PERSON` VARCHAR(100) NULL DEFAULT NULL,
  `CONTACT_NO` VARCHAR(11) NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  `TOTAL_OUTSTANDING` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`VENDOR_CODE`),
  INDEX `VMFK` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `VMFK`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`bill_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`bill_master` (
  `BILL_NO` VARCHAR(12) NOT NULL,
  `VENDOR_CODE` VARCHAR(12) NOT NULL,
  `INVOICE_NO` VARCHAR(20) NOT NULL,
  `BILL_DATE` DATETIME NOT NULL,
  `TOTAL_BILL` DECIMAL(10,2) NOT NULL,
  `TOTAL_IGST` DECIMAL(8,2) NOT NULL,
  `TOTAL_CGST` DECIMAL(8,2) NOT NULL,
  `TOTAL_SGST` DECIMAL(8,2) NOT NULL,
  `TOTAL_GST` DECIMAL(8,2) NOT NULL,
  `GROSS_BILL` DECIMAL(10,2) NOT NULL,
  `TOTAL_DISCOUNT` DECIMAL(8,2) NOT NULL,
  `NET_BILL` DECIMAL(10,2) NOT NULL,
  `BALANCE` DECIMAL(10,2) NOT NULL,
  `CANCELLED` CHAR(1) NOT NULL,
  PRIMARY KEY (`BILL_NO`),
  INDEX `BMFK` (`VENDOR_CODE` ASC) VISIBLE,
  CONSTRAINT `BMFK`
    FOREIGN KEY (`VENDOR_CODE`)
    REFERENCES `tradewell_data`.`vendor_master` (`VENDOR_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`bill_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`bill_detail` (
  `SERIAL_NO` INT UNSIGNED NOT NULL,
  `BILL_NO` VARCHAR(12) NOT NULL,
  `ITEM_CODE` VARCHAR(6) NOT NULL,
  `BILLED_QUANTITY` DECIMAL(8,2) NOT NULL,
  `FREE_QUANTITY` DECIMAL(8,2) NOT NULL,
  `TOTAL_QUANTITY` DECIMAL(8,2) NOT NULL,
  `RATE` DECIMAL(5,2) NOT NULL,
  `PRICE` DECIMAL(8,2) NOT NULL,
  `IGST` DECIMAL(5,2) NOT NULL,
  `CGST` DECIMAL(5,2) NOT NULL,
  `SGST` DECIMAL(5,2) NOT NULL,
  `GST` DECIMAL(8,2) NOT NULL,
  `GROSS` DECIMAL(8,2) NOT NULL,
  `DISCOUNT` DECIMAL(5,2) NOT NULL,
  `NET` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`SERIAL_NO`),
  UNIQUE INDEX `BDUK` (`BILL_NO` ASC, `ITEM_CODE` ASC) VISIBLE,
  CONSTRAINT `BDFK`
    FOREIGN KEY (`BILL_NO`)
    REFERENCES `tradewell_data`.`bill_master` (`BILL_NO`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`bill_payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`bill_payment` (
  `PAYMENT_NO` VARCHAR(12) NOT NULL,
  `BILL_NO` VARCHAR(12) NOT NULL,
  `PAYMENT_DATE` DATETIME NOT NULL,
  `PAID_AMOUNT` DECIMAL(10,2) NOT NULL,
  `PAYMENT_MODE` VARCHAR(25) NOT NULL,
  `INSTRUMENT_NO` VARCHAR(20) NULL DEFAULT NULL,
  `INSTRUMENT_DATE` DATE NULL DEFAULT NULL,
  `BANK_NAME` VARCHAR(25) NULL DEFAULT NULL,
  `BRANCH_NAME` VARCHAR(25) NULL DEFAULT NULL,
  PRIMARY KEY (`PAYMENT_NO`),
  INDEX `BPFK` (`BILL_NO` ASC) VISIBLE,
  CONSTRAINT `BPFK`
    FOREIGN KEY (`BILL_NO`)
    REFERENCES `tradewell_data`.`bill_master` (`BILL_NO`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`client_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`client_master` (
  `CLIENT_CODE` VARCHAR(12) NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `CLIENT_NAME` VARCHAR(100) NOT NULL,
  `GST_APPLICABLE` CHAR(1) NOT NULL,
  `GST_IN` VARCHAR(20) NULL DEFAULT NULL,
  `GST_TYPE` VARCHAR(10) NULL DEFAULT NULL,
  `WITHIN_STATE` CHAR(1) NOT NULL,
  `ADDRESS` VARCHAR(100) NULL DEFAULT NULL,
  `CITY` VARCHAR(50) NULL DEFAULT NULL,
  `PIN` INT UNSIGNED NULL DEFAULT NULL,
  `CONTACT_PERSON` VARCHAR(100) NULL DEFAULT NULL,
  `CONTACT_NO` VARCHAR(11) NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  `TOTAL_OUTSTANDING` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`CLIENT_CODE`),
  UNIQUE INDEX `CMUK` (`CLIENT_CODE` ASC) VISIBLE,
  INDEX `CMFK` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `CMFK`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`issue_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`issue_master` (
  `ISSUE_NO` INT UNSIGNED NOT NULL,
  `ISSUING_ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `RECEIVING_ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `ISSUE_DATE` DATETIME NOT NULL,
  PRIMARY KEY (`ISSUE_NO`),
  INDEX `IMFK` USING BTREE (`ISSUING_ORGANIZATION_CODE`) VISIBLE,
  INDEX `IMFK2` USING BTREE (`RECEIVING_ORGANIZATION_CODE`) VISIBLE,
  CONSTRAINT `IMFK1`
    FOREIGN KEY (`ISSUING_ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`),
  CONSTRAINT `IMFK2`
    FOREIGN KEY (`RECEIVING_ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`item_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`item_master` (
  `ITEM_CODE` VARCHAR(6) NOT NULL,
  `ITEM_NAME` VARCHAR(100) NOT NULL,
  `ITEM_TYPE` CHAR(1) NOT NULL,
  `PRIMARY_UOM` VARCHAR(25) NOT NULL,
  `SECONDARY_UOM` VARCHAR(25) NOT NULL,
  `TERTIARY_UOM` VARCHAR(25) NULL DEFAULT NULL,
  `SECONDARY_CONVERSION` DECIMAL(7,2) NOT NULL,
  `TERTIARY_CONVERSION` DECIMAL(7,2) NOT NULL,
  `HSN_CODE` VARCHAR(10) NOT NULL,
  `GST_SLAB` DECIMAL(5,2) NOT NULL,
  `GST_TYPE` VARCHAR(15) NOT NULL,
  `GST_GROUP` INT UNSIGNED NULL DEFAULT NULL,
  `MANUFACTURER_SALE_RATE` DECIMAL(8,2) NOT NULL,
  `MANUFACTURER_GST_RATE` DECIMAL(5,2) NOT NULL,
  `DEALER_SALE_RATE` DECIMAL(8,2) NOT NULL,
  `DEALER_GST_RATE` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`ITEM_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`issue_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`issue_detail` (
  `SERIAL_NO` INT UNSIGNED NOT NULL,
  `ISSUE_NO` INT UNSIGNED NOT NULL,
  `ITEM_CODE` VARCHAR(6) NOT NULL,
  `ISSUED_QUANTITY` DECIMAL(8,2) NOT NULL,
  `FREE_QUANTITY` DECIMAL(8,2) NOT NULL,
  `TOTAL_QUANTITY` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`SERIAL_NO`),
  UNIQUE INDEX `IDUK` (`ISSUE_NO` ASC, `ITEM_CODE` ASC) VISIBLE,
  INDEX `IDFK1` (`ISSUE_NO` ASC) VISIBLE,
  INDEX `IDFK2` (`ITEM_CODE` ASC) VISIBLE,
  CONSTRAINT `IDFK1`
    FOREIGN KEY (`ISSUE_NO`)
    REFERENCES `tradewell_data`.`issue_master` (`ISSUE_NO`),
  CONSTRAINT `IDFK2`
    FOREIGN KEY (`ITEM_CODE`)
    REFERENCES `tradewell_data`.`item_master` (`ITEM_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`production_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`production_master` (
  `ISSUE_NO` INT UNSIGNED NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `ISSUE_TYPE` VARCHAR(15) NOT NULL,
  `ISSUE_DATE` DATETIME NOT NULL,
  `ITEM_CODE` VARCHAR(6) NULL DEFAULT NULL,
  `FINISHED_QUANTITY` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`ISSUE_NO`),
  INDEX `PMFK1` USING BTREE (`ORGANIZATION_CODE`) VISIBLE,
  INDEX `PMFK2` (`ITEM_CODE` ASC) VISIBLE,
  CONSTRAINT `PMFK1`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`),
  CONSTRAINT `PMFK2`
    FOREIGN KEY (`ITEM_CODE`)
    REFERENCES `tradewell_data`.`item_master` (`ITEM_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`production_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`production_detail` (
  `SERIAL_NO` INT UNSIGNED NOT NULL,
  `ISSUE_NO` INT UNSIGNED NOT NULL,
  `ITEM_CODE` VARCHAR(6) NOT NULL,
  `ISSUED_QUANTITY` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`SERIAL_NO`),
  UNIQUE INDEX `PDUK` USING BTREE (`ISSUE_NO`, `ITEM_CODE`) VISIBLE,
  INDEX `PDFK2` USING BTREE (`ITEM_CODE`) VISIBLE,
  CONSTRAINT `PDFK1`
    FOREIGN KEY (`ISSUE_NO`)
    REFERENCES `tradewell_data`.`production_master` (`ISSUE_NO`),
  CONSTRAINT `PDFK2`
    FOREIGN KEY (`ITEM_CODE`)
    REFERENCES `tradewell_data`.`item_master` (`ITEM_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`receipt_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`receipt_master` (
  `RECEIPT_NO` INT UNSIGNED NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `RECEIPT_DATE` DATETIME NOT NULL,
  PRIMARY KEY (`RECEIPT_NO`),
  INDEX `RMFK1` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `RMFK1`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`receipt_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`receipt_detail` (
  `SERIAL_NO` INT UNSIGNED NOT NULL,
  `RECEIPT_NO` INT UNSIGNED NOT NULL,
  `ITEM_CODE` VARCHAR(6) NOT NULL,
  `RECEIVED_QUANTITY` DECIMAL(8,2) NOT NULL,
  `FREE_QUANTITY` DECIMAL(8,2) NOT NULL,
  `TOTAL_QUANTITY` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`SERIAL_NO`),
  UNIQUE INDEX `RDUK` (`RECEIPT_NO` ASC, `ITEM_CODE` ASC) VISIBLE,
  INDEX `RDFK1` (`RECEIPT_NO` ASC) VISIBLE,
  INDEX `RDFK2` (`ITEM_CODE` ASC) VISIBLE,
  CONSTRAINT `RDFK1`
    FOREIGN KEY (`RECEIPT_NO`)
    REFERENCES `tradewell_data`.`receipt_master` (`RECEIPT_NO`),
  CONSTRAINT `RDFK2`
    FOREIGN KEY (`ITEM_CODE`)
    REFERENCES `tradewell_data`.`item_master` (`ITEM_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`sale_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`sale_master` (
  `SALE_NO` VARCHAR(12) NOT NULL,
  `CLIENT_CODE` VARCHAR(12) NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NULL DEFAULT NULL,
  `GST_APPLICABLE` CHAR(1) NOT NULL,
  `INVOICE_NO` VARCHAR(20) NOT NULL,
  `SALE_DATE` DATETIME NOT NULL,
  `TOTAL_SALE` DECIMAL(10,2) NOT NULL,
  `TOTAL_IGST` DECIMAL(8,2) NOT NULL,
  `TOTAL_CGST` DECIMAL(8,2) NOT NULL,
  `TOTAL_SGST` DECIMAL(8,2) NOT NULL,
  `TOTAL_GST` DECIMAL(8,2) NOT NULL,
  `GROSS_SALE` DECIMAL(10,2) NOT NULL,
  `TOTAL_DISCOUNT` DECIMAL(8,2) NOT NULL,
  `NET_SALE` DECIMAL(10,2) NOT NULL,
  `BALANCE` DECIMAL(10,2) NOT NULL,
  `CANCELLED` CHAR(1) NOT NULL,
  PRIMARY KEY (`SALE_NO`),
  UNIQUE INDEX `SMUK` (`INVOICE_NO` ASC) VISIBLE,
  INDEX `SMFK` (`CLIENT_CODE` ASC) VISIBLE,
  CONSTRAINT `SMFK`
    FOREIGN KEY (`CLIENT_CODE`)
    REFERENCES `tradewell_data`.`client_master` (`CLIENT_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`sale_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`sale_detail` (
  `SERIAL_NO` INT UNSIGNED NOT NULL,
  `SALE_NO` VARCHAR(12) NOT NULL,
  `ITEM_CODE` VARCHAR(6) NOT NULL,
  `SOLD_QUANTITY` DECIMAL(8,2) NOT NULL,
  `FREE_QUANTITY` DECIMAL(8,2) NOT NULL,
  `TOTAL_QUANTITY` DECIMAL(8,2) NOT NULL,
  `SALE_RATE` DECIMAL(5,2) NOT NULL,
  `SALE_PRICE` DECIMAL(8,2) NOT NULL,
  `IGST` DECIMAL(5,2) NOT NULL,
  `CGST` DECIMAL(5,2) NOT NULL,
  `SGST` DECIMAL(5,2) NOT NULL,
  `GST` DECIMAL(8,2) NOT NULL,
  `GROSS_PRICE` DECIMAL(8,2) NOT NULL,
  `DISCOUNT` DECIMAL(5,2) NOT NULL,
  `NET_PRICE` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`SERIAL_NO`),
  UNIQUE INDEX `SDUK` (`SALE_NO` ASC, `ITEM_CODE` ASC) VISIBLE,
  INDEX `SDFK` (`SALE_NO` ASC) VISIBLE,
  CONSTRAINT `SDFK`
    FOREIGN KEY (`SALE_NO`)
    REFERENCES `tradewell_data`.`sale_master` (`SALE_NO`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`sale_receipt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`sale_receipt` (
  `RECEIPT_NO` VARCHAR(12) NOT NULL,
  `SALE_NO` VARCHAR(12) NOT NULL,
  `RECEIPT_DATE` DATETIME NOT NULL,
  `RECEIVED_AMOUNT` DECIMAL(10,2) NOT NULL,
  `RECEIPT_MODE` VARCHAR(25) NOT NULL,
  `INSTRUMENT_NO` VARCHAR(20) NULL DEFAULT NULL,
  `INSTRUMENT_DATE` DATE NULL DEFAULT NULL,
  `BANK_NAME` VARCHAR(25) NULL DEFAULT NULL,
  `BRANCH_NAME` VARCHAR(25) NULL DEFAULT NULL,
  PRIMARY KEY (`RECEIPT_NO`),
  INDEX `SRFK` (`SALE_NO` ASC) VISIBLE,
  CONSTRAINT `SRFK`
    FOREIGN KEY (`SALE_NO`)
    REFERENCES `tradewell_data`.`sale_master` (`SALE_NO`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`statutory_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`statutory_master` (
  `REGISTERED_USER` VARCHAR(100) NOT NULL,
  `GST_IN` VARCHAR(25) NOT NULL,
  `CGST_PORTION` DECIMAL(4,2) NOT NULL,
  `SGST_PORTION` DECIMAL(4,2) NOT NULL,
  `CONTACT_NO` VARCHAR(100) NULL DEFAULT NULL,
  `FOOD_LICENSE_NO` VARCHAR(100) NULL DEFAULT NULL,
  `FOOD_LICENSE_EXPIRY` DATE NULL DEFAULT NULL,
  `LABOUR_LICENSE_NO` VARCHAR(100) NULL DEFAULT NULL,
  `LABOUR_LICENSE_EXPIRY` DATE NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  `URL` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`REGISTERED_USER`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`stock_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`stock_master` (
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `ITEM_CODE` VARCHAR(6) NOT NULL,
  `ITEM_NAME` VARCHAR(100) NOT NULL,
  `TOTAL_QUANTITY` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY USING BTREE (`ORGANIZATION_CODE`, `ITEM_CODE`),
  INDEX `SMFK2` (`ITEM_CODE` ASC) VISIBLE,
  CONSTRAINT `SMFK1`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`),
  CONSTRAINT `SMFK2`
    FOREIGN KEY (`ITEM_CODE`)
    REFERENCES `tradewell_data`.`item_master` (`ITEM_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `tradewell_data`.`user_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`user_master` (
  `USER_ID` VARCHAR(25) NOT NULL,
  `USER_NAME` VARCHAR(50) NULL DEFAULT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NULL DEFAULT NULL,
  `USER_TYPE` VARCHAR(25) NOT NULL,
  `PASSWORD` VARCHAR(50) NOT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  `REGISTERING_IP` VARCHAR(20) NOT NULL,
  `REGISTRATION_DATE` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`USER_ID`),
  INDEX `UMFK` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `UMFK`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `tradewell_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `tradewell_data` ;

-- -----------------------------------------------------
-- Placeholder table for view `tradewell_data`.`stock_master_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tradewell_data`.`stock_master_view` (`ORGANIZATION_CODE` INT, `ORGANIZATION_NAME` INT, `ITEM_CODE` INT, `ITEM_NAME` INT, `PRIMARY_QUANTITY` INT, `SECONDARY_QUANTITY` INT, `TERTIARY_QUANTITY` INT);

-- -----------------------------------------------------
-- procedure BILL_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BILL_MASTER_INSUPDEL`(
              IN BN VARCHAR(12),
              IN VC VARCHAR(12),
              IN IV VARCHAR(20),
              IN BD DATETIME,
              IN TB DECIMAL(10,2),
              IN TI DECIMAL(8,2),
              IN TC DECIMAL(8,2),
              IN TS DECIMAL(8,2),
              IN TG DECIMAL(8,2),
              IN GB DECIMAL(10,2),
              IN TD DECIMAL(8,2),
              IN NB DECIMAL(10,2),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE BILLNO VARCHAR(12);

    DECLARE VENDORCODE VARCHAR(12);
    DECLARE BL DECIMAL(10,2);
    DECLARE CN CHAR(1);

    DECLARE BILL_DATE_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE VENDOR_CODE_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE CANCELLED_ERROR CONDITION FOR SQLSTATE '99003';

    DECLARE CONTINUE HANDLER FOR BILL_DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Bill Date Should Not Be After Current Date.';

    DECLARE CONTINUE HANDLER FOR VENDOR_CODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Vendor Code Should Not Be Edited.';

    DECLARE CONTINUE HANDLER FOR CANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Purchase Has Been Cancelled.';

    IF DATE(BD) > DATE(NOW()) THEN
      SIGNAL BILL_DATE_ERROR;
    ELSE
  	  IF FLAG = -1 THEN
         SELECT GENERATE_PRIMARY_KEY('bill_master') INTO BILLNO;

         INSERT INTO bill_master
         VALUES(BILLNO,VC,IV,BD,0,0,0,0,0,0,0,0,0,'N');
 	   END IF;

  	  IF FLAG = 0 THEN
        SELECT VENDOR_CODE,BALANCE,CANCELLED
        INTO VENDORCODE,BL,CN
        FROM bill_master
        WHERE BILL_NO=BN;

        IF VC <> VENDORCODE THEN
          SIGNAL VENDOR_CODE_ERROR;
        ELSEIF UPPER(CN) IN ('Y') THEN
          SIGNAL CANCELLED_ERROR;
        ELSE
          UPDATE bill_master
		      SET VENDOR_CODE=VC,INVOICE_NO=IV,BILL_DATE=BD,TOTAL_BILL=TB,TOTAL_IGST=TI,TOTAL_CGST=TC,TOTAL_SGST=TS,
          TOTAL_GST=TG,GROSS_BILL=GB,TOTAL_DISCOUNT=TD,NET_BILL=NB,BALANCE=BL
          WHERE BILL_NO=BN;
        END IF;
  	  END IF;

  	  IF FLAG = 1 THEN
         SELECT CANCELLED INTO CN
         FROM bill_master
         WHERE BILL_NO=BN;

         IF UPPER(CN) IN ('Y') THEN
           SIGNAL CANCELLED_ERROR;
        ELSE
           DELETE FROM bill_master WHERE BILL_NO=BN;
        END IF;
  	  END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure BILL_PAYMENT_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BILL_PAYMENT_INSUPDEL`(
              IN PN VARCHAR(12),
              IN BN VARCHAR(12),
              IN PD DATETIME,
			        IN PA DECIMAL(10,2),
              IN PM VARCHAR(15),
              IN IO VARCHAR(20),
              IN ID VARCHAR(15),
              IN BA VARCHAR(15),
              IN BC VARCHAR(20),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE VENDORCODE VARCHAR(12);
    DECLARE CN CHAR(1);
    DECLARE PAYMENTNO VARCHAR(12);
    DECLARE BILLNO VARCHAR(12);
    DECLARE PAIDAMOUNT DECIMAL(10,2);

    DECLARE CANCELLED_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE PAYMENT_DATE_ERROR CONDITION FOR SQLSTATE '99003';
    DECLARE PAYMENT_MODE_ERROR CONDITION FOR SQLSTATE '99004';
    DECLARE BILL_NO_ERROR CONDITION FOR SQLSTATE '99005';

    DECLARE CONTINUE HANDLER FOR CANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Purchase Has Been Cancelled.';

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Payment Mode Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR PAYMENT_DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Payment Date Should Not Be After Current Date.';

    DECLARE CONTINUE HANDLER FOR PAYMENT_MODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Payment Mode Are:CASH,CHEQUE,DEMAND DRAFT,RTGS,NEFT,MONEY TRANSFER And ONLINE.';

    DECLARE CONTINUE HANDLER FOR BILL_NO_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Bill No Should Not Be Edited.';

    SELECT VENDOR_CODE,CANCELLED
    INTO VENDORCODE,CN
    FROM bill_master
    WHERE BILL_NO=BN;

    IF CN IN ('Y') THEN
      SIGNAL CANCELLED_ERROR;
    ELSEIF PM IN (' ','') THEN
      SIGNAL EMPTY_ERROR;
    ELSEIF DATE(PD) > DATE(NOW()) THEN
      SIGNAL PAYMENT_DATE_ERROR;
     ELSEIF UPPER(PM) NOT IN ('CASH','CHEQUE','DEMAND DRAFT','RTGS','NEFT','MONEY TRANSFER','ONLINE') THEN
      SIGNAL PAYMENT_MODE_ERROR;
    ELSE
  	  IF FLAG = -1 THEN
         SELECT GENERATE_PRIMARY_KEY('bill_payment') INTO PAYMENTNO;

         INSERT INTO bill_payment
         VALUES(PAYMENTNO,BN,PD,PA,UPPER(PM),IO,ID,BA,BC);

         UPDATE bill_master
         SET BALANCE=BALANCE - PA
         WHERE BILL_NO=BN;

         UPDATE vendor_master
         SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING - PA
         WHERE VENDOR_CODE=VENDORCODE;
 	   END IF;

  	  IF FLAG = 0 THEN
        SELECT BILL_NO,PAID_AMOUNT
        INTO BILLNO,PAIDAMOUNT
        FROM bill_payment
        WHERE PAYMENT_NO=PN;

        IF BN <> BILLNO THEN
          SIGNAL BILL_NO_ERROR;
        ELSE
		      UPDATE bill_payment
		      SET BILL_NO=BN,PAYMENT_DATE=PD,PAID_AMOUNT=PA,PAYMENT_MODE=UPPER(PM),INSTRUMENT_NO=IO,INSTRUMENT_DATE=ID,
          BANK_NAME=BA,BRANCH_NAME=BC
          WHERE PAYMENT_NO=PN;

          UPDATE bill_master
          SET BALANCE=BALANCE + PAIDAMOUNT - PA
          WHERE BILL_NO=BN;

          UPDATE vendor_master
          SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING + PAIDAMOUNT - PA
          WHERE VENDOR_CODE=VENDORCODE;
        END IF;
  	  END IF;

  	  IF FLAG = 1 THEN
         UPDATE vendor_master
         SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING + PA
         WHERE VENDOR_CODE=VENDORCODE;

         UPDATE bill_master
         SET BALANCE=BALANCE + PA
         WHERE BILL_NO=BN;

         DELETE FROM bill_payment WHERE PAYMENT_NO=PN;
  	  END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CLIENT_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CLIENT_MASTER_INSUPDEL`(
              IN CC VARCHAR(12),
              IN OC VARCHAR(12),
			        IN CN VARCHAR(100),
              IN GA CHAR(1),
              IN GI VARCHAR(20),
              IN GT VARCHAR(10),
              IN WS CHAR(1),
              IN AR VARCHAR(100),
              IN CT VARCHAR(50),
              IN PN INTEGER(6),
              IN CP VARCHAR(100),
              IN CO VARCHAR(11),
              IN EM VARCHAR(50),
              IN TU DECIMAL(12,2),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE CLIENTCODE VARCHAR(12);

	  DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE GST_APPLICABLE_WITHIN_STATE_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE GST_TYPE_ERROR CONDITION FOR SQLSTATE '99003';

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Client Name,Organization Type & GST Applicable Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR GST_APPLICABLE_WITHIN_STATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For GST Applicable & Within State Are:Y & N.';

    DECLARE CONTINUE HANDLER FOR GST_TYPE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'If GST Is Applicable Then GST IN Should Not Be Empty & Valid Values For GST Type Are:REGULAR & COMPOSITION.
                                 If GST Is Not Applicable Then GST IN & GST Type Should Be Empty';

    IF CN IN (' ','') OR GA IN (' ','') THEN
      SIGNAL EMPTY_ERROR;
    ELSEIF UPPER(GA) NOT IN ('Y','N') THEN
      SIGNAL GST_APPLICABLE_WITHIN_STATE_ERROR;
    ELSEIF UPPER(GA) IN ('Y') AND GI IS NULL THEN
      SIGNAL GST_TYPE_ERROR;
    ELSEIF UPPER(GA) IN ('Y') AND UPPER(GT) NOT IN ('REGULAR','COMPOSITION') THEN
      SIGNAL GST_TYPE_ERROR;
    ELSEIF UPPER(GA) IN ('N') AND GI IS NOT NULL THEN
      SIGNAL GST_TYPE_ERROR;
    ELSEIF UPPER(GA) IN ('N') AND UPPER(GT) IS NOT NULL THEN
      SIGNAL GST_TYPE_ERROR;
    ELSEIF UPPER(WS) NOT IN ('Y','N') THEN
      SIGNAL GST_APPLICABLE_WITHIN_STATE_ERROR;
    ELSE
  	  IF FLAG = -1 THEN
         SELECT GENERATE_PRIMARY_KEY('client_master') INTO CLIENTCODE;

         INSERT INTO client_master
         VALUES(CLIENTCODE,OC,UPPER(CN),UPPER(GA),GI,UPPER(GT),UPPER(WS),AR,CT,PN,UPPER(CP),CT,LOWER(EM),TU);
 	   END IF;

  	  IF FLAG = 0 THEN
		      UPDATE client_master
		      SET ORGANIZATION_CODE=OC,CLIENT_NAME=UPPER(CN),GST_APPLICABLE=UPPER(GA),GST_IN=GI,GST_TYPE=UPPER(GT),
          WITHIN_STATE=UPPER(WS),ADDRESS=AR,CITY=CT,PIN=PN,CONTACT_PERSON=UPPER(CP),CONTACT_NO=CO,E_MAIL=LOWER(EM),
          TOTAL_OUTSTANDING=TU
          WHERE CLIENT_CODE=CC;
  	  END IF;

  	  IF FLAG = 1 THEN
         DELETE FROM client_master WHERE CLIENT_CODE=CC;
  	  END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DELETE_DATA
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DELETE_DATA`(
              IN TN VARCHAR(100),
              IN PK INTEGER(10)
              )
BEGIN
         IF LOWER(TN) IN ('production_master') THEN
            DELETE FROM production_master WHERE ISSUE_NO=PK;
         ELSEIF LOWER(TN) IN ('production_detail') THEN
            DELETE FROM production_detail WHERE SERIAL_NO=PK;
         END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ISSUE_DETAIL_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ISSUE_DETAIL_INSUPDEL`(
      IN SN INTEGER(10),
      IN IO INTEGER(10),
      IN IC VARCHAR(6),
      IN IQ DECIMAL(8,2),
      IN FQ DECIMAL(8,2),
      IN TQ DECIMAL(8,2),
      IN FLAG INT
      )
BEGIN
  DECLARE ISSUINGORGANIZATIONCODE VARCHAR(12);
  DECLARE RECEIVINGORGANIZATIONCODE VARCHAR(12);
  DECLARE TOQU DECIMAL(8,2);

  DECLARE SERIALNO INTEGER(10);

  DECLARE COUNTER INTEGER;

  DECLARE ITEMNAME VARCHAR(100);

  DECLARE ITEMCODE VARCHAR(6);
  DECLARE TOTALQUANTITY DECIMAL(8,2);

  DECLARE TOTAL_QUANTITY_ERROR CONDITION FOR SQLSTATE '99001';
  DECLARE ITEM_CODE_ERROR CONDITION FOR SQLSTATE '99002';

  DECLARE CONTINUE HANDLER FOR TOTAL_QUANTITY_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Total Quantity Issued Cannot Exceed The Total Quantity In Stock For This Item.';

  DECLARE CONTINUE HANDLER FOR ITEM_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Issued Item Code Should Not Be Edited.';

  SELECT ISSUING_ORGANIZATION_CODE,RECEIVING_ORGANIZATION_CODE
  INTO ISSUINGORGANIZATIONCODE,RECEIVINGORGANIZATIONCODE
  FROM issue_master
  WHERE ISSUE_NO=IO;

  SELECT TOTAL_QUANTITY INTO TOQU
  FROM stock_master
  WHERE ITEM_CODE=IC AND ORGANIZATION_CODE=ISSUINGORGANIZATIONCODE;

  IF FLAG = -1 THEN
     IF TQ > TOQU THEN
        SIGNAL TOTAL_QUANTITY_ERROR;
     ELSE
       SELECT GENERATE_PRIMARY_KEY('issue_detail') INTO SERIALNO;

       INSERT INTO issue_detail
       VALUES(SERIALNO,IO,IC,IQ,FQ,TQ);

       UPDATE stock_master
       SET TOTAL_QUANTITY = TOTAL_QUANTITY - TQ
       WHERE ORGANIZATION_CODE=ISSUINGORGANIZATIONCODE AND ITEM_CODE=IC;

       SELECT COUNT(*) INTO COUNTER
       FROM stock_master
       WHERE ORGANIZATION_CODE=RECEIVINGORGANIZATIONCODE AND ITEM_CODE=IC;

       IF COUNTER <= 0 THEN
          SELECT ITEM_NAME INTO ITEMNAME
          FROM item_master
          WHERE ITEM_CODE=IC;

          INSERT INTO stock_master
          VALUES(RECEIVINGORGANIZATIONCODE,IC,ITEMNAME,TQ);
        ELSE
          UPDATE stock_master
          SET TOTAL_QUANTITY = TOTAL_QUANTITY + TQ
          WHERE ORGANIZATION_CODE=RECEIVINGORGANIZATIONCODE AND ITEM_CODE=IC;
        END IF;
    END IF;
  END IF;

  IF FLAG = 0 THEN
     SELECT ITEM_CODE,TOTAL_QUANTITY
     INTO ITEMCODE,TOTALQUANTITY
     FROM issue_detail
     WHERE SERIAL_NO=SN;

     IF IC <> ITEMCODE THEN
       SIGNAL ITEM_CODE_ERROR;
     ELSEIF TQ  > (TOQU + TOTALQUANTITY) THEN
       SIGNAL TOTAL_QUANTITY_ERROR;
     ELSE
       UPDATE issue_detail
       SET ISSUE_NO=IO,ITEM_CODE=IC,ISSUED_QUANTITY=IQ,FREE_QUANTITY=FQ,TOTAL_QUANTITY=TQ
       WHERE SERIAL_NO=SN;

       UPDATE stock_master
       SET TOTAL_QUANTITY = TOTAL_QUANTITY + TOTALQUANTITY - TQ
       WHERE ORGANIZATION_CODE=ISSUINGORGANIZATIONCODE AND ITEM_CODE=IC;

       UPDATE stock_master
       SET TOTAL_QUANTITY = TOTAL_QUANTITY - TOTALQUANTITY + TQ
       WHERE ORGANIZATION_CODE=RECEIVINGORGANIZATIONCODE AND ITEM_CODE=IC;
    END IF;
  END IF;

  IF FLAG = 1 THEN
     UPDATE stock_master
     SET TOTAL_QUANTITY = TOTAL_QUANTITY - TQ
     WHERE ORGANIZATION_CODE=RECEIVINGORGANIZATIONCODE AND ITEM_CODE=IC;

     UPDATE stock_master
     SET TOTAL_QUANTITY = TOTAL_QUANTITY + TQ
     WHERE ORGANIZATION_CODE=ISSUINGORGANIZATIONCODE AND ITEM_CODE=IC;

     DELETE FROM issue_detail WHERE SERIAL_NO=SN;
  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ISSUE_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ISSUE_MASTER_INSUPDEL`(
      IN IO INTEGER(10),
      IN IOC VARCHAR(12),
      IN ROC VARCHAR(12),
      IN ID DATETIME,
      IN FLAG INT
      )
BEGIN
  DECLARE PARENTORGANIZATION CHAR(1);

  DECLARE ISSUENO INTEGER(10);

  DECLARE ISSUINGORGANIZATIONCODE VARCHAR(12);
  DECLARE RECEIVINGORGANIZATIONCODE VARCHAR(12);

  DECLARE PARENT_ORGANIZATION_ERROR CONDITION FOR SQLSTATE '99001';
  DECLARE ISSUE_DATE_ERROR CONDITION FOR SQLSTATE '99002';
  DECLARE ISSUING_ORGANIZATION_CODE_ERROR CONDITION FOR SQLSTATE '99003';
  DECLARE RECEIVING_ORGANIZATION_CODE_ERROR CONDITION FOR SQLSTATE '99004';

  DECLARE CONTINUE HANDLER FOR PARENT_ORGANIZATION_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Only Parent Type Organization Can Issue Stock.';

  DECLARE CONTINUE HANDLER FOR ISSUE_DATE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Issue Date Should Not Be After Current Date.';

  DECLARE CONTINUE HANDLER FOR ISSUING_ORGANIZATION_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Issuing Organization Should Not Be Edited.';

  DECLARE CONTINUE HANDLER FOR RECEIVING_ORGANIZATION_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Receiving Organization Should Not Be Edited.';

  SELECT PRIMARY_ORGANIZATION  INTO PARENTORGANIZATION
  FROM organization_master
  WHERE ORGANIZATION_CODE=IOC;

  IF UPPER(PARENTORGANIZATION) NOT IN ('Y') THEN
    SIGNAL PARENT_ORGANIZATION_ERROR;
  ELSEIF DATE(ID) > DATE(NOW()) THEN
    SIGNAL ISSUE_DATE_ERROR;
  ELSE
    IF FLAG = -1 THEN
       SELECT GENERATE_PRIMARY_KEY('issue_master') INTO ISSUENO;

       INSERT INTO issue_master
       VALUES(ISSUENO,IOC,ROC,ID);
    END IF;

    IF FLAG = 0 THEN
      SELECT ISSUING_ORGANIZATION_CODE,RECEIVING_ORGANIZATION_CODE
      INTO ISSUINGORGANIZATIONCODE,RECEIVINGORGANIZATIONCODE
      FROM issue_master
      WHERE ISSUE_NO=IO;

      IF IOC <> ISSUINGORGANIZATIONCODE THEN
        SIGNAL ISSUING_ORGANIZATION_CODE_ERROR;
      ELSEIF ROC <> RECEIVINGORGANIZATIONCODE THEN
        SIGNAL RECEIVING_ORGANIZATION_CODE_ERROR;
      ELSE
        UPDATE issue_master
        SET ISSUING_ORGANIZATION_CODE=IOC,RECEIVING_ORGANIZATION_CODE=ROC,ISSUE_DATE=ID
        WHERE ISSUE_NO=IO;
      END IF;
    END IF;

    IF FLAG = 1 THEN
      DELETE FROM issue_master WHERE ISSUE_NO=IO;
    END IF;
  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ITEM_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ITEM_MASTER_INSUPDEL`(
      IN IC VARCHAR(6),
      IN IM VARCHAR(100),
      IN IT CHAR(1),
      IN PU VARCHAR(25),
      IN SU VARCHAR(25),
      IN TU VARCHAR(25),
      IN SC DECIMAL(7,2),
      IN TC DECIMAL(7,2),
      IN HC VARCHAR(10),
      IN GS DECIMAL(5,2),
      IN GT VARCHAR(15),
      IN GG INTEGER(10),
      IN MSR DECIMAL(8,2),
      IN MGR DECIMAL(5,2),
      IN DSR DECIMAL(8,2),
      IN DGR DECIMAL(5,2),
      IN FLAG INT
      )
BEGIN
  DECLARE ITEMCODE VARCHAR(6);
  DECLARE DONE INT DEFAULT FALSE;
  DECLARE ORGANIZATIONCODE VARCHAR(12);

  DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99001';
  DECLARE ITEM_TYPE_ERROR CONDITION FOR SQLSTATE '99002';
  DECLARE GST_TYPE_ERROR CONDITION FOR SQLSTATE '99003';

  DECLARE PRIMARY_ORGANIZATION_CODE_CURSOR CURSOR FOR
	SELECT ORGANIZATION_CODE
  FROM organization_master
  WHERE PRIMARY_ORGANIZATION IN ('Y');

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE = TRUE;

  DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Item Name,Item Type,Primary UOM,Secondary UOM,HSN Code & GST Type Should Not Be Empty.';

  DECLARE CONTINUE HANDLER FOR ITEM_TYPE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Item Type Are:R,S,F & B.';

  DECLARE CONTINUE HANDLER FOR GST_TYPE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Valid Values For GST Type Are:INCLUSIVE & EXCLUSIVE.';

  IF IM IN (' ','') OR IT IN (' ','') OR PU IN (' ','') OR SU IN (' ','') OR HC IN (' ','') OR GT IN (' ','') THEN
    SIGNAL EMPTY_ERROR;
  ELSEIF UPPER(IT) NOT IN ('R','S','F','B') THEN
    SIGNAL GST_TYPE_ERROR;
  ELSEIF UPPER(GT) NOT IN ('INCLUSIVE','EXCLUSIVE') THEN
    SIGNAL GST_TYPE_ERROR;
  ELSE
    IF FLAG = -1 THEN
       SELECT GENERATE_PRIMARY_KEY('item_master') INTO ITEMCODE;

       INSERT INTO item_master
       VALUES(ITEMCODE,UPPER(IM),UPPER(IT),UPPER(PU),UPPER(SU),UPPER(TU),SC,TC,UPPER(HC),GS,UPPER(GT),GG,MSR,MGR,DSR,DGR);

       OPEN PRIMARY_ORGANIZATION_CODE_CURSOR;

       READ_LOOP:LOOP
    		FETCH PRIMARY_ORGANIZATION_CODE_CURSOR
		    INTO ORGANIZATIONCODE;

    		IF DONE THEN
      			LEAVE READ_LOOP;
		    END IF;

        INSERT INTO stock_master
        VALUES(ORGANIZATIONCODE,ITEMCODE,UPPER(IM),0);
  	  END LOOP;

	    CLOSE PRIMARY_ORGANIZATION_CODE_CURSOR;
    END IF;

    IF FLAG = 0 THEN
       UPDATE item_master
       SET ITEM_NAME=UPPER(IM),ITEM_TYPE=UPPER(IT),PRIMARY_UOM=UPPER(PU),SECONDARY_UOM=UPPER(SU),TERTIARY_UOM=UPPER(TU),
       SECONDARY_CONVERSION=SC,TERTIARY_CONVERSION=TC,HSN_CODE=UPPER(HC),GST_SLAB=GS,
       GST_TYPE=UPPER(GT),GST_GROUP=GG,MANUFACTURER_SALE_RATE=MSR,MANUFACTURER_GST_RATE=MGR,DEALER_SALE_RATE=DGR,
       DEALER_GST_RATE=DGR
       WHERE ITEM_CODE=IC;

       UPDATE stock_master
       SET ITEM_NAME=UPPER(IM)
       WHERE ITEM_CODE=IC;
    END IF;

    IF FLAG = 1 THEN
       DELETE FROM stock_master WHERE ITEM_CODE=IC AND TOTAL_QUANTITY <= 0;
       DELETE FROM item_master WHERE ITEM_CODE=IC;
    END IF;
  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ORGANIZATION_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ORGANIZATION_MASTER_INSUPDEL`(
              IN OC VARCHAR(12),
			        IN OM VARCHAR(100),
              IN OG VARCHAR(25),
				      IN OT VARCHAR(20),
              IN PO CHAR(1),
              IN GI VARCHAR(20),
              IN GT VARCHAR(10),
              IN AR VARCHAR(100),
              IN CT VARCHAR(50),
              IN PN INTEGER(6),
              IN CP VARCHAR(100),
              IN CN VARCHAR(11),
              IN EM VARCHAR(50),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE ORGANIZATIONCODE VARCHAR(12);
    DECLARE ITEMCODE VARCHAR(12);
    DECLARE ITEMNAME VARCHAR(100);
    DECLARE DONE INT DEFAULT FALSE;

	  DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE ORGANIZATION_TYPE_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE PRIMARY_ORGANIZATION_ERROR CONDITION FOR SQLSTATE '99003';
    DECLARE GST_TYPE_ERROR CONDITION FOR SQLSTATE '99004';

    DECLARE ITEM_MASTER_CURSOR CURSOR FOR
	  SELECT ITEM_CODE,ITEM_NAME
    FROM item_master;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE = TRUE;

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Organization Name,Organization Type,Parent Organization,GST IN & GST Type Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR ORGANIZATION_TYPE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Organization Type Are:ALL,MANUFACTURER,WAREHOUSE,DEALER,DISTRIBUTER,STOCKIST & FRANCHISE.';

    DECLARE CONTINUE HANDLER FOR PRIMARY_ORGANIZATION_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Primary Organization Are:Y & N.';

    DECLARE CONTINUE HANDLER FOR GST_TYPE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For GST Type Are:REGULAR & COMPOSITION.';

    IF OM IN (' ','') OR OT IN (' ','') OR GI IN (' ','') OR PO IN (' ','') OR GT IN (' ','') THEN
      SIGNAL EMPTY_ERROR;
    ELSEIF UPPER(OT) NOT IN ('ALL','MANUFACTURER','WAREHOUSE','DEALER','DISTRIBUTER','STOCKIST','FRANCHISE') THEN
      SIGNAL ORGANIZATION_TYPE_ERROR;
    ELSEIF UPPER(PO) NOT IN ('Y','N') THEN
      SIGNAL PRIMARY_ORGANIZATION_ERROR;
    ELSEIF UPPER(GT) NOT IN ('REGULAR','COMPOSITION') THEN
      SIGNAL GST_TYPE_ERROR;
    ELSE
  	  IF FLAG = -1 THEN
         SELECT GENERATE_PRIMARY_KEY('organization_master') INTO ORGANIZATIONCODE;

         INSERT INTO organization_master
         VALUES(ORGANIZATIONCODE,UPPER(OM),UPPER(OG),UPPER(OT),UPPER(PO),GI,UPPER(GT),AR,CT,PN,UPPER(CP),CN,LOWER(EM));

         IF UPPER(PO) IN ('Y') THEN
           OPEN ITEM_MASTER_CURSOR;

           READ_LOOP:LOOP
             FETCH ITEM_MASTER_CURSOR
             INTO ITEMCODE,ITEMNAME;

    		    IF DONE THEN
      			  LEAVE READ_LOOP;
		        END IF;

            INSERT INTO stock_master
            VALUES(ORGANIZATIONCODE,ITEMCODE,ITEMNAME,0);
  	      END LOOP;

	        CLOSE ITEM_MASTER_CURSOR;
        END IF;
 	   END IF;

  	  IF FLAG = 0 THEN
		    UPDATE organization_master
		    SET ORGANIZATION_NAME=UPPER(OM),ORGANIZATION_GROUP=UPPER(OG),ORGANIZATION_TYPE=UPPER(OT),PRIMARY_ORGANIZATION=UPPER(PO),
        GST_IN=GI,GST_TYPE=UPPER(GT),ADDRESS=AR,CITY=CT,PIN=PN,CONTACT_PERSON=UPPER(CP),CONTACT_NO=CN,E_MAIL=LOWER(EM)
        WHERE ORGANIZATION_CODE=OC;
  	  END IF;

  	  IF FLAG = 1 THEN
         DELETE FROM stock_master WHERE ORGANIZATION_CODE=OC AND TOTAL_QUANTITY<=0;
         DELETE FROM organization_master WHERE ORGANIZATION_CODE=OC;
  	  END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PRODUCTION_DETAIL_INSERT_DELETE
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PRODUCTION_DETAIL_INSERT_DELETE`(
      IN SN INTEGER(10),
      IN IO INTEGER(10),
      IN IC VARCHAR(6),
      IN IQ DECIMAL(8,2),
      IN FLAG INT
      )
BEGIN
  DECLARE ORGANIZATIONCODE VARCHAR(12);
  DECLARE ITEMTYPE CHAR(1);

  DECLARE SERIALNO INTEGER(10);

  DECLARE ISSUENO INTEGER(10);
  DECLARE ITEMCODE VARCHAR(6);
  DECLARE ISSUEDQUANTITY DECIMAL(8,2);

  DECLARE ITEM_TYPE_ERROR CONDITION FOR SQLSTATE '99001';
  DECLARE ISSUE_NO_ERROR CONDITION FOR SQLSTATE '99002';
  DECLARE ITEM_CODE_ERROR CONDITION FOR SQLSTATE '99003';

  DECLARE CONTINUE HANDLER FOR ITEM_TYPE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Item Type Are:R And S.';

  DECLARE CONTINUE HANDLER FOR ISSUE_NO_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Item Should Not Be Edited.';

  DECLARE CONTINUE HANDLER FOR ITEM_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Issue No Should Not Be Edited.';

  SELECT ORGANIZATION_CODE INTO ORGANIZATIONCODE
  FROM production_master
  WHERE ISSUE_NO=IO;

  SELECT ITEM_TYPE INTO ITEMTYPE
  FROM item_master
  WHERE ITEM_CODE=IC;

  IF ITEMTYPE NOT IN ('R','S') THEN
      SIGNAL ITEM_TYPE_ERROR;
  ELSE
      IF FLAG = -1 THEN
         SELECT GENERATE_PRIMARY_KEY('production_detail') INTO SERIALNO;

         INSERT INTO production_detail
         VALUES(SERIALNO,IO,IC,IQ);

         UPDATE stock_master
         SET TOTAL_QUANTITY = TOTAL_QUANTITY - IQ
         WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;
      END IF;

      IF FLAG = 0 THEN
         SELECT ISSUE_NO,ITEM_CODE,ISSUED_QUANTITY
         INTO ISSUENO,ITEMCODE,ISSUEDQUANTITY
         FROM production_detail
         WHERE SERIAL_NO=SN;

         IF IO <> ISSUENO THEN
            SIGNAL ISSUE_NO_ERROR;
         ELSEIF IC <> ITEMCODE THEN
            SIGNAL ITEM_CODE_ERROR;
         ELSE
           UPDATE production_detail
           SET ISSUE_NO=IO,ITEM_CODE=IC,ISSUED_QUANTITY=IQ
           WHERE SERIAL_NO=SN;

           UPDATE stock_master
           SET TOTAL_QUANTITY = TOTAL_QUANTITY + ISSUEDQUANTITY - IQ
           WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;
        END IF;
      END IF;

  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PRODUCTION_MASTER_INSERT_DELETE
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PRODUCTION_MASTER_INSERT_DELETE`(
      IN IO INTEGER(10),
      IN OC VARCHAR(12),
      IN IT VARCHAR(15),
      IN ID DATETIME,
      IN IC VARCHAR(6),
      IN FQ DECIMAL(8,2),
      IN FLAG INT
      )
BEGIN
  DECLARE ISSUENO INTEGER(10);
  DECLARE ITEMTYPE CHAR(1);

  DECLARE ORGANIZATIONCODE VARCHAR(12);
  DECLARE ITEMCODE VARCHAR(6);
  DECLARE FINISHEDQUANTITY DECIMAL(8,2);

  DECLARE ISSUE_TYPE_ERROR CONDITION FOR SQLSTATE '99001';
  DECLARE ISSUE_DATE_ERROR CONDITION FOR SQLSTATE '99002';
  DECLARE ITEM_TYPE_ERROR CONDITION FOR SQLSTATE '99003';
  DECLARE ORGANIZATION_CODE_ERROR CONDITION FOR SQLSTATE '99004';
  DECLARE ITEM_CODE_ERROR CONDITION FOR SQLSTATE '99005';

  DECLARE CONTINUE HANDLER FOR ISSUE_TYPE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Valid values For Issue Type Are:BOTH,ISSUE ONLY & RECEIVE ONLY.';

  DECLARE CONTINUE HANDLER FOR ISSUE_DATE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Issue Date Should Not Be After Current Date.';

  DECLARE CONTINUE HANDLER FOR ITEM_TYPE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Item Type Are:S And F.';

  DECLARE CONTINUE HANDLER FOR ORGANIZATION_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Organization Should Not Be Edited.';

  DECLARE CONTINUE HANDLER FOR ITEM_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Item Should Not Be Edited.';

  IF IC IS NOT NULL THEN
    SELECT ITEM_TYPE INTO ITEMTYPE
    FROM item_master
    WHERE ITEM_CODE=IC;
  END IF;

  IF UPPER(IT) NOT IN ('BOTH','ISSUE ONLY','RECEIVE ONLY') THEN
    SIGNAL ISSUE_TYPE_ERROR;
  ELSEIF DATE(ID) > DATE(NOW()) THEN
    SIGNAL ISSUE_DATE_ERROR;
  ELSEIF IC IS NOT NULL AND ITEMTYPE NOT IN ('S','F') THEN
      SIGNAL ITEM_TYPE_ERROR;
  ELSE
    IF FLAG = -1 THEN
       SELECT GENERATE_PRIMARY_KEY('production_master') INTO ISSUENO;

       INSERT INTO production_master
       VALUES(ISSUENO,OC,UPPER(IT),ID,IC,FQ);

       IF IC IS NOT NULL THEN
         UPDATE stock_master
         SET TOTAL_QUANTITY = TOTAL_QUANTITY + FQ
         WHERE ORGANIZATION_CODE=OC AND ITEM_CODE=IC;
      END IF;
    END IF;

    IF FLAG = 0 THEN
      SELECT ORGANIZATION_CODE,ITEM_CODE,FINISHED_QUANTITY
      INTO ORGANIZATIONCODE,ITEMCODE,FINISHEDQUANTITY
      FROM production_master
      WHERE ISSUE_NO=IO;

      IF OC <> ORGANIZATIONCODE THEN
        SIGNAL ORGANIZATION_CODE_ERROR;
      ELSEIF IC <> ITEMCODE THEN
        SIGNAL ITEM_CODE_ERROR;
      ELSE
        UPDATE production_master
        SET ORGANIZATION_CODE=OC,ISSUE_TYPE=UPPER(IT),ISSUE_DATE=ID,ITEM_CODE=IC,FINISHED_QUANTITY=FQ
        WHERE ISSUE_NO=IO;

        IF IC IS NOT NULL THEN
          UPDATE stock_master
          SET TOTAL_QUANTITY = TOTAL_QUANTITY - FINISHEDQUANTITY + FQ
          WHERE ORGANIZATION_CODE=OC AND ITEM_CODE=IC;
        END IF;
      END IF;
    END IF;

  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RECEIPT_DETAIL_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RECEIPT_DETAIL_INSUPDEL`(
      IN SN INTEGER(10),
      IN RN INTEGER(10),
      IN IC VARCHAR(6),
      IN RQ DECIMAL(8,2),
      IN FQ DECIMAL(8,2),
      IN TQ DECIMAL(8,2),
      IN FLAG INT
      )
BEGIN
  DECLARE ORGANIZATIONCODE VARCHAR(12);

  DECLARE SERIALNO INTEGER(10);

  DECLARE ITEMCODE VARCHAR(6);
  DECLARE TOTALQUANTITY DECIMAL(8,2);

  DECLARE ITEM_CODE_ERROR CONDITION FOR SQLSTATE '99001';

  DECLARE CONTINUE HANDLER FOR ITEM_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Received Item Code Should Not Be Edited.';

  SELECT ORGANIZATION_CODE INTO ORGANIZATIONCODE
  FROM receipt_master
  WHERE RECEIPT_NO=RN;

  IF FLAG = -1 THEN
     SELECT GENERATE_PRIMARY_KEY('receipt_detail') INTO SERIALNO;

     INSERT INTO receipt_detail
     VALUES(SERIALNO,RN,IC,RQ,FQ,TQ);

     UPDATE stock_master
     SET TOTAL_QUANTITY = TOTAL_QUANTITY + TQ
     WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;
  END IF;

  IF FLAG = 0 THEN
     SELECT ITEM_CODE,TOTAL_QUANTITY
     INTO ITEMCODE,TOTALQUANTITY
     FROM receipt_detail
     WHERE SERIAL_NO=SN;

     IF IC <> ITEMCODE THEN
        SIGNAL ITEM_CODE_ERROR;
     ELSE
       UPDATE receipt_detail
       SET RECEIPT_NO=RN,ITEM_CODE=IC,RECEIVED_QUANTITY=RQ,FREE_QUANTITY=FQ,TOTAL_QUANTITY=TQ
       WHERE SERIAL_NO=SN;

       UPDATE stock_master
       SET TOTAL_QUANTITY = TOTAL_QUANTITY - TOTALQUANTITY + TQ
       WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;
    END IF;
  END IF;

  IF FLAG = 1 THEN
     UPDATE stock_master
     SET TOTAL_QUANTITY = TOTAL_QUANTITY - TQ
     WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;

     DELETE FROM receipt_detail WHERE SERIAL_NO=SN;
  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RECEIPT_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RECEIPT_MASTER_INSUPDEL`(
      IN RN INTEGER(10),
      IN OC VARCHAR(12),
      IN RD DATETIME,
      IN FLAG INT
      )
BEGIN
  DECLARE PRIMARYORGANIZATION CHAR(1);

  DECLARE RECEIPTNO INTEGER(10);

  DECLARE ORGANIZATIONCODE VARCHAR(12);

  DECLARE PRIMARY_ORGANIZATION_ERROR CONDITION FOR SQLSTATE '99001';
  DECLARE RECEIPT_DATE_ERROR CONDITION FOR SQLSTATE '99002';
  DECLARE ORGANIZATION_CODE_ERROR CONDITION FOR SQLSTATE '99003';

  DECLARE CONTINUE HANDLER FOR PRIMARY_ORGANIZATION_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Only Primary Organization Can Receive Stock.';

  DECLARE CONTINUE HANDLER FOR RECEIPT_DATE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Reecipt Date Should Not Be After Current Date.';

  DECLARE CONTINUE HANDLER FOR ORGANIZATION_CODE_ERROR
  RESIGNAL SET MESSAGE_TEXT = 'Organization Code Should Not Be Edited.';

  SELECT PRIMARY_ORGANIZATION INTO PRIMARYORGANIZATION
  FROM organization_master
  WHERE ORGANIZATION_CODE=OC;

  IF UPPER(PRIMARYORGANIZATION) NOT IN ('Y') THEN
    SIGNAL PRIMARY_ORGANIZATION_ERROR;
  ELSEIF DATE(RD) > DATE(NOW())  THEN
    SIGNAL RECEIPT_DATE_ERROR;
  ELSE
    IF FLAG = -1 THEN
       SELECT GENERATE_PRIMARY_KEY('receipt_master') INTO RECEIPTNO;

       INSERT INTO receipt_master
       VALUES(RECEIPTNO,OC,RD);
    END IF;

    IF FLAG = 0 THEN
      SELECT ORGANIZATION_CODE INTO ORGANIZATIONCODE
      FROM receipt_master
      WHERE RECEIPT_NO=RN;

      IF OC <> ORGANIZATIONCODE THEN
        SIGNAL ORGANIZATION_CODE_ERROR;
      ELSE
        UPDATE receipt_master
        SET ORGANIZATION_CODE=OC,RECEIPT_DATE=RD
        WHERE RECEIPT_NO=RN;
      END IF;
    END IF;

    IF FLAG = 1 THEN
      DELETE FROM receipt_master WHERE RECEIPT_NO=RN;
    END IF;
  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SALE_CANCEL_UNCANCEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SALE_CANCEL_UNCANCEL`(
              IN SN VARCHAR(12),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE CLIENTCODE VARCHAR(12);
    DECLARE ORGC VARCHAR(12);
    DECLARE NETSALE DECIMAL(10,2);
    DECLARE CN CHAR(1);
    DECLARE IC VARCHAR(12);
    DECLARE TQ DECIMAL(8,2);
    DECLARE ORGANIZATIONCODE VARCHAR(12);
    DECLARE DONE INT DEFAULT FALSE;

    DECLARE CANCELLED_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE UNCANCELLED_ERROR CONDITION FOR SQLSTATE '99002';

    DECLARE TOTAL_QUANTITY_CURSOR CURSOR FOR
	  SELECT ITEM_CODE,TOTAL_QUANTITY
    FROM sale_detail
    WHERE SALE_NO=SN;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE = TRUE;

    DECLARE CONTINUE HANDLER FOR CANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Invoice Has Already Been Been Cancelled.';

    DECLARE CONTINUE HANDLER FOR UNCANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Invoice Has Not Been Been Cancelled.';

    SELECT CLIENT_CODE,ORGANIZATION_CODE,NET_SALE,CANCELLED
    INTO CLIENTCODE,ORGC,NETSALE,CN
    FROM sale_master
    WHERE SALE_NO=SN;

    IF ORGC IS NULL THEN
      SELECT ORGANIZATION_CODE INTO ORGANIZATIONCODE
      FROM client_master
      WHERE CLIENT_CODE=CLIENTCODE;
    ELSE
      SET ORGANIZATIONCODE := ORGC;
    END IF;

  	IF FLAG = -1 THEN
      IF CN IN ('Y') THEN
        SIGNAL CANCELLED_ERROR;
      ELSE
        OPEN TOTAL_QUANTITY_CURSOR;

        READ_LOOP:LOOP
          FETCH TOTAL_QUANTITY_CURSOR
          INTO IC,TQ;

          IF DONE THEN
             LEAVE READ_LOOP;
          END IF;

          UPDATE stock_master
          SET TOTAL_QUANTITY=TOTAL_QUANTITY + TQ
          WHERE ITEM_CODE=IC AND ORGANIZATION_CODE=ORGANIZATIONCODE;
        END LOOP;

        CLOSE TOTAL_QUANTITY_CURSOR;

        UPDATE sale_master
        SET BALANCE=0,CANCELLED='Y'
        WHERE SALE_NO=SN;

        UPDATE client_master
        SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING - NETSALE
        WHERE CLIENT_CODE=CLIENTCODE;
      END IF;
 	 END IF;

  	IF FLAG = 1 THEN
      IF CN IN ('N') THEN
        SIGNAL UNCANCELLED_ERROR;
      ELSE
        OPEN TOTAL_QUANTITY_CURSOR;

        READ_LOOP:LOOP
          FETCH TOTAL_QUANTITY_CURSOR
          INTO IC,TQ;

          IF DONE THEN
             LEAVE READ_LOOP;
          END IF;

          UPDATE stock_master
          SET TOTAL_QUANTITY=TOTAL_QUANTITY - TQ
          WHERE ITEM_CODE=IC AND ORGANIZATION_CODE=ORGANIZATIONCODE;
        END LOOP;

        CLOSE TOTAL_QUANTITY_CURSOR;

        UPDATE client_master
        SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING + NETSALE
        WHERE CLIENT_CODE=CLIENTCODE;

        UPDATE sale_master
        SET BALANCE=NETSALE,CANCELLED='N'
        WHERE SALE_NO=SN;
      END IF;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SALE_DETAIL_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SALE_DETAIL_INSUPDEL`(
              IN SSN INTEGER(10),
              IN SN VARCHAR(12),
              IN IC VARCHAR(6),
			        IN SQ DECIMAL(8,2),
              IN FQ DECIMAL(8,2),
              IN TQ DECIMAL(8,2),
              IN SR DECIMAL(5,2),
              IN SP DECIMAL(8,2),
              IN IG DECIMAL(5,2),
              IN CG DECIMAL(5,2),
              IN SG DECIMAL(5,2),
              IN GT DECIMAL(8,2),
              IN GP DECIMAL(8,2),
              IN DS DECIMAL(8,2),
              IN NP DECIMAL(8,2),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE SERIALNO INTEGER(10);
    DECLARE CLIENTCODE VARCHAR(12);
    DECLARE ORGC VARCHAR(12);
    DECLARE CN CHAR(1);
    DECLARE ITEMTYPE CHAR(1);

    DECLARE ORGANIZATIONCODE VARCHAR(12);
    DECLARE TOQU DECIMAL(8,2);

    DECLARE SALENO VARCHAR(12);
    DECLARE ITEMCODE VARCHAR(6);
    DECLARE TOTALQUANTITY DECIMAL(8,2);
    DECLARE SALEPRICE DECIMAL(8,2);
    DECLARE I DECIMAL(5,2);
    DECLARE C DECIMAL(5,2);
    DECLARE S DECIMAL(5,2);
    DECLARE G DECIMAL(5,2);
    DECLARE GROSSPRICE DECIMAL(8,2);
    DECLARE D DECIMAL(5,2);
    DECLARE NETPRICE DECIMAL(8,2);

    DECLARE CANCELLED_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE ITEM_TYPE_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE TOTAL_QUANTITY_ERROR CONDITION FOR SQLSTATE '99003';
    DECLARE SALE_NO_ERROR CONDITION FOR SQLSTATE '99004';
    DECLARE ITEM_CODE_ERROR CONDITION FOR SQLSTATE '99005';

    DECLARE CONTINUE HANDLER FOR CANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Invoice Has Been Cancelled.';

    DECLARE CONTINUE HANDLER FOR ITEM_TYPE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Item Type Are:S,F And B.';

    DECLARE CONTINUE HANDLER FOR TOTAL_QUANTITY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Total Quantity Sold Cannot Exceed The Total Quantity In Stock For This Item.';

    DECLARE CONTINUE HANDLER FOR SALE_NO_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Sale No Should Not Be Edited.';

    DECLARE CONTINUE HANDLER FOR ITEM_CODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Item Code Should Not Be Edited.';

    SELECT CLIENT_CODE,ORGANIZATION_CODE,CANCELLED
    INTO CLIENTCODE,ORGC,CN
    FROM sale_master
    WHERE SALE_NO=SN;

    SELECT ITEM_TYPE INTO ITEMTYPE
    FROM item_master
    WHERE ITEM_CODE=IC;

    IF ORGC IS NULL THEN
      SELECT ORGANIZATION_CODE INTO ORGANIZATIONCODE
      FROM client_master
      WHERE CLIENT_CODE=CLIENTCODE;
    ELSE
      SET ORGANIZATIONCODE := ORGC;
    END IF;

    SELECT TOTAL_QUANTITY INTO TOQU
    FROM stock_master
    WHERE ITEM_CODE=IC AND ORGANIZATION_CODE=ORGANIZATIONCODE;

    IF CN IN ('Y') THEN
      SIGNAL CANCELLED_ERROR;
    ELSEIF ITEMTYPE NOT IN ('S','F','B') THEN
      SIGNAL ITEM_TYPE_ERROR;
    ELSE
      IF FLAG = -1 THEN
         IF TQ > TOQU THEN
            SIGNAL TOTAL_QUANTITY_ERROR;
         ELSE
           SELECT GENERATE_PRIMARY_KEY('sale_detail') INTO SERIALNO;

           INSERT INTO sale_detail
           VALUES(SERIALNO,SN,IC,SQ,FQ,TQ,SR,SP,IG,CG,SG,GT,GP,DS,NP);

           UPDATE stock_master
           SET TOTAL_QUANTITY=TOTAL_QUANTITY - TQ
           WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;

           UPDATE sale_master
           SET TOTAL_SALE=TOTAL_SALE + SP,TOTAL_IGST=TOTAL_IGST + IG,TOTAL_CGST=TOTAL_CGST + CG,TOTAL_SGST=TOTAL_SGST + SG,
           TOTAL_GST=TOTAL_GST + GT,GROSS_SALE=GROSS_SALE + GP,TOTAL_DISCOUNT=TOTAL_DISCOUNT + DS,NET_SALE=NET_SALE + NP,
           BALANCE=BALANCE + NP
           WHERE SALE_NO=SN;

           UPDATE client_master
           SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING + NP
           WHERE CLIENT_CODE=CLIENTCODE;
        END IF;
      END IF;

      IF FLAG = 0 THEN

         SELECT SALE_NO,ITEM_CODE,TOTAL_QUANTITY,SALE_PRICE,IGST,CGST,SGST,GST,GROSS_PRICE,DISCOUNT,NET_PRICE
         INTO SALENO,ITEMCODE,TOTALQUANTITY,SALEPRICE,I,C,S,G,GROSSPRICE,D,NETPRICE
         FROM sale_detail
         WHERE SERIAL_NO=SSN;

         IF SN <> SALENO THEN
            SIGNAL SALE_NO_ERROR;
         ELSEIF IC <> ITEMCODE THEN
            SIGNAL ITEM_CODE_ERROR;
         ELSEIF TQ  > (TOQU + TOTALQUANTITY) THEN
            SIGNAL TOTAL_QUANTITY_ERROR;
         ELSE
           UPDATE sale_detail
           SET SALE_NO=SN,SOLD_QUANTITY=SQ,FREE_QUANTITY=FQ,TOTAL_QUANTITY=TQ,SALE_RATE=SR,SALE_PRICE=SP,IGST=IG,CGST=CG,SGST=SG,
           GST=GT,GROSS_PRICE=GP,DISCOUNT=DS,NET_PRICE=NP
           WHERE SERIAL_NO=SSN;

           UPDATE stock_master
           SET TOTAL_QUANTITY=TOTAL_QUANTITY + TOTALQUANTITY - TQ
           WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;

           UPDATE sale_master
           SET TOTAL_SALE=TOTAL_SALE - SALEPRICE + SP,TOTAL_IGST=TOTAL_IGST - I + IG,TOTAL_CGST=TOTAL_CGST - C + CG,
           TOTAL_SGST=TOTAL_SGST - S + SG,TOTAL_GST=TOTAL_GST - G + GT,GROSS_SALE=GROSS_SALE - GROSSPRICE + GP,
           TOTAL_DISCOUNT=TOTAL_DISCOUNT - D + DS,NET_SALE=NET_SALE - NETPRICE + NP,BALANCE=BALANCE - NETPRICE + NP
           WHERE SALE_NO=SN;

           UPDATE client_master
           SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING - NETPRICE + NP
           WHERE CLIENT_CODE=CLIENTCODE;
         END IF;


      END IF;

      IF FLAG = 1 THEN
        UPDATE client_master
        SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING - NP
        WHERE CLIENT_CODE=CLIENTCODE;

        UPDATE sale_master
        SET TOTAL_SALE=TOTAL_SALE - SP,TOTAL_IGST=TOTAL_IGST - IG,TOTAL_CGST=TOTAL_CGST - CG,TOTAL_SGST=TOTAL_SGST - SG,
        TOTAL_GST=TOTAL_GST - GT,GROSS_SALE=GROSS_SALE - GP,TOTAL_DISCOUNT=TOTAL_DISCOUNT - DS,NET_SALE=NET_SALE - NP,
        BALANCE=BALANCE - NP
        WHERE SALE_NO=SN;

        UPDATE stock_master
        SET TOTAL_QUANTITY=TOTAL_QUANTITY + TQ
        WHERE ORGANIZATION_CODE=ORGANIZATIONCODE AND ITEM_CODE=IC;

        DELETE FROM sale_detail WHERE SERIAL_NO=SSN;
      END IF;
  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SALE_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SALE_MASTER_INSUPDEL`(
              IN SN VARCHAR(12),
              IN CC VARCHAR(12),
              IN OC VARCHAR(12),
              IN GA CHAR(1),
              IN SD DATETIME,
              IN TE DECIMAL(10,2),
              IN TI DECIMAL(8,2),
              IN TC DECIMAL(8,2),
              IN TS DECIMAL(8,2),
              IN TG DECIMAL(8,2),
              IN GS DECIMAL(10,2),
              IN TD DECIMAL(8,2),
              IN NS DECIMAL(10,2),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE SALENO VARCHAR(12);
    DECLARE INVOICENO VARCHAR(12);

    DECLARE CLIENTCODE VARCHAR(12);
    DECLARE ORGANIZATIONCODE VARCHAR(12);
    DECLARE BL DECIMAL(10,2);
    DECLARE CN CHAR(1);

	  DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE GST_APPLICABLE_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE SALE_DATE_ERROR CONDITION FOR SQLSTATE '99003';
    DECLARE CLIENT_CODE_ERROR CONDITION FOR SQLSTATE '99004';
    DECLARE ORGANIZATION_CODE_ERROR CONDITION FOR SQLSTATE '99005';
    DECLARE CANCELLED_ERROR CONDITION FOR SQLSTATE '99006';

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Invoice No Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR GST_APPLICABLE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For GST Applicable Are Y And N.';

    DECLARE CONTINUE HANDLER FOR SALE_DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Sale Date Should Not Be After Current Date.';

    DECLARE CONTINUE HANDLER FOR CLIENT_CODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Client Should Not Be Edited.';

    DECLARE CONTINUE HANDLER FOR ORGANIZATION_CODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Organization Should Not Be Edited.';

    DECLARE CONTINUE HANDLER FOR CANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Invoice Has Been Cancelled.';

    IF DATE(SD) > DATE(NOW()) THEN
      SIGNAL SALE_DATE_ERROR;
    ELSEIF UPPER(GA) NOT IN ('Y','N') THEN
      SIGNAL GST_APPLICABLE_ERROR;
    ELSE
  	  IF FLAG = -1 THEN
         SELECT ORGANIZATION_CODE INTO ORGANIZATIONCODE
         FROM client_master
         WHERE CLIENT_CODE=CC;

         SELECT GENERATE_PRIMARY_KEY('sale_master') INTO SALENO;

         SELECT GENERATE_INVOICE_NO(ORGANIZATIONCODE) INTO INVOICENO;

         INSERT INTO sale_master
         VALUES(SALENO,CC,OC,UPPER(GA),INVOICENO,SD,0,0,0,0,0,0,0,0,0,'N');
 	   END IF;

  	  IF FLAG = 0 THEN
        SELECT CLIENT_CODE,ORGANIZATION_CODE,BALANCE,CANCELLED
        INTO CLIENTCODE,ORGANIZATIONCODE,BL,CN
        FROM sale_master
        WHERE SALE_NO=SN;

        IF CC <> CLIENTCODE THEN
          SIGNAL CLIENT_CODE_ERROR;
        ELSEIF OC <> ORGANIZATIONCODE THEN
          SIGNAL ORGANIZATION_CODE_ERROR;
        ELSEIF UPPER(CN) IN ('Y') THEN
          SIGNAL CANCELLED_ERROR;
        ELSE
          UPDATE sale_master
		      SET CLIENT_CODE=CC,ORGANIZATION_CODE=OC,GST_APPLICABLE=UPPER(GA),SALE_DATE=SD,TOTAL_SALE=TE,TOTAL_IGST=TI,TOTAL_CGST=TC,TOTAL_SGST=TS,
          TOTAL_GST=TG,GROSS_SALE=GS,TOTAL_DISCOUNT=TD,NET_SALE=NS,BALANCE=BL
          WHERE SALE_NO=SN;
        END IF;
  	  END IF;

  	  IF FLAG = 1 THEN
         SELECT CANCELLED INTO CN
         FROM sale_master
         WHERE SALE_NO=SN;

         IF UPPER(CN) IN ('Y') THEN
           SIGNAL CANCELLED_ERROR;
        ELSE
           DELETE FROM sale_master WHERE SALE_NO=SN;
        END IF;
  	  END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SALE_RECEIPT_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SALE_RECEIPT_INSUPDEL`(
              IN RN VARCHAR(12),
              IN SN VARCHAR(12),
              IN RD DATETIME,
			        IN RA DECIMAL(10,2),
              IN RM VARCHAR(15),
              IN IO VARCHAR(20),
              IN ID VARCHAR(15),
              IN BN VARCHAR(15),
              IN BC VARCHAR(20),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE CLIENTCODE VARCHAR(12);
    DECLARE CN CHAR(1);

    DECLARE RECEIPTNO VARCHAR(12);

    DECLARE SALENO VARCHAR(12);
    DECLARE RECEIVEDAMOUNT DECIMAL(10,2);

    DECLARE CANCELLED_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE RECEIPT_DATE_ERROR CONDITION FOR SQLSTATE '99003';
    DECLARE RECEIPT_MODE_ERROR CONDITION FOR SQLSTATE '99004';
    DECLARE SALE_NO_ERROR CONDITION FOR SQLSTATE '99005';

    DECLARE CONTINUE HANDLER FOR CANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Invoice Has Been Cancelled.';

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Receipt Mode Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR RECEIPT_DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Receipt Date Should Not Be After Current Date.';

    DECLARE CONTINUE HANDLER FOR RECEIPT_MODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Receipt Mode Are:CASH,CHEQUE,DEMAND DRAFT,RTGS,NEFT,MONEY TRANSFER And ONLINE.';

    DECLARE CONTINUE HANDLER FOR SALE_NO_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Invoice No Should Not Be Edited.';

    SELECT CLIENT_CODE,CANCELLED
    INTO CLIENTCODE,CN
    FROM sale_master
    WHERE SALE_NO=SN;

    IF CN IN ('Y') THEN
      SIGNAL CANCELLED_ERROR;
    ELSEIF RM IN (' ','') THEN
      SIGNAL EMPTY_ERROR;
    ELSEIF DATE(RD) > DATE(NOW()) THEN
      SIGNAL RECEIPT_DATE_ERROR;
     ELSEIF UPPER(RM) NOT IN ('CASH','CHEQUE','DEMAND DRAFT','RTGS','NEFT','MONEY TRANSFER','ONLINE') THEN
      SIGNAL RECEIPT_MODE_ERROR;
    ELSE
  	  IF FLAG = -1 THEN
         SELECT GENERATE_PRIMARY_KEY('sale_receipt') INTO RECEIPTNO;

         INSERT INTO sale_receipt
         VALUES(RECEIPTNO,SN,RD,RA,UPPER(RM),IO,ID,BN,BC);

         UPDATE sale_master
         SET BALANCE=BALANCE - RA
         WHERE SALE_NO=SN;

         UPDATE client_master
         SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING - RA
         WHERE CLIENT_CODE=CLIENTCODE;
 	   END IF;

  	  IF FLAG = 0 THEN
        SELECT SALE_NO,RECEIVED_AMOUNT
        INTO SALENO,RECEIVEDAMOUNT
        FROM sale_receipt
        WHERE RECEIPT_NO=RN;

        IF SN <> SALENO THEN
          SIGNAL SALE_NO_ERROR;
        ELSE
		      UPDATE sale_receipt
		      SET SALE_NO=SN,RECEIPT_DATE=RD,RECEIVED_AMOUNT=RA,RECEIPT_MODE=UPPER(RM),INSTRUMENT_NO=IO,INSTRUMENT_DATE=ID,
          BANK_NAME=BN,BRANCH_NAME=BC
          WHERE RECEIPT_NO=RN;

          UPDATE sale_master
          SET BALANCE=BALANCE + RECEIVEDAMOUNT - RA
          WHERE SALE_NO=SN;

          UPDATE client_master
          SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING + RECEIVEDAMOUNT - RA
          WHERE CLIENT_CODE=CLIENTCODE;
        END IF;
  	  END IF;

  	  IF FLAG = 1 THEN
         UPDATE client_master
         SET TOTAL_OUTSTANDING=TOTAL_OUTSTANDING + RA
         WHERE CLIENT_CODE=CLIENTCODE;

         UPDATE sale_master
         SET BALANCE=BALANCE + RA
         WHERE SALE_NO=SN;

         DELETE FROM sale_receipt WHERE RECEIPT_NO=RN;
  	  END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure STATUTORY_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `STATUTORY_MASTER_INSUPDEL`(
              IN RU VARCHAR(100),
			        IN GI VARCHAR(25),
				      IN CP DECIMAL(4,2),
              IN SP DECIMAL(4,2),
              IN CN VARCHAR(100),
              IN FLN VARCHAR(100),
              IN FLE DATE,
              IN LLN VARCHAR(100),
              IN LLE DATE,
              IN EM VARCHAR(50),
              IN UL VARCHAR(50),
			        IN FLAG INTEGER(1)
              )
BEGIN

    DECLARE COUNTER INTEGER(1);
	  DECLARE NO_OF_ROW_ERROR CONDITION FOR SQLSTATE '99001';

    DECLARE CONTINUE HANDLER FOR NO_OF_ROW_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'There Can Be only One Row In Statutory Detail.';

  	IF FLAG = -1 THEN
      SELECT COUNT(*) INTO COUNTER
      FROM statutory_master;

      IF COUNTER > 0 THEN
        SIGNAL NO_OF_ROW_ERROR;
      ELSE
        INSERT INTO statutory_master
        VALUES(UPPER(RU),GI,CP,SP,CN,FLN,FLE,LLN,LLE,LOWER(EM),LOWER(UL));
      END IF;
 	 END IF;

  	IF FLAG = 0 THEN
		  UPDATE statutory_master
		  SET REGISTERED_USER=RU,GST_IN=GI,CGST_PORTION=CP,SGST_PORTION=SP,CONTACT_NO=CN,
      FOOD_LICENSE_NO=FLN,FOOD_LICENSE_EXPIRY=FLE,LABOUR_LICENSE_NO=LLN,LABOUR_LICENSE_EXPIRY=LLE,
      E_MAIL=LOWER(EM),URL=LOWER(UL);
  	END IF;

  	IF FLAG = 1 THEN
       DELETE FROM statutory_master;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure USER_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USER_MASTER_INSUPDEL`(
      IN UI VARCHAR(25),
			IN UN VARCHAR(50),
      IN OC VARCHAR(12),
      IN UT VARCHAR(25),
			IN PW VARCHAR(50),
      IN EM VARCHAR(50),
			IN RI VARCHAR(20),
			IN RD VARCHAR(25),
			IN FLAG INTEGER(1)

			)
BEGIN
	  DECLARE DATE_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE USER_TYPE_ERROR CONDITION FOR SQLSTATE '99003';

	  DECLARE CONTINUE HANDLER FOR DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Registration Date Should Not Be After Current Date.';

  	DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
  	RESIGNAL SET MESSAGE_TEXT = 'User Name,User Type,Password And Registering IP.';

  	DECLARE CONTINUE HANDLER FOR USER_TYPE_ERROR
  	RESIGNAL SET MESSAGE_TEXT = 'Valid Values For User Type Are:ADMINISTRATOR,EMPLOYEE,DEALER,CLIENT,GENERAL USER,OTHER.';

  	IF UN IN (' ','') OR UT IN (' ','') OR PW IN (' ','') OR RI IN (' ','') THEN
		  SIGNAL EMPTY_ERROR;
	  ELSEIF UPPER(UT) NOT IN  ('ADMINISTRATOR','EMPLOYEE','DEALER','CLIENT','GENERAL USER','OTHERS') THEN
      SIGNAL USER_TYPE_ERROR;
  	ELSEIF DATE(RD) > DATE(CURDATE()) THEN
		  SIGNAL DATE_ERROR;
	  ELSE
	    IF FLAG = -1 THEN
		    INSERT INTO user_master
		    VALUES(UI,UN,OC,UPPER(UT),PW,LOWER(EM),RI,RD);
	    END IF;

	    IF FLAG = 0 THEN
		    UPDATE user_master
		    SET USER_NAME=UN,ORGANIZATION_CODE=OC,USER_TYPE=UPPER(UT),PASSWORD=PW,E_MAIL=LOWER(EM),REGISTERING_IP=RI,
        REGISTRATION_DATE=RD
		    WHERE USER_ID=UI;
      END IF;

	    IF FLAG = 1 THEN
		    DELETE FROM user_master WHERE USER_ID=UI;
	    END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure VENDOR_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `tradewell_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `VENDOR_MASTER_INSUPDEL`(
              IN VC VARCHAR(12),
              IN OC VARCHAR(12),
			        IN VN VARCHAR(100),
              IN GA CHAR(1),
              IN GI VARCHAR(20),
              IN WS CHAR(1),
              IN AR VARCHAR(100),
              IN CT VARCHAR(50),
              IN PN INTEGER(6),
              IN CP VARCHAR(100),
              IN CO VARCHAR(11),
              IN EM VARCHAR(50),
              IN TU DECIMAL(12,2),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE VENDORCODE VARCHAR(12);
	  DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE GST_IN_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE GST_APPLICABLE_WITHIN_STATE_ERROR CONDITION FOR SQLSTATE '99003';

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Vendor Name & GST Applicable Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR GST_APPLICABLE_WITHIN_STATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For GST Applicable & Within State Are:Y & N.';

    DECLARE CONTINUE HANDLER FOR GST_IN_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'If GST Is Applicable Then GST IN Should Not Be Empty.If GST Is Not Applicable Then GST IN Should Be Empty';

    IF VN IN (' ','') OR GA IN (' ','') THEN
      SIGNAL EMPTY_ERROR;
    ELSEIF UPPER(GA) NOT IN ('Y','N') THEN
      SIGNAL GST_APPLICABLE_WITHIN_STATE_ERROR;
    ELSEIF UPPER(GA) IN ('Y') AND GI IS NULL THEN
      SIGNAL GST_IN_ERROR;
    ELSEIF UPPER(GA) IN ('N') AND GI IS NOT NULL THEN
      SIGNAL GST_IN_ERROR;
    ELSEIF UPPER(WS) NOT IN ('Y','N') THEN
      SIGNAL GST_APPLICABLE_WITHIN_STATE_ERROR;
    ELSE
  	  IF FLAG = -1 THEN
         SELECT GENERATE_PRIMARY_KEY('vendor_master') INTO VENDORCODE;

         INSERT INTO vendor_master
         VALUES(VENDORCODE,OC,UPPER(VN),UPPER(GA),GI,UPPER(WS),AR,CT,PN,UPPER(CP),CT,LOWER(EM),TU);
 	   END IF;

  	  IF FLAG = 0 THEN
         UPDATE vendor_master
         SET ORGANIZATION_CODE=OC,VENDOR_NAME=UPPER(VN),GST_APPLICABLE=UPPER(GA),GST_IN=GI,
         WITHIN_STATE=UPPER(WS),ADDRESS=AR,CITY=CT,PIN=PN,CONTACT_PERSON=UPPER(CP),CONTACT_NO=CO,E_MAIL=LOWER(EM),
         TOTAL_OUTSTANDING=TU
         WHERE VENDOR_CODE=VC;
  	  END IF;

  	  IF FLAG = 1 THEN
         DELETE FROM vendor_master WHERE VENDOR_CODE=VC;
  	  END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `tradewell_data`.`stock_master_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tradewell_data`.`stock_master_view`;
USE `tradewell_data`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`rayobeve`@`localhost` SQL SECURITY DEFINER VIEW `tradewell_data`.`stock_master_view` AS select `tradewell_data`.`stock_master`.`ORGANIZATION_CODE` AS `ORGANIZATION_CODE`,`tradewell_data`.`organization_master`.`ORGANIZATION_NAME` AS `ORGANIZATION_NAME`,`tradewell_data`.`stock_master`.`ITEM_CODE` AS `ITEM_CODE`,`tradewell_data`.`stock_master`.`ITEM_NAME` AS `ITEM_NAME`,concat(`tradewell_data`.`stock_master`.`TOTAL_QUANTITY`,' ',`tradewell_data`.`item_master`.`PRIMARY_UOM`) AS `PRIMARY_QUANTITY`,concat((`tradewell_data`.`stock_master`.`TOTAL_QUANTITY` * `tradewell_data`.`item_master`.`SECONDARY_CONVERSION`),' ',`tradewell_data`.`item_master`.`SECONDARY_UOM`) AS `SECONDARY_QUANTITY`,concat((`tradewell_data`.`stock_master`.`TOTAL_QUANTITY` * `tradewell_data`.`item_master`.`TERTIARY_CONVERSION`),' ',`tradewell_data`.`item_master`.`TERTIARY_UOM`) AS `TERTIARY_QUANTITY` from ((`tradewell_data`.`stock_master` join `tradewell_data`.`organization_master`) join `tradewell_data`.`item_master`) where ((`tradewell_data`.`item_master`.`ITEM_CODE` = `tradewell_data`.`stock_master`.`ITEM_CODE`) and (`tradewell_data`.`stock_master`.`ORGANIZATION_CODE` = `tradewell_data`.`organization_master`.`ORGANIZATION_CODE`)) group by `tradewell_data`.`stock_master`.`ORGANIZATION_CODE`,`tradewell_data`.`stock_master`.`ITEM_CODE`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
