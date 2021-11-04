use portfolio_project;
select Location, continent, date, total_cases, new_cases, total_deaths, population
from covid_deaths
where continent not like ''
order by 1,2;

-- Looking at Total Cases vs Total Deaths
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from portfolio_project.covid_deaths
where continent not like ''
order by 1,2;

-- Looking at Total Cases vs Population
select Location, date, population, total_cases,(total_cases/population)*100 as percent_population_infected
from portfolio_project.covid_deaths
where continent not like ''
-- where Location like '%states%'
order by 1,2;

-- Looking at Countries with Highest Infestion Rate
select Location, population, max(total_cases) as highest_infection_rate,max((total_cases/population)*100) as percent_population_infected
from portfolio_project.covid_deaths
where continent not like ''
-- where Location like '%states%'
group by Location, population
order by percent_population_infected desc;

-- Showing Countries with Highest Death Count per Population
select Location, max(total_deaths) as total_death_count
from portfolio_project.covid_deaths
where continent not like ''
group by Location
order by total_death_count desc;

-- Showing continents with the highest death count per population
select continent, max(total_deaths) as total_death_count
from portfolio_project.covid_deaths
where continent not like ''
group by continent
order by total_death_count desc;

-- GLOBAL NUMBERS
select date, sum(new_cases) as total_cases, sum(new_deaths) as t, (sum(new_deaths)/sum(new_cases))*100 as death_percentage
from portfolio_project.covid_deaths
where continent not like ''
group by date
order by 1,2;

select sum(new_cases) as total_cases, sum(new_deaths) as t, (sum(new_deaths)/sum(new_cases))*100 as death_percentage
from portfolio_project.covid_deaths
where continent not like ''
order by 1,2;

-- Looking at Total Population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from portfolio_project.covid_deaths dea
join portfolio_project.covid_vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.location like '%canada%'
order by 2,3

-- Use CTE
With pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from portfolio_project.covid_deaths dea
join portfolio_project.covid_vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent not like ''
-- order by 2,3
)
select *, (rolling_people_vaccinated/population)*100
from pop_vs_vac

-- Temp table
drop table if exists percent_pop_vaccinated
Create Table percent_pop_vaccinated (
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

insert into percent_pop_vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from portfolio_project.covid_deaths dea
join portfolio_project.covid_vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent not like ''
-- order by 2,3

select *, (rolling_people_vaccinated/population)*100
from percent_pop_vaccinated

-- Creating view to store data for later visualizations
create view percent_pop_vaccinated_view as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from portfolio_project.covid_deaths dea
join portfolio_project.covid_vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent not like ''
order by 2,3

select * from percent_pop_vaccinated_view

