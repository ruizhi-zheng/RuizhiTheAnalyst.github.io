select *
from Covid19DataExploration..CovidDeaths
where continent is not null
order by 3,4


--select *
--from Covid19DataExploration..CovidVaccinations
--order by 3,4


--select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from Covid19DataExploration..CovidDeaths
where continent is not null
order by 1,2


--looking at Total Cases vs Total Deaths
--shows likelihood of dying if you contract covid in the US

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Covid19DataExploration..CovidDeaths
where location like '%states%'
      and continent is not null
order by 1,2


--looking at Total Cases vs Population
--shows what percentage of population infected with Covid

select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from Covid19DataExploration..CovidDeaths
--where location like '%states%'
order by 1,2


--looking at countries with highest infection rate compared to population

select location,population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
from Covid19DataExploration..CovidDeaths
--where location like '%states%'
group by location,population
order by PercentPopulationInfected desc


--showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from Covid19DataExploration..CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc


--let's break things down by continent
-- Showing contintents with the highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from Covid19DataExploration..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


--global numbers

select
      date,
      sum(new_cases) as total_cases,
      sum(cast(new_deaths as int)) as total_deaths,
      sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Covid19DataExploration..CovidDeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select
      --date,
      sum(new_cases) as total_cases,
      sum(cast(new_deaths as int)) as total_deaths,
      sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Covid19DataExploration..CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


--looking at Total Population vs Vaccinations
--Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent,
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.date ) as RollingPeopleVaccinatied
       --(RollingPeopleVaccinatied/dea.population)*100
from Covid19DataExploration..CovidDeaths dea
join Covid19DataExploration..CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3 


--Using CTE to perform Calculation on Partition By in previous query

with PopvsVac as(
select dea.continent,
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.date ) as RollingPeopleVaccinatied
       --(RollingPeopleVaccinatied/dea.population)*100
from Covid19DataExploration..CovidDeaths dea
join Covid19DataExploration..CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
              )
select*,(RollingPeopleVaccinatied/population)*100 as VaccinationRate
from PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
       (
       continent nvarchar(255),
       location nvarchar(255),
       date datetime,
       population numeric,
       new_vaccinations numeric,
       RollingPeopleVaccinatied numeric
       )

insert into #PercentPopulationVaccinated
select dea.continent,
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.date ) as RollingPeopleVaccinatied
       --(RollingPeopleVaccinatied/dea.population)*100 as VaccinationRate
from Covid19DataExploration..CovidDeaths dea
join Covid19DataExploration..CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
--where dea.continent is not null

select*,(RollingPeopleVaccinatied/population)*100 as VaccinationRate
from #PercentPopulationVaccinated
order by 2,3


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent,
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.date ) as RollingPeopleVaccinatied
       --(RollingPeopleVaccinatied/dea.population)*100 as VaccinationRate
from Covid19DataExploration..CovidDeaths dea
join Covid19DataExploration..CovidVaccinations vac 
     on dea.location=vac.location 
     and dea.date=vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated

