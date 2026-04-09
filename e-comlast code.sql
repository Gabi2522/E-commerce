-- Turn off unnecessary messages and set options for performance
SET NOCOUNT ON;
GO

-- =================================================================================
-- Section 1: Table Creation
-- Drop existing tables to ensure a clean slate for script re-runs.
-- =================================================================================

PRINT '--- Section 1: Dropping and Creating Tables ---';

-- Drop tables in reverse order of dependency to avoid foreign key errors
IF OBJECT_ID('dbo.MarketingCampaigns', 'U') IS NOT NULL DROP TABLE dbo.MarketingCampaigns;
IF OBJECT_ID('dbo.WebsiteInteractionMetrics', 'U') IS NOT NULL DROP TABLE dbo.WebsiteInteractionMetrics;
IF OBJECT_ID('dbo.TransactionDetails', 'U') IS NOT NULL DROP TABLE dbo.TransactionDetails;
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.ProductDetails', 'U') IS NOT NULL DROP TABLE dbo.ProductDetails;
IF OBJECT_ID('dbo.CustomerInformation', 'U') IS NOT NULL DROP TABLE dbo.CustomerInformation;
GO

-- 1. Customer Information
CREATE TABLE dbo.CustomerInformation (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    EmailAddress NVARCHAR(100),
    LocationCity NVARCHAR(50),
    LocationState NVARCHAR(50),
    LocationCountry NVARCHAR(50),
    Gender NVARCHAR(10),
    AgeGroup VARCHAR(10),
    CustomerType NVARCHAR(20) DEFAULT 'New' -- Will be updated later
);

-- 2. Product Details
CREATE TABLE dbo.ProductDetails (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Subcategory NVARCHAR(50),
    BrandName NVARCHAR(50),
    Price DECIMAL(10, 2),
    StockAvailability INT
);

-- 3. Order Details
CREATE TABLE dbo.OrderDetails (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES dbo.CustomerInformation(CustomerID),
    OrderDate DATETIME,
    DeliveryDate DATETIME, -- Can be NULL for pending/cancelled orders
    OrderStatus NVARCHAR(20),
    PaymentMethod NVARCHAR(50)
);

-- 4. Transaction Details
CREATE TABLE dbo.TransactionDetails (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES dbo.OrderDetails(OrderID),
    ProductID INT FOREIGN KEY REFERENCES dbo.ProductDetails(ProductID),
    QuantityOrdered INT,
    TotalPrice DECIMAL(10, 2),
    DiscountsApplied DECIMAL(10, 2),
    TaxApplied DECIMAL(10, 2)
);

-- 5. Website Interaction Metrics
CREATE TABLE dbo.WebsiteInteractionMetrics (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES dbo.CustomerInformation(CustomerID),
    SessionDurationMinutes DECIMAL(8, 2),
    NumberOfPagesVisited INT,
    ItemsAddedToCart INT,
    ItemsRemovedFromCart INT,
    DeviceUsed NVARCHAR(20)
);

-- 6. Marketing Campaigns
CREATE TABLE dbo.MarketingCampaigns (
    InteractionID INT PRIMARY KEY IDENTITY(1,1),
    CampaignID INT,
    CampaignName NVARCHAR(100),
    CustomerID INT FOREIGN KEY REFERENCES dbo.CustomerInformation(CustomerID),
    CampaignMedium NVARCHAR(50),
    EngagementLevel NVARCHAR(20),
    ConversionStatus NVARCHAR(20)
);
GO

PRINT '--- Tables created successfully. ---';

-- =================================================================================
-- Section 2: Data Population
-- Populating tables with realistic, randomized data.
-- =================================================================================

PRINT '--- Section 2: Populating Data ---';

