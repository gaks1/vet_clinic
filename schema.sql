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
