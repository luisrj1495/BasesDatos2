Create table aeronave(
  id_aeronave serial primary key not null,
  marca varchar(50) not null,
  modelo numeric(4,0) not null,
  capacidad numeric(3,0) not null

 CONSTRAINT ck_capacidad_positiva CHECK (capacidad>=0 and capacidad<1000);
 CONSTRAINT ck_model_positivo CHECK (modelo>=0);

);

Create table aeropuerto(
  id_aeropuerto serial primary key not null,
  nombre varchar(50) not null,
  ciudad varchar(50) not null,
  pais varchar(20) not null
);

Create table puertaSalida(
  id_puerta numeric(2,0) primary key not null,
  descripcion varchar(20) not null
);

Create table aerolinea(
  id_aerolinea serial primary key not null,
  nombre_aerolinea varchar(50) not null
);

Create table costoVuelo(
  id_costoVuelo serial primary key not null,
  costo_combustible numeric(12,2) ,
  costo_porcentaje_vuelo numeric(4,2),
  costo_adicional numeric(8,2),

  CONSTRAINT ck_combustible_positivo CHECK (costo_combustible>=0);

);



Create table vuelo(
  id_vuelo serial primary key not null,
  hora_salida varchar(6) not null,
  hora_llegada varchar(6) not null,
  id_puerta_fk numeric(2) not null ,
  id_aerolinea_fk integer  not null,
  id_aeropuerto_fk integer not null,
  id_aeronave_fk integer not null
  constraint fk_vuelo_puerta FOREIGN KEY (id_puerta_fk) REFERENCES puertaSalida;
  CONSTRAINT fk_vuelo_aerolinea FOREIGN KEY (id_aerolinea_fk) REFERENCES aerolinea;
  CONSTRAINT fk_vuelo_aeropuerto FOREIGN KEY (id_aeropuerto_fk) REFERENCES aeropuerto;
  CONSTRAINT fk_vuelo_aeronave FOREIGN KEY (id_aeropuerto_fk) REFERENCES aeronave;
);

Create table escala(
id_escalas serial primary key not null,
no_pasajeros_suben numeric(3.0) null,
no_pasajeros_bajan numeric(3,0) null,
id_vuelo_fk integer not null,
id_aeropuerto integer not null,

CONSTRAINT fk_escala_vuelo FOREIGN KEY (id_vuelo_fk) REFERENCES vuelo;
CONSTRAINT fk_escala_aeropuerto FOREIGN KEY (id_aeropuerto_fk) REFERENCES aeronave;
CONSTRAINT ck_no_pasajero_suben CHECK (no_pasajeros_suben>0 and no_pasajeros_bajan>0);

);


Create table pasajero(
  id_pasajero numeric(12,0) primary key not null,
  pas_nombre varchar(25) not null,
  pas_apellido varchar(25) not null,
  pas_telefono varchar(14) null,
  pas_residencia varchar(50) null
);


Create table rel_vuelo_pasajero(
  id_pasajero_fk numeric(12) not null,
  id_vuelo_fk integer not null,
  CONSTRAINT pk_llaveCompuesta_rel_vueloPas primary key(id_pasajero_fk,id_vuelo_fk);
  CONSTRAINT fk_relVueloPas_pasajero FOREIGN KEY (id_pasajero_fk) REFERENCES pasajero;
  CONSTRAINT fk_relVueloPas_vuelo FOREIGN KEY (id_vuelo_fk) REFERENCES vuelo;


  P




);
