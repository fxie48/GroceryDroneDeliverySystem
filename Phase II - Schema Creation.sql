-- CS4400: Introduction to Database Systems
-- Spring 2021
-- Phase II Create Table and Insert Statements Template

-- Team 63
-- Neo Pak (npak9)
-- Felice Xie (fxie48)
-- Catherine Wang (cwang724)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission

DROP DATABASE IF EXISTS PhaseII;
CREATE DATABASE PhaseII;
USE PhaseII;

-- CREATE TABLE STATEMENTS BELOW

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
	username varchar(20) NOT NULL,
    pass varchar(10) NOT NULL,
    fname varchar(20) NOT NULL,
	lname varchar(20) NOT NULL,
    street varchar(30) NOT NULL,
    city varchar(30) NOT NULL,
    state char(2) NOT NULL,
    zip int NOT NULL,
    PRIMARY KEY (username)
);

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
	ccNumber BIGINT NOT NULL,
    username VARCHAR(20) NOT NULL,
    CVV INT NOT NULL,
    expDate CHAR(5) NOT NULL,
    PRIMARY KEY (ccNumber),
    FOREIGN KEY (username) REFERENCES Users(username)
);

DROP TABLE IF EXISTS Admins;
CREATE TABLE Admins (
	username VARCHAR(20) NOT NULL PRIMARY KEY,
    FOREIGN KEY (username) REFERENCES Users(username)
);

DROP TABLE IF EXISTS Chains;
CREATE TABLE Chains (
  chain_name varchar(15) NOT NULL,
  PRIMARY KEY (chain_name)
);

DROP TABLE IF EXISTS Store;
CREATE TABLE Store (
	chain_name varchar(15) NOT NULL,
    store_name varchar(20) NOT NULL,
    street varchar(30) NOT NULL,
    city varchar(30) NOT NULL,
    state char(2) NOT NULL,
    zip int NOT NULL,
    PRIMARY KEY (store_name, chain_name),
    FOREIGN KEY (chain_name) REFERENCES Chains(chain_name)
);

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
	emp_username VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (emp_username) REFERENCES Users(username)
);

DROP TABLE IF EXISTS Manager;
CREATE TABLE Manager (
	emp_username VARCHAR(20) PRIMARY KEY,
    manages VARCHAR(15) NOT NULL,
    FOREIGN KEY (emp_username) REFERENCES Employee(emp_username),
    FOREIGN KEY (manages) REFERENCES Chains(chain_name)
);

DROP TABLE IF EXISTS Drone_Technician;
CREATE TABLE Drone_Technician (
	emp_username VARCHAR(20) NOT NULL PRIMARY KEY,
    works_at_store VARCHAR(20) NOT NULL,
    works_at_chain VARCHAR(20) NOT NULL,
    FOREIGN KEY (emp_username) REFERENCES Employee(emp_username),
    FOREIGN KEY (works_at_store) REFERENCES Store(store_name),
    FOREIGN KEY (works_at_chain) REFERENCES Chains(chain_name)
);

DROP TABLE IF EXISTS Drone;
CREATE TABLE Drone (
	drone_ID INT,
    drone_status VARCHAR(15) NOT NULL,
    zip INT NOT NULL,
    radius INT NOT NULL,
    worked_on_by VARCHAR(20) NOT NULL,
    PRIMARY KEY (drone_ID),
    FOREIGN KEY (worked_on_by) REFERENCES Drone_Technician(emp_username)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
	order_ID INT NOT NULL,
	order_status VARCHAR(15) NOT NULL,
    date_ordered DATE NOT NULL,
    made_by BIGINT NOT NULL,
    delivered_by INT,
    PRIMARY KEY (order_ID),
    FOREIGN KEY (made_by) REFERENCES Customer(ccNumber),
    FOREIGN KEY (delivered_by) REFERENCES Drone(drone_ID)
);

DROP TABLE IF EXISTS Item;
CREATE TABLE Item (
	item_name varchar(30) NOT NULL,
    item_type varchar(20) NOT NULL,
    origin varchar(20) NOT NULL,
    organic varchar(3) NOT NULL,
    PRIMARY KEY (item_name)
);

