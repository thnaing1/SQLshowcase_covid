-- USED SQL server input and export wizard to import two datasets
-- the datasets came from ourworldindata.org



--SELECT *
--FROM porfolio_project.dbo.covid_deaths
--ORDER BY 3,4 

--SELECT *
--FROM porfolio_project.dbo.covid_vaccinations
--ORDER BY 3,4 

--

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM porfolio_project.dbo.covid_deaths
ORDER BY 1, 2

-- Probability of dying from infection 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_per_case
FROM porfolio_project.dbo.covid_deaths
WHERE location like '%states%'
ORDER BY 1, 2

-- Probability of getting infected from covid

SELECT location, date, total_cases, population, (total_cases/population)*100 AS case_percent
FROM porfolio_project.dbo.covid_deaths
WHERE location like '%states%'
ORDER BY 1, 2

-- Countries with highest infection rate as percent of population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS infected_pop
FROM porfolio_project.dbo.covid_deaths
-- WHERE location like '%states%'
GROUP BY location, population
ORDER BY 4 DESC

-- Countries with the highest death counts in descending order

SELECT location,MAX(CAST(total_deaths AS INT)) AS total_death_count -- you have to cast it because it is using 
-- a specific data type other than an integer
FROM porfolio_project.dbo.covid_deaths
-- WHERE location like '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Breaking things down by continent,income levels, and economic region

SELECT location,MAX(CAST(total_deaths AS INT)) AS total_death_count -- you have to cast it because it is using 
-- a specific data type other than an integer
FROM porfolio_project.dbo.covid_deaths
-- WHERE location like '%states%'
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Breaking things down by continent
SELECT continent ,MAX(CAST(total_deaths AS INT)) AS total_death_count -- you have to cast it because it is using 
-- a specific data type other than an integer
FROM porfolio_project.dbo.covid_deaths
-- WHERE location like '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- Global cases, deaths, and percent of cases resulting in deaths at any given date
--*
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS death_percent--, (total_deaths/total_cases)*100 AS death_percent
FROM porfolio_project.dbo.covid_deaths
--WHERE location like '%states%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Global max of cases, deaths, and average percent of cases resulting in deaths

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS death_percent--, (total_deaths/total_cases)*100 AS death_percent
FROM porfolio_project.dbo.covid_deaths
--WHERE location like '%states%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2

-- Total population vs vaccinations

SELECT death.continent, death.location ,death.date, death.population, vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS running_total_vacc -- partition by location because you want the count to
-- start over when reaching a new location
--, (running_total_vacc/population)*100
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL
ORDER BY 2,3 

-- with CTE

WITH POPvsVAC (Continent, Location, Date, Population, New_vaccinations, running_total_vacc)
AS (
SELECT death.continent, death.location ,death.date, death.population, vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, 
death.date) AS running_total_vacc -- partition by location because you want the count to
-- start over when reaching a new location
--, (running_total_vacc/population)*100
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL
)
SELECT *, (running_total_vacc/population) * 100 AS percent_vaccinated
FROM POPvsVAC

-- TEMP TABLE - want to create a table but not store it in the database 

DROP TABLE IF exists #percent_population_vaccinated
CREATE TABLE #percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
running_total_vacc numeric
)

INSERT INTO #percent_population_vaccinated 
SELECT death.continent, death.location ,death.date, death.population, vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, 
death.date) AS running_total_vacc -- partition by location because you want the count to
-- start over when reaching a new location
--, (running_total_vacc/population)*100
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL

SELECT *, (running_total_vacc/population) * 100 AS percent_vaccinated
FROM #percent_population_vaccinated

-- Creating view to store data for later visualizations

USE porfolio_project   -- the function USE allows you to change databases

CREATE VIEW percent_population_vaccinated AS 
SELECT death.continent, death.location ,death.date, death.population, vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, 
death.date) AS running_total_vacc -- partition by location because you want the count to
-- start over when reaching a new location
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL

SELECT *
FROM percent_population_vaccinated


--------------------------- 

-- Total Deaths per million in the US
SELECT death.continent, death.location, death.date, death.population, death.total_cases, death.total_deaths, (death.total_deaths/death.population)*1000000 AS deaths_per_million
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL and death.location = 'United States'
ORDER BY death.location ,death.date

-- total cases per million in the US

SELECT death.continent, death.location, death.date, death.population, death.total_cases, death.total_deaths, (death.total_cases/death.population)*1000000 AS cases_per_million
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL and death.location = 'United States'
ORDER BY death.location ,death.date


-- total cases per million per country

SELECT death.location, death.population, MAX((death.total_cases/death.population)) * 1000000 AS cases_per_mil
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL 
GROUP BY death.location, death.population
ORDER BY cases_per_mil

----------
-- total tests per capita

SELECT vacc.continent, vacc.location, vacc.date, death.population, vacc.total_tests, (vacc.total_tests/death.population) * 100 AS tests_relative_to_pop
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL and death.location = 'United States'
ORDER BY death.location ,death.date

-- total tests per capita per country; very important because it indicates whether a country is undercounting 
-- covid cases or deaths

SELECT death.location, death.population, MAX((vacc.total_tests/death.population)) * 100 AS tests_relative_to_pop
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL --AND death.location = 'Brazil'
GROUP BY death.location, death.population
ORDER BY tests_relative_to_pop

--ORDER BY death.location, tests_relative_to_pop


------------



