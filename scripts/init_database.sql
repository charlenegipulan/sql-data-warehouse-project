-- Create Database and Schemas

-- Purpose: 
--   Creates a new db after checking if it already exists

-- Warning: 
--   Running this script will drop the enture 'DataWarehouse' db. 
--   All data will be permanently deleted. Proceed with caution and 
--   ensure you have proper backup

USE master;

GO

-- Drop and recreate the Datawarehouse database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
