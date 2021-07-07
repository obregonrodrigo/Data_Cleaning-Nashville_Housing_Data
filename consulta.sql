
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