
-- DATASET from Kaggle
-- FROM USER Yam Peleg

-- What is the prevelance of non-omnicron variants by country?

SELECT *
FROM portfolio_project_2.dbo.covid_variants AS vari
--WHERE variant like 'B.1%' AND num_sequences <> 0
WHERE vari.variant <> 'Omnicron'
ORDER BY location, date


-- What is the most dominant variant in the US currently?

SELECT vari.variant, SUM(vari.num_sequences) AS us_squence_prevalance 
FROM portfolio_project_2.dbo.covid_variants AS vari
WHERE vari.location = 'United States'
GROUP BY vari.variant
ORDER BY us_squence_prevalance DESC


-- What is the most dominant variants in the world currently?

SELECT vari.variant, SUM(vari.num_sequences) AS global_squence_prevalance 
FROM portfolio_project_2.dbo.covid_variants AS vari
--WHERE variant like 'B.1%' AND num_sequences <> 0
GROUP BY vari.variant
ORDER BY global_squence_prevalance DESC

-- What is the least dominant variants?
SELECT vari.variant, SUM(vari.num_sequences) AS global_squence_prevalance 
FROM portfolio_project_2.dbo.covid_variants AS vari
--WHERE variant like 'B.1%' AND num_sequences <> 0
GROUP BY vari.variant
ORDER BY global_squence_prevalance

-- Total amount of sequences taken for each country

SELECT vari.location, SUM(vari.num_sequences) --OVER (PARTITION BY vari.location) AS total_sequences
FROM portfolio_project_2.dbo.covid_variants AS vari
--WHERE variant like 'B.1%' AND num_sequences <> 0
GROUP BY vari.location
ORDER BY vari.location --, date

-- How many covid variants are there in total?

SELECT COUNT(DISTINCT vari.variant) AS number_of_covid_variants
FROM portfolio_project_2.dbo.covid_variants AS vari

-- In which countries is Omnicron most dominant in? (highest percent_sequences)

SELECT *
FROM portfolio_project_2.dbo.covid_variants AS vari
--WHERE variant like 'B.1%' AND num_sequences <> 0
-- WHERE vari.variant = 'Omicron'
ORDER BY location, date

SELECT vari.location, vari.variant, MAX(vari.perc_sequences) AS omni_presence
FROM portfolio_project_2.dbo.covid_variants AS vari
--WHERE variant like 'B.1%' AND num_sequences <> 0
WHERE vari.variant = 'Omicron'
GROUP BY vari.location, vari.variant
ORDER BY omni_presence DESC

-- What is the prevelance of non-omnicron variants globally?




-- What is the prevelance of non-omnicron variants by country?
SELECT vari.location,(SUM(vari.num_sequences)/MAX(num_sequences_total))
FROM portfolio_project_2.dbo.covid_variants AS vari
--WHERE variant like 'B.1%' AND num_sequences <> 0
WHERE vari.variant <> 'Omicron' --AND vari.location = 'Angola'
GROUP BY vari.location
-- ORDER BY vari.location

-- USE CTE; SUM(DISTINCT ... ) then on the query SUM(num_sequence) where variant = 'omnicron'