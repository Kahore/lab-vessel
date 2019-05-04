IF ('@PARAM2@' = 'UpdateVesselInfoManually')
BEGIN

  SET @Labcode = (SELECT [LabCode]
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE CAST( [ID] AS nvarchar(36) )='@unid@' )

  SET @SLIM_Server = ( SELECT [SLIM_Server]
  FROM [LabProtocols].[dbo].[Ent_Laboratories]
  WHERE [LabCode] = @Labcode )
  SET @SLIM_DB =( SELECT [SLIM_DB]
  FROM [LabProtocols].[dbo].[Ent_Laboratories]
  WHERE [LabCode] = @Labcode )
  SET @SLIM_Labcode = ( SELECT [SLIM_Labcode]
  FROM [LabProtocols].[dbo].[Ent_Laboratories]
  WHERE [LabCode] = @Labcode )

  SET @LastAutoCounterDate= ( SELECT [LastAutoCounterDate]
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE CAST( [ID] AS nvarchar(50) )='@unid@' )
  SET @LastAutoCounterDate = CONVERT(char(23),try_parse(@LastAutoCounterDate as datetime2(3) using 'en-GB'),121)

  /*MEMO: на KI app сервере МСК время*/
  IF @Labcode <> 'KI'
BEGIN
    SET @NewLastAutoCounterDate=dateadd( hour, 4, getdate() )
  END
ELSE
BEGIN
    SET @NewLastAutoCounterDate=getdate()
  END

  SET @NewLastAutoCounterDate = CONVERT(char(23),try_parse(@NewLastAutoCounterDate as datetime2(3) using 'en-GB'),121)

  SET @Serial = ( SELECT [Serial]
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE CAST( [ID] AS nvarchar(50) )='@unid@' )

  BEGIN TRY

	SET @NewData_OPENQUERY='SELECT * FROM OPENQUERY('+@SLIM_Server+','+
	'''
	SELECT /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ COUNT(PJCSA.CUID)
			FROM ['+@SLIM_Server+'].['+@SLIM_DB+'].dbo.[PROFJOB_CUID_SCHEME_ANALYTE] AS PJCSA
				INNER JOIN ['+@SLIM_Server+'].['+@SLIM_DB+'].dbo.[PROFJOB_CUID_SCHEME] AS PJCS
					ON PJCSA.LABCODE=PJCS.LABCODE
					AND PJCSA.PRO_JOB=PJCS.PRO_JOB
					AND PJCSA.CUID=PJCS.CUID
					AND PJCSA.SCH_CODE=PJCS.SCH_CODE AND PJCSA.SCHVERSION=PJCS.SCHVERSION
			WHERE PJCSA.SCH_CODE =''''COCV__BOMB_VALUE''''
			AND PJCSA.ANALYTECODE=''''BOMB_ID'''' 
			AND PJCSA.FINALVALUE='''''+@Serial+'''''
			AND PJCS.ANALYSED between '''''+@LastAutoCounterDate+''''' and '''''+@NewLastAutoCounterDate+'''''
			 '')'

	INSERT @t_VesselCnt
  exec (@NewData_OPENQUERY)

	SET @Count = ( SELECT VesselCnt
  FROM @t_VesselCnt )
	/*SELECT @Count*/

	SET @CommissioningCount = ( SELECT CAST( [CommissioningCount] AS int )
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE  CAST([ID] AS nvarchar(50))='@unid@' )
	SET @LastCheckCount = ( SELECT CAST( [LastCheckCount] AS int )
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE  CAST([ID] AS nvarchar(50))='@unid@' )

	SET @CommissioningCount = @CommissioningCount+@Count
	SET @LastCheckCount  = @LastCheckCount+@Count

	UPDATE /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity]
		  SET [CommissioningCount] = CAST( @CommissioningCount AS nvarchar(50) )
			 ,[LastCheckCount] = CAST( @LastCheckCount AS nvarchar(50) ) 
			 ,[LastAutoCounterDate] = @NewLastAutoCounterDate
			 ,[LastChangedBy] = '@UserName@'
	WHERE  CAST( [ID] AS nvarchar(50) ) = '@unid@'

/*Вставка истории*/
	INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
    ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
  VALUES
    (NewID(), '@unid@', 'Поджиги', NULL, @Count, @NewLastAutoCounterDate, '@UserName@')

/*Вставка истории в месячное накопление для графиков*/
    SET @CummMonthCount = ( SELECT CAST([ItemVal] AS int)
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History]
  WHERE [EntityID] = '@unid@' AND [ItemGroup] = CAST( YEAR( @NewLastAutoCounterDate ) AS CHAR(4) ) + '-'+ LEFT( DATENAME ( MONTH, @NewLastAutoCounterDate ),3 ) 
						  )
    IF @CummMonthCount IS NULL
    BEGIN
    /*Берём куммулятивные данные прошлого месяца*/
    SET @CummMonthCount = ( SELECT TOP 1
      CAST([ItemVal] AS int)
    FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History]
    WHERE [EntityID] = '@unid@' AND [ItemGroup] IS NOT NULL
    ORDER BY [Created] DESC
						    )

    INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
      ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
    VALUES
      (NewID(), '@unid@', 'Поджиги', CAST( YEAR( @NewLastAutoCounterDate ) AS CHAR(4) ) + '-'+ LEFT(DATENAME ( MONTH, @NewLastAutoCounterDate ),3), @CummMonthCount+@Count, @NewLastAutoCounterDate, '@UserName@')
  END
    ELSE
    BEGIN
    UPDATE /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
		 SET [ItemVal] = @CummMonthCount+@Count
	   WHERE [EntityID] = '@unid@' AND [ItemGroup] = CAST( YEAR( @NewLastAutoCounterDate ) AS CHAR(4) ) + '-' + LEFT(DATENAME ( MONTH, @NewLastAutoCounterDate ),3)
  END


SELECT [LabProtocols].dbo.qfn_XmlToJson ((
	  SELECT
      [CommissioningCount]  AS [CommissioningCount]
		, [LastCheckCount] AS [LastCheckCount]
		, CONVERT(nchar(19),[LastAutoCounterDate],120) AS [LastAutoCounterDate]
		, [LastChangedBy] AS [LastChangedBy]
    FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
    WHERE CAST( [ID] AS nvarchar(36) )='@unid@'
    FOR xml path(''), root																								
	))

  END TRY

  BEGIN CATCH
	SELECT '@PARAM2@ отработал с ошибкой: '+ERROR_MESSAGE()+', Номер строки: '+CAST(ERROR_LINE() AS nvarchar(max));
  END CATCH
END