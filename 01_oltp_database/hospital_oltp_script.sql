/* =========================================================
   HOSPITAL_OLTP - SCRIPT COMPLETO CORREGIDO
   ========================================================= */

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Hospital_OLTP')
BEGIN
    ALTER DATABASE Hospital_OLTP SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Hospital_OLTP;
END;
GO

CREATE DATABASE Hospital_OLTP;
GO

USE Hospital_OLTP;
GO
SET NOCOUNT ON;

/* ---------- TABLAS MAESTRAS ---------- */
CREATE TABLE Especialidades (
    IDEspecialidad INT IDENTITY(1,1) PRIMARY KEY,
    NombreEspecialidad VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(250)
);
CREATE TABLE Sedes (
    IDSede INT IDENTITY(1,1) PRIMARY KEY,
    NombreSede VARCHAR(100) NOT NULL,
    Distrito VARCHAR(80),
    Direccion VARCHAR(200),
    Telefono VARCHAR(15)
);
CREATE TABLE Salas (
    IDSala INT IDENTITY(1,1) PRIMARY KEY,
    IDSede INT FOREIGN KEY REFERENCES Sedes(IDSede),
    NombreSala VARCHAR(50) NOT NULL,
    Piso INT,
    Capacidad INT DEFAULT 1
);
CREATE TABLE Medicos (
    IDMedico INT IDENTITY(1,1) PRIMARY KEY,
    IDEspecialidad INT FOREIGN KEY REFERENCES Especialidades(IDEspecialidad),
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    NumeroColegiatura VARCHAR(20) UNIQUE,
    Telefono VARCHAR(15),
    Email VARCHAR(120)
);
CREATE TABLE Pacientes (
    IDPaciente INT IDENTITY(1,1) PRIMARY KEY,
    DNI VARCHAR(8) UNIQUE NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    FechaNacimiento DATE,
    Genero CHAR(1),
    Telefono VARCHAR(15),
    Direccion VARCHAR(200),
    Distrito VARCHAR(80)
);
CREATE TABLE Aseguradoras (
    IDAseguradora INT IDENTITY(1,1) PRIMARY KEY,
    NombreAseguradora VARCHAR(100) NOT NULL
);
CREATE TABLE Planes_Seguro (
    IDPlan INT IDENTITY(1,1) PRIMARY KEY,
    IDAseguradora INT FOREIGN KEY REFERENCES Aseguradoras(IDAseguradora),
    NombrePlan VARCHAR(100) NOT NULL,
    PorcentajeCobertura DECIMAL(5,2)
);
CREATE TABLE Catalogo_Servicios (
    IDServicio INT IDENTITY(1,1) PRIMARY KEY,
    NombreServicio VARCHAR(150) NOT NULL,
    PrecioBase DECIMAL(10,2) NOT NULL
);
CREATE TABLE Medicamentos (
    IDMedicamento INT IDENTITY(1,1) PRIMARY KEY,
    NombreMedicamento VARCHAR(150) NOT NULL,
    Presentacion VARCHAR(100),
    Precio DECIMAL(10,2) NOT NULL
);
CREATE TABLE Diagnosticos_CIE10 (
    IDDiagnostico INT IDENTITY(1,1) PRIMARY KEY,
    CodigoCIE10 VARCHAR(10) UNIQUE NOT NULL,
    Descripcion VARCHAR(250) NOT NULL
);

/* ---------- TABLAS TRANSACCIONALES ---------- */
CREATE TABLE Citas (
    IDCita INT IDENTITY(1,1) PRIMARY KEY,
    IDPaciente INT FOREIGN KEY REFERENCES Pacientes(IDPaciente),
    IDMedico INT FOREIGN KEY REFERENCES Medicos(IDMedico),
    IDSala INT FOREIGN KEY REFERENCES Salas(IDSala),
    FechaHoraCita DATETIME NOT NULL,
    EstadoCita VARCHAR(20)
);
CREATE TABLE Atenciones (
    IDAtencion INT IDENTITY(1,1) PRIMARY KEY,
    IDCita INT FOREIGN KEY REFERENCES Citas(IDCita),
    IDDiagnostico INT FOREIGN KEY REFERENCES Diagnosticos_CIE10(IDDiagnostico),
    Observaciones VARCHAR(500)
);
CREATE TABLE Recetas_Cabecera (
    IDReceta INT IDENTITY(1,1) PRIMARY KEY,
    IDAtencion INT FOREIGN KEY REFERENCES Atenciones(IDAtencion),
    FechaEmision DATE NOT NULL
);
CREATE TABLE Detalle_Recetas (
    IDDetalleReceta INT IDENTITY(1,1) PRIMARY KEY,
    IDReceta INT FOREIGN KEY REFERENCES Recetas_Cabecera(IDReceta),
    IDMedicamento INT FOREIGN KEY REFERENCES Medicamentos(IDMedicamento),
    Cantidad INT NOT NULL,
    Indicaciones VARCHAR(200)
);
CREATE TABLE Facturacion (
    IDFacturacion INT IDENTITY(1,1) PRIMARY KEY,
    IDCita INT FOREIGN KEY REFERENCES Citas(IDCita),
    IDPlan INT FOREIGN KEY REFERENCES Planes_Seguro(IDPlan),
    MontoSubtotal DECIMAL(10,2) NOT NULL,
    MontoDescuento DECIMAL(10,2) NOT NULL,
    MontoTotal DECIMAL(10,2) NOT NULL,
    FechaPago DATETIME NOT NULL,
    MetodoPago VARCHAR(30)
);
GO