DROP TABLE IF EXISTS Chain_Item;
CREATE TABLE Chain_Item (
	item_name varchar(30) NOT NULL,
    chain_name varchar(15) NOT NULL,
    PLU_Number INT NOT NULL,
    order_limit INT NOT NULL,
    quantity INT NOT NULL,
    price FLOAT NOT NULL,
    PRIMARY KEY (item_name, chain_name, PLU_Number),
    FOREIGN KEY (item_name) REFERENCES Item(item_name),
    FOREIGN KEY (chain_name) REFERENCES Chains(chain_name)
);

DROP TABLE IF EXISTS Contain;
CREATE TABLE Contain (
	order_id INT,
    item_name VARCHAR(30),
	chain_name VARCHAR(15),
    PLU_Number INT,
    chain_item_quantity INT NOT NULL,
    PRIMARY KEY (order_id, PLU_Number, item_name, chain_name),
    FOREIGN KEY (order_id) REFERENCES Orders(order_ID),
    FOREIGN KEY (item_name, chain_name, PLU_Number) REFERENCES Chain_Item(item_name, chain_name, PLU_Number)
);

-- INSERT STATEMENTS BELOW
INSERT INTO Users VALUES
("mmoss7", "password2", "Mark", "Moss", "15 Tech Lane", "Duluth", "GA", 30047),
("lchen27", "password3", "Liang", "Chen", "40 Walker Rd", "Kennesaw", "GA", 30144),
("jhilborn97", "password4", "Jack", "Hilborn", "1777 W Beaverdam Rd", "Atlanta", "GA", 30303),
("jhilborn98", "password5", "Jake", "Hilborn", "4605 Nasa Pkwy", "Atlanta", "GA", 30309),
("ygao10", "password6", "Yuan", "Gao", "27 Paisley Dr SW", "Atlanta", "GA", 30313),
("kfrog03", "password7", "Kermit", "Frog", "707 E Norfolk Ave", "Atlanta", "GA", 30318),
("cforte58", "password8", "Connor", "Forte", "13817 Shirley Ct NE", "Atlanta", "GA", 30332),
("fdavenport49", "password9", "Felicia", "Davenport", "6150 Old Millersport Rd NE", "College Park", "GA", 30339),
("hliu88", "password10", "Hang", "Liu", "1855 Fruit St", "Atlanta", "GA", 30363),
("akarev16", "password11", "Alex", "Karev", "100 NW 73rd Pl", "Johns Creek", "GA", 30022),
("jdoe381", "password12", "Jane", "Doe", "12602 Gradwell St", "Duluth", "GA", 30047),
("sstrange11", "password13", "Stephen", "Strange", "112 Huron Dr", "Kennesaw", "GA", 30144),
("dmcstuffins7","password14","Doc","Mcstuffins","27 Elio Cir","Atlanta","GA",30303),
("mgrey91","password15","Meredith","Grey","500 N Stanwick Rd","Atlanta","GA",30309),
("pwallace51","password16","Penny","Wallace","3127 Westwood Dr NW","Atlanta","GA",30313),
("jrosario34","password17","Jon","Rosario","1111 Catherine St","Atlanta","GA",30318),
("nshea230","password18","Nicholas","Shea","299 Shady Ln","Atlanta","GA",30332),
("mgeller3","password19","Monica", "Geller","120 Stanley St","College Park","GA",30339),
("rgeller9","password20","Ross","Geller" ,"4206 106th Pl NE","Atlanta","GA",30363),
("jtribbiani27","password21","Joey" ,"Tribbiani","143 Pebble Ln","Johns Creek","GA",30022),
("pbuffay56","password22","Phoebe","Buffay","230 County Rd","Duluth","GA",30047),
("rgreen97","password23","Rachel","Green","40 Frenchburg Ct","Kennesaw","GA",30144),
("cbing101","password24","Chandler" ,"Bing","204 S Mapletree Ln","Atlanta","GA",30303),
("pbeesly61", "password25",	"Pamela", "Beesly",	"932 Outlaw Bridge Rd",	"Atlanta", "GA", 30309),
("jhalpert75", "password26", "Jim", "Halpert","185 Dry Creek Rd", "Atlanta", "GA", 30313),
("dschrute18", "password27"	,"Dwight", 	"Schrute", "3009 Miller Ridge Ln", "Atlanta", "GA",	30318),
("amartin365",	"password28","Angela", "Martin", "905 E Pinecrest Cir",	"Atlanta", "GA", 30332),
("omartinez13",	"password29", "Oscar", "Martinez", "26958 Springcreek Rd", "College Park", "GA",30339),
("mscott845", "password30",	"Michael", 	"Scott", "105 Calusa Lake Dr", "Denver", "CO", 80014),
("abernard224",	"password31", "Andy", "Bernard", "21788 Monroe Rd #284", "Johns Creek", "GA",30022),
("kkapoor155", "password32", "Kelly", "Kapoor",	"100 Forest Point Dr", "Duluth", "GA", 30047),
("dphilbin81", "password33", "Darryl", 	"Philbin",	"800 Washington St", "Kennesaw", "GA", 30144),
("sthefirst1", "password34", "Sofia", "Thefirst", "4337 Village Creek Dr", "Atlanta", "GA", 30303),
("gburdell1", "password35", "George", "Burdell", "201 N Blossom St", "Atlanta",	"GA", 30309),
("dsmith102", "password36",	"Dani",	"Smith", "1648 Polk Rd", "Atlanta",	"GA", 30313),
("dbrown85", "password37", "David",	"Brown", "12831 Yorba Ave",	"Atlanta", "GA", 30318),
("dkim99", "password38", "Dave", "Kim",	"1710 Buckner Rd", "Atlanta", "GA", 303320),
("tlee984",	"password39", "Tom", "Lee",	"205 Mountain Ave", "College Park",	"GA", 30339),
("jpark29",	"password40", "Jerry", "Park", "520 Burberry Way", "Atlanta", "GA", 30363),
("vneal101", "password41",	"Vinay", "Neal", "190 Drumar Ct", "Johns Creek", "GA", 30022),
("hpeterson55", "password42", "Haydn", "Peterson", "878 Grand Ivey Pl",	"Duluth", "GA", 30047),
("lpiper20", "password43", "Leroy",	"Piper", "262 Stonecliffe Aisle", "Kennesaw", "GA",	30144),
("mbob2", "password44", "Chuck", "Bass", "505 Bridge St", "New York", "NY", 10033),
("mrees785", "password45", "Marie", "Rees", "1081 Florida Ln", "Atlanta", "GA",	30309),
("wbryant23", "password46",	"William", "Bryant", "109 Maple St", "Atlanta", "GA", 30313),
("aallman302", "password47", "Aiysha:",	"Allman", "420 Austerlitz Rd", "Atlanta", "GA",	30318),
("kweston85", "password48", "Kyle", "Weston", "100 Palace Dr", "Birmingham", "AL", 35011),
("lknope98", "password49", "Leslie", "Knope", "10 Dogwood Ln", "College Park", "GA", 30339),
("bwaldorf18", "password50", "Blair", "Waldorf", "1110 Greenway Dr", "Atlanta", "GA", 30363);