-- 2.1 Populate ProductDetails (1,458 products)
PRINT 'Populating ProductDetails...';
BEGIN
    DECLARE @i_prod INT = 1;
    DECLARE @TotalProducts INT = 1458;
    
    WHILE @i_prod <= @TotalProducts
    BEGIN
        DECLARE @Category NVARCHAR(50), @Subcategory NVARCHAR(50), @BrandName NVARCHAR(50), @Price DECIMAL(10, 2);
        DECLARE @cat_rand FLOAT = RAND();
        
        IF @cat_rand < 0.25
        BEGIN
            SET @Category = 'Electronics';
            SET @BrandName = (SELECT TOP 1 v.Brand FROM (VALUES ('ElectroBrand'), ('TechGiant'), ('GadgetPro')) v(Brand) ORDER BY NEWID());
            SET @Subcategory = (SELECT TOP 1 v.Subcat FROM (VALUES ('Smartphones'), ('Laptops'), ('Headphones')) v(Subcat) ORDER BY NEWID());
            SET @Price = 150 + RAND() * 1850;
        END
        ELSE IF @cat_rand < 0.5
        BEGIN
            SET @Category = 'Clothing';
            SET @BrandName = (SELECT TOP 1 v.Brand FROM (VALUES ('UrbanWear'), ('ClassicFits'), ('EcoThreads')) v(Brand) ORDER BY NEWID());
            SET @Subcategory = (SELECT TOP 1 v.Subcat FROM (VALUES ('T-Shirts'), ('Jeans'), ('Jackets')) v(Subcat) ORDER BY NEWID());
            SET @Price = 20 + RAND() * 280;
        END
        ELSE IF @cat_rand < 0.75
        BEGIN
            SET @Category = 'Home & Kitchen';
            SET @BrandName = (SELECT TOP 1 v.Brand FROM (VALUES ('HomeEssentials'), ('KitchenWiz'), ('CozyLiving')) v(Brand) ORDER BY NEWID());
            SET @Subcategory = (SELECT TOP 1 v.Subcat FROM (VALUES ('Cookware'), ('Bedding'), ('Decor')) v(Subcat) ORDER BY NEWID());
            SET @Price = 15 + RAND() * 485;
        END
        ELSE
        BEGIN
            SET @Category = 'Beauty & Health';
            SET @BrandName = (SELECT TOP 1 v.Brand FROM (VALUES ('GlowUp'), ('PureHealth'), ('VitaBoost')) v(Brand) ORDER BY NEWID());
            SET @Subcategory = (SELECT TOP 1 v.Subcat FROM (VALUES ('Skincare'), ('Vitamins'), ('Makeup')) v(Subcat) ORDER BY NEWID());
            SET @Price = 10 + RAND() * 190;
        END
        
        INSERT INTO dbo.ProductDetails (ProductName, Category, Subcategory, BrandName, Price, StockAvailability)
        VALUES (
            CONCAT(@BrandName, ' ', @Subcategory, ' Model #', @i_prod),
            @Category,
            @Subcategory,
            @BrandName,
            CAST(@Price AS DECIMAL(10, 2)),
            CAST(RAND() * 500 AS INT)
        );
        SET @i_prod = @i_prod + 1;
    END
END;
GO

