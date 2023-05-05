/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255),
  date_of_birth DATE,
  escape_attempts INTEGER,
  neutered BOOLEAN,
  weight_kg DECIMAL(10, 2),
  PRIMARY KEY (id)
);

ALTER TABLE animals
ADD COLUMN species VARCHAR(255);

/**/

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INT
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species (id);

ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES owners (id);


CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    date_of_graduation DATE
);


CREATE TABLE specializations (
    vet_id INT,
    species_id INT,
    PRIMARY KEY (vet_id, species_id),
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (species_id) REFERENCES species(id)
);


CREATE TABLE visits (
    animal_id INT,
    vet_id INT,
    visit_date DATE,
    PRIMARY KEY (animal_id, vet_id, visit_date),
    FOREIGN KEY (animal_id) REFERENCES animals(id),
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);




