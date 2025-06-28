-- Cleansed DIM_Customers Table --
SELECT 
  c.CustomerKey AS CustomerKey, 
  --,[GeographyKey]
  --,[CustomerAlternateKey]
  --,[Title]
  c.firstname AS [First Name], 
  --[MiddleName]
  c.LastName AS [Last Name], 
  c.firstname + ' ' + c.lastname AS [Full Name], 
  --Combined First Name and Last Name
  --,[NameStyle]
  --,[BirthDate]
  --,[MaritalStatus]
  --,[Suffix]
  CASE c.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender, 
  --,[EmailAddress]
  --,[YearlyIncome]
  --,[TotalChildren]
  --,[NumberChildrenAtHome]
  --,[EnglishEducation]
  --,[SpanishEducation]
  --,[FrenchEducation]
  --,[EnglishOccupation]
  --,[SpanishOccupation]
  --,[FrenchOccupation]
  --,[HouseOwnerFlag]
  --,[NumberCarsOwned]
  --,[AddressLine1]
  --,[AddressLine2]
  --,[Phone]
  c.DateFirstPurchase AS DateFirstPurchase, 
  --,[CommuteDistance]
  g.City AS [Customer City] -- Joined in Customer City from Geography Table
FROM 
  dbo.DimCustomer AS c 
  LEFT JOIN dbo.DimGeography AS g ON c.GeographyKey = g.GeographyKey 
ORDER BY 
  CustomerKey ASC -- Ordered List by CustomerKey



