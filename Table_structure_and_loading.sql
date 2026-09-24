

USE berka_financial;
drop table account;
CREATE TABLE account (
    account_id INT PRIMARY KEY,
    district_id INT,
    frequency VARCHAR(25),
    date DATE,
    foreign key (district_id) references district(district_id)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/account.csv'
INTO TABLE account
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table loan;
CREATE TABLE loan (
    loan_id INT PRIMARY KEY,
    account_id INT,
    date DATE,
    amount INT,
    duration INT,
    payments INT,
    status VARCHAR(1),
    foreign key (account_id) references account(account_id)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loan.csv'
INTO TABLE loan
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
select count(*) from loan;
drop table trans;
CREATE TABLE trans (
    trans_id INT PRIMARY KEY,
    account_id INT,
    date DATE,
    type VARCHAR(25),
    operation VARCHAR(100),
    amount INT,
    balance INT,
    k_symbol VARCHAR(100),
    bank VARCHAR(10),
    account INT,
     foreign key (account_id) references account(account_id)
    );
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trans_full.csv'
INTO TABLE trans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    trans_id,
    account_id,
    @date_var,
    type,
    operation,
    amount,
    balance,
    k_symbol,
    bank,
    @account_var
)
SET
    date = STR_TO_DATE(@date_var, '%Y-%m-%d'),
    account = NULLIF(NULLIF(TRIM(@account_var), ''), 'NULL');
drop table orders ;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    account_id INT,
    bank_to VARCHAR(2),
    account_to BIGINT,
    amount DECIMAL(10,2),
    k_symbol VARCHAR(20),
     foreign key (account_id) references account(account_id)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
drop table district;
CREATE TABLE district (
    district_id INT PRIMARY KEY,
    A2 VARCHAR(50),
    A3 VARCHAR(30),
    A4 INT,
    A5 INT,
    A6 INT,
    A7 INT,
    A8 INT,
    A9 INT,
    A10 DECIMAL(5,1),
    A11 INT,
    A12 DECIMAL(5,1),
    A13 DECIMAL(5,2),
    A14 INT,
    A15 INT,
    A16 INT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/district.csv'
INTO TABLE district
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table disp;
CREATE TABLE disp (
    disp_id INT PRIMARY KEY,
    client_id INT,
    account_id INT,
    type VARCHAR(20),foreign key (client_id) REFERENCES client(client_id),
    foreign key (account_id) REFERENCES account(account_id)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/disp.csv'
INTO TABLE disp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
drop table client;
CREATE TABLE client (
    client_id INT PRIMARY KEY,
    gender VARCHAR(1),
    birth_date DATE,
    district_id INT,
    foreign key (district_id) references district(district_id)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/client.csv'
INTO TABLE client
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
 table client;
 drop table card;
CREATE TABLE card (
    card_id INT PRIMARY KEY,
    disp_id INT,
    type VARCHAR(20),
    issued DATE,
     foreign key (disp_id) references disp(disp_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/card.csv'
INTO TABLE card
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;






















