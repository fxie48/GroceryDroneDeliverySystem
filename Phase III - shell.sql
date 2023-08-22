/*
CS4400: Introduction to Database Systems
Spring 2021
Phase III Template
Team ##
Neo Pak (npak9) 
Felicie Xie (fxie48) 
Catherine Wang (cwang724)

Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/

use grocery_drone_delivery;

-- ID: 2a
-- Author: asmith457
-- Name: register_customer
DROP PROCEDURE IF EXISTS register_customer;
DELIMITER //
CREATE PROCEDURE register_customer(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
	   IN i_zipcode CHAR(5),
       IN i_ccnumber VARCHAR(40),
	   IN i_cvv CHAR(3),
       IN i_exp_date DATE
)
sp_main: BEGIN
-- Type solution below

if length(i_zipcode) != 5 or length(i_state) != 2 or length(i_password) < 8 then
leave sp_main; end if;

insert into USERS (Username, Pass, FirstName, LastName, Street, City, State, Zipcode) 
values (i_username, MD5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);
 
insert into CUSTOMER (Username, CcNumber, CVV, EXP_DATE)
values (i_username, i_ccnumber, i_cvv, i_exp_date);
-- End of solution
END //
DELIMITER ;

-- ID: 2b
-- Author: asmith457
-- Name: register_employee
DROP PROCEDURE IF EXISTS register_employee;
DELIMITER //
CREATE PROCEDURE register_employee(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
       IN i_zipcode CHAR(5)
)
BEGIN
-- Type solution below
#if length(i_zipcode) != 5 or length(i_state) != 2 or length(i_password) < 8 then
#leave sp_main; end if;

insert into USERS (Username, Pass, FirstName, LastName, Street, City, State, Zipcode) 
values (i_username, MD5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);
 
insert into EMPLOYEE (Username)
values (i_username); 
-- End of solution
END //
DELIMITER ;

-- ID: 4a
-- Author: asmith457
-- Name: admin_create_grocery_chain
DROP PROCEDURE IF EXISTS admin_create_grocery_chain;
DELIMITER //
CREATE PROCEDURE admin_create_grocery_chain(
        IN i_grocery_chain_name VARCHAR(40)
)
BEGIN

-- Type solution below
insert into CHAIN (ChainName) 
values(i_grocery_chain_name); 
-- End of solution
END //
DELIMITER ;

-- ID: 5a
-- Author: ahatcher8
-- Name: admin_create_new_store
DROP PROCEDURE IF EXISTS admin_create_new_store;
DELIMITER //
CREATE PROCEDURE admin_create_new_store(
    	IN i_store_name VARCHAR(40),
        IN i_chain_name VARCHAR(40),
    	IN i_street VARCHAR(40),
    	IN i_city VARCHAR(40),
    	IN i_state VARCHAR(2),
    	IN i_zipcode CHAR(5)
)
sp_main: BEGIN
-- Type solution below
if length(i_state) != 2 or length(i_zipcode) != 5 then
	leave sp_main; end if;
    
insert into STORE (StoreName, ChainName, Street, City, State, Zipcode)
values (i_store_name, i_chain_name, i_street, i_city, i_state, i_zipcode);

-- End of solution
END //
DELIMITER ;


-- ID: 6a
-- Author: ahatcher8
-- Name: admin_create_drone
DROP PROCEDURE IF EXISTS admin_create_drone;
DELIMITER //
CREATE PROCEDURE admin_create_drone(
	   IN i_drone_id INT,
       IN i_zip CHAR(5),
       IN i_radius INT,
       IN i_drone_tech VARCHAR(40)
)
sp_main: BEGIN
-- Type solution below
IF i_zip<>(SELECT zipcode FROM drone_tech JOIN store 
ON store.storename=drone_tech.storename AND store.chainname=drone_tech.chainname 
WHERE drone_tech.username=i_drone_tech) THEN LEAVE sp_main; END IF;

#set @previousID = (select max(ID) from Drone); 

#if i_drone_id != (@previousID + 1) then
	#leave sp_main; end if;
    
INSERT INTO Drone (ID, DroneStatus, Zip, Radius, DroneTech)
VALUES (i_drone_id, "Available", i_zip, i_radius, i_drone_tech);
-- End of solution
END //
DELIMITER ;


-- ID: 7a
-- Author: ahatcher8
-- Name: admin_create_item
DROP PROCEDURE IF EXISTS admin_create_item;
DELIMITER //
CREATE PROCEDURE admin_create_item(
        IN i_item_name VARCHAR(40),
        IN i_item_type VARCHAR(40),
        IN i_organic VARCHAR(3),
        IN i_origin VARCHAR(40)
)
sp_main: BEGIN
-- Type solution below
if i_item_name is null or i_item_type is null or i_organic is null or i_origin is null then 
	leave sp_main; end if;
    
if i_item_type not in ("Dairy", "Bakery", "Meat", "Produce", "Personal Care", "Paper Goods", "Beverages", "Other") then
	leave sp_main; end if;

if i_organic not in ("Yes", "No") then
	leave sp_main; end if;

insert into ITEM (ItemName, ItemType, Origin, Organic) values (i_item_name, i_item_type, i_origin, i_organic);
-- End of solution
END //
DELIMITER ;

-- ID: 8a
-- Author: dvaidyanathan6
-- Name: admin_view_customers
DROP PROCEDURE IF EXISTS admin_view_customers;
DELIMITER //
CREATE PROCEDURE admin_view_customers(
	   IN i_first_name VARCHAR(40),
       IN i_last_name VARCHAR(40)
)
BEGIN
-- Type solution below
DROP VIEW IF EXISTS admin_view_customers;
CREATE VIEW admin_view_customers as
SELECT Username, concat(FirstName, " ", LastName) as Name, concat(Street, ", ", City, ", ", State, " ", Zipcode) as Address 
FROM CUSTOMER NATURAL JOIN USERS; 

DROP TABLE IF EXISTS admin_view_customers_result;
if i_first_name is not null and i_last_name is not null then 
	CREATE TABLE admin_view_customers_result as 
	SELECT Username, Name, Address
	FROM admin_view_customers NATURAL JOIN USERS 
	where FirstName = i_first_name and LastName = i_last_name;
    
elseif i_first_name is null and i_last_name is not null then
	CREATE TABLE admin_view_customers_result as 
	SELECT Username, Name, Address
	FROM admin_view_customers NATURAL JOIN USERS 
	where LastName = i_last_name;
    
elseif i_first_name is not null and i_last_name is null then
	CREATE TABLE admin_view_customers_result as 
	SELECT Username, Name, Address
	FROM admin_view_customers NATURAL JOIN USERS 
	where FirstName = i_first_name;
    
else 
	CREATE TABLE admin_view_customers_result as 
	SELECT Username, Name, Address
	FROM admin_view_customers NATURAL JOIN USERS;
end if;

-- End of solution
END //
DELIMITER ;

-- ID: 9a
-- Author: dvaidyanathan6
-- Name: manager_create_chain_item
DROP PROCEDURE IF EXISTS manager_create_chain_item;
DELIMITER //
CREATE PROCEDURE manager_create_chain_item(
        IN i_chain_name VARCHAR(40),
    	IN i_item_name VARCHAR(40),
    	IN i_quantity INT, 
    	IN i_order_limit INT,
    	IN i_PLU_number INT,
    	IN i_price DECIMAL(4, 2)
)
sp_main: BEGIN
-- Type solution below

IF i_PLU_number in (select plunumber from chain_item where chainname=i_chain_name) 
or length(i_PLU_number) != 5 then 
LEAVE sp_main; END IF;

IF i_item_name in (select chainitemname from chain_item where chainname=i_chain_name) then
LEAVE sp_main; END IF;

IF i_quantity<0 or i_order_limit<= 0 or i_PLU_number<0 or i_price<0 then
LEAVE sp_main; END IF;

IF i_order_limit>i_quantity then 
LEAVE sp_main; END IF;

INSERT INTO chain_item (ChainItemName, ChainName, PLUNumber, Orderlimit, Quantity, Price)
VALUES (i_item_name, i_chain_name, i_PLU_number, i_order_limit, i_quantity, i_price);

-- End of solution
END //
DELIMITER ;

-- ID: 10a
-- Author: dvaidyanathan6
-- Name: manager_view_drone_technicians
DROP PROCEDURE IF EXISTS manager_view_drone_technicians;
DELIMITER //
CREATE PROCEDURE manager_view_drone_technicians(
	   IN i_chain_name VARCHAR(40),
       IN i_drone_tech VARCHAR(40),
       IN i_store_name VARCHAR(40)
)
BEGIN
-- Type solution below
DROP VIEW IF EXISTS manager_view_drone_technicians;
CREATE VIEW manager_view_drone_technicians as
SELECT DRONE_TECH.Username, concat(FirstName, " ", LastName) as Name, StoreName as Location
FROM DRONE_TECH NATURAL JOIN USERS;

DROP TABLE IF EXISTS manager_view_drone_technicians_result;
if i_drone_tech is not null and i_store_name is not null then 
	CREATE TABLE manager_view_drone_technicians_result as 
    SELECT Username, Name, Location 
    FROM manager_view_drone_technicians NATURAL JOIN DRONE_TECH
    WHERE manager_view_drone_technicians.Username = i_drone_tech and Location = i_store_name and ChainName = i_chain_name;
	
elseif i_drone_tech is null and i_store_name is not null then
	CREATE TABLE manager_view_drone_technicians_result as 
	SELECT Username, Name, Location 
    FROM manager_view_drone_technicians NATURAL JOIN DRONE_TECH
    WHERE Location = i_store_name and ChainName = i_chain_name;
    
elseif i_drone_tech is not null and i_store_name is null then
	CREATE TABLE manager_view_drone_technicians_result as 
	SELECT Username, Name, Location 
    FROM manager_view_drone_technicians NATURAL JOIN DRONE_TECH
    WHERE manager_view_drone_technicians.Username = i_drone_tech and ChainName = i_chain_name;
    
else 
	CREATE TABLE manager_view_drone_technicians_result as 
    SELECT DRONE_TECH.Username, Name, Location 
    FROM manager_view_drone_technicians NATURAL JOIN DRONE_TECH
    WHERE ChainName = i_chain_name;
	
end if;
-- End of solution
END //
DELIMITER ;


-- ID: 11a
-- Author: vtata6
-- Name: manager_view_drones
DROP PROCEDURE IF EXISTS manager_view_drones;
DELIMITER //
CREATE PROCEDURE manager_view_drones(
	   IN i_mgr_username varchar(40), 
	   IN i_drone_id int, 
       IN drone_radius int
)
BEGIN
-- Type solution below	     
drop view if exists manager_view_drones;
create view manager_view_drones as
select MANAGER.Username as mgr_username, ID as DroneID, DroneTech as Operator, Radius, Zip as ZipCode, DroneStatus as Status 
from MANAGER join DRONE_TECH on MANAGER.ChainName = DRONE_TECH.ChainName join DRONE on DroneTech = DRONE_TECH.Username;

drop table if exists manager_view_drones_result;
if i_drone_id is null and drone_radius is null then
	create table manager_view_drones_result as
	select DroneID, Operator, Radius, ZipCode, Status from manager_view_drones 
	where mgr_username = i_mgr_username;

elseif i_drone_id is null and drone_radius is not null then
	create table manager_view_drones_result as
	select DroneID, Operator, Radius, ZipCode, Status from manager_view_drones 
	where mgr_username = i_mgr_username and Radius >= drone_radius;

elseif i_drone_id is not null and drone_radius is null then
	create table manager_view_drones_result as
	select DroneID, Operator, Radius, ZipCode, Status from manager_view_drones 
	where mgr_username = i_mgr_username and DroneID = i_drone_id;
    
else
	create table manager_view_drones_result as
	select DroneID, Operator, Radius, ZipCode, Status from manager_view_drones 
	where mgr_username = i_mgr_username and Radius >= drone_radius and DroneID = i_drone_id;
    
end if; 
-- End of solution
END //
DELIMITER ;

-- ID: 12a
-- Author: vtata6
-- Name: manager_manage_stores
DROP PROCEDURE IF EXISTS manager_manage_stores;
DELIMITER //
CREATE PROCEDURE manager_manage_stores(
	   IN i_mgr_username varchar(50), 
	   IN i_storeName varchar(50), 
	   IN i_minTotal int, 
	   IN i_maxTotal int
)
BEGIN
-- Type solution below
drop table if exists manager_manage_stores_result; 
if i_storeName is not null and i_minTotal is not null and i_maxTotal is not null then 
	create table manager_manage_stores_result as 
    select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where StoreName = i_storeName and (Total between i_minTotal and i_maxTotal) and manager.Username = i_mgr_username;
    
elseif i_storeName is not null and i_minTotal is not null and i_maxTotal is null then 
	create table manager_manage_stores_result as 
    select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where StoreName = i_storeName and Total > i_minTotal  and manager.Username = i_mgr_username;
    
elseif i_storeName is not null and i_minTotal is null and i_maxTotal is not null then 
	create table manager_manage_stores_result as 
    select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where StoreName = i_storeName and Total < i_maxTotal and manager.Username = i_mgr_username;
    
elseif i_storeName is not null and i_minTotal is null and i_maxTotal is null then 
	create table manager_manage_stores_result as 
    select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where StoreName = i_storeName and manager.Username = i_mgr_username;
    
elseif i_storeName is null and i_minTotal is not null and i_maxTotal is not null then 
	create table manager_manage_stores_result as 
    select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where (Total between i_minTotal and i_maxTotal) and manager.Username = i_mgr_username;
    
elseif i_storeName is null and i_minTotal is not null and i_maxTotal is null then 
	create table manager_manage_stores_result as 
   select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where Total > i_minTotal and manager.Username = i_mgr_username;
    
elseif i_storeName is null and i_minTotal is null and i_maxTotal is not null then 
	create table manager_manage_stores_result as 
    select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where Total < i_maxTotal and manager.Username = i_mgr_username;
    
elseif i_storeName is null and i_minTotal is null and i_maxTotal is null then 
	create table manager_manage_stores_result as 
    select StoreName, Address, Num_Orders, ifnull(num_emp,0) as num_emp, ifnull(Total,0) as Total from ((select store.StoreName, store.ChainName, num_emp from store 
	left join (select DRONE_TECH.ChainName, DRONE_TECH.StoreName, (count(DRONE_TECH.Username)+count(distinct(MANAGER.Username))) as num_emp
	from DRONE_TECH left join MANAGER on DRONE_TECH.ChainName = MANAGER.ChainName
	group by DRONE_TECH.ChainName, DRONE_TECH.StoreName) as num_emp
	on store.ChainName = num_emp.ChainName and store.StoreName = num_emp.StoreName) as total_emp
	natural join 
	(select StoreName, Store.ChainName as ChainName, concat(Street, " ", City, ", ", State, " ", Store.Zipcode) as Address, count(distinct(OrderID)) as Num_Orders, sum(all_orders.quantity* price) as Total from store 
	left join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	left join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber
    where OrderStatus != "Creating"
	group by StoreName, ChainName, Address) as order_price)
	join manager on manager.ChainName = order_price.ChainName
    where manager.Username = i_mgr_username;
    
end if;
-- End of solution
END //
DELIMITER ;

-- ID: 13a
-- Author: vtata6
-- Name: customer_change_credit_card_information
DROP PROCEDURE IF EXISTS customer_change_credit_card_information;
DELIMITER //
CREATE PROCEDURE customer_change_credit_card_information(
	   IN i_custUsername varchar(40), 
	   IN i_new_cc_number varchar(19), 
	   IN i_new_CVV int, 
	   IN i_new_exp_date date
)

sp_main: BEGIN
-- Type solution below
if i_custUsername is null or i_new_cc_number is null or i_new_CVV is null or i_new_exp_date is null then
leave sp_main;

elseif i_custUsername not in (select Username from CUSTOMER) then
leave sp_main; 

elseif i_new_exp_date < CURDATE() then
leave sp_main; end if;
	
update CUSTOMER set CcNumber = i_new_cc_number where Username = i_custUsername;
update CUSTOMER set CVV = i_new_CVV where Username = i_custUsername;
update CUSTOMER set EXP_DATE = i_new_exp_date where Username = i_custUsername;
-- End of solution
END //
DELIMITER ;

-- ID: 14a
-- Author: ftsang3
-- Name: customer_view_order_history
DROP PROCEDURE IF EXISTS customer_view_order_history;
DELIMITER //
CREATE PROCEDURE customer_view_order_history(
	   IN i_username VARCHAR(40),
       IN i_orderid INT
)
BEGIN
-- Type solution below
DROP VIEW IF EXISTS customer_view_order_history;
CREATE VIEW customer_view_order_history as
select orders.ID,  orders.orderstatus,  orders.orderdate,  orders.customerusername, contains.chainname, contains.plunumber, contains.quantity, chain_item.price, dronetech, orders.droneid
from orders 
join contains on orders.id=contains.orderid
join chain_item on contains.itemname=chain_item.chainitemname and contains.chainname=chain_item.chainname and contains.plunumber=chain_item.plunumber
join drone on orders.droneid=drone.id;

DROP TABLE IF EXISTS customer_view_order_history_result;
CREATE TABLE customer_view_order_history_result as 
SELECT sum(quantity*price) as total_amount, sum(quantity) as total_items, orderdate, droneid, dronetech, orderstatus
FROM customer_view_order_history
where id=i_orderid and customerusername=i_username
group by orderdate,droneid,dronetech,orderstatus;
-- End of solution
END //
DELIMITER ;

-- ID: 15a
-- Author: ftsang3
-- Name: customer_view_store_items
DROP PROCEDURE IF EXISTS customer_view_store_items;
DELIMITER //
CREATE PROCEDURE customer_view_store_items(
	   IN i_username VARCHAR(40),
       IN i_chain_name VARCHAR(40),
       IN i_store_name VARCHAR(40),
       IN i_item_type VARCHAR(40)
)
sp_main: BEGIN
-- Type solution below
drop table if exists customer_view_store_items_result;
if (select zipcode from users where username=i_username) != (select zipcode from store where store.storename=i_store_name and store.chainname = i_chain_name) then 
leave sp_main; end if;

if i_item_type = "ALL" then 

	create table customer_view_store_items_result as 
	select ChainItemName, (case when Quantity > Orderlimit then Orderlimit else Quantity END) as Quantity 
    from (select ChainItemName, chain_store_zip.ChainName, chain_store_zip.StoreName, ItemType, OrderLimit, Quantity from item 
	join chain_item on ItemName = ChainItemName 
	join (select ChainName, StoreName from chain natural join store where zipcode = (select zipcode from customer natural join users where Username = i_username)) as chain_store_zip 
	on chain_store_zip.ChainName = chain_item.ChainName) as final 
	where final.ChainName = i_chain_name and final.StoreName = i_store_name;

else

	create table customer_view_store_items_result as 
	select ChainItemName, (case when Quantity > Orderlimit then Orderlimit else Quantity END) as Quantity 
    from (select ChainItemName, chain_store_zip.ChainName, chain_store_zip.StoreName, ItemType, OrderLimit, Quantity from item 
	join chain_item on ItemName = ChainItemName 
	join (select ChainName, StoreName from chain natural join store where zipcode = (select zipcode from customer natural join users where Username = i_username)) as chain_store_zip 
	on chain_store_zip.ChainName = chain_item.ChainName) as final 
	where final.ChainName = i_chain_name and final.StoreName = i_store_name and final.ItemType = i_item_type;


end if;
-- End of solution
END //
DELIMITER ;

-- ID: 15b
-- Author: ftsang3
-- Name: customer_select_items
DROP PROCEDURE IF EXISTS customer_select_items;
DELIMITER //
CREATE PROCEDURE customer_select_items(
	    IN i_username VARCHAR(40),
    	IN i_chain_name VARCHAR(40),
    	IN i_store_name VARCHAR(40),
    	IN i_item_name VARCHAR(40),
    	IN i_quantity INT
)
sp_main: BEGIN
-- Type solution below
if (select zipcode from users where username=i_username) != (select zipcode from store where store.storename=i_store_name) then 
leave sp_main; end if;

set @new_order_id = (select max(id) + 1 from orders);

if (select zipcode from users where username=i_username) != (select zipcode from store where store.storename=i_store_name) then 
	leave sp_main; end if;

if  i_chain_name not in (select chainname from store where storename = i_store_name) then 
	leave sp_main; end if;

if (i_quantity > (select Orderlimit from chain_item where ChainItemName = i_item_name and ChainName = i_chain_name)) then
	leave sp_main; end if;

if (i_quantity > (select quantity from chain_item where chainitemname=i_item_name and Chainname=i_chain_name)) then 
	leave sp_main; end if;
    
if (select exists(select * from chain_item where chainitemname=i_item_name and Chainname=i_chain_name)) = 0 then 
	leave sp_main; end if;

if 'Creating' not in (select orderstatus from orders where customerusername=i_username) then
	insert into orders values (@new_order_id, 'Creating', current_timestamp, i_username, null);
    insert into contains values (@new_order_id, i_item_name, i_chain_name,(select PLUnumber from chain_item where chainitemname=i_item_name and chainname=i_chain_name), i_quantity);

elseif 'Creating' in (select orderstatus from orders where customerusername=i_username) then 
	insert into contains values (@new_order_id, i_item_name, i_chain_name,(select PLUnumber from chain_item where chainitemname=i_item_name and chainname=i_chain_name), i_quantity);
    
end if;
-- End of solution
END //
DELIMITER ;
#CALL customer_select_items(‘mscott845’, ‘Moss Market’, ‘West Midtown’, ‘Bread’, ‘1’); 

-- ID: 16a
-- Author: jkomskis3
-- Name: customer_review_order
DROP PROCEDURE IF EXISTS customer_review_order;
DELIMITER //
CREATE PROCEDURE customer_review_order(
	   IN i_username VARCHAR(40)
)
BEGIN
-- Type solution below
Drop table if exists customer_review_order_result;
Create table customer_review_order_result as
select ItemName, Contains.Quantity, Price
from orders join contains on ID = OrderID 
join Chain_Item on ChainItemName = ItemName and Contains.ChainName = Chain_Item.ChainName and Contains.PLUNumber = Chain_Item.PLUNumber
where CustomerUsername = i_username and OrderStatus = "Creating"; 
-- End of solution
END //
DELIMITER ;


-- ID: 16b
-- Author: jkomskis3
-- Name: customer_update_order
DROP PROCEDURE IF EXISTS customer_update_order;
DELIMITER //
CREATE PROCEDURE customer_update_order(
	   IN i_username VARCHAR(40),
       IN i_item_name VARCHAR(40),
       IN i_quantity INT
)
sp_main: BEGIN
-- Type solution below
DROP VIEW IF EXISTS contains_plus_orders;
CREATE VIEW contains_plus_orders AS
SELECT * FROM ORDERS JOIN CONTAINS ON CONTAINS.OrderId=Orders.ID;

IF i_quantity> (SELECT Orderlimit 
FROM Chain_Item
WHERE (SELECT ChainName FROM contains_plus_orders WHERE CustomerUsername = i_username AND OrderStatus = 'Creating' AND Itemname = i_item_name) = chain_item.chainname
AND (SELECT plunumber FROM contains_plus_orders WHERE customerusername = i_username AND orderstatus = 'Creating' AND Itemname = i_item_name) = chain_item.plunumber)
then leave sp_main; end if;

if i_quantity = 0 and (select orderstatus from orders where customerusername=i_username and Orderstatus = 'Creating') = 'Creating' then 

	DELETE FROM contains 
	where itemname=i_item_name and orderid = (select ID from orders where customerusername=i_username and orderstatus='Creating');
    
else 

	UPDATE CONTAINS SET Quantity = i_quantity WHERE ItemName = i_item_name and 
    orderid = (select ID from orders where customerusername=i_username and orderstatus='Creating');
    

end if;
-- End of solution
END //
DELIMITER ;


-- ID: 17a
-- Author: jkomskis3
-- Name: customer_update_order
DROP PROCEDURE IF EXISTS drone_technician_view_order_history;
DELIMITER //
CREATE PROCEDURE drone_technician_view_order_history(
        IN i_username VARCHAR(40),
    	IN i_start_date DATE,
    	IN i_end_date DATE
)
BEGIN
-- Type solution below
Set @StoreName = (select StoreName from Drone_Tech where Username = i_username);
Set @ChainName = (select ChainName from Drone_Tech where Username = i_username);

DROP TABLE IF EXISTS drone_technician_view_order_history_result;
if i_start_date is not null and i_end_date is not null then  
	create table drone_technician_view_order_history_result as
	select ID, Operator, OrderDate as Date, order_info.DroneID, OrderStatus as Status, Total from (select StoreName, ChainName, ID, OrderDate, DroneID, OrderStatus, sum(Quantity*Price) as Total from (select StoreName, Store.ChainName, Store.Zipcode, all_orders.ID, DroneID, OrderDate, all_orders.Quantity, Price, OrderStatus from store 
	join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber) as all_info
	where OrderStatus != "Creating"
	group by ID, StoreName, ChainName) as order_info
	join 
	(select OrderID, DroneID, ifnull(concat(FirstName, " ", LastName),null) as Operator from Contains join Orders on OrderID = Orders.ID left join Drone on Drone.ID = DroneID left join Users on DroneTech = Username group by OrderID) as operator 
	on OrderID = order_info.ID
    where StoreName = @StoreName and ChainName = @ChainName and OrderDate Between i_start_date and i_end_date;
    
elseif i_start_date is null and i_end_date is not null then  
	create table drone_technician_view_order_history_result as
	select ID, Operator, OrderDate as Date, order_info.DroneID, OrderStatus as Status, Total from (select StoreName, ChainName, ID, OrderDate, DroneID, OrderStatus, sum(Quantity*Price) as Total from (select StoreName, Store.ChainName, Store.Zipcode, all_orders.ID, DroneID, OrderDate, all_orders.Quantity, Price, OrderStatus from store 
	join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber) as all_info
	where OrderStatus != "Creating"
	group by ID, StoreName, ChainName) as order_info
	join 
	(select OrderID, DroneID, ifnull(concat(FirstName, " ", LastName),null) as Operator from Contains join Orders on OrderID = Orders.ID left join Drone on Drone.ID = DroneID left join Users on DroneTech = Username group by OrderID) as operator 
	on OrderID = order_info.ID
    where StoreName = @StoreName and ChainName = @ChainName and OrderDate < i_end_date;

elseif i_start_date is not null and i_end_date is null then  
	create table drone_technician_view_order_history_result as
	select ID, Operator, OrderDate as Date, order_info.DroneID, OrderStatus as Status, Total from (select StoreName, ChainName, ID, OrderDate, DroneID, OrderStatus, sum(Quantity*Price) as Total from (select StoreName, Store.ChainName, Store.Zipcode, all_orders.ID, DroneID, OrderDate, all_orders.Quantity, Price, OrderStatus from store 
	join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber) as all_info
	where OrderStatus != "Creating"
	group by ID, StoreName, ChainName) as order_info
	join 
	(select OrderID, DroneID, ifnull(concat(FirstName, " ", LastName),null) as Operator from Contains join Orders on OrderID = Orders.ID left join Drone on Drone.ID = DroneID left join Users on DroneTech = Username group by OrderID) as operator 
	on OrderID = order_info.ID
    where StoreName = @StoreName and ChainName = @ChainName and OrderDate > i_start_date;
    
else 
	create table drone_technician_view_order_history_result as
	select ID, Operator, OrderDate as Date, order_info.DroneID, OrderStatus as Status, Total from (select StoreName, ChainName, ID, OrderDate, DroneID, OrderStatus, sum(Quantity*Price) as Total from (select StoreName, Store.ChainName, Store.Zipcode, all_orders.ID, DroneID, OrderDate, all_orders.Quantity, Price, OrderStatus from store 
	join (select * from orders join (select Username, Zipcode from customer natural join users) as cust_user_zip on CustomerUsername = Username join contains on OrderID = ID) as all_orders 
	on store.Zipcode = all_orders.Zipcode and store.ChainName = all_orders.ChainName
	join chain_item on ChainItemName = ItemName and Chain_Item.ChainName = all_orders.ChainName and Chain_Item.PLUNumber = all_orders.PLUNumber) as all_info
	where OrderStatus != "Creating"
	group by ID, StoreName, ChainName) as order_info
	join 
	(select OrderID, DroneID, ifnull(concat(FirstName, " ", LastName), null) as Operator from Contains join Orders on OrderID = Orders.ID left join Drone on Drone.ID = DroneID left join Users on DroneTech = Username group by OrderID) as operator 
	on OrderID = order_info.ID
    where StoreName = @StoreName and ChainName = @ChainName;
    
end if;
-- End of solution
END //
DELIMITER ;

-- ID: 17b
-- Author: agoyal89
-- Name: dronetech_assign_order
DROP PROCEDURE IF EXISTS dronetech_assign_order;
DELIMITER //
CREATE PROCEDURE dronetech_assign_order(
	   IN i_username VARCHAR(40),
       IN i_droneid INT,
       IN i_status VARCHAR(20),
       IN i_orderid INT
)
sp_main: BEGIN
-- Type solution below
if (select ID from Drone where DroneTech = i_username) !=  i_droneid then 
leave sp_main; end if;

if (select orderstatus from orders where ID = i_orderid) = 'Pending' then 
	update drone set dronestatus='Busy' 
	where ID = i_droneid and DroneTech =i_username;

	update orders set droneid=i_droneid, orderstatus=i_status
	where ID = i_orderid;
    
elseif (select orderstatus from orders where ID = i_orderid and DroneID = i_droneid) != 'Pending' and i_status != "Delivered" then 
	update orders set orderstatus = i_status 
    where ID = i_orderid;
    
elseif (select orderstatus from orders where ID = i_orderid and DroneID = i_droneid) != 'Pending' and i_status = "Delivered" then 
	update drone set dronestatus = "Available"
    where ID = i_droneid and DroneTech = i_username;
    
	update orders set orderstatus = i_status
    where ID = i_orderid;
    
end if;
-- End of solution
END //
DELIMITER ;

-- ID: 18a
-- Author: agoyal89
-- Name: dronetech_order_details
DROP PROCEDURE IF EXISTS dronetech_order_details;
DELIMITER //
CREATE PROCEDURE dronetech_order_details(
	   IN i_username VARCHAR(40),
       IN i_orderid VARCHAR(40)
)
BEGIN
-- Type solution below
drop view if exists dronetech_order_details_view;
create view dronetech_order_details_view as
select CustomerUsername, orders.ID as Order_ID, 
Price, contains.Quantity, orders.OrderDate as Date_of_Purchase,
orders.DroneID as Drone_ID, concat(FirstName, " ", LastName) as SalesAssociate, DroneTech, orders.OrderStatus, contains.PLUNumber
from
orders join contains on orders.ID = contains.OrderID join chain_item on contains.PLUNumber = chain_item.PLUNumber
left join drone on orders.DroneID = drone.ID left join users on users.Username = drone.DroneTech
where contains.ItemName = chain_item.ChainItemName and orderStatus != 'Creating';

drop table if exists dronetech_order_details_result;

if i_username is not null then
create table dronetech_order_details_result as
select concat(FirstName, " ", LastName) as Customer_Name, Order_ID, sum(Price * Quantity) as Total_Amount, sum(Quantity) as Total_Items,
Date_of_Purchase, Drone_ID, SalesAssociate, OrderStatus, concat(users.Street, ", ", users.City, ", ", users.State, " ", users.ZipCode) as Address
from dronetech_order_details_view join users on users.Username = dronetech_order_details_view.CustomerUsername
where i_username = DroneTech and i_orderid = Order_ID
group by dronetech_order_details_view.CustomerUsername, 
Order_ID;

elseif (i_username is null) or (i_username = "N/A") then
create table dronetech_order_details_result as
select concat(FirstName, " ", LastName) as Customer_Name, Order_ID, sum(Price * Quantity) as Total_Amount, sum(Quantity) as Total_Items,
Date_of_Purchase, Drone_ID, SalesAssociate, OrderStatus, concat(users.Street, ", ", users.City, ", ", users.State, " ", users.ZipCode) as Address
from dronetech_order_details_view join users on users.Username = dronetech_order_details_view.CustomerUsername
where DroneTech is null and i_orderid = Order_ID
group by dronetech_order_details_view.CustomerUsername, 
Order_ID; end if;


-- End of solution
END //
DELIMITER ;

-- ID: 18b
-- Author: agoyal89
-- Name: dronetech_order_items
DROP PROCEDURE IF EXISTS dronetech_order_items;
DELIMITER //
CREATE PROCEDURE dronetech_order_items(
        IN i_username VARCHAR(40),
    	IN i_orderid INT
)
BEGIN
-- Type solution below
drop view if exists dronetech_order_items;
create view dronetech_order_items as
select drone.DroneTech, contains.OrderID, contains.ItemName, contains.Quantity from
drone join orders on drone.ID = orders.DroneID join contains on orders.ID = contains.OrderID;

drop table if exists dronetech_order_items_result;
create table dronetech_order_items_result as
select ItemName, Quantity from dronetech_order_items where 
i_username = DroneTech and i_orderid = OrderID;

-- End of solution
END //
DELIMITER ;

-- ID: 19a
-- Author: agoyal89
-- Name: dronetech_assigned_drones
DROP PROCEDURE IF EXISTS dronetech_assigned_drones;
DELIMITER //
CREATE PROCEDURE dronetech_assigned_drones(
        IN i_username VARCHAR(40),
    	IN i_droneid INT,
    	IN i_status VARCHAR(20)
)
BEGIN
-- Type solution below
drop view if exists dronetech_assigned_drones;
create view dronetech_assigned_drones as
select ID, DroneStatus, Radius, DroneTech from Drone;

drop table if exists dronetech_assigned_drones_result; 
if i_status is not null and i_status != "All" then 
	if i_droneid is not null then
		create table dronetech_assigned_drones_result as
		select ID, DroneStatus, Radius from dronetech_assigned_drones 
		where ID = i_droneid and DroneStatus = i_status and DroneTech = i_username;
	else
		create table dronetech_assigned_drones_result as
		select ID, DroneStatus, Radius from dronetech_assigned_drones 
		where DroneStatus = i_status and DroneTech = i_username;
	end if;
else
	if i_droneid is not null then
		create table dronetech_assigned_drones_result as
		select ID, DroneStatus, Radius from dronetech_assigned_drones 
		where ID = i_droneid and DroneTech = i_username;
	else
		create table dronetech_assigned_drones_result as
		select ID, DroneStatus, Radius from dronetech_assigned_drones
		where DroneTech = i_username;
	end if;
    
end if;
-- End of solution
END //
DELIMITER ;