INSERT INTO Customer Values
(6518555974461663, "mscott845", 551, "2/24"),
(2328567043101965, "abernard224", 644, "5/24"),
(8387952398279291, "kkapoor155", 201, "2/31"),
(6558859698525299, "dphilbin81", 102, "12/31"),
(3414755937212479, "sthefirst1", 489, "11/21"),
(5317121090872666, "gburdell1", 852, "1/22"),
(9383321241981836, "dsmith102", 455, "8/29"),
(3110266979495605, "dbrown85", 744, "10/22"),
(2272355540784744, "dkim99", 606, "8/29"),
(9276763978834273, "tlee984", 862, "8/31"),
(4652372688643798, "jpark29", 258, "12/30"),
(5478842044367471, "vneal101", 857, "9/29"),
(3616897712963372, "hpeterson55", 295, "4/23"),
(9954569863556952, "lpiper20", 794, "4/22"),
(7580327437245356, "mbob2", 269, "5/27"),
(7907351371614248, "mrees785", 858, "8/27"),
(1804206278259689, "wbryant23", 434, "4/30"),
(2254788788633807, "aallman302", 862, "4/21"),
(8445858521381374, "kweston85", 632, "11/30"),
(1440229259624450, "lknope98", 140, "4/31"),
(5839267386001880, "bwaldorf18", 108, "12/29");

