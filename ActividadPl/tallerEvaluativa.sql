-- /////////////////////
-- -- 1. Dada una tabla tbl_lista_precios (id_lista, id_producto, id_region, precio), 
-- -- construya un esquema para que puda ser consultada la información desde una 
-- -- vista mediante un usuario limitado solo para ésta tarea
-- ////////////////////

CREATE USER usuarioweb  WITH PASSWORD '1234' VALID UNTIL '2019-01-01';
CREATE SCHEMA infoWeb AUTHORIZATION usuarioweb;

CREATE TABLE infoWeb.tbl_lista(
    id_lista int ,
    id_producto int ,
    id_region int ,
    precio float
);

INSERT INTO infoWeb.tbl_lista (id_lista,id_producto,id_region, precio) VALUES (1,1,1,2500),(1,2,1,2500),(1,3,1,3000),(1,4,1,2000);

ALTER DEFAULT PRIVILEGES IN SCHEMA infoWeb GRANT SELECT ON TABLES TO usuarioweb;
CREATE VIEW v_tbl_lista as SELECT * FROM infoWeb.tbl_lista;
GRANT SELECT ON v_tbl_lista TO usuarioweb;

SELECT v_tbl_lista;

-- //////////////
-- 2. Defina un ejemplo que utilice vectores
-- /////////////

CREATE TABLE producto(
    id serial,
    caracteristicas text[] 
);

INSERT INTO  producto (caracteristicas) VALUES ('{"barato","economico","calidoso"}'),('{"malo","costoso"}');

SELECT * FROM producto WHERE producto.caracteristicas[1] = 'barato';

-- ///////////
-- 3. Creé un proceso orientado a cambiar el precio utilizando transacciones
-- //////////

BEGIN;
    UPDATE infoWeb.tbl_lista SET precio = 8888 WHERE id_producto = 1;
COMMIT;
ROLLBACK;


-- ///////
-- 4. Defina un procedimiento almacenado que permita evaluar que producto es el más caro en determinada región suministrada
-- //////

CREATE OR REPLACE FUNCTION evaluarProducto(int) RETURNS VARCHAR AS $$
    DECLARE
        id_reg ALIAS FOR $1;
        producto INT;
        precioProd FLOAT;

    BEGIN
        SELECT id_producto, MAX(precio) as preciomax INTO producto,precioProd from infoweb.tbl_lista where id_region = id_reg GROUP BY id_producto ORDER BY preciomax DESC LIMIT 1;
        RETURN 'EL producto con el código ' || producto || ' es el mas caro de la región '|| id_reg;
    END     
$$ LANGUAGE plpgsql;

SELECT evaluarProducto(1);

-- ///////
-- 5. Defina un disparador que garantice que solo se podrán ingresar datos numéricos al precio
-- //////

CREATE OR REPLACE FUNCTION checkPrecioNumeric() RETURNS TRIGGER AS $$
        BEGIN
            -- IF pg_typeof(NEW.precio) = 'double precision' OR pg_typeof(NEW.precio) = 'integer' THEN
            --     RAISE EXCEPTION ' El tipo de es numerico';
        
            -- END IF;

            RETURN pg_typeof(NEW.precio);
        END;
    $$ 
    LANGUAGE 'plpgsql';

CREATE TRIGGER checkPrecioNumeric BEFORE INSERT OR UPDATE ON infoWeb.tbl_lista
        FOR EACH ROW EXECUTE PROCEDURE checkPrecioNumeric();

INSERT INTO infoWeb.tbl_lista (id_lista,id_producto,id_region, precio) VALUES (1,1,1,988);

DROP TRIGGER checkPrecioNumeric ON infoWeb.tbl_lista;
DROP FUNCTION checkPrecioNumeric();