-- 2.2 Populate CustomerInformation (12,500 customers)
PRINT 'Populating CustomerInformation...';
BEGIN
    DECLARE @i_cust INT = 1;
    DECLARE @TotalCustomers INT = 12500;
    
    WHILE @i_cust <= @TotalCustomers
    BEGIN
        DECLARE @FirstName NVARCHAR(50) = (SELECT TOP 1 v.Name FROM (VALUES ('John'), ('Jane'), ('Peter'), ('Emily'), ('Chris'), ('Sarah'), ('David'), ('Laura')) v(Name) ORDER BY NEWID());
        DECLARE @LastName NVARCHAR(50) = (SELECT TOP 1 v.Name FROM (VALUES ('Smith'), ('Doe'), ('Jones'), ('Williams'), ('Brown'), ('Garcia'), ('Miller'), ('Davis')) v(Name) ORDER BY NEWID());
        DECLARE @Gender NVARCHAR(10) = (SELECT TOP 1 v.Gender FROM (VALUES ('Male'), ('Female'), ('Other')) v(Gender) ORDER BY NEWID());
        
        INSERT INTO dbo.CustomerInformation (FirstName, LastName, EmailAddress, LocationCity, LocationState, LocationCountry, Gender, AgeGroup)
        VALUES (
            @FirstName,
            @LastName,
            LOWER(CONCAT(@FirstName, '.', @LastName, @i_cust, '@example.com')),
            (SELECT TOP 1 v.City FROM (VALUES ('New York'), ('London'), ('Sydney'), ('Tokyo'), ('Paris'), ('Berlin'), ('Toronto')) v(City) ORDER BY NEWID()),
            (SELECT TOP 1 v.State FROM (VALUES ('NY'), ('ENG'), ('NSW'), ('TKY'), ('IDF'), ('BE'), ('ON')) v(State) ORDER BY NEWID()),
            (SELECT TOP 1 v.Country FROM (VALUES ('USA'), ('UK'), ('Australia'), ('Japan'), ('France'), ('Germany'), ('Canada')) v(Country) ORDER BY NEWID()),
            @Gender,
            (SELECT TOP 1 v.Age FROM (VALUES ('18-24'), ('25-34'), ('35-44'), ('45-54'), ('55-64'), ('65+')) v(Age) ORDER BY NEWID())
        );
        SET @i_cust = @i_cust + 1;
    END
END;
GO

-- 2.3 Populate OrderDetails and TransactionDetails (54,321 orders)
PRINT 'Populating OrderDetails and TransactionDetails...';
BEGIN
    -- Declare variables needed in this batch
    DECLARE @TotalCustomers INT = 12500;
    DECLARE @TotalProducts INT = 1458;
    DECLARE @i_order INT = 1;
    DECLARE @TotalOrders INT = 54321;
    
    WHILE @i_order <= @TotalOrders
    BEGIN
        DECLARE @OrderID INT, @CustomerID INT, @OrderDate DATETIME, @DeliveryDate DATETIME, @OrderStatus NVARCHAR(20);
        
        -- Skew customer IDs to create returning/VIP customers (lower IDs get more orders)
        SET @CustomerID = CAST(POWER(RAND(), 2) * (@TotalCustomers - 1) AS INT) + 1;
        SET @OrderDate = DATEADD(day, -CAST(RAND() * (365 * 3) AS INT), GETDATE());
        
        SET @OrderStatus = (SELECT TOP 1 v.Status FROM (VALUES ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'),
                                                               ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'), ('Completed'),
                                                               ('Cancelled'), ('Cancelled'), ('Returned'), ('Returned'), ('Pending')) v(Status) ORDER BY NEWID());
        
        -- Set DeliveryDate only for 'Completed' or 'Returned' orders (realistic missing data)
        IF @OrderStatus IN ('Completed', 'Returned')
            SET @DeliveryDate = DATEADD(day, CAST(RAND()*7 AS INT) + 2, @OrderDate);
        ELSE
            SET @DeliveryDate = NULL;
            
        INSERT INTO dbo.OrderDetails (CustomerID, OrderDate, DeliveryDate, OrderStatus, PaymentMethod)
        VALUES (@CustomerID, @OrderDate, @DeliveryDate, @OrderStatus,
            (SELECT TOP 1 v.Method FROM (VALUES ('Credit Card'), ('PayPal'), ('Debit Card'), ('Cash on Delivery')) v(Method) ORDER BY NEWID()));
        
        SET @OrderID = SCOPE_IDENTITY(); -- Get the ID of the order we just created
        
        -- Now create transaction line items for this order (1 to 5 items per order)
        DECLARE @num_items INT = CAST(RAND()*4 AS INT) + 1;
        DECLARE @i_item INT = 1;
        WHILE @i_item <= @num_items
        BEGIN
            -- Declare @ProductID here to fix the "Must declare" error
            DECLARE @ProductID INT = CAST(RAND() * (@TotalProducts - 1) AS INT) + 1;
            DECLARE @ProductPrice DECIMAL(10, 2);
            SELECT @ProductPrice = Price FROM dbo.ProductDetails WHERE ProductID = @ProductID;
            
            -- Create outliers in quantity (e.g., a few bulk purchases)
            DECLARE @Quantity INT = CASE WHEN RAND() < 0.01 THEN CAST(RAND()*50 AS INT) + 10 ELSE CAST(RAND()*3 AS INT)+1 END;
            
            -- Apply discount with a higher probability for VIPs (to be updated later)
            DECLARE @Discount DECIMAL(10, 2) = CASE WHEN RAND() > 0.9 THEN (@ProductPrice * @Quantity * (RAND()*0.2 + 0.05)) ELSE 0 END;
            DECLARE @TotalPrice DECIMAL(10, 2) = (@ProductPrice * @Quantity) - @Discount;
            DECLARE @Tax DECIMAL(10, 2) = @TotalPrice * 0.08; -- 8% tax rate
            
            INSERT INTO dbo.TransactionDetails (OrderID, ProductID, QuantityOrdered, TotalPrice, DiscountsApplied, TaxApplied)
            VALUES (@OrderID, @ProductID, @Quantity, @TotalPrice, @Discount, @Tax);
            
            SET @i_item = @i_item + 1;
        END
        
        SET @i_order = @i_order + 1;
    END
