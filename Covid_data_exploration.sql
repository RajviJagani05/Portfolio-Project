
select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

select * 
from PortfolioProject..CovidVaccinations
order by 3,4

Select Location, date, total_cases, new_cases, Total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

Select Location, date, total_cases, Total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2

Select Location, date, total_cases, Population, (total_cases/population)*100 as PopulationPercentage
from PortfolioProject..CovidDeaths
--where location like '%India%'
order by 1,2

Select Location,Max(total_cases) as HighestInfectionCount, Population, MAX((total_cases/population))*100 as PopulationPercentage
from PortfolioProject..CovidDeaths
--where location like '%India%'
group by location, population
order by PopulationPercentage desc

Select Location, max(cast(Total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
group by location
order by totalDeathCount desc

Select continent, max(cast(Total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
group by continent
order by totalDeathCount desc

Select sum(new_cases) AS total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
--group by date
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3 

--create CTE

with PopvsVac ( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 
)
select *, (RollingPeopleVaccinated/population)*100 
from PopvsVac

--Temp table

drop table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3 

select *
from #PercentPopulationVaccinated

--create views


Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 

select *
from PercentPopulationVaccinated