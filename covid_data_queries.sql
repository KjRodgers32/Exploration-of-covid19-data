-- Exploring covid data from https://ourworldindata.org/covid-deaths
-- Lets take a peek at or our datasets
SELECT
  *
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
LIMIT
  10;

SELECT 
  *
FROM
  `my-data-project-347804.covid_data.covid_vaccinations` AS vacc
LIMIT
  10;

-- Selecting some of key info
SELECT 
  location,
  date,
  total_cases,
  new_cases,
  total_deaths
FROM
  covid_data.covid_deaths
WHERE
  continent IS NOT NULL
ORDER BY
  1,2;

-- Look at the total deaths vs total cases
SELECT
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases) * 100 AS death_rate
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
WHERE
  continent IS NOT NULL
ORDER BY
  1,2;

-- look at the death rate in the US
SELECT
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases) * 100 AS death_rate
FROM
  covid_data.covid_deaths AS deaths
WHERE
  location = "United States"
  AND continent IS NOT NULL
ORDER BY
  1,2;

-- Now lets look at the total cases vs populaiton in the US
SELECT
  location,
  date,
  population,
  total_cases,
  (total_cases/population) * 100 AS affect_percent
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
WHERE
  location = "United States"
  AND continent IS NOT NULL
ORDER BY
  1,2;

-- Lets look at other country's infection rate at the peak of infection
SELECT
  DISTINCT location,
  population,
  MAX(total_cases) AS highest_case_total,
  MAX(total_cases/population) * 100 AS infection_rate
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
WHERE
  continent IS NOT NULL
GROUP BY
  location, population
ORDER BY
  4 DESC;
-- US had the 56th highest infection rate at its peak! (As of 5/23/22)

-- Look at the highest death rate in each country
SELECT
  DISTINCT location,
  population,
  MAX(total_deaths) AS highest_death_total,
  MAX(total_deaths/population) * 100 AS death_rate
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
WHERE 
  continent IS NOT NULL
GROUP BY
  location, population
ORDER BY
  4 DESC;
-- Thankfully no population reached a 1% death rate
-- Look at the infection rates of each continent
SELECT
  continent,
  MAX(population) AS max_pop,
  MAX(total_cases) AS highest_case_total,
  MAX(total_cases)/MAX(population) * 100 AS infection_rate
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
WHERE
  continent IS NOT NULL
GROUP BY
  continent
ORDER BY
  4 DESC;

-- Look at the death rate of each country
SELECT
  continent,
  MAX(population) AS max_pop,
  MAX(total_deaths) AS highest_death_total,
  MAX(total_deaths)/MAX(population) * 100 AS death_rate
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
WHERE
  continent IS NOT NULL
GROUP BY
  continent
ORDER BY
  4 DESC;

-- Look at the new cases  and new deaths added each day from around the world
SELECT
  date,
  SUM(new_cases) AS num_new_cases,
  SUM(new_deaths) AS num_deaths_cases,
  SUM(new_deaths)/SUM(new_cases) * 100 AS death_percentage
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
WHERE
  continent IS NOT NULL
GROUP BY
  date
ORDER BY
  1;

-- Lets take a look at both of the datasets
-- Look at total population vs vaccinated
SELECT
  deaths.continent,
  deaths.location,
  deaths.date,
  deaths.population,
  vacc.new_vaccinations,
  SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_vaccinated_total
FROM
  `my-data-project-347804.covid_data.covid_deaths` AS deaths
JOIN
  `my-data-project-347804.covid_data.covid_vaccinations` AS vacc
  ON deaths.location = vacc.location
  AND deaths.date = vacc.date
WHERE
  deaths.continent IS NOT NULL
ORDER BY
  1, 2;