END;
GO

-- 2.4 Update CustomerType and Discounts based on logical correlation
PRINT 'Updating CustomerType and Discounts for logical correlation...';
BEGIN
    -- Update CustomerType
    WITH CustomerSpending AS (
        SELECT
            o.CustomerID,
            COUNT(DISTINCT o.OrderID) AS OrderCount,
            SUM(t.TotalPrice) AS TotalSpend
        FROM dbo.OrderDetails o
        JOIN dbo.TransactionDetails t ON o.OrderID = t.OrderID
        WHERE o.OrderStatus = 'Completed'
        GROUP BY o.CustomerID
    )
    UPDATE c
    SET CustomerType = CASE
        WHEN cs.TotalSpend > 5000 OR cs.OrderCount > 15 THEN 'VIP'
        WHEN cs.OrderCount > 1 THEN 'Returning'
        ELSE 'New'
    END
    FROM dbo.CustomerInformation c
    JOIN CustomerSpending cs ON c.CustomerID = cs.CustomerID;
    
    -- Update Discounts for VIPs
    UPDATE td
    SET DiscountsApplied = td.TotalPrice * (RAND() * 0.3 + 0.1) -- 10-40% discount
    FROM dbo.TransactionDetails td
    JOIN dbo.OrderDetails od ON td.OrderID = od.OrderID
    JOIN dbo.CustomerInformation ci ON od.CustomerID = ci.CustomerID
    WHERE ci.CustomerType = 'VIP' AND td.DiscountsApplied = 0 AND RAND() > 0.5; -- 50% chance for a discount on a VIP order
END;
GO


-- 2.5 Populate WebsiteInteractionMetrics (e.g., 50,000 sessions)
PRINT 'Populating WebsiteInteractionMetrics...';
BEGIN
    -- Declare variables needed in this batch
    DECLARE @TotalCustomers INT = 12500;
    DECLARE @i_sess INT = 1;
    DECLARE @TotalSessions INT = 50000;
    
    WHILE @i_sess <= @TotalSessions
    BEGIN
        DECLARE @CustID_Sess INT = CAST(RAND() * (@TotalCustomers - 1) AS INT) + 1;
        DECLARE @PagesVisited INT = CAST(RAND() * 25 AS INT) + 1;
        DECLARE @ItemsAdded INT = CASE WHEN RAND() > 0.3 THEN CAST(RAND() * 5 AS INT) ELSE 0 END;
        
        INSERT INTO dbo.WebsiteInteractionMetrics (CustomerID, SessionDurationMinutes, NumberOfPagesVisited, ItemsAddedToCart, ItemsRemovedFromCart, DeviceUsed)
        VALUES (
            @CustID_Sess,
            @PagesVisited * (RAND() * 1.5 + 0.5), -- Duration correlated with pages visited
            @PagesVisited,
            @ItemsAdded,
            CASE WHEN @ItemsAdded > 0 AND RAND() > 0.7 THEN CAST(RAND() * @ItemsAdded AS INT) ELSE 0 END, -- Remove some of the added items
            (SELECT TOP 1 v.Device FROM (VALUES ('Mobile'), ('Desktop'), ('Tablet')) v(Device) ORDER BY NEWID())
        );
        SET @i_sess = @i_sess + 1;
    END
