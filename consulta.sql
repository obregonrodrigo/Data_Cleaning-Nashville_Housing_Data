
USE NashvilleHouses

SELECT * 
FROM NashvilleHouses.dbo.NashivilleHousing

-- Formatando SaleDate
SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM NashvilleHouses.dbo.NashivilleHousing

UPDATE NashivilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashivilleHousing
ADD SaleDateConverted Date

UPDATE NashivilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Preenchimento de dados de endereço da propriedade
SELECT *
FROM NashvilleHouses.dbo.NashivilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHouses.dbo.NashivilleHousing a
JOIN NashvilleHouses.dbo.NashivilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHouses.dbo.NashivilleHousing a
JOIN NashvilleHouses.dbo.NashivilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Dividindo o endereço em colunas individuais (Endereço, cidade, estado)
SELECT PropertyAddress
FROM NashvilleHouses.dbo.NashivilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Endereco,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Cidade
FROM NashvilleHouses.dbo.NashivilleHousing

ALTER TABLE NashivilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashivilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashivilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashivilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * 
FROM NashvilleHouses.dbo.NashivilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.') ,3) AS Endereco,
PARSENAME(REPLACE(OwnerAddress,',','.') ,2) AS Cidade,
PARSENAME(REPLACE(OwnerAddress,',','.') ,1) AS Estado
FROM NashvilleHouses.dbo.NashivilleHousing

ALTER TABLE NashivilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashivilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE NashivilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashivilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE NashivilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashivilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

SELECT * 
FROM NashvilleHouses.dbo.NashivilleHousing

-- Alterar o campo 'SoldAsVacant' de Y para Yes e N para No
-- Atualmente a coluna possui tanto Y quanto Yes e N quanto No
SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHouses.dbo.NashivilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM NashvilleHouses.dbo.NashivilleHousing

UPDATE NashivilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

-- Remoção de itens duplicados
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
				) row_num

FROM NashvilleHouses.dbo.NashivilleHousing
) 
SELECT *
-- DELETE
FROM RowNumCTE
WHERE row_num > 1
