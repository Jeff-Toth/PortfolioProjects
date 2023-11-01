--Covid Data Exploration
--Skills used: Window's Functions, Aggregate Functions, Data Type Conversions, CTE's, Temp Tables, Creating Views


--Initial check to see if data was loaded

SELECT *
FROM dbo.CovidDeaths
order by 3, 4

SELECT *
FROM dbo.CovidVaccinations
order by 3, 4

--ALTER TABLE PortfolioProject.dbo.CovidDeaths
--ALTER COLUMN total_deaths float;



--Selected data that we are going to start with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM dbo.CovidDeaths
WHERE continent is not null
order by 1, 2



--Total Cases vs. Total Deaths
--Shows the likelihood of dying if contracting Covid in the United States

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE location like '%states%' and continent is not null
order by 1, 2



--Total Cases vs. Population
--Shows the percentage of the population infected with Covid in the United States

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
WHERE location like '%states%'
order by 1, 2



--Countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
GROUP BY population, location
order by PercentPopulationInfected desc



--Countries with the highest death count per population

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc



--BREAKDOWN BY CONTINENT

--Continents with highest death count per population

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM dbo.CovidDeaths
WHERE continent is not null and location not like '%income%'
GROUP BY continent
ORDER BY TotalDeathCount desc



--Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE continent is not null and new_cases > 0
group by date
order by 1, 2



--Total Population vs. Vaccinations
--Shows Percentage of Population that recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3



--Using CTE to perform Partition by Calculation in previous query

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac



----Using Temp Table to perform Partition by Calculation in previous query

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



--Create View to store for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM dbo.CovidDeaths dea
JOIN dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3


SELECT *
FROM PercentPopulationVaccinated