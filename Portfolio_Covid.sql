SELECT *
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

-- select the data that we will be using
SELECT location, date, total_cases, new_cases,total_deaths, population
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- comparing Total_cases VS Total_deaths
-- the risk of dying if a person contracts the covid virus in a specific country
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT))*100 AS death_percent
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- comparing Total_cases VS Population
-- the percentage of population that contracted the covid virus
SELECT location, date, total_cases, population, (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))*100 AS case_percent
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- show countries with highest infection rate compared to population
SELECT location, population, MAX((CAST (total_cases AS FLOAT)) / CAST (population AS FLOAT))*100 AS high_infection_rate
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY high_infection_rate DESC

-- show locations with highest death
SELECT location, MAX(CAST (total_deaths AS FLOAT)) AS highest_death_location
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY highest_death_location DESC

-- let's break things down by continent
-- show continents with highest death
SELECT continent, MAX(CAST(total_deaths AS FLOAT)) AS highest_death_continent
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_death_continent DESC

-- show percentage of deaths per cases
SELECT date, SUM(CAST(new_deaths AS FLOAT)) AS total_new_deaths, SUM(CAST(new_cases AS FLOAT)) AS total_new_cases, SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)),0)*100 AS percent_death_case
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY percent_death_case

-- looking at total population vs vaccination
-- Use CTE
With pop_vs_vacc (Continent, Location, Date, Population, New_vaccination, Vaccinated_Persons_Count)
AS
(
SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS FLOAT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS vaccinated_persons_count
FROM Portfolio..covid_deaths death
INNER JOIN Portfolio..covid_vaccinations vacc
ON death.location = vacc.location
AND death.date = vacc.date
WHERE death.continent IS NOT NULL
)
Select *, (vaccinated_persons_count/CAST(population AS FLOAT))*100 AS percent_vaccinated
FROM pop_vs_vacc

-- TEMP TABLE
DROP TABLE IF EXISTS percent_population_vaccinated
CREATE TABLE percent_population_vaccinated
(
  Continent NVARCHAR(255),
  Location NVARCHAR(255),
  Date DATE,
  Population FLOAT,
  New_Vaccinations FLOAT,
  Vaccinated_Persons_Count FLOAT
)
INSERT INTO percent_population_vaccinated
SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS FLOAT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS vaccinated_persons_count
FROM Portfolio..covid_deaths death
INNER JOIN Portfolio..covid_vaccinations vacc
ON death.location = vacc.location
AND death.date = vacc.date
WHERE death.continent IS NOT NULL

Select *, (vaccinated_persons_count/population)*100 AS percent_vaccinated
FROM percent_population_vaccinated

-- creating View for visualizations

CREATE VIEW percentage_of_population_vaccinated AS
SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations, SUM(CAST(vacc.new_vaccinations AS FLOAT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS vaccinated_persons_count
FROM Portfolio..covid_deaths death
INNER JOIN Portfolio..covid_vaccinations vacc
ON death.location = vacc.location
AND death.date = vacc.date
WHERE death.continent IS NOT NULL