INSERT INTO Chains VALUES
("Moss Market"),
("Publix"),
("Whole Foods"),
("Sprouts"),
("Query Mart"),
("Kroger"),
("Trader Joe's"),
("Wal Mart");

INSERT INTO Store VALUES
("Sprouts", "Abbots Bridge", "116 Bell Rd", "Johns Creek", "GA", 30022),
("Whole Foods", "North Point", "532 8th St NW", "Johns Creek", "GA", 30022),
("Kroger", "Norcross", "650 Singleton Road", "Duluth", "GA", 30047),
("Wal Mart", "Pleasant Hill", "2365 Pleasant Hill Rd", "Duluth", "GA", 30047),
("Moss Market", "KSU Center", "3305 Busbee Drive NW", "Kennesaw", "GA", 30144),
("Trader Joe's", "Owl Circle", "48 Owl Circle SW", "Kennesaw", "GA", 30144),
("Publix", "Park Place", "10 Park Place South SE", "Atlanta", "GA", 30303),
("Publix", "The Plaza Midtown", "950 W Peachtree St NW", "Atlanta", "GA", 30309),
("Query Mart", "GT Center", "172 6th St NW", "Atlanta", "GA", 30313),
("Whole Foods", "North Avenue",	"120 North Avenue NW", "Atlanta", "GA", 30313),
("Sprouts", "Piedmont", "564 Piedmont ave NW", "Atlanta", "GA", 30318),
("Kroger", "Midtown", "725 Ponce De Leon Ave",	"Atlanta",	"GA",	30332),
("Moss Market", "Tech Square", "740 Ferst Drive", "Atlanta", "GA", 30332),
("Moss Market", "Bobby Dodd", "150 Bobby Dodd Way NW", "Atlanta", "GA", 30332),
("Query Mart", "Tech Square", "280 Ferst Drive NW", "Atlanta", "GA", 30332),
("Moss Market", "College Park", "1895 Phoenix Blvd", "College Park", "GA", 30339),
("Publix", "Atlanta Station", "595 Piedmot Ave NE", "Atlanta ", "GA", 30363);

INSERT INTO Employee VALUES
('lchen27'),
('jhilborn97'),
('jhilborn98'),
('ygao10'),
('kfrog03'),
('cforte58'),
('fdavenport49'),
('hliu88'),
('akarev16'),
('jdoe381'),
('sstrange11'),
('dmcstuffins7'),
('mgrey91'),
('pwallace51'),
('jrosario34'),
('nshea230'),
('mgeller3'),
('rgeller9'),
('jtribbiani27'),
('pbuffay56'),
('rgreen97'),
('cbing101'),
('pbeesly61'),
('jhalpert75'),
('dschrute18'),
('amartin365'),
('omartinez13');

INSERT INTO Manager VALUES
("rgreen97", "Kroger"),
("cbing101", "Publix"),
("pbeesly61", "Wal Mart"),
("jhalpert75", "Trader Joe's"),
("dschrute18", "Whole Foods"),
("amartin365", "Sprouts"),
("omartinez13", "Query Mart");