/* ---------- MAESTROS ---------- */
INSERT INTO Especialidades (NombreEspecialidad, Descripcion) VALUES
('Medicina General','Atención médica integral del paciente adulto'),
('Pediatría','Atención médica de niños y adolescentes'),
('Cardiología','Diagnóstico y tratamiento de enfermedades del corazón'),
('Dermatología','Tratamiento de enfermedades de la piel'),
('Traumatología','Tratamiento de lesiones del sistema musculoesquelético'),
('Ginecología y Obstetricia','Salud reproductiva de la mujer y embarazo'),
('Oftalmología','Diagnóstico y tratamiento de enfermedades oculares'),
('Odontología','Salud bucodental'),
('Neurología','Tratamiento de enfermedades del sistema nervioso'),
('Psicología','Salud mental y apoyo psicológico'),
('Endocrinología','Tratamiento de trastornos hormonales y metabólicos'),
('Gastroenterología','Tratamiento del aparato digestivo'),
('Urología','Tratamiento del aparato urinario'),
('Otorrinolaringología','Tratamiento de oído, nariz y garganta'),
('Medicina Interna','Diagnóstico y tratamiento de enfermedades del adulto');

INSERT INTO Sedes (NombreSede, Distrito, Direccion, Telefono) VALUES
('Clínica San Vicente de Cañete','San Vicente de Cañete','Av. Mariscal Benavides 745','01-581-2030'),
('Hospital Rezola','San Vicente de Cañete','Jr. Miguel Grau 125','01-581-3120'),
('Centro Médico Imperial','Imperial','Av. Ramos Larrea 210','01-581-4510'),
('Posta Médica Nuevo Imperial','Nuevo Imperial','Av. 28 de Julio 340','01-581-7788'),
('Clínica Santa María','San Vicente de Cañete','Av. Libertadores 890','01-581-9040');

INSERT INTO Aseguradoras (NombreAseguradora) VALUES
('Pacífico Seguros'),('Rímac Seguros'),('Mapfre Perú'),('Sanitas Perú'),
('La Positiva'),('Sequoia'),('Vivir Seguros'),('ONCOSALUD');

INSERT INTO Planes_Seguro (IDAseguradora, NombrePlan, PorcentajeCobertura) VALUES
(1,'Salud Básico',50.00),(1,'Salud Premium',80.00),(2,'Vida Total',70.00),
(3,'Plan Familiar',60.00),(4,'Plan Corporativo',90.00),(5,'Plan Esencial',55.00),
(6,'Plan Oncológico',100.00);

INSERT INTO Diagnosticos_CIE10 (CodigoCIE10, Descripcion) VALUES
('J00','Rinofaringitis aguda (resfriado común)'),
('A09','Diarrea y gastroenteritis de presunto origen infeccioso'),
('E11','Diabetes mellitus tipo 2'),
('I10','Hipertensión esencial (primaria)'),
('J45','Asma'),('K29','Gastritis y duodenitis'),('M54','Dorsalgia'),
('N39','Trastornos del sistema urinario'),('R51','Cefalea'),('J18','Neumonía'),
('K21','Enfermedad por reflujo gastroesofágico'),('F41','Trastorno de ansiedad'),
('H10','Conjuntivitis'),('L20','Dermatitis atópica'),('E66','Obesidad');

