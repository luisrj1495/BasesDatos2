Create table aeronave(
  id_aeronave serial primary key not null,
  marca varchar(50) not null,
  modelo numeric(4,0) not null,
  capacidad numeric(3,0) not null
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
  costo_combustible numeric(12,2) not null,
  costo_porcentaje_vuelo numeric(4,2)

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
