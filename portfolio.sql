Select *
from portfolio_Database..CovidDeaths$
order by 3,4

Select *
from portfolio_Database..CovidVaccinations$
order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
from portfolio_Database..CovidDeaths$
order by 1,2

--total cases vs total deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 As deathpertentage
from portfolio_Database..CovidDeaths$
where location like '%states%'
order by 1,2

--total cases vs Population
Select location,date,total_cases,Population,(total_cases/population)*100 As case_pertentage
from portfolio_Database..CovidDeaths$
where location like '%states%'
order by 1,2

--Countries with highest infection rate compared to population
Select location,Population,Max(total_cases) as Highestinflectioncount,Max(total_cases/population)*100 As pertentagePopulationInfected
from portfolio_Database..CovidDeaths$
--where location like '%states%'
Group by location,population
order by pertentagePopulationInfected desc

--Countries with highest death count per population
Select location,Max(cast(total_deaths as int)) as totalDeathsCount
from portfolio_Database..CovidDeaths$
Where continent is not null
--where location like '%states%'
Group by location
order by totalDeathsCount desc

--lets break things by continent
Select location,Max(cast(total_deaths as int)) as totalDeathsCount
from portfolio_Database..CovidDeaths$
Where continent is null
--where location like '%states%'
Group by location
order by totalDeathsCount desc


--Contients with highest death count
Select continent,Max(cast(total_deaths as int)) as totalDeathsCount
from portfolio_Database..CovidDeaths$
Where continent is  not  null
--where location like '%states%'
Group by continent
order by totalDeathsCount desc

--Global numbers
Select date,SUM(new_cases) as total_Cases,SUM(cast(new_deaths as int)) as Total_deaths, Sum(cast(new_deaths as int ))/sum(new_cases)*100 as deathpertentage
from portfolio_Database..CovidDeaths$
Where continent is not null
 Group by date
 order by 1,2
 --Totalpopulation vs vaccination
 Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations)) over(partition by dea.Location order by dea.location,dea.date) as rollingPeopleVaccinated
 from portfolio_Database..CovidDeaths$ dea
 Join portfolio_Database..CovidVaccinations$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3

 --use cte
 with popvsVac (continent,location,Date,Population,new_vaccinations,RollingpeopleVaccinated)
 As
 (
 Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations)) over(partition by dea.Location order by dea.location,dea.date) as rollingPeopleVaccinated
 from portfolio_Database..CovidDeaths$ dea
 Join portfolio_Database..CovidVaccinations$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --order by 2,3
 )
 Select * ,(rollingpeoplevaccinated/Population)from popvsVac


 --Create view to store date for visulaization
 Create view PercentPopulationVaccinated as 
 Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations)) over(partition by dea.Location order by dea.location,dea.date) as rollingPeopleVaccinated
 from portfolio_Database..CovidDeaths$ dea
 Join portfolio_Database..CovidVaccinations$ vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --order by 2,3









