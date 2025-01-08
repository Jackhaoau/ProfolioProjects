/*
Cleansing Date in SQL quires
*/
USE TEST
GO
Select * from [Test].[dbo].[VictoriaHousing]
---------------------------------------------------------------------------------------------------

----Standardize Date Format

Select Cast(SaleDate as DATE) as SaleDate
from [Test].[dbo].[VictoriaHousing]

Update [Test].[dbo].[VictoriaHousing]
Set saleDate = Cast(SaleDate as DATE)  --Doesn't work since update is DML can't change column date type, has to use DDL like Alter table.

ALter table [Test].[dbo].[VictoriaHousing]
ALter column SaleDate Date


--------------------------------------------------------------------------------------------------

--Populate Property Address Data

Select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress--UniqueID,  PropertyAddress 

From VictoriaHousing a join VictoriaHousing b

on a.ParcelID = b.ParcelID   and  a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Create unique index U_ID
on [Test].[dbo].[VictoriaHousing] ([UniqueID ])

Create index Par_ID
on [Test].[dbo].[VictoriaHousing] (ParcelID)

Update a
Set a.PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
From VictoriaHousing a join VictoriaHousing b

on a.ParcelID = b.ParcelID   and  a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------------------------------------

--Breaking out Address column  into individual columns(Address, City, State)

Select   Substring(PropertyAddress, 1, Charindex(',',PropertyAddress)-1) as Address,
         --Right(PropertyAddress, Charindex(',', Reverse(PropertyAddress))-1) as City
		 Substring(PropertyAddress,Charindex(',',PropertyAddress)+1, 
		 Len(propertyAddress)-Charindex(',',PropertyAddress)) as City

from VictoriaHousing

ALter table VictoriaHousing
ADD PropertySplitAddress Varchar(255)


Update VictoriaHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',',PropertyAddress)-1) 

ALter table VictoriaHousing
ADD PropertySplitCity Varchar(255)

Update VictoriaHousing
Set PropertySplitCity = Right(PropertyAddress, Charindex(',', Reverse(PropertyAddress))-1)

Select Parsename(Replace(OwnerAddress,',','.'),3),
Parsename(Replace(OwnerAddress,',','.'),2) ,
Parsename(Replace(OwnerAddress,',','.'),1) 

From VictoriaHousing


ALter table VictoriaHousing
ADD OwnerSplitAddress Varchar(255)

Update VictoriaHousing
Set OwnerSplitAddress = Parsename(Replace(OwnerAddress,',','.'),3)

ALter table VictoriaHousing
ADD OwnerSplitCity Varchar(255)

Update VictoriaHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'),2)

ALter table VictoriaHousing
ADD OwnerSplitState Varchar(255)

Update VictoriaHousing
Set OwnerSplitState = Parsename(Replace(OwnerAddress,',','.'),1) 


Select * from VictoriaHousing

---------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant,
   Case when SoldAsVacant='N' then 'No'
        when SoldAsVacant='Y' then 'Yes'
		Else SoldAsVacant END  as NSoldAsVacant

from VictoriaHousing

Update VictoriaHousing

set SoldAsVacant=Case when SoldAsVacant='N' then 'No'
        when SoldAsVacant='Y' then 'Yes'
		Else SoldAsVacant END  
--Verify the update statement
Select Distinct SoldAsVacant,
       Count(SoldAsVacant)
from VictoriaHousing

Group by SoldAsVacant

--------------------------------------------------------------------------------------------

--Remove Duplicates


;With CTE_Rank as 
(
Select  *,
Rank() Over ( Partition By
              ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order By UniqueID) as RankD

from VictoriaHousing)
--Order by RankD DESC)

Select * 

from CTE_Rank
Where RankD>1


;With CTE_Rank as 
(
Select  *,
Row_number() Over ( Partition By
              ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order By UniqueID) as RankD

from VictoriaHousing)
--Order by RankD DESC)

Delete 

from CTE_Rank
Where RankD>1

---------------------------------------------------------------------------------------------

--Delete Unused columns

Alter table VictoriaHousing
Drop column PropertyAddress,OwnerAddress, TaxDistrict


                        


Exec sp_rename 'VictoriaHousing.PropertySplitAddress','PropertyAddress','column'

Exec sp_rename 'VictoriaHousing.PropertySplitCity','PropertySuburb','column'

Exec sp_rename 'VictoriaHousing.OwnerSplitCity','OwnerSuburb','column'
Exec sp_rename 'VictoriaHousing.OwnerSplitState','OwnerState','column'

Select Distinct OwnerState, count(OwnerState)
from VictoriaHousing

Group by OwnerState









