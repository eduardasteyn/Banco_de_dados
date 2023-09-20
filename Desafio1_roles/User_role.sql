/*
*@author Eduarda Jeniffer Steilein Gislon
*/
-- criação de usuários
CREATE USER gerente IDENTIFIED BY '12345';
CREATE USER Recepcionista IDENTIFIED BY '12345';
CREATE USER Atendente_Geral IDENTIFIED BY '12345';

-- criação de role/grupo
CREATE ROLE role_gerente;
CREATE ROLE role_Recepcionista;
CREATE ROLE role_Atendente_Geral;

-- permissão para o role_gerente
GRANT ALL ON bancoteste.* TO role_gerente WITH GRANT OPTION;

-- permissão para a role_Recepcionista
GRANT ALL ON bancoteste.cliente TO role_Recepcionistaa;
GRANT ALL ON bancoteste.reserva TO role_Recepcionista;
GRANT ALL ON bancoteste.hospedagem TO role_Recepcionista;

-- criação da view para o Atendente_Geral
CREATE OR REPLACE VIEW view_nome_cliente_numero_quarto AS
SELECT nm_cliente, nr_quarto
FROM cliente
INNER JOIN reserva ON reserva.cd_cliente = cliente.cd_cliente;

-- permissão para o role_Atendente_Geral
GRANT SELECT ON view_nome_cliente_numero_quarto TO role_Atendente_Geral;
GRANT INSERT, UPDATE ON hospedagem_servico TO role_Atendente_Geral;

-- associa role_gerente com o user gerente
GRANT role_gerente TO gerente;

-- associa role_Recepcionista com o user Recepcionista
GRANT role_Recepcionista TO Recepcionista;

-- associa role_Atendente_Geral com o user Atendente_Geral
GRANT role_Atendente_Geral TO Atendente_Geral;

-- setando roles para ser padrões em seus usuários
SET DEFAULT ROLE "role_gerente" FOR gerente;
SET DEFAULT ROLE "role_Recepcionista" FOR Recepcionista;
SET DEFAULT ROLE "role_Atendente_Geral" FOR Atendente_Geral;