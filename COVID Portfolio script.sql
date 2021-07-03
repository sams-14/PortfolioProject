--DATA EXPLORATION OF THE COVID 19 GLOBAL PANDEMIC
SELECT *
FROM PortfolioProject..CovidDeaths
where continent is not null


--GLOBAL CASES, DEATHS AND POPULATION
SELECT location, date, total_cases, total_deaths,new_cases, population 
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Percentage of People that died since the Pandemic In my Country Nigeria

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
FROM PortfolioProject..CovidDeaths
where location = 'Nigeria' 
and continent is not null
order by 1,2

-- Total Cases Vs Population
-- Percentage of the Population infected with Covid In Nigeria

SELECT location, date, total_cases, population, (total_cases/population)*100 As PercentageOfPopulationInfected
FROM PortfolioProject..CovidDeaths
where location = 'Nigeria'
and continent is not null
order by 1,2

--Countries with Highest Infection Rate

SELECT location, Population, Max(cast(total_cases as int)) AS HighestInfectionCount, Max((total_cases/population)*100) As PercentagePopulationInfection
FROM PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by HighestInfectionCount desc

--GLOBAL NUMBERS

SELECT date, sum((new_cases)) AS TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM((new_cases))*100 as GlobalDeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

--Global Numbers as of 30th June 2021
SELECT continent, sum((new_cases)) AS TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM((new_cases))*100 as GlobalDeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by 1


--Data Exploration for Covid Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--Rolling sum of the Total Vaccination Per country
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(Convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) As TotalVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
and dea.location = 'Nigeria'
order by 2, 3


--Using CTE to find the Percentage of Vaccinated People in my country Nigeria
with PopVac (Continent,Location, Date, Population, new_vaccinations, TotalVaccination)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(Convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) As TotalVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
and dea.location = 'Nigeria'
)
Select *, (TotalVaccination/Population)*100 AS PercentageVaccinated
from PopVac
