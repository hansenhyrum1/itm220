USE operating_system;

-- Hyrum Hansen

-- John is a employee at a store that sells computer equipment. A named Hyrum Hansen calls and says that he recently built
-- orderd and built a computer through the store. He has a Windows 10 and would like to upgrade to Windows 11, 
-- but it is telling him that he needs to upgrade his storage and Ram. He has 32gb of storage and 2gb of DDR4 RAM.
-- Use the database to find how much more storage and memory your customer must add in order to upgrade to Windows 11.
-- Also include the price difference of the new operating system and the time since the computer was purchased on January, 13th.

SET @current_storage := 32;
SET @current_ram := 2; 
SET @current_price := 99.99;
SET @purchase_date := "2025-01-13";
SET @customer_name := "Hyrum Hansen";

SELECT CONCAT(c.first_name, " ", c.last_name) AS "Name"
	, FLOOR(DATEDIFF(NOW(), @purchase_date)) AS "Days Since Purchase"
    , os.os_name AS "Operating System"
	, (mr.ram_size - @current_ram) AS "RAM Needed"
    , (ms.storage_size - @current_storage) AS "Storage Needed"
    , CONCAT("$", ROUND((os.cost - @current_price), 2)) AS "Price Difference"
FROM operating_system os 
	JOIN required_specs rs ON os.required_specs_id = rs.required_specs_id
    JOIN min_ram mr ON rs.min_ram_id = mr.min_ram_id
    JOIN min_storage ms ON rs.min_storage_id = ms.min_storage_id
    , customer c
WHERE os.os_name = "Windows 11 Pro" AND CONCAT(c.first_name, " ", c.last_name) = "Hyrum Hansen";