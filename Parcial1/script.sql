DROP DATABASE dbhospital;
CREATE DATABASE dbhospital;

\c dbhospital

DROP USER medico;
DROP USER recepcionista;
DROP USER enfermero;

CREATE USER medico  WITH PASSWORD 'medico' VALID UNTIL '2019-01-01';
CREATE USER recepcionista WITH PASSWORD 'recepcionista' VALID UNTIL '2019-01-01';
CREATE USER enfermero  WITH PASSWORD 'enfermero' VALID UNTIL '2019-01-01';


CREATE SCHEMA infoPacientes AUTHORIZATION medico;
CREATE SCHEMA infoLugar AUTHORIZATION enfermero;
CREATE SCHEMA infoPersonal AUTHORIZATION recepcionista;

CREATE TABLE infoPacientes.paciente(
	id INTEGER not null,
	nombre varchar(20) not null,
	PRIMARY KEY(id)

);

CREATE TABLE infoPacientes.enfermedad(
	id INTEGER NOT NULL,
	nombre varchar(20) not null,
	PRIMARY KEY(id)
);


CREATE TABLE infoPacientes.historiaclinica(
	id_historia SERIAL NOT NULL,
	id_paciente_fk INTEGER not null,
	id_enfermedad_fk INTEGER not null,
	antecedentes varchar(100) not null,
	PRIMARY KEY(id_historia),
	FOREIGN KEY (id_paciente_fk) references infoPacientes.paciente(id),
	FOREIGN KEY (id_enfermedad_fk) references infoPacientes.enfermedad(id)
);


INSERT INTO infoPacientes.paciente (id,nombre) VALUES (111,'ALBEIRO');
INSERT INTO infoPacientes.paciente (id,nombre) VALUES (222,'PEPA');
INSERT INTO infoPacientes.paciente (id,nombre) VALUES (333,'JUAN');
INSERT INTO infoPacientes.paciente (id,nombre) VALUES (444,'PEDRO');

INSERT INTO infoPacientes.enfermedad (id,nombre) VALUES (111,'DENGUE');
INSERT INTO infoPacientes.enfermedad (id,nombre) VALUES (222,'DIARREA');
INSERT INTO infoPacientes.enfermedad (id,nombre) VALUES (333,'CARIES');

INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');
INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');
INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');
INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');
INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');
INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');
INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');
INSERT INTO infoPacientes.historiaclinica (id_paciente_fk,id_enfermedad_fk,antecedentes) VALUES(111,111,'COMIO MUCHO BANANO');


REVOKE ALL ON infoPacientes.paciente from public;
REVOKE ALL ON infoPacientes.enfermedad from public;
REVOKE ALL ON infoPacientes.historiaclinica from public;

CREATE VIEW v_enfermedades as SELECT * FROM infoPacientes.enfermedad;

CREATE VIEW v_historial as SELECT * FROM infoPacientes.historiaclinica 
WHERE id_paciente_fk=111;

CREATE VIEW v_top_enfermedad as SELECT count(h.id_enfermedad_fk) as total ,e.nombre 
	FROM infoPacientes.historiaclinica as h 
	JOIN infoPacientes.enfermedad as e 
	ON h.id_enfermedad_fk=e.id 
	GROUP BY h.id_enfermedad_fk,e.nombre
	ORDER BY  total DESC;


GRANT SELECT ON v_top_enfermedad TO recepcionista;
GRANT SELECT ON v_historial,v_enfermedades TO medico;








