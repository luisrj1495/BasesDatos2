CREATE OR REPLACE FUNCTION diferencia(int4,int4) RETURNS int4
AS 'SELECT $1-$2;' LANGUAGE 'sql';

SELECT diferencia(5,4);

CREATE TABLE empleado (nom text, sueldo int);
INSERT INTO empleado (nom,sueldo) VALUES ('Luis',2000),('Lopez',4000),('Lolo',2500);

CREATE OR REPLACE FUNCTION mayorSueldo(empleado,refVal float) RETURNS TEXT AS $$
  	DECLARE
  		emp ALIAS FOR $1;

    BEGIN
        IF emp.sueldo >= 2500 THEN
            RETURN 'Bien pagado';
        ELSE
            RETURN 'Mal pagado';
        END IF;
    END;

$$ LANGUAGE 'plpgsql';

SELECT nom,mayorSueldo(empleado,1000) from empleado;


--------------------------

--------------------------

CREATE OR REPLACE FUNCTION mayorSueldo2() RETURNS VARCHAR AS $$
    DECLARE
    sueldoEmpleado int;
    BEGIN
    
        IF sueldo >=2500 THEN
            RETURN 'BIEN PAGO';
        ELSE
            RETURN 'MAL PAGO';
        END IF;
    END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION diferencia2(int4,int4) RETURNS int4 AS '
    BEGIN
        RETURN $1-$2;
    END;


'LANGUAGE 'sql';

CREATE OR REPLACE FUNCTION suma_producto(a int,b int, OUT suma int, OUT multiplicacion int) AS $$ 
    BEGIN
        suma := a + b;
        multiplicacion := a*b;
    END;

$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION division(a float,b float) RETURNS float AS $$
DECLARE 
    result float;

BEGIN
    result := a/b;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------
Ejemplo de multiplicacion de dos numeros y 
sumar unas constantes
-----------------------------------------------

CREATE OR REPLACE FUNCTION ejemplo(integer, integer) RETURNS integer AS $$
DECLARE
 numero1 ALIAS FOR $1;
 numero2 ALIAS FOR $2;

 constante CONSTANT integer := 100;
 resultado integer;


BEGIN
 resultado := (numero1 * numero2) + constante;

 RETURN resultado;
END;
$$ LANGUAGE plpgsql;



-------------------------------------
Con condicional
-------------------------------------


CREATE OR REPLACE FUNCTION ejemplo_txt(integer, integer) RETURNS text AS $$
DECLARE
 numero1 ALIAS FOR $1;
 numero2 ALIAS FOR $2;

 constante CONSTANT integer := 100;
 resultado INTEGER;

 resultado_txt TEXT DEFAULT 'El resultado es 104'; 

BEGIN
 resultado := (numero1 * numero2) + constante;

 IF resultado <> 104 THEN
    resultado_txt :=  'El resultado NO es 104';
 END IF;

 RETURN resultado_txt;
END;
$$ LANGUAGE plpgsql;

--------------------
Resuelve la fórmula de la cuadrática
--------------------

CREATE OR REPLACE FUNCTION cuadratica(float,float,float, OUT x float, OUT xx float) AS $$
DECLARE
    a ALIAS FOR $1;
    b ALIAS FOR $2;
    c ALIAS FOR $3;
  
BEGIN
  
    x := ((-1*b)+sqrt((power(b,2))-(4*a*c)))/(2*a);
    xx :=((-1*b)-sqrt((power(b,2))-(4*a*c)))/(2*a);
  

END;
$$ LANGUAGE plpgsql;

SELECT cuadratica(1,2,-8);


-------------------------
Solicita el nombre de una persona y el año de nacimiento, informarle si es mayor de edad o no
------------------------

CREATE OR REPLACE FUNCTION mayorEdad(nom text, ano int) RETURNS text AS $$
    DECLARE
        diferencia int;
    BEGIN
        diferencia := 2018-ano;
        IF diferencia >= 18 THEN
            RETURN  nom || ' Es mayor de edad';
        ELSE
            RETURN nom || ' No es mayor de edad';
        END IF;
    END;
$$ LANGUAGE plpgsql;

SELECT mayorEdad('Luis',1995);


//////////////////////////

Se requiere una función que reciba el nombre de una persona y el apellido para luego retornar sus datos concatenados.

//////////////////////////


CREATE OR REPLACE FUNCTION mostrarNombre(varchar, varchar) RETURNS VARCHAR AS $$

    DECLARE
    nom ALIAS FOR $1;
    appe ALIAS FOR $2;

    BEGIN
        RETURN nom || ' ' || appe;
    END
$$ LANGUAGE plpgsql;

SELECT mostrarNombre('Luis','Ruiz');



/////////////////
Tablas para transferencias Bancarias
/////////////////


CREATE TABLE cuenta(
    id_cuenta int PRIMARY KEY,
    saldo float
);

INSERT INTO cuenta (id_cuenta,saldo) VALUES (1,500),(2,0);

CREATE TABLE transferencia(
    id_transfer int PRIMARY KEY,
    id_transfiere int,
    id_recibe int,
    saldo float
);

CREATE OR REPLACE FUNCTION transferenciaBancaria(int,int,float) RETURNS VARCHAR AS $$

    DECLARE
        cuentaInicial ALIAS FOR $1;
        cuentaFinal ALIAS FOR $2;
        valorTrans ALIAS FOR $3;
        saldoCuenta FLOAT;
        diferencia FLOAT;
    BEGIN
        SELECT saldo INTO saldoCuenta FROM cuenta WHERE id_cuenta = cuentaInicial;
        diferencia := saldoCuenta -valorTrans;
        IF diferencia < 0 THEN 
            RETURN 'NO SE PUEDE HACER LA TRANSFERENCIA';
        ELSE
            UPDATE cuenta SET saldo = diferencia WHERE id_cuenta = cuentaInicial;
            UPDATE cuenta SET saldo = saldo + valorTrans WHERE id_cuenta = cuentaFinal;
            RETURN 'TRANSFERENCIA EXITOSA';
        END IF;
    END
$$ LANGUAGE plpgsql;

SELECT transferenciaBancaria(1,2,100);



//////////////////////

Basados en la tabla anterior, es necesario aplicar intereses sobre los saldos de las cuentas.

//////////////////////

CREATE OR REPLACE FUNCTION sumarInteres(float, cuenta ) RETURNS VARCHAR AS $$

    DECLARE 
        interes ALIAS FOR $1;
        tabla ALIAS FOR $2;
        valor float;
  
    BEGIN
        UPDATE cuenta  SET saldo=(tabla.saldo*interes+tabla.saldo) WHERE id_cuenta=tabla.id_cuenta;

   
        RETURN 'Se sumó el interes';

    END;
$$ LANGUAGE plpgsql;

SELECT id_cuenta,saldo,sumarInteres(0.10,cuenta) FROM cuenta;

////////////////////////////
Crear un procedimiento que inserte información en una tabla, pero antes validando que dicha información no esté
///////////////////////////

CREATE OR REPLACE FUNCTION checkInfo(float) RETURNS VARCHAR AS $$
    DECLARE
        valorAdd ALIAS FOR $1;
        valorSerch float;
    BEGIN
        SELECT saldo INTO valorSerch FROM cuenta WHERE saldo = valorAdd;
        IF valorSerch = NULL THEN 
            INSERT INTO cuenta (id_cuenta,saldo) VALUES (round(random()*100), valorAdd);
            RETURN 'Se registro el nuevo valor';   
        ELSE 
             RETURN 'El valor ya existe !';
        END IF;
    END;
$$ LANGUAGE plpgsql;

SELECT checkInfo(250);

