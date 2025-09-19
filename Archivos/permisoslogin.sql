USE [callcenter]
GO
/****** Object:  StoredProcedure [dbo].[usp_permisos_login_reportes_seguros_celulares]    Script Date: 18/09/2025 11:41:47 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alonso Lira
-- Create date: 04 de Agosto de 2025
-- Description:	Proceso para identificar permisos en pagina de reporte de reclamos de celulares
/*
declare @ROL  as VARCHAR (50)
EXECUTE usp_permisos_login_reportes_seguros_celulares 'SUBGERENTE CEL',@ROL output
select	@ROL
*/
-- =============================================
ALTER PROCEDURE [dbo].[usp_permisos_login_reportes_seguros_celulares]
	-- Add the parameters for the stored procedure here
	@puesto varchar(50)
	,@ROL VARCHAR (50) output
AS
  SET NOCOUNT ON;
  --DECLARE @ROL VARCHAR (50)
  set @ROL = @ROL
SELECT
    @ROL =    CASE	
				  WHEN @puesto IN ('DESARROLLADOR','TECH LEAD','COORD SISTEMAS CRED','GTE COMPRAS CEL' , 'ESPEC DESARROLLO','GTE DESARROLLO','COORD CAPACITACION')THEN '1'	

				  WHEN @puesto IN ('COORD CONTACT CENTER','GTE CALLCENTER','AUX CONTACT CENTER')		THEN '2'
				  
				  WHEN @puesto IN ('GTE CALLCENTER','CALL CENTER COMER CM','CAJERA CRE. Y COB.')	THEN '3'
				  
				  WHEN @puesto IN ('GERENTE CEL','SUBGERENTE CEL','GTE COMPRAS CEL')							THEN '4'
				  
				  WHEN @puesto IN ('GTE DIV AUD OPER','GTE AUDITORIA CREDIT','ADMON INFO AUDITORIA')			THEN '5'	

				  ELSE '0'
			  END

    --SELECT puesto= @ROL
	return @ROL
	--Administrador                  1 Acceso a todo 
	--Registrar                      2 callcenter
	--Cargar Archivos                3 credito
	--PreAutorizar                   4 manuel
	--Autorizar                      5 auditoria carlos castrellon auditor