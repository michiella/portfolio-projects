/*

Queries used for Tableau visualization project

*/

-- 1.

select sum(new_cases) as total_cases, 
sum(new_deaths) as total_deaths, 
(sum(new_deaths)/sum(new_cases))*100 as death_percentage
from portfolio_project.covid_deaths
where continent not like ''
order by 1,2;

-- 2.
select location,
sum(new_deaths) as total_death_count
from portfolio_project.covid_deaths
where continent like ''
and location not in ('World', 'European Union', 'International')
group by location
order by total_death_count desc;

-- 3.
select location,
population,
max(total_cases) as highest_infection_count,
max(total_cases/population)*100 as percent_population_infected
from portfolio_project.covid_deaths
group by location, population
order by percent_population_infected desc;

-- 4.
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_project.covid_deaths
Group by Location, Population, date;
-- order by date desc;

select date from portfolio_project.covid_deaths
order by date asc