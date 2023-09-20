/*
*@author Eduarda Jeniffer Steilein Gislon
*/

-- Criação da tabela log
CREATE TABLE log_Cliente
(data_operacao DATE,
hora_operacao TIME,
usuario VARCHAR(50),
ds_operacao TEXT(500)
);

-- Trigger para o insert
CREATE OR REPLACE TRIGGER tg_insert_tb_Cliente BEFORE INSERT ON bancoteste.cliente 
FOR EACH ROW
BEGIN
	INSERT INTO log_Cliente (data_operacao, hora_operacao, usuario, ds_operacao)
	VALUES (CURDATE(), CURTIME(), USER(), 'Tipo da operação: Insert');
END 

-- Trigger para o delete
CREATE OR REPLACE TRIGGER tg_delete_tb_Cliente AFTER DELETE ON bancoteste.cliente 
FOR EACH ROW
BEGIN
	INSERT INTO log_Cliente (data_operacao, hora_operacao, usuario, ds_operacao)
	VALUES (CURDATE(), CURTIME(), USER(), 'Tipo da operação: Delete');
END 

-- Trigger para o update
CREATE OR REPLACE TRIGGER tg_update_tb_Cliente BEFORE UPDATE ON bancoteste.cliente 
FOR EACH ROW
BEGIN
DECLARE ALTERACAO_NOME VARCHAR(100) DEFAULT '';
DECLARE ALTERACAO_EMAIL VARCHAR(100) DEFAULT '';
DECLARE ALTERACAO_TELEFONE VARCHAR(100) DEFAULT '';
	
	IF NEW.NM_CLIENTE <> OLD.NM_CLIENTE THEN
		SET ALTERACAO_NOME = CONCAT(' Alteracao Nome: ', OLD.NM_CLIENTE,' -> ', NEW.NM_CLIENTE);
	END IF;
	
  	IF NEW.DS_EMAIL <> OLD.DS_EMAIL THEN
		SET ALTERACAO_EMAIL = CONCAT(' Alteracao Email: ', OLD.DS_EMAIL, ' -> ', NEW.DS_EMAIL);
  	END IF;

	IF NEW.NR_TELEFONE <> OLD.NR_TELEFONE THEN
		SET ALTERACAO_TELEFONE = CONCAT(' Alteracao Telefone: ', OLD.NR_TELEFONE, ' -> ', NEW.NR_TELEFONE);
  	END IF;
  	
	INSERT INTO log_Cliente (data_operacao, hora_operacao, usuario, ds_operacao)
	VALUES (CURDATE(), CURTIME(), USER(), CONCAT('Tipo da operação: Update.', ALTERACAO_NOME, ALTERACAO_EMAIL, ALTERACAO_TELEFONE));
END 

-- Criacao da function para quartos disponíveis, sendo data_pesquisa a possível data para hospedagem
CREATE OR REPLACE FUNCTION func_quartos_disponiveis(data_pesquisa DATE) RETURNS TEXT(500)
BEGIN
DECLARE lista_quartos TEXT(500) DEFAULT '';

-- Criando um group_concat para que, a cada quarto disponível pela data, seja listado junto com seu numero do quarto 
  SELECT DISTINCT group_concat(quarto.NR_QUARTO SEPARATOR ' | ') INTO lista_quartos
  FROM QUARTO quarto
  LEFT JOIN RESERVA reserva ON quarto.NR_QUARTO = reserva.NR_QUARTO
  WHERE reserva.NR_QUARTO IS NULL OR (DATE_ADD(reserva.DT_ENTRADA, INTERVAL reserva.QT_DIARIAS DAY) <= data_pesquisa);
  
  RETURN lista_quartos;
  
END

-- Criando uma procedure para fazer a inserção de hospedagem
CREATE OR REPLACE PROCEDURE pc_inserir_hospedagem(cd_cliente_pm INT, nr_quarto_pm INT, data_entrada_pm DATE, data_saida_pm DATE)
BEGIN
DECLARE reserva_cliente INT DEFAULT NULL;
	
- A partir das informações de hospedagem informadas pelo parâmetro, estou verificando se o cliente tem uma reserva prévia.
  SELECT DISTINCT reserva.NR_RESERVA INTO reserva_cliente 
  FROM reserva 
  WHERE reserva.CD_CLIENTE = cd_cliente_pm AND 
  (reserva.DT_RESERVA <= data_entrada_pm) AND 
  ((reserva.DT_RESERVA + reserva.QT_DIARIAS) >= data_saida_pm);
 
-- Se a reserva existir devo cria a hospedagem informando situacao de ocupado.
  IF (reserva_cliente IS NOT NULL) THEN
  	INSERT INTO hospedagem(DT_ENTRADA, DT_SAIDA, FL_SITUACAO, CD_CLIENTE, CD_FUNCIONARIO, NR_QUARTO)
  	VALUES (data_entrada_pam, data_saida_pm, 'O', cd_cliente_pm, 1, nr_quarto_pm);
  END IF;
END

-- Criando uma procedure para fazer a inserção de um serviço 
CREATE OR REPLACE PROCEDURE pc_inserir_servico(cd_hospedagem_pm INT, cd_servico_pm INT)
BEGIN 
DECLARE vr_id_servico INT;

-- A partir das informações de hospedagem e serviço informada pelo parâmetro, 
-- verificar se o cd_ hospedagem é maior que zero e se ela possui algum valor em NR_SEQUENCIA se possui adicionou mais 1 ao valor

	IF (SELECT count(NR_SEQUENCIA) FROM hospedagem_servico hs WHERE hs.CD_HOSPEDAGEM = cd_hospedagem_pm > 0) THEN 
		SELECT max(NR_SEQUENCIA) INTO vr_id_servico
		FROM hospedagem_servico hs
		WHERE hs.CD_HOSPEDAGEM = cd_hospedagem_pm;
		SET vr_id_servico = vr_id_servico + 1;
		INSERT INTO hospedagem_servico (CD_HOSPEDAGEM, CD_SERVICO, NR_SEQUENCIA, DT_SOLICITACAO)
		VALUES (cd_hospedagem_pm, cd_servico_pm, vr_id_servico, CURDATE());
-- Se não apenas dou um set 1 a minha vr_id_servico e faço meu insert a tabela 
	ELSE
		SET vr_id_servico = 1;
		INSERT INTO hospedagem_servico (CD_HOSPEDAGEM, CD_SERVICO, NR_SEQUENCIA, DT_SOLICITACAO)
		VALUES (cd_hospedagem_pm, cd_servico_pm, vr_id_servico, CURDATE());
	END IF;
END

-- Criando uma procedure para fazer a finalização de uma hospedagem 
CREATE OR REPLACE PROCEDURE pc_finalizar_hospedagem(cd_hospedagem_pm INT)
BEGIN 
-- A partir das informações de hospedagem informada pelo parâmetro devo setar f(finalizado) para a cd_hospedagem informada
	UPDATE hospedagem SET fl_situacao = 'F' WHERE CD_HOSPEDAGEM = cd_hospedagem_pm;
END


