ALTER TABLE Cohorte
ADD CONSTRAINT fk_carrera_id
FOREIGN KEY (carrera) REFERENCES Carrera(idCarrera);