select * 
from PortfolioProject..CovidDeaths1$
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations$
--order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths1$
order by 1,2

--Looking at Total cases vs Total Deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths1$
where location like 'india'
order by 1,2

--Looking at Total cases vs Population

select location,date,total_cases,total_deaths,population,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths1$
--where location like 'india'
order by 1,2


--Looking at countries with highest infection rate compared to population


select location,population,max(total_cases) as highest_infectedCount,max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths1$
--where location like 'india'
group by population,location
order by PercentPopulationInfected desc

--showing countries with the highest death count per population
select location,max(cast(total_deaths as int)) as total_deathscount
from PortfolioProject..CovidDeaths1$
where continent is not null
group by location
order by total_deathscount desc

----showing continent with highest death count AS PER CONTINENT
select continent,max(cast(total_deaths as int)) as total_deathscount
from PortfolioProject..CovidDeaths1$
where continent is not null
group by continent
order by total_deathscount desc

--global numbers

select date,sum(new_cases),sum(cast(new_deaths as int )) ,new_deaths/new_cases
from PortfolioProject..CovidDeaths1$
--where location like 'india'
where continent is not null
group by date
order by 1,2


--looking at toal pop vs vaccincations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int )) over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated

from PortfolioProject..CovidDeaths1$ dea
join 
PortfolioProject..CovidVaccinations$ vac
on
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use CTE
with PopvsVac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int )) over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated

from PortfolioProject..CovidDeaths1$ dea
join 
PortfolioProject..CovidVaccinations$ vac
on
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(rollingpeoplevaccinated/population)*100
from PopvsVac



--temp table



create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int )) over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated

from PortfolioProject..CovidDeaths1$ dea
join 
PortfolioProject..CovidVaccinations$ vac
on
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * ,(rollingpeoplevaccinated/population)*100
from #PercentPopulationVaccinated




--creating view
create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(new_vaccinations as int )) over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated

from PortfolioProject..CovidDeaths1$ dea
join 
PortfolioProject..CovidVaccinations$ vac
on
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3