INSERT INTO Medicamentos (NombreMedicamento, Presentacion, Precio) VALUES
('Paracetamol','Tableta 500 mg',1.50),
('Amoxicilina','Cápsula 500 mg',4.50),
('Ibuprofeno','Tableta 400 mg',2.80),
('Omeprazol','Cápsula 20 mg',3.20),
('Metformina','Tableta 850 mg',2.40),
('Losartán','Tableta 50 mg',3.80),
('Salbutamol','Inhalador 100 mcg',18.50),
('Diclofenaco','Tableta 50 mg',2.20),
('Azitromicina','Tableta 500 mg',8.50),
('Cetirizina','Tableta 10 mg',2.60),
('Amlodipino','Tableta 5 mg',3.10),
('Insulina Glargina','Pluma 100 UI/mL',65.00);

INSERT INTO Catalogo_Servicios (NombreServicio, PrecioBase) VALUES
('Consulta Médica General',30.00),('Consulta Especializada',60.00),
('Ecografía Abdominal',120.00),('Radiografía de Tórax',80.00),
('Electrocardiograma',90.00),('Análisis de Sangre Completo',45.00),
('Perfil Lipídico',55.00),('Hemograma Completo',35.00),
('Examen de Orina',25.00),('Tomografía Axial Computarizada',350.00),
('Endoscopía Digestiva Alta',280.00),('Consulta Odontológica',50.00);
GO

/* ---------- SALAS ---------- */
DECLARE @i INT = 1;
WHILE @i <= 20 BEGIN
    INSERT INTO Salas (IDSede, NombreSala, Piso, Capacidad)
    VALUES ((@i % 5) + 1, 'Consultorio ' + RIGHT('00' + CAST(@i AS VARCHAR), 2), (@i % 3) + 1, 1);
    SET @i += 1;
END;
GO

/* ---------- MEDICOS ---------- */
DECLARE @NombresMedicos TABLE (Id INT IDENTITY, Nombre VARCHAR(50));
INSERT INTO @NombresMedicos (Nombre) VALUES
('José'),('María'),('Carlos'),('Ana'),('Luis'),('Rosa'),('Juan'),('Carmen'),
('Pedro'),('Lucía'),('Miguel'),('Elena'),('Jorge'),('Sofía'),('Ricardo'),
('Patricia'),('Fernando'),('Gabriela'),('Alberto'),('Verónica'),('César'),
('Milagros'),('Raúl'),('Katherine'),('Marco'),('Yolanda'),('Andrés'),
('Diana'),('Eduardo'),('Jessica'),('Víctor'),('Silvia'),('Óscar'),('Paola'),
('Hugo'),('Nancy'),('Iván'),('Roxana'),('Percy'),('Flor'),('Bruno'),
('Melissa'),('Pablo'),('Karina'),('Renzo'),('Liliana'),('Diego'),('Tatiana'),
('Sergio'),('Noelia');

DECLARE @ApellidosMedicos TABLE (Id INT IDENTITY, Apellido VARCHAR(50));
INSERT INTO @ApellidosMedicos (Apellido) VALUES
('Quispe'),('Mamani'),('Huamán'),('Flores'),('Condori'),('Chávez'),
('Rojas'),('Vásquez'),('Sánchez'),('Ramos'),('Castillo'),('Espinoza'),
('Torres'),('Salazar'),('Bravo'),('Paredes'),('Cárdenas'),('Yupanqui'),
('Yactayo'),('Ormeño'),('Ñaupa'),('Ccahuana'),('Ttito'),('Cáceres'),
('Ríos'),('Vargas'),('Cruz'),('Guzmán'),('Rivera'),('Mendoza'),
('Aguilar'),('Cabrera'),('Del Águila'),('Panduro'),('Tuanama'),
('Sangama'),('Pizango'),('Yumbato'),('Amasifuén'),('Tapullima'),
('Rengifo'),('Ruiz'),('Silva'),('Tello'),('Urbina'),
('Valdez'),('Zegarra'),('Zapata'),('Zavaleta'),('Yataco');

DECLARE @iMed INT = 1;
DECLARE @nomMed VARCHAR(50), @apeMed VARCHAR(50);
WHILE @iMed <= 50 BEGIN
    SET @nomMed = (SELECT Nombre FROM @NombresMedicos WHERE Id = @iMed);
    SET @apeMed = (SELECT Apellido FROM @ApellidosMedicos WHERE Id = @iMed);
    INSERT INTO Medicos (IDEspecialidad, Nombres, Apellidos, NumeroColegiatura, Telefono, Email)
    VALUES (
        (ABS(CHECKSUM(NEWID())) % 15) + 1,
        @nomMed,
        @apeMed,
        'CMP' + RIGHT('00000' + CAST(10000 + @iMed AS VARCHAR), 5),
        '9' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR), 8),
        LOWER(@nomMed) + '.' + LOWER(@apeMed) + '@clinicasanvicente.pe'
    );
    SET @iMed += 1;
