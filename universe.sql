CREATE DATABASE universe;

\c universe

CREATE TABLE IF NOT EXISTS galaxy (
  galaxy_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  galaxy_type TEXT NOT NULL,
  age_million_years INT NOT NULL,
  diameter_thousand_ly NUMERIC NOT NULL,
  is_active BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS star (
  star_id SERIAL PRIMARY KEY,
  galaxy_id INT NOT NULL REFERENCES galaxy(galaxy_id),
  name VARCHAR(100) NOT NULL UNIQUE,
  spectral_type VARCHAR(10) NOT NULL,
  mass_solar NUMERIC NOT NULL,
  is_variable BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS planet (
  planet_id SERIAL PRIMARY KEY,
  star_id INT NOT NULL REFERENCES star(star_id),
  name VARCHAR(100) NOT NULL UNIQUE,
  planet_type TEXT NOT NULL,
  orbital_period_days NUMERIC NOT NULL,
  moon_count INT NOT NULL,
  has_rings BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS moon (
  moon_id SERIAL PRIMARY KEY,
  planet_id INT NOT NULL REFERENCES planet(planet_id),
  name VARCHAR(100) NOT NULL UNIQUE,
  diameter_km INT NOT NULL,
  is_spherical BOOLEAN NOT NULL,
  discovery_year INT NOT NULL
);

CREATE TABLE IF NOT EXISTS nebula (
  nebula_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  nebula_type TEXT NOT NULL,
  distance_ly NUMERIC NOT NULL,
  is_emission BOOLEAN NOT NULL
);

INSERT INTO galaxy (name, galaxy_type, age_million_years, diameter_thousand_ly, is_active)
VALUES
  ('Milky Way', 'Barred spiral', 13600, 105, TRUE),
  ('Andromeda', 'Spiral', 10000, 220, TRUE),
  ('Triangulum', 'Spiral', 12000, 60, TRUE),
  ('Sombrero', 'Lenticular', 13000, 50, FALSE),
  ('Whirlpool', 'Spiral', 13000, 76, TRUE),
  ('Pinwheel', 'Spiral', 10500, 170, TRUE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO star (galaxy_id, name, spectral_type, mass_solar, is_variable)
SELECT g.galaxy_id, s.name, s.spectral_type, s.mass_solar, s.is_variable
FROM (VALUES
  ('Milky Way', 'Sun', 'G2V', 1.0::NUMERIC, FALSE),
  ('Milky Way', 'Sirius A', 'A1V', 2.06::NUMERIC, FALSE),
  ('Milky Way', 'Proxima Centauri', 'M5.5V', 0.12::NUMERIC, FALSE),
  ('Milky Way', 'Betelgeuse', 'M1-2Ia', 16.5::NUMERIC, TRUE),
  ('Andromeda', 'Vega', 'A0V', 2.1::NUMERIC, FALSE),
  ('Triangulum', 'Kepler-22', 'G5V', 0.97::NUMERIC, FALSE)
) AS s(galaxy_name, name, spectral_type, mass_solar, is_variable)
JOIN galaxy g ON g.name = s.galaxy_name
ON CONFLICT (name) DO NOTHING;

INSERT INTO planet (star_id, name, planet_type, orbital_period_days, moon_count, has_rings)
SELECT s.star_id, p.name, p.planet_type, p.orbital_period_days, p.moon_count, p.has_rings
FROM (VALUES
  ('Sun', 'Mercury', 'Terrestrial', 87.97::NUMERIC, 0, FALSE),
  ('Sun', 'Venus', 'Terrestrial', 224.70::NUMERIC, 0, FALSE),
  ('Sun', 'Earth', 'Terrestrial', 365.25::NUMERIC, 1, FALSE),
  ('Sun', 'Mars', 'Terrestrial', 686.98::NUMERIC, 2, FALSE),
  ('Sun', 'Jupiter', 'Gas giant', 4332.59::NUMERIC, 95, TRUE),
  ('Sun', 'Saturn', 'Gas giant', 10759.22::NUMERIC, 146, TRUE),
  ('Sun', 'Uranus', 'Ice giant', 30688.5::NUMERIC, 28, TRUE),
  ('Sun', 'Neptune', 'Ice giant', 60182::NUMERIC, 16, TRUE),
  ('Proxima Centauri', 'Proxima Centauri b', 'Terrestrial', 11.19::NUMERIC, 0, FALSE),
  ('Kepler-22', 'Kepler-22b', 'Super-Earth', 289.86::NUMERIC, 0, FALSE),
  ('Kepler-22', 'Kepler-22c', 'Super-Earth', 500.0::NUMERIC, 0, FALSE),
  ('Sirius A', 'Sirius b', 'Ice giant', 2.0::NUMERIC, 0, FALSE)
) AS p(star_name, name, planet_type, orbital_period_days, moon_count, has_rings)
JOIN star s ON s.name = p.star_name
ON CONFLICT (name) DO NOTHING;

INSERT INTO moon (planet_id, name, diameter_km, is_spherical, discovery_year)
SELECT p.planet_id, m.name, m.diameter_km, m.is_spherical, m.discovery_year
FROM (VALUES
  ('Earth', 'Luna', 3474, TRUE, 0),
  ('Mars', 'Phobos', 22, FALSE, 1877),
  ('Mars', 'Deimos', 12, FALSE, 1877),
  ('Jupiter', 'Io', 3643, TRUE, 1610),
  ('Jupiter', 'Europa', 3122, TRUE, 1610),
  ('Jupiter', 'Ganymede', 5268, TRUE, 1610),
  ('Jupiter', 'Callisto', 4821, TRUE, 1610),
  ('Jupiter', 'Amalthea', 167, FALSE, 1892),
  ('Saturn', 'Titan', 5150, TRUE, 1655),
  ('Saturn', 'Enceladus', 504, TRUE, 1789),
  ('Saturn', 'Mimas', 396, TRUE, 1789),
  ('Saturn', 'Rhea', 1528, TRUE, 1672),
  ('Saturn', 'Iapetus', 1469, TRUE, 1671),
  ('Uranus', 'Titania', 1578, TRUE, 1787),
  ('Uranus', 'Oberon', 1523, TRUE, 1787),
  ('Uranus', 'Ariel', 1158, TRUE, 1851),
  ('Uranus', 'Umbriel', 1169, TRUE, 1851),
  ('Neptune', 'Triton', 2707, TRUE, 1846),
  ('Neptune', 'Nereid', 340, TRUE, 1949),
  ('Neptune', 'Proteus', 420, FALSE, 1989)
) AS m(planet_name, name, diameter_km, is_spherical, discovery_year)
JOIN planet p ON p.name = m.planet_name
ON CONFLICT (name) DO NOTHING;

INSERT INTO nebula (name, nebula_type, distance_ly, is_emission)
VALUES
  ('Orion Nebula', 'Diffuse nebula', 1344, TRUE),
  ('Crab Nebula', 'Supernova remnant', 6500, TRUE),
  ('Ring Nebula', 'Planetary nebula', 2300, TRUE)
ON CONFLICT (name) DO NOTHING;
