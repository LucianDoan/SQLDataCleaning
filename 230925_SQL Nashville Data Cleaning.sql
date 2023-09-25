Use CompanyDB
GO

/* Format date */
ALTER TABLE Nashville
Add SaleDateConverted Date

Update Nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)

ALTER TABLE Nashville
Drop Column SaleDate

Select *
From Nashville

/* Fill in NULL value in PropertyAddress */
/* PropertyAddress must be the same for those having the identical ParcelID */
/* Using Left Join the same table, utilize the UniqueID Column */
Select Distinct a.ParcelID, a.PropertyAddress, b.PropertyAddress
From Nashville as a
Left Join Nashville as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville as a
Left Join Nashville as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

SELECT *
FROM Nashville

/* Break PropertyAddress into AddressCity & State Columns*/
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as AddressCity, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as AddressState
FROM Nashville

ALTER TABLE Nashville
Add CityAddress Nvarchar(255)

Update Nashville
SET CityAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Nashville
Add StateAddress Nvarchar(255)

Update Nashville
SET StateAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM Nashville

/* Change Y into Yes, N into No at SoldAsVacant Column */
Update Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

SELECT * 
FROM Nashville

/* Delete Unused Column */
ALTER TABLE Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

SELECT *
FROM Nashville