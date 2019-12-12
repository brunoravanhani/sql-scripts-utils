/*

@Autor: Dircel Resende
@Url: https://www.dirceuresende.com/blog/sql-server-como-identificar-e-substituir-coisas-estranhas-caracteres-ocultos-invisiveis-em-strings-e-tabelas/
*/


--- Insert of test rows
IF (OBJECT_ID('tempdb..#Teste') IS NOT NULL) DROP TABLE #Teste
CREATE TABLE #Teste (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
)
 
 
DECLARE 
    @Contador INT = 1, @Total INT = 100,
    @Contador2 INT = 1, @Total2 INT = 10,
    @String VARCHAR(100)
 
WHILE(@Contador <= @Total)
BEGIN
    
 
    SET @Contador2 = 1
    SET @String = ''
 
 
    WHILE(@Contador2 <= @Total2)
    BEGIN
 
        IF (@Contador2 <= 8)
            SET @String += CHAR(65 + dbo.fncRand(25))
        ELSE
            SET @String += CHAR(dbo.fncRand(255))
 
 
        SET @Contador2 += 1
 
 
    END
 
 
    INSERT INTO #Teste
    VALUES(@String)
 
    SET @Contador += 1
 
END
GO
--- Function has hidden carasters

CREATE FUNCTION [dbo].[fncPossui_Caractere_Oculto](
    @String VARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    RETURN (CASE WHEN PATINDEX('%[^ !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\^_`abcdefghijklmnopqrstuvwxyz|{}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ[[]%', REPLACE(@String, ']', '')) > 0 THEN 1 ELSE 0 END)
END
GO
--- Function show hidden caracters

CREATE FUNCTION [dbo].[fncMostra_Caracteres_Ocultos](
    @String VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

    DECLARE 
        @Result VARCHAR(MAX) = '', 
        @Contador INT = 1,
        @Total INT,
        @AdicionarBarra BIT = 0
    
    
    SET @Total = LEN(@String)

    WHILE(@Contador <= @Total)
    BEGIN
        
        IF (PATINDEX('%[^ !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\^_`abcdefghijklmnopqrstuvwxyz|{}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ[[]%', SUBSTRING(REPLACE(@String, ']', ''), @Contador, 1)) > 0)
        BEGIN
            SET @Result += (CASE WHEN @AdicionarBarra = 1 THEN ' | ' ELSE '' END) + 'Pos ' + CAST(@Contador AS VARCHAR(100)) + ': CHAR(' + CAST(ASCII(SUBSTRING(@String, @Contador, 1)) AS VARCHAR(5)) + ')'
            SET @AdicionarBarra = 1
        END

        SET @Contador += 1

    END
    
    RETURN @Result

END
GO

--- function remove hidden characters

CREATE FUNCTION [dbo].[fncRemove_Caracteres_Ocultos](
    @String VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
 
    
    DECLARE 
        @Result VARCHAR(MAX), 
        @StartingIndex INT = 0
    
    
    WHILE (1 = 1)
    BEGIN 
        
        SET @StartingIndex = PATINDEX('%[^ !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\^_`abcdefghijklmnopqrstuvwxyz|{}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ[[]%', REPLACE(@String, ']', ''))
        
        IF (@StartingIndex <> 0)
            SET @String = REPLACE(@String,SUBSTRING(@String, @StartingIndex,1),'') 
        ELSE
            BREAK
 
    END    
    
    SET @Result = REPLACE(@String,'|','')
    
    RETURN @Result
 
END
GO

--- Test

DECLARE @string varchar(max) = 'Dir' + CHAR(0) + CHAR(1) + CHAR(9) + 'ceu' + CHAR(12) + CHAR(10) + 'RESENDE'

select @string