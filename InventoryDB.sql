CREATE DATABASE InventoryDB;
USE InventoryDB;

CREATE TABLE Location (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    LocationName VARCHAR(50) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    Country VARCHAR(50) NOT NULL
);
CREATE TABLE CostCode (
    CostCodeID INT AUTO_INCREMENT PRIMARY KEY,
    CodeCodeName VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Business VARCHAR(50)
);
CREATE TABLE TaxRates (
    TaxID INT AUTO_INCREMENT PRIMARY KEY,
    TaxName VARCHAR(20) NOT NULL,
    Decription VARCHAR(50) NOT NULL,
    TaxRate DECIMAL(7, 4) NOT NULL,
    Notes TEXT
);
CREATE TABLE Currency (
    CurrencyID INT AUTO_INCREMENT PRIMARY KEY,
    CurrencyName VARCHAR(5) NOT NULL,
    SwiftCode VARCHAR(11) NOT NULL,
    ExchangeRate DECIMAL(10, 4) NOT NULL
);
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserCode VARCHAR(50) NOT NULL,
    UserName VARCHAR(50) NOT NULL,
    HRID VARCHAR(50) NOT NULL, -- ID Provided by HR, not auto generated
    CostCodeID INT NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Department VARCHAR(50),
    LocationID INT NOT NULL,
    StartDate DATE,
    TermDate DATE,
    FOREIGN KEY (CostCodeID) REFERENCES CostCode(CostCodeID),
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);
CREATE TABLE Vendor (
    VendorID INT AUTO_INCREMENT PRIMARY KEY,
    VendorName VARCHAR(50) NOT NULL,
    VendorType VARCHAR(20),
    VendorContact VARCHAR(20),
    VendorEmail VARCHAR (50),
    VendorPhone VARCHAR(15)
);
CREATE TABLE Accounts (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    AccountNumber VARCHAR(50) NOT NULL,
    VendorID INT NOT NULL,
    Descriptions TEXT NOT NULL, -- Description is keyword
    BillingAccountID INT UNIQUE NOT NULL, -- NOT BEING REFERENCED
    BillingCycle ENUM('Monthly', 'Quarterly', 'Semi-Annually', 'Annually') NOT NULL, -- Pre-defined billingcycle
    TaxRateID INT NOT NULL,
    ClosedDate DATE,
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
    FOREIGN KEY (TaxRateID) REFERENCES TaxRates(TaxID)
);
CREATE TABLE Contract (
    ContractID INT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT NOT NULL,
    ContractCode VARCHAR(100) NOT NULL,
    Descriptions TEXT NOT NULL, -- Description is a keyword
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CancellationPeriod INT NOT NULL,
    AutoRenew BOOLEAN DEFAULT FALSE,
    EverGreen BOOLEAN DEFAULT FALSE, -- In perpetuity
    FileAttachment MEDIUMBLOB, -- Hyperlink instead
    Notes TEXT,
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);
CREATE TABLE Service (
    ServiceID INT AUTO_INCREMENT PRIMARY KEY,
    ServiceCode VARCHAR(50) NOT NULL,
    ServiceName VARCHAR(255) NOT NULL,
    VendorID INT NOT NULL,
    AccountID INT NOT NULL,
    ContractID INT NOT NULL,
    Platform VARCHAR(100),
    Notes TEXT,
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID)
);
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ContractID INT NOT NULL,
    Platform VARCHAR(255) NOT NULL,
    BillingAccountID INT NOT NULL,
    UserID INT NOT NULL,
    State ENUM('Active', 'Add-Req', 'Cancelled', 'Canx-Req', 'Del-Req', 'N/C') NOT NULL, -- Pre-defined
    Spare BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID),
    FOREIGN KEY (BillingAccountsID) REFERENCES Accounts(BillingAccountID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
