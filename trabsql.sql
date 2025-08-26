CREATE DATABASE Projeto_Final;


USE Projeto_Final;

DROP TABLE Consultas;
DROP TABLE Clinicas;
DROP TABLE Avaliacoes;
DROP TABLE Medicos;
DROP TABLE Pacientes;


CREATE TABLE Consultas(
id_consulta INT PRIMARY KEY ,
id_paciente INT, FOREIGN KEY (id_paciente)  REFERENCES Pacientes(id_paciente),
id_medico INT, FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico),
id_clinica INT, FOREIGN KEY (id_clinica) REFERENCES Clinicas(id_clinica),
especialidade VARCHAR(100),
data_hora_agendada DATETIME,
data_hora_inicio DATETIME,
status VARCHAR(50)
);

CREATE TABLE Clinicas(
id_clinica INT PRIMARY KEY,
nome VARCHAR(100),
cidade VARCHAR(100),
capacidade_diaria INT
);

CREATE TABLE Avaliacoes(
id_consulta INT PRIMARY KEY,
nota_satisfacao INT,
comentario VARCHAR(100)
);

CREATE TABLE Medicos(
id_medico INT PRIMARY KEY,
nome VARCHAR(100),
especialidade VARCHAR(100)
);

CREATE TABLE Pacientes(
id_paciente INT PRIMARY KEY,
idade INT,
sexo VARCHAR(50),
cidade VARCHAR(100),
plano_saude VARCHAR(50)
);




SELECT * FROM Medicos;


SELECT especialidade, SUM(id_consulta) AS total_especialidade
FROM Consultas
GROUP BY especialidade;


SELECT id_medico, SUM(id_consulta) AS total_Medicos
FROM Consultas
GROUP BY id_Medico;






SELECT
    Medicos.id_medico,
    Medicos.nome,
    Consultas.id_consulta,
    Consultas.especialidade,
    Consultas.status
FROM
    Medicos
INNER JOIN
    Consultas ON Medicos.id_medico = Consultas.id_medico
ORDER BY
Medicos.nome ASC , Consultas.id_consulta ASC;

    
    
SELECT
    Medicos.nome,
    COUNT(consultas.id_consulta) AS total_de_consultas
FROM
    Medicos 
JOIN
    Consultas ON Medicos.id_medico = Consultas.id_medico
GROUP BY
    Medicos.nome
ORDER BY
    total_de_consultas DESC;
    
    
    
SELECT
    Clinicas.nome,
    COUNT(Consultas.id_consulta) AS total_de_consultas
FROM
    Clinicas
INNER JOIN
    Consultas ON Clinicas.id_clinica = Consultas.id_clinica
GROUP BY
    Clinicas.nome
ORDER BY
    total_de_consultas DESC;
    
    
    
SELECT
    plano_saude,
    COUNT(id_paciente) AS total_de_pacientes
FROM
    Pacientes
GROUP BY
    plano_saude
ORDER BY
    plano_saude;


SELECT
    status,
    COUNT(id_consulta) AS total_de_consultas_plano
FROM
    Consultas
GROUP BY
    status
ORDER BY
    total_de_consultas DESC;
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    SELECT
    Pacientes.cidade,
    CASE
        WHEN Pacientes.idade BETWEEN 0 AND 17 THEN '0-17 (Crianças/Adolescentes)'
        WHEN Pacientes.idade BETWEEN 18 AND 35 THEN '18-35 (Jovens Adultos)'
        WHEN Pacientes.idade BETWEEN 36 AND 59 THEN '36-59 (Adultos)'
        ELSE '60+ (Idosos)'
    END AS faixa_etaria,
    Consultas.especialidade,
    COUNT(*) AS total_avaliacoes_negativas
FROM
    Pacientes
INNER JOIN
    Consultas ON Pacientes.id_paciente = Consultas.id_paciente
INNER JOIN
    Avaliacoes ON Consultas.id_consulta = Avaliacoes.id_consulta
WHERE
    Avaliacoes.nota_satisfacao <= 2 -- Filtra apenas por notas 1 e 2 (insatisfeitos)
GROUP BY
    Pacientes.cidade,
    faixa_etaria,
    Consultas.especialidade
ORDER BY
    total_avaliacoes_negativas DESC;



--  ###  Não consegui fazer    Médicos com menor tempo médio de atendimento estão concentrando mais reclamações? ########






SELECT
    Clinicas.nome,
    Clinicas.cidade,
    Clinicas.capacidade_diaria,
    COUNT(DISTINCT Consultas.id_consulta) AS total_consultas_realizadas,
    ROUND(AVG(Avaliacoes.nota_satisfacao), 2) AS media_satisfacao
FROM
    Clinicas
LEFT JOIN
    Consultas ON Clinicas.id_clinica = Consultas.id_clinica
LEFT JOIN
    Avaliacoes ON Consultas.id_consulta = Avaliacoes.id_consulta
GROUP BY
    Clinicas.id_clinica, Clinicas.nome, Clinicas.cidade, Clinicas.capacidade_diaria
ORDER BY
    Clinicas.capacidade_diaria DESC;
    
    
    
    
    
####•Existe relação entre plano de saúde e tempo de espera? Duvida###
    


SELECT
    Consultas.especialidade,
    COUNT(Consultas.id_consulta) AS total_consultas,
    (SUM(CASE WHEN Consultas.status = 'Cancelada' THEN 1 ELSE 0 END) * 100.0 / COUNT(Consultas.id_consulta)) AS taxa_cancelamento_percent,
    ROUND(AVG(Avaliacoes.nota_satisfacao), 2) AS media_satisfacao
FROM
    Consultas
LEFT JOIN
    Avaliacoes ON Consultas.id_consulta = Avaliacoes.id_consulta
GROUP BY
    Consultas.especialidade
ORDER BY
    taxa_cancelamento_percent DESC,
    media_satisfacao ASC; 

    

    
    
    
    
    
    







SET GLOBAL local_infile = 1;



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trabalho_final/consultas_final.csv'
INTO TABLE Consultas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trabalho_final/pacientes_final.csv'
INTO TABLE Pacientes
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trabalho_final/clinicas_final.csv'
INTO TABLE Clinicas
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trabalho_final/avaliacoes_final.csv'
INTO TABLE Avaliacoes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trabalho_final/medicos_final.csv'
INTO TABLE Medicos
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;






SHOW VARIABLES LIKE 'secure_file_priv';

DESCRIBE Medicos;
