use farmmarketdb;

--  Q2. For each crop type, calculate the average market price and sort in descending order.
SELECT Product, AVG(Market_Price_per_ton) AS AvgMarketPrice
FROM market_researcher_dataset
GROUP BY Product
ORDER BY AvgMarketPrice DESC;

--  Q5. List all crops where the max and min market prices differ by more than ₹10 per ton.
SELECT Product
FROM market_researcher_dataset
GROUP BY Product
HAVING MAX(Market_Price_per_ton) - MIN(Market_Price_per_ton) > 10;

--  Q7. Rank crops by profit per unit (assume: market price - average fertilizer usage as cost) using RANK().
SELECT 
    f.Crop_Type,
    AVG(m.Market_Price_per_ton - f.Fertilizer_Usage_kg) AS ProfitPerUnit,
    RANK() OVER (ORDER BY AVG(m.Market_Price_per_ton - f.Fertilizer_Usage_kg) DESC) AS RankByProfit
FROM farmer_advisor_dataset f
JOIN market_researcher_dataset m
    ON f.Crop_Type = m.Product
GROUP BY f.Crop_Type;

--  Q8. Identify crops where the current market price is more than 20% above the average across all markets.
SELECT Product, Market_Price_per_ton
FROM market_researcher_dataset
WHERE Market_Price_per_ton > 1.2 * (
    SELECT AVG(Market_Price_per_ton)
    FROM market_researcher_dataset AS sub
    WHERE sub.Product = market_researcher_dataset.Product
);

--  Q12. Create a new column that classifies crop yield as Low, Medium, or High, and count the number of crops in each category.
SELECT 
  CASE 
    WHEN Crop_Yield_ton < 2 THEN 'Low'
    WHEN Crop_Yield_ton BETWEEN 2 AND 5 THEN 'Medium'
    ELSE 'High'
  END AS YieldCategory,
  COUNT(*) AS CropCount
FROM farmer_advisor_dataset
GROUP BY YieldCategory;

--  Q15. Identify if any farmer has duplicate crop entries (by Crop_Type).
SELECT Crop_Type, COUNT(*) AS NumEntries
FROM farmer_advisor_dataset
GROUP BY Crop_Type
HAVING COUNT(*) > 1;

--  Q16. List all crops grown by farmers that are not listed in the market dataset.
SELECT DISTINCT f.Crop_Type
FROM farmer_advisor_dataset f
LEFT JOIN market_researcher_dataset m
    ON f.Crop_Type = m.Product
WHERE m.Product IS NULL;

--  Q19. List all distinct crop types (as we don’t have Advisor info).
SELECT Crop_Type, COUNT(*) AS Frequency
FROM farmer_advisor_dataset
GROUP BY Crop_Type
HAVING COUNT(DISTINCT Crop_Type) > 5;