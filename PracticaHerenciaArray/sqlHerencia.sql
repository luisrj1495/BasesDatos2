CREATE DATABASE pruebaHerencia;

CREATE TABLE persona (
	id integer primary key,
	nombres text[],
	apellidos text[],
	habilidades text[]

);


INSERT INTO persona VALUES(1,'{"luis","ernesto"}','{"ruiz","aramillo"}','{"volar","comer"}');
INSERT INTO persona VALUES(2,'{"lu","ernesto"}','{"ruiz","aramillo"}','{"volar","comer"}');
INSERT INTO persona VALUES(3,'{"luise","ernesto"}','{"ruiz","aramillo"}','{"volar","comer"}');
INSERT INTO persona VALUES(4,'{"luisoi","ernesto"}','{"ruiz","aramillo"}','{"volar","comer"}');
INSERT INTO persona VALUES(5,'{"luisoi","ernesto"}','{"ruiz","aramillo"}','{"cantar","comer"}');

SELECT * FROM persona;
SELECT apellidos FROM persona WHERE PERSONA.habilidades[1] ='cantar';


CREATE TABLE astronomo(
	nivel_fisica integer CHECK (nivel_fisica>=0 OR nivel_fisica<=10),
	area_especifica text[]

)INHERITS(persona);


INSERT INTO astronomo VALUES(6,'{"elber","gomez"}','{"torba","morales"}','{"bailar","comer"}',5,'{"cagarla","hacer delete en las tablas"}');
INSERT INTO astronomo VALUES(7,'{"Benito","gomez"}','{"torba","morales"}','{"bailar","comer"}',5,'{"cagarla","hacer delete en las tablas"}');
INSERT INTO astronomo VALUES(8,'{"violentina","gomez"}','{"torba","morales"}','{"bailar","comer"}',5,'{"cagarla","hacer delete en las tablas"}');
INSERT INTO astronomo VALUES(9,'{"Elz","gomez"}','{"torba","morales"}','{"bailar","comer"}',5,'{"cagarla","hacer delete en las tablas"}');



DELETE FROM astronomo WHERE id=1;


 ¿Se puede insertar en las dos tablas?
 Si, se pueden ver como tablas independientes

 ¿Si se inserta en la tabla padre se refleja en la hija?
 No, porque no se esta vinculando directamente el hijo

 ¿Si se inserta en la tabla hija se refleja en la padre?
 si, porque esta depende del padre, es decir, toma sus campos heredados

 ¿al insertar en la tabla padre se puede borrar desde la hija?
 No, porque no estan relacionados directamente

 DELETE FROM astronomo WHERE id=1;

 ¿al insertar en la tabla hija se puede borrar desde la tabla padre?
 si, Porque es el padre tiene el control sobre las hijas

 DELETE FROM persona WHERE id=9;

 ¿Se puede borrar la tabla padre luego de crear la herencia?.
No, porque el padre tiene hijos que dependen de él



//Transaccion

BEGIN;
INSERT INTO astronomo VALUES(10,'{"PITER","PAN"}','{"torba","morales"}','{"bailar","comer"}',5,'{"cagarla","hacer cositas"}');
COMMIT;

BEGIN;
DELETE FROM persona where id=3;
ROLLBACK;

¿al iniciar desde otra instancia se ve la información?
No, porque cuando se realiza una Transaccion sino se ejecuta COMMIT que es para realizar los cambios o ROLLBACK para desechar los cambios, 
no se pueden ver reflejados en la base de datos 