INSERT INTO Drone_Technician VALUES
("lchen27", "KSU Center", "Moss Market"),
("jhilborn97", "Park Place", "Publix"),
("jhilborn98", "The Plaza Midtown", "Publix"),
("ygao10", "North Avenue", "Whole Foods"),
("kfrog03", "Piedmont", "Sprouts"),
("cforte58", "Tech Square", "Query Mart"),
("fdavenport49", "College Park", "Moss Market"),
("hliu88", "Atlanta Station", "Publix"),
("akarev16", "North Point", "Whole Foods"),
("jdoe381", "Norcross", "Kroger"),
("sstrange11", "Owl Circle", "Trader Joe's"),
("dmcstuffins7", "Park Place", "Publix"),
("mgrey91", "The Plaza Midtown", "Publix"),
("pwallace51", "GT Center", "Query Mart"),
("jrosario34", "Piedmont", "Sprouts"),
("nshea230", "Midtown", "Kroger"),
("mgeller3", "College Park", "Moss Market"),
("rgeller9", "Atlanta Station", "Publix"),
("jtribbiani27", "Abbots Bridge", "Sprouts"),
("pbuffay56", "Pleasant Hill", "Wal Mart");

INSERT INTO Drone VALUES
(103,"Available",30144,3, "lchen27"),
(114,"Available",30303,8, "jhilborn97"),
(105,"Available",30309,4, "jhilborn98"),
(106,"Available",30313,6, "ygao10"),
(117,"Available",30318,9, "kfrog03"),
(118,"Available",30332,5, "cforte58"),
(109,"Available",30339,5, "fdavenport49"),
(110,"Available",30363,5, "hliu88"),
(111,"Busy",30022,5, "akarev16"),
(102,"Available",30047,7, "jdoe381"),
(113,"Available",30144,6, "sstrange11"),
(104,"Busy",30303,8, "dmcstuffins7"),
(115,"Available",30309,7, "mgrey91"),
(116,"Available",30313,3, "pwallace51"),
(107,"Available",30318,8, "jrosario34"),
(108,"Available",30332,7, "nshea230"),
(119,"Available",30339,7, "mgeller3"),
(120,"Available",30363,7, "rgeller9"),
(101,"Available",30022,5, "jtribbiani27"),
(112,"Busy",30047,6, "pbuffay56");

INSERT INTO Orders VALUES
(10001,"Delivered", '2021-01-03', 3616897712963372, 102),
(10002,"Delivered", '2021-01-13', 2328567043101965, 111),
(10003,"Delivered", '2021-01-13', 3110266979495605, 117),
(10004,"Delivered", '2021-01-16', 2272355540784744, 108),
(10005,"Delivered", '2021-01-21', 6558859698525299, 103),
(10006,"Delivered", '2021-01-22', 3414755937212479, 104),
(10007,"Delivered", '2021-01-22', 3414755937212479, 104),
(10008,"Delivered",'2021-01-28', 1804206278259689, 116),
(10009,"Delivered",'2021-02-01', 3616897712963372, 112),
(10010,"Delivered",'2021-02-04', 8387952398279291, 112),
(10011,"Delivered",'2021-02-05', 2254788788633807, 117),
(10012,"In Transit",'2021-02-14', 5478842044367471, 111),
(10013,"In Transit",'2021-02-14', 3414755937212479, 104),
(10014,"Drone Assigned",'2021-02-14', 3616897712963372, 112),
(10015,"Pending",'2021-02-24', 9954569863556952, NULL);

