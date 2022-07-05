CREATE TABLE chauffeur(
   id_chauffeur SERIAL,
   nom VARCHAR(50) NOT NULL,
   poids SMALLINT,
   disponible BOOLEAN,
   PRIMARY KEY(id_chauffeur),
   UNIQUE(nom)
);

CREATE TABLE camion(
   id_camion SERIAL,
   immatriculation VARCHAR(15) NOT NULL,
   poids_vide SMALLINT,
   PTAC SMALLINT,
   id_chauffeur INTEGER,
   PRIMARY KEY(id_camion),
   UNIQUE(immatriculation),
   FOREIGN KEY(id_chauffeur) REFERENCES chauffeur(id_chauffeur)
);

CREATE TABLE colis(
   id_colis SERIAL,
   numero VARCHAR(10) NOT NULL,
   poids SMALLINT,
   destination VARCHAR(50) NOT NULL,
   id_camion INTEGER,
   PRIMARY KEY(id_colis),
   UNIQUE(numero),
   FOREIGN KEY(id_camion) REFERENCES camion(id_camion)
);

INSERT INTO chauffeur (id_chauffeur,nom,disponible,poids) VALUES
	 (1,'MARCEL',true,80),
	 (2,'ETIENNE',false,120),
	 (3,'JEAN',true,65),
	 (4,'ADRIEN',NULL,70),
	 (5,'JULIE',NULL,55);

INSERT INTO public.camion (id_camion,immatriculation,poids_vide,PTAC,id_chauffeur) VALUES
	 (1,'YKON',1500,2800,2),
	 (2,'NUNAVUT',2000,6000,NULL),
	 (3,'ONTARIO',2000,5410,NULL),
	 (4,'MANITOBA',3000,7000,NULL),
	 (5,'ALBERTA',1000,3200,NULL);

INSERT INTO colis (numero,poids,destination,id_camion) 	VALUES
	('CO02',200,'PARIS',1),
	('CO03',300,'MARSEILLE',NULL),
	('CO04',150,'PARIS',NULL),
	('CO05',1000,'LILLE',NULL),
	('CO06',900,'PARIS',NULL),
	('CO07',200,'NANTES',4),
	('CO08',400,'PARIS',NULL),
	('CO09',600,'LILLE',NULL),
	('CO10',900,'PARIS',1),
	('CO11',105,'NANTES',4),
	('CO12',200,'NANTES',NULL),
	('CO13',250,'PARIS',NULL),
	('CO14',40,'MARSEILLE',NULL),
	('CO15',300,'PARIS',NULL),
	('CO16',210,'PARIS',NULL),
	('CO17',562,'MARSEILLE',NULL),
	('CO18',120,'PARIS',1),
	('CO19',410,'LILLE',NULL),
	('CO20',652,'PARIS',NULL),
	('CO21',630,'LILLE',NULL),
	('CO22',520,'NANTES',NULL),
	('CO23',47,'PARIS',NULL),
	('CO24',852,'PARIS',NULL),
	('CO25',352,'NANTES',NULL),
	('CO26',145,'PARIS',NULL),
	('CO27',652,'PARIS',NULL),
	('CO28',345,'PARIS',NULL),
	('CO29',763,'PARIS',NULL),
	('CO30',524,'MARSEILLE',NULL),
	('CO31',159,'LILLE',NULL),
	('CO32',357,'PARIS',NULL),
	('CO33',456,'NANTES',4),
	('CO34',654,'PARIS',NULL),
	('CO35',852,'PARIS',NULL),
	('CO36',258,'PARIS',NULL),
	('CO37',973,'PARIS',NULL),
	('CO38',743,'NANTES',4),
	('CO39',813,'PARIS',NULL),
	('CO40',381,'MARSEILLE',NULL),
	('CO41',183,'MARSEILLE',NULL),
	('CO42',671,'PARIS',NULL),
	('CO43',482,'PARIS',NULL),
	('CO44',267,'PARIS',NULL),
	('CO45',842,'PARIS',NULL),
	('CO46',716,'NANTES',4),
	('CO47',521,'PARIS',NULL),
	('CO48',357,'PARIS',NULL),
	('CO49',415,'NANTES',NULL),
	('CO50',352,'PARIS',NULL);