END;
GO

-- 2.6 Populate MarketingCampaigns (e.g., 20,000 interactions)
PRINT 'Populating MarketingCampaigns...';
BEGIN
    -- Declare variables needed in this batch
    DECLARE @TotalCustomers INT = 12500;
    DECLARE @i_mark INT = 1;
    DECLARE @TotalInteractions INT = 20000;
    
    WHILE @i_mark <= @TotalInteractions
    BEGIN
        DECLARE @CampaignID INT = CAST(RAND()*5 AS INT) + 1;
        DECLARE @CustomerID_Mark INT = CAST(RAND() * (@TotalCustomers - 1) AS INT) + 1;
        DECLARE @CustomerType_Mark NVARCHAR(20);
        SELECT @CustomerType_Mark = CustomerType FROM dbo.CustomerInformation WHERE CustomerID = @CustomerID_Mark;
        
        DECLARE @EngagementLevel NVARCHAR(20);
        DECLARE @ConversionStatus NVARCHAR(20) = 'Not Converted';
        
        SET @EngagementLevel = (SELECT TOP 1 v.Level FROM (VALUES ('Ignored'), ('Opened'), ('Clicked')) v(Level) ORDER BY NEWID());
        
        -- Correlation: Higher engagement and VIP status leads to higher conversion chance
        IF @EngagementLevel = 'Clicked' AND RAND() < (CASE WHEN @CustomerType_Mark = 'VIP' THEN 0.8 ELSE 0.3 END)
            SET @ConversionStatus = 'Converted';
        IF @EngagementLevel = 'Opened' AND RAND() < (CASE WHEN @CustomerType_Mark = 'VIP' THEN 0.5 ELSE 0.1 END)
            SET @ConversionStatus = 'Converted';
        
        INSERT INTO dbo.MarketingCampaigns (CampaignID, CampaignName, CustomerID, CampaignMedium, EngagementLevel, ConversionStatus)
        VALUES (
            @CampaignID,
            (SELECT TOP 1 v.Name FROM (VALUES ('Summer Sale 2024'), ('Black Friday 2023'), ('New Year Bonanza 2025'), ('Spring Refresh 2024'), ('Welcome Discount')) v(Name)), -- Removed the incorrect WHERE clause here
            @CustomerID_Mark,
            (SELECT TOP 1 v.Medium FROM (VALUES ('Email'), ('SMS'), ('Social Media')) v(Medium) ORDER BY NEWID()),
            @EngagementLevel,
            @ConversionStatus
        );
        SET @i_mark = @i_mark + 1;
    END
END;
GO

PRINT '--- All tables populated successfully. ---';
PRINT '--- SCRIPT COMPLETE ---';
GO


select * from
[dbo].[CustomerInformation]

select * from
[dbo].[MarketingCampaigns]

select * from
[dbo].[OrderDetails]

select * from
[dbo].[ProductDetails]

select * from
[dbo].[TransactionDetails]

select * from
[dbo].[WebsiteInteractionMetrics]


GO
USE EcommerceDB;
GO

SELECT
orders.OrderID,
orders.CustomerID,
orders.[OrderDate],
orders.[DeliveryDate],
orders.OrderStatus,
orders.PaymentMethod,
trans.TransactionID,
trans.ProductID,
trans.QuantityOrdered,
trans.Totalprice,
trans.DiscountsApplied,
trans.TaxApplied
FROM [dbo].[OrderDetails] as orders
JOIN [dbo].[TransactionDetails] as trans
	ON orders.OrderID = trans.orderID