INSERT INTO Item VALUES
("2% Milk",	"Dairy", "Georgia", "Yes"),
("4-1 Shampoo",	"Personal Care", "Michigan","No"),
("Almond Milk",	"Dairy", "Georgia",	"No"),
("Apple Juice",	"Beverages", "Missouri", "Yes"),
("Baby Food", "Produce", "Georgia", "Yes"),
("Baby Shampoo", "Personal Care", "Michigan", "Yes"),
("Bagels", "Bakery", "Georgia", "No"),
("Bamboo Brush", "Personal Care", "Louisiana", "Yes"),
("Bamboo Comb",	"Personal Care", "Louisiana", "Yes"),
("Bandaids", "Personal Care", "Arkansas", "No"),
("Black Tea", "Beverages", "India",	"Yes"),
("Brown bread", "Bakery", "Georgia", "No"),
("Cajun Seasoning",	"Other", "Lousiana", "Yes"),
("Campbells Soup", "Other", "Georgia", "Yes"),
("Carrot", "Produce", "Alabama", "No"),
("Chicken Breast", "Meat", "Georgia", "No"),
("Chicken Thighs",	"Meat",	"Georgia",	"Yes"),
("Coca-cola", "Beverages", "Georgia", "No"),
("Coffee", "Beverages", "Columbia", "Yes"),
("Disani", "Beverages", "California", "Yes"),
("Doughnuts", "Bakery", "Georgia", "No"),
("Earl Grey Tea", "Beverages", "Italy", "Yes"),
("Fuji Apple", "Produce", "Georgia", "No"),
("Gala Apple", "Produce", "New Zealand", "Yes"),
("Grape Juice", "Beverages", "Missouri", "No"),
("Grassfed Beef", "Meat", "Georgia", "Yes"),
("Green Tea", "Beverages", "India", "Yes"),
("Green Tea Shampoo", "Personal Care", "Michigan", "Yes"),
("Ground Breef", "Meat", "Texas", "Yes"),
("Ice Cream", "Dairy", "Georgia", "No"),
("Lamb Chops", "Meat", "New Zealand", "Yes"),
("Lavender Handsoap", "Personal Care", "France", "Yes"),
("Lemon Handsoap", "Personal Care", "France", "Yes"),
("Makeup", "Personal Care", "New York", "No"),
("Napkins", "Paper Goods", "South Carolina", "No"),
("Navel Orange", "Produce", "California", "Yes"),
("Onions", "Produce", "Mississippi", "No"),
("Orange Juice", "Beverages", "Missouri", "Yes"),
("Organic Peanut Butter", "Other", "Alabama", "Yes"),
("Organic Toothpaste",	"Personal Care", "Florida", "Yes"),
("Paper Cups", "Paper Goods", "South Carolina", "No"),
("Paper plates", "Paper Goods",	"South Carolina", "No"),
("Peanut Butter", "Other", "Alabama", "No"),
("Pepper", "Other", "Alaska", "No"),
("Pepsi", "Beverages", "Kansas", "No"),
("Plastic Brush", "Personal Care", "Louisiana", "No"),
("Plastic Comb", "Personal Care", "Louisiana", "No"),
("Pomagranted Juice", "Beverages", "Florida", "Yes"),
("Potato", "Produce", "Alabama", "No"),
("Pura Life", "Beverages", "California", "Yes"),
("Roma Tomato", "Produce", "Mexico", "Yes"),
("Rosemary Tea", "Beverages", "Greece", "Yes"),
("Sea salt", "Other", "Alaska", "Yes"),
("Spinach", "Produce", "Florida", "Yes"),
("Spring Water", "Beverages", "California", "Yes"),
("Stationary", "Paper Goods", "North Carolina",	"No"),
("Strawberries", "Produce", "Wisconson", "Yes"),
("Sunflower Butter", "Other", "Alabama", "No"),
("Swiss Cheese", "Dairy","Italy", "No"),
("Toilet Paper", "Personal Care", "Kentucky", "No"),
("Toothbrush", "Personal Care", "Kansas", "No"),
("Toothpaste", "Personal Care", "Florida", "No"),
("Turkey Wings", "Meat", "Georgia", "No"),
("White Bread", "Bakery", "Georgia", "No"),
("Whole Milk", "Dairy", "Georgia", "Yes"),
("Yellow Curry Powder", "Other", "India",  "No"),
("Yogurt", "Dairy", "Georgia", "No");

