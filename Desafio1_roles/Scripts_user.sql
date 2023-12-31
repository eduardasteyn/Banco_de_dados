-- scripts
CREATE TABLE cargo (
CD_CARGO integer,
DS_CARGO varchar(50),
PRIMARY KEY (CD_CARGO)
);

CREATE TABLE categoria (
CD_CATEGORIA integer,
DS_CATEGORIA varchar(50),
PRIMARY KEY (CD_CATEGORIA)
);

CREATE TABLE cliente (
CD_CLIENTE integer,
NM_CLIENTE varchar(50),
DS_EMAIL varchar(50),
NR_TELEFONE varchar(15),
PRIMARY KEY (CD_CLIENTE)
);

CREATE TABLE funcionario (
CD_FUNCIONARIO integer,
CD_CARGO integer,
NM_FUNCIONARIO varchar(50) ,
PRIMARY KEY (CD_FUNCIONARIO),
FOREIGN KEY (CD_CARGO) REFERENCES cargo (CD_CARGO)
);

CREATE TABLE reserva (
NR_RESERVA integer AUTO_INCREMENT,
DT_RESERVA date,
DT_ENTRADA date,
QT_DIARIAS integer,
FL_SITUACAO char(1),
CD_CLIENTE integer,
NR_QUARTO integer,
CD_FUNCIONARIO integer,
PRIMARY KEY (NR_RESERVA)
);

CREATE TABLE hospedagem (
CD_HOSPEDAGEM integer AUTO_INCREMENT,
DT_ENTRADA date,
DT_SAIDA date,
FL_SITUACAO char(1),
CD_CLIENTE integer,
CD_FUNCIONARIO integer,
NR_QUARTO integer,
PRIMARY KEY (CD_HOSPEDAGEM)
);

CREATE TABLE servico (
CD_SERVICO integer,
DS_SERVICO varchar(50),
PRIMARY KEY (CD_SERVICO)
);

CREATE TABLE hospedagem_servico (
CD_HOSPEDAGEM integer,
CD_SERVICO integer,
NR_SEQUENCIA integer,
DT_SOLICITACAO date,
PRIMARY KEY (CD_HOSPEDAGEM,CD_SERVICO,NR_SEQUENCIA),
FOREIGN KEY (CD_HOSPEDAGEM) REFERENCES hospedagem (CD_HOSPEDAGEM),
FOREIGN KEY (CD_SERVICO) REFERENCES servico (CD_SERVICO)
);

CREATE TABLE quarto (
NR_QUARTO integer,
CD_CATEGORIA integer,
DS_QUARTO varchar(50),
NR_OCUPANTES integer,
PRIMARY KEY (NR_QUARTO),
FOREIGN KEY (CD_CATEGORIA) REFERENCES categoria (CD_CATEGORIA)
);

INSERT INTO cargo (CD_CARGO, DS_CARGO) VALUES
(1, 'Gerente'),
(2, 'Recepcionista'),
(3, 'Atendente Geral'),
(4, 'Estagiário');

INSERT INTO categoria (CD_CATEGORIA, DS_CATEGORIA) VALUES
(1, 'Standart Solteiro'),
(2, 'Standart Casal'),
(3, 'Master Solteiro'),
(4, 'Master Casal'),
(5, 'Deluxe Casal');

INSERT INTO cliente (CD_CLIENTE, NM_CLIENTE, DS_EMAIL, NR_TELEFONE) VALUES
(1, 'Cliente 1', 'cliente1@provedor.com.br', '4799990000'),
(2, 'Cliente 2', 'cliente2@provedor.com.br', '4788880000'),
(3, 'Cliente 3', 'cliente3@provedor.com.br', '47777770000'),
(4, 'Cliente 4', 'cliente4@provedor.com.br', '47666660000'),
(5, 'Cliente 5', 'cliente5@provedor.com.br', '47555550000');

INSERT INTO funcionario (CD_FUNCIONARIO, CD_CARGO, NM_FUNCIONARIO) VALUES
(1, 1, 'João Gerente Fonseca'),
(2, 2, 'Maria Recepcionista da Silva'),
(3, 3, 'Carlos Atendente Geral Costa'),
(4, 4, 'Luiza Estagiária Souza');


INSERT INTO quarto (NR_QUARTO, CD_CATEGORIA, DS_QUARTO, NR_OCUPANTES) VALUES
(101, 1, 'Corredor amarelo, face norte', 1),
(102, 2, 'Corredor verde, face sul', 2),
(103, 1, 'Corredor amarelo, face norte', 1),
(104, 2, 'Corredor verde, face sul', 2),
(105, 1, 'Corredor amarelo, face norte', 1),
(106, 2, 'Corredor verde, face sul', 2),
(201, 3, 'Corredor amarelo, face norte', 1),
(202, 4, 'Corredor verde, face sul', 2),
(203, 3, 'Corredor amarelo, face norte', 1),
(204, 4, 'Corredor verde, face sul', 2),
(205, 3, 'Corredor amarelo, face norte', 1),
(206, 4, 'Corredor verde, face sul', 2),
(301, 5, 'Corredor amarelo, face norte', 2),
(302, 5, 'Corredor verde, face sul', 2),
(303, 5, 'Corredor amarelo, face norte', 2),
(304, 5, 'Corredor verde, face sul', 2);


INSERT INTO servico (CD_SERVICO, DS_SERVICO) VALUES
(1, 'Restaurante'),
(2, 'Bar'),
(3, 'Lavanderia'),
(4, 'Translado'),
(5, 'Lan house');