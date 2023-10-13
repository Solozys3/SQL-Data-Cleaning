-- Data Cleaning Project

Select * 
from NashvilleHousing

--- Date Formatting ---

Select SaleDate
from NashvilleHousing

Select SaleDateConverted, convert(date, SaleDate)
from NashvilleHousing

Update NashvilleHousing
SET SaleDate = convert(date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = convert(date, SaleDate)


-- Populating Property Address Data --

Select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select UniqueID, ParcelID, PropertyAddress
from NashvilleHousing
--where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
	Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

Update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
	Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


--- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING (PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, charindex(',', PropertyAddress) +1, Len(PropertyAddress)) as City
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(225);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, charindex(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(225);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, charindex(',', PropertyAddress) +1, Len(PropertyAddress))

Select * 
from NashvilleHousing



Select OwnerAddress 
from NashvilleHousing

Select
parsename(Replace(OwnerAddress, ',', '.'), 3),
parsename(Replace(OwnerAddress, ',', '.'), 2),
parsename(Replace(OwnerAddress, ',', '.'), 1) 
from NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerAddressNew nvarchar(225);

Update NashvilleHousing
SET OwnerAddressNew = parsename(Replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerCityNew nvarchar(225);

Update NashvilleHousing
SET OwnerCityNew = parsename(Replace(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerStateNew nvarchar(225);

Update NashvilleHousing
SET OwnerStateNew = parsename(Replace(OwnerAddress, ',', '.'), 1)


--- Y and N to Yes and No in SoldAsVacant Column

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant 
END
From NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = 
CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant 
END


--- Remove Duplicates


WITH RowNumCTE AS(
Select *,
ROW_NUMBER() Over (
	partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by
		UniqueID
		) row_num

From NashvilleHousing
--order  by ParcelID
)
DELETE
from RowNumCTE
where row_num > 1
--order by Propertyaddress

WITH RowNumCTE AS(
Select *,
ROW_NUMBER() Over (
	partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by
		UniqueID
		) row_num

From NashvilleHousing
--order  by ParcelID
)
Select *
from RowNumCTE
where row_num > 1
order by Propertyaddress




--- Delete Unused Columns ---

Select *
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, TaxDistrict, OwnerAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate