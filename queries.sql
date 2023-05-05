/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon','Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT delete;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO delete;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;


SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;

SELECT neutered, MAX(escape_attempts) as escape_attempts
FROM animals GROUP BY neutered;

SELECT species, MIN(weight_kg) as min_weight, MAX(weight_kg) as max_weight
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) as avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

/* JOIN queries*/

SELECT a.name, o.full_name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

SELECT a.name, s.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

SELECT s.name, COUNT(a.id) AS total_count
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.id, s.name;

SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;


 SELECT o.full_name, COUNT(a.id) as total
FROM owners o
JOIN animals a ON o.id = a.owner_id
 GROUP BY o.full_name
 ORDER BY total DESC
 LIMIT 1;




-- Who was the last animal seen by William Tatcher?
SELECT a.name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT a.name)
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name, sp.name
FROM vets v
LEFT JOIN specializations s ON v.id = s.vet_id
LEFT JOIN species sp ON sp.id = s.species_id;


-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name, vt.name, v.visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez' AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.id, a.name, COUNT(a.name) as total
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
GROUP BY a.name, a.id
ORDER BY total DESC 
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.id, a.name, v.visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date ASC
LIMIT 1;

--Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name, vt.name, v.visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
ORDER BY v.visit_date DESC
LIMIT 1;

--How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
LEFT JOIN specializations s ON vt.id = s.vet_id AND a.species_id = s.species_id
WHERE s.species_id IS NULL;

--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT sp.name AS species_name, COUNT(*) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN species sp ON a.species_id = sp.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
GROUP BY sp.name
ORDER BY visit_count DESC
LIMIT 1;
