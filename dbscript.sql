# sqlprocedures
SQL stored procedures for UNC Charlotte healthcare portal.

-- project in progress, on-going
-- db creation script
-- by rohan khairnar

-- concept tables as follows:
-- User( UID, fname, lname, dob, InsID , AddID)/
-- patient( PID, UID)/
-- doctor(DID, UID, Speciality, Fee, AID)/
-- prescribtions(PID, Pname, Pcost)/
-- Appointment( AID, PID, DID, Datetime)/
-- Test(TID, Tname, Tcost)/
-- Bill(BID, PaID, DID, RID, TID, PrID, DateTime, InsID, FinalCost)/
-- Payment(PyID, type, Datetime, cost)
-- Recep(RID, UID, ShiftStart, Shiftend)/
-- Insurance(IID, Itype, Istart, Iend)/
-- Address(AID, Ad1, Ad2)/
-- speciality-- /

-- starts here

CREATE SCHEMA IF NOT EXISTS `applied` DEFAULT CHARACTER SET utf8 ;
USE `applied` ;

CREATE TABLE IF NOT EXISTS `applied`.`address` (
  `AddressID` VARCHAR(20) NOT NULL,
  `fline` VARCHAR(40) NOT NULL,
  `lline` VARCHAR(40) NULL DEFAULT NULL,
  `zip` VARCHAR(10) NOT NULL,
  `city` DATE NOT NULL,
  `State` INT(11) NULL DEFAULT NULL,
  `Contactno` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`AddressID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`insurance` (
  `InsID` VARCHAR(20) NOT NULL,
  `sdate` DATE NOT NULL,
  `edate` DATE NOT NULL,
  `type` VARCHAR(10) NOT NULL,
	PRIMARY KEY (`InsID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`user` (
  `UID` VARCHAR(20) NOT NULL,
  `fname` VARCHAR(40) NULL DEFAULT NULL,
  `lname` VARCHAR(40) NULL DEFAULT NULL,
  `Gender` VARCHAR(10) NULL DEFAULT NULL,
  `DOB` DATE NULL DEFAULT NULL,
  `AddressID` VARCHAR(40) NOT NULL,
  `InsID` VARCHAR(40) NOT NULL,
	PRIMARY KEY (`UID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE IF NOT EXISTS `applied`.`patient` (
  `PatID` VARCHAR(20) NOT NULL,
  `UserID` VARCHAR(20) NOT NULL,
	PRIMARY KEY (`PatID`),
    INDEX `fk_UserID_idx`(`UserID` ASC),
    constraint `fk_UserID`
    foreign key (`UserID`)
    references `applied`.`user`(`UID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`speciality` (
  `SID` VARCHAR(20) NOT NULL,
  `Spname` VARCHAR(20) NOT NULL,
	PRIMARY KEY (`SID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`doctor` (
  `DID` VARCHAR(20) NOT NULL,
  `UserID` VARCHAR(20) NOT NULL,
  `SpID` VARCHAR(20) NOT NULL,
  `fee` INT NOT NULL,
	PRIMARY KEY (`DID`),
    INDEX `fk_UserID_doc_idx`(`UserID` ASC),
    INDEX `fk_SpID_doc_idx`(`SpID` ASC),
    constraint `fk_UserID_doc`
    foreign key (`UserID`)
    references user(`UID`),
    constraint `fk_SpID_doc`
    foreign key (`SpID`)
    references speciality(`SID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`appointment` (
  `AID` VARCHAR(20) NOT NULL,
  `UserID` VARCHAR(20) NOT NULL,
  `DocID` VARCHAR(20) NOT NULL,
  `adate` DATE NOT NULL,
	PRIMARY KEY (`AID`),
    INDEX `fk_UserID_app_idx`(`UserID` ASC),
    INDEX `fk_DocID_app_idx`(`DocID` ASC),
    constraint `fk_UserID_app`
    foreign key (`UserID`)
    references user(`UID`),
    constraint `fk_DocID_app`
    foreign key (`DocID`)
    references doctor(`DID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`reciptionist` (
  `recpID` VARCHAR(20) NOT NULL,
  `UserID` VARCHAR(20) NOT NULL,
  `sshift` DATE NOT NULL,
  `eshift` DATE NOT NULL,
	PRIMARY KEY (`recpID`),
    INDEX `fk_UserID_rec_idx`(`UserID` ASC),
    constraint 	`fk_UserID_rec`
    foreign key (`UserID`)
    references user(`UID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`prescribtions` (
  `PrID` VARCHAR(20) NOT NULL,
  `Pname` VARCHAR(20),
  `Pcost` INT NOT NULL,
	PRIMARY KEY (`PrID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`tests` (
  `TestID` VARCHAR(20) NOT NULL,
  `Tname` VARCHAR(20),
  `Tcost` INT NOT NULL,
	PRIMARY KEY (`TestID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`bill` (
  `BillID` VARCHAR(20) NOT NULL,
  `PaID` VARCHAR(20) NOT NULL,
  `DocID` VARCHAR(20) NOT NULL,
  `RecpID` VARCHAR(20) NOT NULL,
  `TestID` VARCHAR(20) NOT NULL,
  `PrID` VARCHAR(20) NOT NULL,
  `InID` VARCHAR(20) NOT NULL,
  `bdate` DATE NOT NULL,
  `amount` INT NOT NULL,
  INDEX `fk_PaID_bil_idx`(`PaID` ASC),
  INDEX `fk_DocID_bil_idx`(`DocID` ASC),
  INDEX `fk_RecpID_bil_idx`(`RecpID` ASC),
  INDEX `fk_TestID_bil_idx`(`TestID` ASC),
  INDEX `fk_PrID_bil_idx`(`PrID` ASC),
  INDEX `fk_InID_bil_idx`(`InID` ASC),
	PRIMARY KEY (`BillID`),
    constraint `fk_PaID_bil`
    foreign key (`PaID`)
    references patient(`PatID`),
    constraint `fk_DocID_bil`
    foreign key (`DocID`)
    references doctor(`DID`),
    constraint `fk_RecpID_bil`
    foreign key (`RecpID`)
    references reciptionist(`recpID`),
    constraint `fk_TestID_bil`
    foreign key (`TestID`)
    references tests(`TestID`),
    constraint `fk_PrID_bil`
    foreign key (`PrID`)
    references prescribtions(`PrID`),
    constraint `fk_InID_bil`
    foreign key (`InID`)
    references insurance(`InsID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `applied`.`payment` (
  `payID` VARCHAR(20) NOT NULL,
  `billID` VARCHAR(20) NOT NULL,
  `type` VARCHAR(20),
  `pdate` DATE NOT NULL,
  `cost` INT NOT NULL,
	PRIMARY KEY (`payID`),
    INDEX `fk_billID_pay_idx`(`billID` ASC),
    constraint `fk_billID_pay`
    foreign key (`billID`)
    references bill(`BillID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