INSERT INTO Chain_Item VALUES
('2% Milk','Sprouts',10001,10,410,6.38),
('4-1 Shampoo','Publix',10006,6,60,5.85),
('Baby Food','Sprouts',10005,5,170,10.56),
('Bagels','Publix',10009,5,130,5.67),
('Bandaids','Wal Mart',10002,4,300,14.71),
('Black Tea',"Trader Joe's",10003,8,130,3.31),
('Brown bread','Kroger',10002,10,80,6.99),
('Campbells Soup','Moss Market',10003,8,390,13.31),
('Carrot','Kroger',10004,10,370,8.19),
('Carrot','Publix',10001,9,110,9.71),
('Chicken Thighs','Publix',10008,10,280,2.81),
('Coca-cola','Wal Mart',10003,6,160,14.85),
('Coffee','Kroger',10005,8,170,4.30),
('Earl Grey Tea',"Trader Joe's",10005,8,130,20.53),
('Fuji Apple','Moss Market',10002,2,130,1.99),
('Gala Apple','Moss Market',10001,8,450,15.32),
('Grape Juice','Publix',10004,7,150,11.89),
('Grassfed Beef','Whole Foods',10001,1,170,13.88),
('Green Tea',"Trader Joe's",10002,4,340,7.25),
('Ice Cream','Query Mart',10002,2,310,13.58),
('Lamb Chops','Query Mart',10001,2,410,7.72),
('Lamb Chops','Whole Foods',10002,4,280,20.14),
('Lavender Handsoap','Kroger',10008,4,140,7.23),
('Napkins','Wal Mart',10006,4,410,18.36),
('Paper Cups','Publix',10003,10,430,20.18),
('Paper Cups','Wal Mart',10005,1,50,7.73),
('Paper plates','Wal Mart',10007,10,60,20.29),
('Peanut Butter','Publix',10002,6,190,10.35),
('Peanut Butter','Sprouts',10004,7,410,1.30),
('Pepsi','Kroger',10007,6,340,14.74),
('Pepsi','Publix',10007,6,440,11.19),
('Pepsi','Wal Mart',10004,10,110,3.21),
('Roma Tomato','Publix',10005,6,140,15.91),
('Rosemary Tea',"Trader Joe's",10004,10,310,10.55),
('Spinach','Kroger',10006,8,130,2.35),
('Spinach','Wal Mart',10001,9,320,11.44),
('Sunflower Butter',"Trader Joe's",10001,4,160,8.23),
('White Bread','Kroger',10001,8,220,7.52),
('Whole Milk','Sprouts',10002,8,370,15.26),
('Yellow Curry Powder','Sprouts',10003,7,230,16.72),
('Yogurt','Kroger',10003,6,330,3.27);

INSERT INTO contain VALUES
(10001,'Yogurt','Kroger',10003,4),
(10001,'White Bread','Kroger',10001,1),
(10001,'Carrot','Kroger',10004,10),
(10001,'Coffee','Kroger',10005,1),
(10001,'Spinach','Kroger',10006,2),
(10002,'Lamb Chops','Whole Foods',10002,2),
(10003,'2% Milk','Sprouts',10001,2),
(10003,'Yellow Curry Powder','Sprouts',10003,3),
(10003,'Peanut Butter','Sprouts',10004,1),
(10004,'Brown Bread','Kroger',10002,2),
(10005,'Gala Apple','Moss Market',10001,6),
(10005,'Fuji Apple','Moss Market',10002,2),
(10006,'Peanut Butter','Publix',10002,1),
(10006,'Paper Cups','Publix',10003,6),
(10006,'Grape Juice','Publix',10004,2),
(10006,'Roma Tomato','Publix',10005,6),
(10006,'4-1 Shampoo','Publix',10006,1),
(10006,'Carrot','Publix',10001,5),
(10007,'4-1 Shampoo','Publix',10006,1),
(10008,'Ice Cream','Query Mart',10002,1),
(10009,'Bandaids','Wal Mart',10002,4),
(10010,'Pepsi','Wal Mart',10004,1),
(10010,'Coca-cola','Wal Mart',10003,1),
(10011,'Baby Food','Sprouts',10005,3),
(10012,'Grassfed Beef','Whole Foods',10001,1),
(10013,'Chicken Thighs','Publix',10008,2),
(10014,'Paper Plates','Wal Mart',10007,8),
(10015,'Green Tea',"Trader Joe's",10002,2),
(10015,'Black Tea',"Trader Joe's",10003,2),
(10015,'Rosemary Tea',"Trader Joe's",10004,2),
(10015,'Earl Grey Tea',"Trader Joe's",10005,2);

