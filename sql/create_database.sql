CREATE DATABASE police_data;
USE police_data;

CREATE TABLE fatal_shooting (
    shooting_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    race VARCHAR(50),
    date DATE,
    state VARCHAR(2),
    manner_of_death VARCHAR(50),
    mental_illness BOOLEAN,
    armed VARCHAR(20),
    weapon VARCHAR(100),
    threat_level VARCHAR(50),
    body_camera BOOLEAN
);



CREATE TABLE median_house_income (
    income_id INT AUTO_INCREMENT PRIMARY KEY,
    state VARCHAR(2),
    year YEAR,
    median_house_income FLOAT
);


CREATE TABLE edu (
    edu_id INT AUTO_INCREMENT PRIMARY KEY,
    state VARCHAR(2),
    year YEAR,
    over25_completed_highschool FLOAT
);


CREATE TABLE poverty (
    poverty_id INT AUTO_INCREMENT PRIMARY KEY,
    state VARCHAR(2),
    year YEAR,
    poverty_population FLOAT
);




CREATE TABLE race (
    total_population FLOAT,
    total_white FLOAT,
    total_black FLOAT,
    total_american_indian_alaska_native FLOAT,
    total_asian FLOAT,
    total_native_hawaiian_pacific_islander FLOAT,
    total_other_race FLOAT,
    state VARCHAR(2),                          
    year YEAR,
    PRIMARY KEY (state, year)
);







