select *
from PortfolioProject..CovidDeaths
order by 3,4


--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--select data 
select Location,date,total_cases,new_cases,total_deaths,
population
from PortfolioProject..CovidDeaths
order by 1,2

-- looking at total cases vs total deaths
select Location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%kashmir'
order by 1,2

--



--looking at total cases vs population
select Location,date,total_cases,Population,
(total_cases/Population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states'
order by 1,2

--countries with high infection rate
select Location,max(total_cases) as HighestInfection,
Population,
max((total_cases/Population)*100) as PercenPoppulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states'
group by Location,Population
order by PercenPoppulationInfected

--contries with highest death count per population
select Location,
max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
group by Location
order by TotalDeathCount desc


--by continent
select continent,
max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
group by continent
order by TotalDeathCount desc

--shoewing continent iwth high death count
select continent,
max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
group by continent
order by TotalDeathCount desc

--globally
select date,sum(new_cases)as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
--(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null 
group by date
order by 1,2 

--
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
order by dea.location,dea.date) as RoolingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
order by 2,3

--CTE
WITH PopvsVac (Continent,location,Date,Population,
New_Vaccinations,RoolingPeopleVaccinated) as
(
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
order by dea.location,dea.date) as RoolingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,(RoolingPeopleVaccinated/Population)*100
From PopvsVac

--temp table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated 
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
order by dea.location,dea.date) as RoolingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
--order by 2,3

select*,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--creating view
create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
order by dea.location,dea.date) as RoolingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
--order by 2,3