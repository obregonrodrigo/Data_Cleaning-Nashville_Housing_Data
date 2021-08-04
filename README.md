# DATA CLEANING
Nashville Housing Data é uma base de dados disponível no Kaggle. O objetivo aqui é fazer a limpeza dos dados.

<br>Banco de dados utilizado: SQL Server 2019
<br>Fonte de dados: Kagle | https://ourworldindata.org/covid-deaths
<br>Skills: 

<br><b>Data Cleaning</b>
<br>USE NashvilleHouses
<br>SELECT * FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br><b>Formatando o campo Saledate</b>
<br>SELECT SaleDateConverted, CONVERT(Date, SaleDate)
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br>UPDATE NashivilleHousing
<br>SET SaleDate = CONVERT(Date, SaleDate)
<br>
<br>ALTER TABLE NashivilleHousing
<br>ADD SaleDateConverted Date
<br>
<br>UPDATE NashivilleHousing
<br>SET SaleDateConverted = CONVERT(Date, SaleDate)
<br>
<br><b>Preenchimento de dados de endereço da propriedade</b>
<br>SELECT *
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>ORDER BY ParcelID
<br>
<br>SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
<br>FROM NashvilleHouses.dbo.NashivilleHousing a
<br>JOIN NashvilleHouses.dbo.NashivilleHousing b
<br>	ON a.ParcelID = b.ParcelID
<br>	AND a.[UniqueID ]<>b.[UniqueID ]
<br>WHERE a.PropertyAddress IS NULL
<br>
<br>UPDATE a
<br>SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
<br>FROM NashvilleHouses.dbo.NashivilleHousing a
<br>JOIN NashvilleHouses.dbo.NashivilleHousing b
<br>	ON a.ParcelID = b.ParcelID
<br>	AND a.[UniqueID ]<>b.[UniqueID ]
<br>WHERE a.PropertyAddress IS NULL
<br>
<br><b>Dividindo o endereço em colunas individuais (Endereço, cidade, estado)</b>
<br>SELECT PropertyAddress
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br>SELECT 
<br>SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Endereco,
<br>SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Cidade
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br>ALTER TABLE NashivilleHousing
<br>ADD PropertySplitAddress Nvarchar(255)
<br>
<br>UPDATE NashivilleHousing
<br>SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)
<br>
<br>ALTER TABLE NashivilleHousing
<br>ADD PropertySplitCity Nvarchar(255)
<br>
<br>UPDATE NashivilleHousing
<br>SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
<br>
<br>SELECT * 
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br>SELECT
<br>PARSENAME(REPLACE(OwnerAddress,',','.') ,3) AS Endereco,
<br>PARSENAME(REPLACE(OwnerAddress,',','.') ,2) AS Cidade,
<br>PARSENAME(REPLACE(OwnerAddress,',','.') ,1) AS Estado
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br>ALTER TABLE NashivilleHousing
<br>ADD OwnerSplitAddress Nvarchar(255)
<br>
<br>UPDATE NashivilleHousing
<br>SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
<br>
<br>ALTER TABLE NashivilleHousing
<br>ADD OwnerSplitCity Nvarchar(255)
<br>
<br>UPDATE NashivilleHousing
<br>SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
<br>
<br>ALTER TABLE NashivilleHousing
<br>ADD OwnerSplitState Nvarchar(255)
<br>
<br>UPDATE NashivilleHousing
<br>SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
<br>
<br>SELECT * 
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br><b>Alterar o campo 'SoldAsVacant' de Y para Yes e N para No</b>
<br>SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>GROUP BY SoldAsVacant
<br>ORDER BY 2
<br>
<br>SELECT SoldAsVacant,
<br>	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
<br>		 WHEN SoldAsVacant = 'N' THEN 'No'
<br>		 ELSE SoldAsVacant
<br>		 END
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br>UPDATE NashivilleHousing
<br>SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
<br>		 WHEN SoldAsVacant = 'N' THEN 'No'
<br>		 ELSE SoldAsVacant
<br>		 END
<br>
<br><b>Remoção de itens duplicados</b>
<br>WITH RowNumCTE AS(
<br>SELECT *,
<br>	ROW_NUMBER() OVER(
<br>	PARTITION BY ParcelID,
<br>				 PropertyAddress,
<br>				 SalePrice,
<br>				 SaleDate,
<br>				 LegalReference
<br>				 ORDER BY
<br>					UniqueID
<br>				) row_num
<br>
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>) 
<br>SELECT *
<br>-- DELETE
<br>FROM RowNumCTE
<br>WHERE row_num > 1
<br><b>Remoção de colunas não usadas ou duplicadas</b>
<br>SELECT *
<br>FROM NashvilleHouses.dbo.NashivilleHousing
<br>
<br>ALTER TABLE NashvilleHouses.dbo.NashivilleHousing
<br>DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
<br>
<br>ALTER TABLE NashvilleHouses.dbo.NashivilleHousing
<br>DROP COLUMN SaleDate

