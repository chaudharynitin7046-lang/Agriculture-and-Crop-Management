USE Projects

CREATE TABLE Farmer(
farmer_id INT PRIMARY KEY NOT NULL,
farmer_name VARCHAR(50),
Village VARCHAR(50)
)

CREATE TABLE Farm(
farm_id INT PRIMARY KEY NOT NULL,
farmer_id INT NOT NULL,
farm_type VARCHAR(50),
farm_area DECIMAL(14,2)
FOREIGN KEY (farmer_id) REFERENCES Farmer(Farmer_id)
)

CREATE TABLE crops(
crop_id INT PRIMARY KEY NOT NULL,
crop_name VARCHAR(50),
crop_category VARCHAR(50)
)

CREATE TABLE crop_recoed (
record_id INT PRIMARY KEY NOT NULL,
farm_id INT NOT NULL,
farmer_id INT NOT NULL,
crop_id INT NOT NULL,
season VARCHAR(20),
sowing_date DATE,
harvest_date DATE,
land_area_acres DECIMAL(10,2),
seed_quantity_kg DECIMAL(10,2),
fertilizer_quantity DECIMAL(10,2),
water_usage_liters DECIMAL(14,2),
yield_quantity DECIMAL(10,2),
selling_price_per_unit DECIMAL(10,2),
total_revenue DECIMAL(20,2),
crop_status VARCHAR(50)

FOREIGN KEY (farm_id) REFERENCES Farm(farm_id),
FOREIGN KEY (farmer_id) REFERENCES Farmer(farmer_id),
FOREIGN KEY (crop_id) REFERENCES crops(crop_id)
)

INSERT INTO Farmer (farmer_id, farmer_name, Village)
VALUES
(1,'Rajesh Patel','Anand'),
(2,'Suresh Patel','Nadiad'),
(3,'Mahesh Parmar','Vadodara'),
(4,'Ramesh Chaudhary','Mehsana'),
(5,'Kiran Patel','Borsad'),
(6,'Dinesh Thakor','Patan'),
(7,'Amit Desai','Ahmedabad'),
(8,'Vijay Rathod','Surendranagar'),
(9,'Mukesh Patel','Kheda'),
(10,'Bharat Solanki','Dahod'),
(11,'Prakash Parmar','Anand'),
(12,'Ravi Chaudhary','Mehsana'),
(13,'Sanjay Patel','Nadiad'),
(14,'Ashok Thakor','Patan'),
(15,'Nilesh Desai','Vadodara'),
(16,'Manoj Rathod','Rajkot'),
(17,'Paresh Patel','Junagadh'),
(18,'Harish Solanki','Bhavnagar'),
(19,'Gopal Parmar','Amreli'),
(20,'Deepak Patel','Gandhinagar');


INSERT INTO Farm (farm_id, farmer_id, farm_type, farm_area)
VALUES
(1,1,'Organic',10.50),
(2,2,'Traditional',8.50),
(3,3,'Commercial',15.00),
(4,4,'Mixed Farming',12.50),
(5,5,'Organic',9.00),
(6,6,'Traditional',7.50),
(7,7,'Commercial',18.00),
(8,8,'Mixed Farming',11.00),
(9,9,'Organic',6.50),
(10,10,'Traditional',14.00),
(11,11,'Commercial',16.50),
(12,12,'Organic',9.50),
(13,13,'Mixed Farming',13.00),
(14,14,'Traditional',8.00),
(15,15,'Commercial',20.00),
(16,16,'Organic',12.00),
(17,17,'Traditional',10.00),
(18,18,'Mixed Farming',17.50),
(19,19,'Commercial',14.50),
(20,20,'Organic',11.50),
(21,1,'Traditional',5.50),
(22,2,'Organic',7.00),
(23,3,'Mixed Farming',9.50),
(24,4,'Commercial',13.50),
(25,5,'Traditional',6.00),
(26,6,'Organic',8.50),
(27,7,'Mixed Farming',10.50),
(28,8,'Commercial',15.50),
(29,9,'Traditional',7.50),
(30,10,'Organic',12.50);


