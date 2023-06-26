-- Effects of Covid-19 virus to humans

-- Table 1
-- The risk of dying if a person contracts the Covid-19 virus
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(CAST(new_deaths AS FLOAT)) / SUM(CAST(new_cases AS FLOAT))*100 AS death_percent
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Table 2
-- Total deaths per continent caused by Covid-19 virus
SELECT continent, SUM(new_deaths) AS total_deaths
FROM Portfolio..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths DESC

-- Table 3
-- Percentage of population infected by Covid-19 virus per country
SELECT location, population, MAX(total_cases) AS highest_case_count, MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS percent_population_infected
FROM Portfolio..covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC

-- Table 4
-- Percentage of population infected by Covid-19 virus per day
SELECT location, population, date, MAX(total_cases) AS highest_case_count, MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS percent_population_infected
From Portfolio..covid_deaths
GROUP BY location, population, date
ORDER BY percent_population_infected DESC
