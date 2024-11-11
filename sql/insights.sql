USE police_data;
DROP TEMPORARY TABLE IF EXISTS shooting_analysis;


-- Insight 1: Relationship between fatal shooting and social impacts
CREATE TEMPORARY TABLE shooting_analysis AS
SELECT 
    p.state,
    p.year,
    p.poverty_population,
    e.over25_completed_highschool AS completed_high_school_count,
    m.median_house_income,
    r.total_population,
    COUNT(f.shooting_id) AS total_shootings
FROM 
    poverty p
JOIN 
    edu e ON p.state = e.state AND p.year = e.year
JOIN 
    median_house_income m ON p.state = m.state AND p.year = m.year
LEFT JOIN 
    fatal_shooting f ON p.state = f.state AND YEAR(f.date) = p.year
JOIN 
    race r ON p.state = r.state AND p.year = r.year
GROUP BY 
    p.state, p.year, p.poverty_population, e.over25_completed_highschool, m.median_house_income;


SELECT 
    state,
    year,
    ROUND((poverty_population / total_population) * 100, 3) AS poverty_rate_percentage,
    ROUND((completed_high_school_count / total_population) * 100, 3) AS high_school_completion_percent,  
    median_house_income,
    total_shootings,
    total_population,
    CASE 
        WHEN total_population = 0 THEN NULL
        ELSE ROUND((total_shootings / total_population)* 100, 3)
    END AS shooting_rate_percentage  
FROM 
    shooting_analysis
ORDER BY 
    state, year;


-- Insight 2: Is police USA racist?
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT 
    fs.state,
    fs.race,
    COUNT(*) AS total_cases,
    CASE 
        WHEN fs.race = 'white_alone' THEN rp.total_white
        WHEN fs.race = 'black_alone' THEN rp.total_black
        WHEN fs.race = 'american_indian_alaska_native_alone' THEN rp.total_american_indian_alaska_native
        WHEN fs.race = 'asian_alone' THEN rp.total_asian
        WHEN fs.race = 'native_hawaiian_pacific_islander_alone'THEN rp.total_native_hawaiian_pacific_islander
        WHEN fs.race = 'other_race' THEN rp.total_other_race
        ELSE 0
    END AS population,
    (ROUND(COUNT(*) * 100 / 
        CASE 
            WHEN fs.race = 'white_alone' THEN rp.total_white
			WHEN fs.race = 'black_alone' THEN rp.total_black
			WHEN fs.race = 'american_indian_alaska_native_alone' THEN rp.total_american_indian_alaska_native
			WHEN fs.race = 'asian_alone' THEN rp.total_asian
			WHEN fs.race = 'native_hawaiian_pacific_islander_alone'THEN rp.total_native_hawaiian_pacific_islander
			WHEN fs.race = 'other_race' THEN rp.total_other_race
            ELSE NULL
        END, 2)) AS percentage_of_cases
FROM 
    fatal_shooting fs
JOIN 
    race rp ON fs.state = rp.state  
GROUP BY 
    fs.state, fs.race
ORDER BY 
    total_cases DESC;


-- Insight 3: Only Black cases
SELECT 
    fs.state,
    YEAR(fs.date) AS year,
    pd.poverty_population,
    COUNT(*) AS total_black_cases
FROM 
    fatal_shooting fs
JOIN 
    poverty pd ON fs.state = pd.state 
WHERE 
    fs.race = 'black_alone' 
  
GROUP BY 
    fs.state, YEAR(fs.date), pd.poverty_population
ORDER BY 
    pd.poverty_population DESC;


-- Insight 4: Volatility

SELECT 
    YEAR(date) AS year,
    COUNT(*) AS total_cases,
    STDDEV(COUNT(*)) OVER () AS volatility  
FROM 
    fatal_shooting
GROUP BY 
    YEAR(date)
ORDER BY 
    year;

