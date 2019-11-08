exec master.dbo.sp_addlogin 'UserTeste','SenhaTeste';

use curso;
go

--Adicionar
EXEC sp_grantdbaccess 'UserTeste';

EXEC sp_revokedbaccess 'UserTeste';
---------------------------------------------------

---------------------------------------------------
--Concedendo Acesso DE ATUALIZACAO PARA UserTeste.
GRANT UPDATE ON TABELA TO UserTeste; 

--Concedendo Acesso DE INSERT PARA UserTeste.
GRANT INSERT ON TABELA TO UserTeste; 

--Concedendo Acesso DE Leitura PARA UserTeste.
GRANT SELECT ON TABELA TO UserTeste;

--Concedendo Acesso DE DELETE PARA UserTeste.
GRANT DELETE ON TABELA TO UserTeste;
---------------------------------------------------

--procedure
---------------------------------------------------
CREATE PROCEDURE testproc 
as
select * from TABELA

--executando procedure
EXEC testproc
--Concedendo Acesso PARA EXCUTAR PROC TESTE_PROC PARA UsrTeste.
GRANT EXECUTE ON testproc TO UserTeste
---------------------------------------------------

---------------------------------------------------
--VERIFICANDO USUARIO LOGADO
select CURRENT_USER
--ALTERANDO USUARIO LOGADO
SETUSER 'UserTeste'
--voltar para usuario dbo
SETUSER
---------------------------------------------------


--revogando permissoes
---------------------------------------------------
--REVOGANDO Acesso DE ATUALIZACAO UsrTeste.
REVOKE UPDATE ON TABELA to UserTeste; 

-- REVOGANDO Acesso DE inserção UsrTeste.
REVOKE INSERT ON TABELA TO UserTeste; 

-- REVOGANDO Acesso DE Leitura UsrTeste.
REVOKE SELECT ON TABELA TO UserTeste; 

--REVOGA DIREITO DE EXECUCAO DA PROC TESTE_PROC PARA UserTeste.
REVOKE EXECUTE ON testproc TO UserTeste ;
---------------------------------------------------


--negando permissoes
---------------------------------------------------
--REVOGANDO Acesso DE ATUALIZACAO UsrTeste.
DENY UPDATE ON TABELA to UserTeste; 

-- REVOGANDO Acesso DE inserção UsrTeste.
DENY INSERT ON TABELA TO UserTeste; 

-- REVOGANDO Acesso DE Leitura UsrTeste.
DENY SELECT ON TABELA TO UserTeste; 

--REVOGA DIREITO DE EXECUCAO DA PROC TESTE_PROC PARA UserTeste.
DENY EXECUTE ON testproc TO UserTeste ;
---------------------------------------------------