END;
GO

/* ---------- PACIENTES (CORREGIDO) ---------- */
DECLARE @NombresPac TABLE (Id INT IDENTITY, Nombre VARCHAR(50));
INSERT INTO @NombresPac (Nombre) VALUES
('José'),('María'),('Carlos'),('Ana'),('Luis'),('Rosa'),('Juan'),('Carmen'),
('Pedro'),('Lucía'),('Miguel'),('Elena'),('Jorge'),('Sofía'),('Ricardo'),
('Patricia'),('Fernando'),('Gabriela'),('Alberto'),('Verónica'),('César'),
('Milagros'),('Raúl'),('Katherine'),('Marco'),('Yolanda'),('Andrés'),
('Diana'),('Eduardo'),('Jessica'),('Víctor'),('Silvia'),('Óscar'),('Paola'),
('Hugo'),('Nancy'),('Iván'),('Roxana'),('Percy'),('Flor');

DECLARE @ApellidosPac TABLE (Id INT IDENTITY, Apellido VARCHAR(50));
INSERT INTO @ApellidosPac (Apellido) VALUES
('Quispe'),('Mamani'),('Huamán'),('Flores'),('Condori'),('Chávez'),
('Rojas'),('Vásquez'),('Sánchez'),('Ramos'),('Castillo'),('Espinoza'),
('Torres'),('Salazar'),('Bravo'),('Paredes'),('Cárdenas'),('Yupanqui'),
('Yactayo'),('Ormeño'),('Ñaupa'),('Ccahuana'),('Ttito'),('Cáceres'),
('Ríos'),('Vargas'),('Cruz'),('Guzmán'),('Rivera'),('Mendoza'),
('Aguilar'),('Cabrera'),('Del Águila'),('Panduro'),('Tuanama'),
('Sangama'),('Pizango'),('Yumbato'),('Amasifuén'),('Tapullima');

DECLARE @Distritos TABLE (Id INT IDENTITY, Nombre VARCHAR(80));
INSERT INTO @Distritos (Nombre) VALUES
('San Vicente de Cañete'),('Imperial'),('Nuevo Imperial'),('Quilmaná'),
('Cerro Azul'),('Asia'),('Coayllo'),('Lunahuaná'),('Pacarán'),
('San Antonio'),('Santa Cruz de Flores'),('Zúñiga'),('Mala'),
('Calango'),('Chilca');

DECLARE @iPac INT = 1;
DECLARE @idxNombre INT, @idxAp1 INT, @idxAp2 INT, @idxDistrito INT;
WHILE @iPac <= 5000 BEGIN
    SET @idxNombre   = (ABS(CHECKSUM(NEWID())) % 40) + 1;
    SET @idxAp1      = (ABS(CHECKSUM(NEWID())) % 40) + 1;
    SET @idxAp2      = (ABS(CHECKSUM(NEWID())) % 40) + 1;
    SET @idxDistrito = (ABS(CHECKSUM(NEWID())) % 15) + 1;

    INSERT INTO Pacientes (DNI, Nombres, Apellidos, FechaNacimiento, Genero, Telefono, Direccion, Distrito)
    VALUES (
        RIGHT('00000000' + CAST(40000000 + @iPac AS VARCHAR), 8),
        (SELECT Nombre FROM @NombresPac WHERE Id = @idxNombre),
        (SELECT Apellido FROM @ApellidosPac WHERE Id = @idxAp1) + ' ' +
        (SELECT Apellido FROM @ApellidosPac WHERE Id = @idxAp2),
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 25000), GETDATE()),
        CASE WHEN @iPac % 2 = 0 THEN 'M' ELSE 'F' END,
        '9' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR), 8),
        'Calle ' + CAST(ABS(CHECKSUM(NEWID())) % 500 AS VARCHAR) + ' Mz ' +
        CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + ' Lt ' + CAST(ABS(CHECKSUM(NEWID())) % 30 AS VARCHAR),
        (SELECT Nombre FROM @Distritos WHERE Id = @idxDistrito)
    );
    SET @iPac += 1;
END;
GO

/* ---------- CITAS (100,000) ---------- */
DECLARE @contadorCitas INT = 1;
DECLARE @idPaciente INT, @idMedico INT, @idSala INT, @diasAleatorios INT;
DECLARE @estados TABLE (Estado VARCHAR(20));
INSERT INTO @estados VALUES ('Atendida'), ('Atendida'), ('Atendida'), ('Cancelada'), ('No Asistió');

