--Glimpses through the Dataset

select SaleDate, CONVERT(Date, SaleDate) As SalesDate
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add SalesDate Date

update NashvilleHousing
set SalesDate = CONVERT(Date, SaleDate)

--Populating the PropertyAdress when it is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Using Substrings to Split the Property Address Column
select PropertyAddress
,SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as City
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table NashvilleHousing
add PropertyCity Nvarchar(255)

update NashvilleHousing
set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))


--Using the ParseName and Replace functions to Split the Owner's Address

 select 
 PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
 ,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
 ,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
 from PortfolioProject.dbo.NashvilleHousing
 where OwnerAddress is not null

 alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

select * 
from PortfolioProject.dbo.NashvilleHousing

--Change Y and N into Yes and No in 'Sold as Vacant field'

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject.dbo.NashvilleHousing

--Removing Duplicates Using CTE

WITH Duplicates as(
select *,
	row_number() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) Row_num
from PortfolioProject.dbo.NashvilleHousing
)
select *
from Duplicates
where Row_num > 1
order by PropertyAddress

select * 
from PortfolioProject.dbo.NashvilleHousing

--THE END!!!!
