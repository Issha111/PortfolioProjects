select *
from PortfolioProject.dbo.NashvilleHousing

--date format
select SaleDateConverted ,COnvert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate =convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
set SaleDateConverted =Convert(Date,SaleDate)


--propert Address

select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelId


select a.ParcelId,a.PropertyAddress,b.ParcelID,
b.PropertyAddress,Isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelId=b.ParcelId
and a.UniqueId<>b.UniqueId
where a.PropertyAddress is null

update a
set PropertyAddress=Isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelId=b.ParcelId
and a.UniqueId<>b.UniqueId
where a.PropertyAddress is null


--address breaking

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing


select 
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address
,substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertSplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertSplitAddress =substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertSplitCity Nvarchar(255);

Update NashvilleHousing
set PropertSplitCity =substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing

 --owner address

 select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
parsename(replace(OwnerAddress,',','.'),3)
,parsename(replace(OwnerAddress,',','.'),2)
,parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing
where OwnerAddress is not null


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress =parsename(replace(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity =parsename(replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplit Nvarchar(255);

Update NashvilleHousing
set OwnerSplit =parsename(replace(OwnerAddress,',','.'),1)

select *
from PortfolioProject.dbo.NashvilleHousing

--changing Y and N

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, CASE when SoldAsVacant ='Y' THEN 'Yes'
when SoldAsVacant='N' THEN 'No'
else SoldAsVacant
end

from PortfolioProject.dbo.NashvilleHousing
where SoldAsVacant='Y'



UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant ='Y' THEN 'Yes'
when SoldAsVacant='N' THEN 'No'
else SoldAsVacant
end

--dupliactes

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 --PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

