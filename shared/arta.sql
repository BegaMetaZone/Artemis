CREATE TABLE arta_players (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    cash FLOAT,
    bank FLOAT,
    crypto FLOAT
);


CREATE TABLE arta_garages (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    artaplayer_id INT,
    FOREIGN KEY (artaplayer_id) REFERENCES arta_players(id)
);

CREATE TABLE arta_vehicles (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    artagarage_id INT,
    FOREIGN KEY (artagarage_id) REFERENCES arta_garages(id)
);