WHILE @contadorCitas <= 100000
BEGIN
    SET @idPaciente = (ABS(CHECKSUM(NEWID())) % 5000) + 1;
    SET @idMedico = (ABS(CHECKSUM(NEWID())) % 50) + 1;
    SET @idSala = (ABS(CHECKSUM(NEWID())) % 20) + 1;
    SET @diasAleatorios = (ABS(CHECKSUM(NEWID())) % 1800);

    INSERT INTO Citas (IDPaciente, IDMedico, IDSala, FechaHoraCita, EstadoCita)
    VALUES (@idPaciente, @idMedico, @idSala,
            DATEADD(HOUR, 8 + (ABS(CHECKSUM(NEWID())) % 10),
                    DATEADD(DAY, -@diasAleatorios, GETDATE())),
            (SELECT TOP 1 Estado FROM @estados ORDER BY NEWID()));
    SET @contadorCitas += 1;
END;
GO

/* ---------- ATENCIONES (80,000) ---------- */
INSERT INTO Atenciones (IDCita, IDDiagnostico, Observaciones)
SELECT TOP 80000
    c.IDCita,
    (ABS(CHECKSUM(NEWID())) % 15) + 1,
    'Paciente evaluado. Se recomienda seguimiento en consulta externa.'
FROM Citas c
WHERE c.EstadoCita = 'Atendida'
ORDER BY c.IDCita;
GO

/* ---------- FACTURACION (80,000) ---------- */
DECLARE @idCitaF INT, @fechaCitaF DATETIME, @idxPlanF INT, @metodoF VARCHAR(30);
DECLARE @subtotalF DECIMAL(10,2), @coberturaF DECIMAL(5,2), @fechaPagoF DATETIME;

DECLARE cursorCitas CURSOR FOR
    SELECT TOP 80000 IDCita, FechaHoraCita
    FROM Citas
    WHERE EstadoCita = 'Atendida'
    ORDER BY IDCita;

OPEN cursorCitas;
FETCH NEXT FROM cursorCitas INTO @idCitaF, @fechaCitaF;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @idxPlanF = (ABS(CHECKSUM(NEWID())) % 7) + 1;
    SET @metodoF = CASE (ABS(CHECKSUM(NEWID())) % 4)
        WHEN 0 THEN 'Efectivo'
        WHEN 1 THEN 'Tarjeta de Débito'
        WHEN 2 THEN 'Tarjeta de Crédito'
        ELSE 'Transferencia'
    END;
    SET @subtotalF = CAST(30 + (ABS(CHECKSUM(NEWID())) % 12) * 10 AS DECIMAL(10,2));
    SET @coberturaF = (SELECT PorcentajeCobertura FROM Planes_Seguro WHERE IDPlan = @idxPlanF);
    SET @fechaPagoF = DATEADD(HOUR, ABS(CHECKSUM(NEWID())) % 12, @fechaCitaF);

    INSERT INTO Facturacion (IDCita, IDPlan, MontoSubtotal, MontoDescuento, MontoTotal, FechaPago, MetodoPago)
    VALUES (@idCitaF, @idxPlanF, @subtotalF,
            @subtotalF * (@coberturaF / 100.0),
            @subtotalF - (@subtotalF * (@coberturaF / 100.0)),
            @fechaPagoF, @metodoF);

    FETCH NEXT FROM cursorCitas INTO @idCitaF, @fechaCitaF;
END;
CLOSE cursorCitas;
DEALLOCATE cursorCitas;
GO

/* ---------- VERIFICACIÓN ---------- */
SELECT 'Especialidades' AS Tabla, COUNT(*) AS Filas FROM Especialidades
UNION ALL SELECT 'Sedes', COUNT(*) FROM Sedes
UNION ALL SELECT 'Salas', COUNT(*) FROM Salas
UNION ALL SELECT 'Medicos', COUNT(*) FROM Medicos
UNION ALL SELECT 'Pacientes', COUNT(*) FROM Pacientes
UNION ALL SELECT 'Aseguradoras', COUNT(*) FROM Aseguradoras
UNION ALL SELECT 'Planes_Seguro', COUNT(*) FROM Planes_Seguro
UNION ALL SELECT 'Medicamentos', COUNT(*) FROM Medicamentos
UNION ALL SELECT 'Diagnosticos_CIE10', COUNT(*) FROM Diagnosticos_CIE10
UNION ALL SELECT 'Citas', COUNT(*) FROM Citas
UNION ALL SELECT 'Atenciones', COUNT(*) FROM Atenciones
UNION ALL SELECT 'Facturacion', COUNT(*) FROM Facturacion;
GO