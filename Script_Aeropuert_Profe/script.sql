DROP DATABASE  aeropuerto;
CREATE DATABASE aeropuerto;

\c aeropuerto; 

DROP USER cliente_vuelo;
DROP USER adminVuelos;
DROP SCHEMA esquemaVuelo;
DROP SCHEMA esquemaCliente;

CREATE VIEW v_pasajero AS SELECT id,nom,dest FROM pasajero;
GRANT SELECT ON v_pasajero to cliente_vuelo;


CREATE USER cliente_vuelo WITH PASSWORD 'cliente' VALID UNTIL '2019-01-01';
CREATE USER  adminVuelos WITH PASSWORD 'admin' VALID UNTIL '2019-01-01';

CREATE SCHEMA esquemaVuelo AUTHORIZATION adminVuelos;
CREATE SCHEMA esquemaCliente AUTHORIZATION cliente_vuelo;


CREATE TABLE esquemaCliente.aeropuerto(
    id serial PRIMARY KEY,
    nom VARCHAR(30) DEFAULT 'NombreAeropuerto' NOT NULL ,
    ubicacion VARCHAR(100),
    costosHora FLOAT(30) NOT NULL,
    CONSTRAINT ck_costosHora CHECK (costosHora>=0)

);

CREATE TABLE esquemaCliente.pasajero(
    id serial,
    nom VARCHAR(30) DEFAULT 'NombrePasajero',
    dest VARCHAR (10) NOT NULL,
    nacional VARCHAR (10) DEFAULT 'Colombiana',
    id_aero_embarque INTEGER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_aero_embarque)  REFERENCES esquemaCliente.aeropuerto(id)
    
);

CREATE TABLE esquemaVuelo.aeronave(
    id serial NOT NULL,
    marca VARCHAR(10) DEFAULT 'AERONAVE',
    modelo INTEGER NOT NULL,
    num_pasa INTEGER NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT ck_num_pasa CHECK (num_pasa>0 OR num_pasa<=800)
);


CREATE TABLE esquemaVuelo.vuelo(
    id serial NOT NULL,    
    dest VARCHAR(100) NOT NULL,
    h_salida TIMESTAMP NOT NULL,
    puertaSalida VARCHAR(8) NOT NULL,
    costo FLOAT(10) DEFAULT 0,
    aerolinea VARCHAR (10) NOT NULL,
    id_aero INTEGER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_aero) REFERENCES esquemaVuelo.aeronave(id)    
);

CREATE TABLE esquemaVuelo.item_vuelo_pasajero (
    id serial NOT NULL,    
    id_vuelo INTEGER NOT NULL,
    id_pasajero INTEGER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_vuelo) REFERENCES esquemaVuelo.vuelo(id),
    FOREIGN KEY (id_pasajero) REFERENCES esquemaCliente.pasajero(id)
);

CREATE TABLE esquemaVuelo.item_aero_vuelo (
    id serial NOT NULL,    
    id_aero INTEGER NOT NULL,
    id_vuelo INTEGER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_aero) REFERENCES esquemaCliente.aeropuerto(id),
    FOREIGN KEY (id_vuelo) REFERENCES esquemaVuelo.vuelo(id)
);


ALTER DEFAULT PRIVILEGES IN SCHEMA esquemaCliente GRANT SELECT,INSERT ON TABLES TO cliente_vuelo;