INSERT INTO crops (crop_id, crop_name, crop_category)
VALUES
(1,'Wheat','Cereal'),
(2,'Rice','Cereal'),
(3,'Cotton','Cash Crop'),
(4,'Groundnut','Oilseed'),
(5,'Maize','Cereal'),
(6,'Bajra','Millet'),
(7,'Mustard','Oilseed'),
(8,'Sugarcane','Cash Crop'),
(9,'Potato','Vegetable'),
(10,'Onion','Vegetable'),
(11,'Chickpea','Pulse'),
(12,'Soybean','Oilseed');


DECLARE @i INT = 1;

WHILE @i <= 500
BEGIN

    DECLARE @farm_id INT;
    DECLARE @farmer_id INT;
    DECLARE @yield DECIMAL(10,2);
    DECLARE @price DECIMAL(10,2);

    SET @farm_id = ((@i - 1) % 30) + 1;

    SET @farmer_id = ((@farm_id - 1) % 20) + 1;

    SET @yield = 5 + ((@i * 13) % 95);

    SET @price = 15 + ((@i * 7) % 85);

    INSERT INTO crop_recoed
    (
        record_id,
        farm_id,
        farmer_id,
        crop_id,
        season,
        sowing_date,
        harvest_date,
        land_area_acres,
        seed_quantity_kg,
        fertilizer_quantity,
        water_usage_liters,
        yield_quantity,
        selling_price_per_unit,
        total_revenue,
        crop_status
    )
    VALUES
    (
        @i,
        @farm_id,
        @farmer_id,
        ((@i - 1) % 12) + 1,

        CASE
            WHEN @i % 3 = 0 THEN 'Kharif'
            WHEN @i % 3 = 1 THEN 'Rabi'
            ELSE 'Summer'
        END,

        DATEADD(DAY, (@i * 17) % 700, CAST('20240101' AS DATE)),

        DATEADD(
            DAY,
            90 + (@i % 70),
            DATEADD(DAY, (@i * 17) % 700, CAST('20240101' AS DATE))
        ),

        1 + ((@i * 3) % 900) / 100.0,

        10 + ((@i * 5) % 90),

        20 + ((@i * 7) % 180),

        5000 + ((@i * 113) % 45000),

        @yield,

        @price,

        @yield * @price,

        CASE
            WHEN @i % 4 = 0 THEN 'Harvested'
            WHEN @i % 4 = 1 THEN 'Completed'
            WHEN @i % 4 = 2 THEN 'In Progress'
            ELSE 'Pending'
        END
    );

    SET @i = @i + 1;

END;



SELECT * FROM crop_recoed
SELECT * FROM crops
SELECT * FROM Farm
SELECT * FROM Farmer
--------------------------------------------------------------------------------------------------------------------------------------------------


SELECT * FROM crop_recoed


SELECT * FROM crop_recoed WHERE yield_quantity > 50


SELECT * FROM crop_recoed ORDER BY total_revenue DESC


SELECT c.crop_category, SUM(r.total_revenue) AS Revenue
FROM crops c
LEFT JOIN crop_recoed r
ON c.crop_id = r.crop_id
GROUP BY c.crop_category


SELECT AVG(yield_quantity) AS AVG_yield FROM crop_recoed


SELECT TOP 10 * FROM crop_recoed ORDER BY total_revenue DESC


SELECT fm.farmer_name,f.farm_type,c.crop_name,cr.season,cr.yield_quantity
FROM crop_recoed cr
JOIN Farmer fm
ON cr.farmer_id = fm.farmer_id
JOIN Farm f
ON cr.farm_id = f.farm_id
JOIN crops c
ON cr.crop_id = c.crop_id


SELECT crop_id,COUNT(DISTINCT crop_id) AS total_crop_types FROM crop_recoed
GROUP BY crop_id
HAVING COUNT(DISTINCT crop_id) > 5


SELECT season, SUM(total_revenue) AS Total_Revenue FROM crop_recoed
GROUP BY season