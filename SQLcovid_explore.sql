-- I used SQL server input and export wizard to import two datasets
-- the datasets came from ourworldindata.org
-- one dataset is about covid deaths and the other is about testing and vaccinations
-- both datasets include information about continent and countries as well as various states in the USA on an observation by 
-- observation basis 


SELECT * -- Select all
FROM porfolio_project.dbo.covid_deaths -- from the dataset covid_deaths under porfolio_project
ORDER BY 3,4 -- order by thrid and fourth column; in this case, this is the location and date

SELECT * -- Select all
FROM porfolio_project.dbo.covid_vaccinations
ORDER BY 3,4 

-- Table showing location, date, total cases in that location, new cases per obervation, cumulative total deaths and 
-- total population
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM porfolio_project.dbo.covid_deaths
ORDER BY 1, 2 -- order by the first and second column; in this case this is location and date

-- Probability of dying from infection based on date and location

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_per_case -- percentage
FROM porfolio_project.dbo.covid_deaths
WHERE location like '%states%' -- locations that include the string "states"
ORDER BY 1, 2

-- Probability of getting infected from covid based on date and location

SELECT location, date, total_cases, population, (total_cases/population)*100 AS case_percent
FROM porfolio_project.dbo.covid_deaths
WHERE location like '%states%'
ORDER BY 1, 2

-- Countries with highest infection rate as percent of population and number of total infections by country

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS infected_pop
FROM porfolio_project.dbo.covid_deaths
-- WHERE location like '%states%'
GROUP BY location, population -- group like observations together based on their location
ORDER BY 4 DESC -- order by infected population rate in descending order


-- Countries with the highest death counts in descending order

SELECT location,MAX(CAST(total_deaths AS INT)) AS total_death_count -- you have to cast it because it is using 
-- a specific data type other than an integer
-- you then get the max deaths per location
FROM porfolio_project.dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Breaking things down by continent,income levels, and economic region

SELECT location,MAX(CAST(total_deaths AS INT)) AS total_death_count -- you have to cast it because it is using 
-- a specific data type other than an integer
FROM porfolio_project.dbo.covid_deaths
WHERE continent IS NULL 
GROUP BY location
ORDER BY total_death_count DESC

-- Breaking things down by continent
SELECT continent ,MAX(CAST(total_deaths AS INT)) AS total_death_count -- you have to cast it because it is using 
-- a specific data type other than an integer
FROM porfolio_project.dbo.covid_deaths
WHERE continent IS NOT NULL -- only refer to continents
GROUP BY continent
ORDER BY total_death_count DESC

-- Global cases, deaths, and percent of cases resulting in deaths at any given date

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS death_percent -- (total_deaths/total_cases)*100 AS death_percent
FROM porfolio_project.dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Global max of cases, deaths, and average percent of cases resulting in deaths

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS death_percent--, (total_deaths/total_cases)*100 AS death_percent
FROM porfolio_project.dbo.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- Total population vs vaccinations

SELECT death.continent, death.location ,death.date, death.population, vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS running_total_vacc 
-- partition by location because you want the count to start over when reaching a new location
FROM porfolio_project.dbo.covid_deaths AS death --Left JOIN
JOIN porfolio_project.dbo.covid_vaccinations AS vacc -- Right JOIN
	ON death.location = vacc.location -- JOIN on location; common column
	AND death.date = vacc.date -- and join on date; common column
WHERE death.continent IS NOT NULL -- continent is marked as null only if the location is refering to a specific economic region
ORDER BY 2,3 

-- same query but with Common Table Expression or CTE for short

WITH POPvsVAC (Continent, Location, Date, Population, New_vaccinations, running_total_vacc)
AS (
SELECT death.continent, death.location ,death.date, death.population, vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations AS BIGINT)) OVER (PARTITION BY death.location ORDER BY death.location, 
death.date) AS running_total_vacc 
-- partition by location because you want the count to start over when reaching a new location
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL
)
SELECT *, (running_total_vacc/population) * 100 AS percent_vaccinated
FROM POPvsVAC

-- TEMP TABLE ; to create a table but not store it in the database 
-- Create empty table and insert values into it

DROP TABLE IF exists #percent_population_vaccinated -- Done to automatically refresh the existing table with same name
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
death.date) AS running_total_vacc 
-- partition by location because you want the count to start over when reaching a new location
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
SELECT death.location, death.date, death.population, death.total_cases, death.total_deaths, (death.total_deaths/death.population)*1000000 AS deaths_per_million
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL and death.location = 'United States'
ORDER BY death.location ,death.date

-- Total cases per million in the US

SELECT death.location, death.date, death.population, death.total_cases, death.total_deaths, (death.total_cases/death.population)*1000000 AS cases_per_million
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL and death.location = 'United States'
ORDER BY death.location ,death.date


-- Total cases per million per country in descending order; worst effected countries

SELECT death.location, death.population, MAX((death.total_cases/death.population)) * 1000000 AS cases_per_mil
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL 
GROUP BY death.location, death.population
ORDER BY cases_per_mil DESC

----------
-- Total tests per capita in the US

SELECT vacc.location, vacc.date, death.population, vacc.total_tests, (vacc.total_tests/death.population) * 100 AS tests_relative_to_pop
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL and death.location = 'United States'
ORDER BY death.location ,death.date

-- Total tests per capita per country and ; very important because it indicates whether a country is undercounting 
-- covid cases

SELECT death.location, death.population, MAX(death.total_cases) AS total_cases,MAX(vacc.total_tests) AS total_tests, MAX((vacc.total_tests/death.population)) AS tests_per_person, MAX(vacc.total_tests)/MAX(death.total_cases) AS tests_per_case
FROM porfolio_project.dbo.covid_deaths AS death
JOIN porfolio_project.dbo.covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent IS NOT NULL 
GROUP BY death.location, death.population
-- ORDER BY tests_relative_to_pop DESC
ORDER BY tests_per_case DESC



------------



