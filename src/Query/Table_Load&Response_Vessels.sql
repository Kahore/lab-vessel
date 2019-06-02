IF ('@PARAM2@' = 'Vessels_GetData')
BEGIN
  BEGIN TRY

	IF ('@unid@' <> '@'+'unid'+'@' and '@unid@' <> '')
	BEGIN
    SET @isSingleResults = 1
  END
	ELSE
	BEGIN
    SET @isSingleResults = 0
  END

	SET @AccessList =(SELECT [AccessQuery]
  FROM [NKReports].[dbo].[DB_Settings_ACL]
  WHERE [UserName]='@UserName@' AND [TableName]='LabVesselMonitoring')
	SET @delimiter  = ','

	DECLARE @t_Location as Table([Location] nvarchar(max),
    [LocationCode] int,
    [Condition] nvarchar(max) )
	  INSERT INTO @t_Location
  SELECT DISTINCT [Location], [LocationCode] , [Condition]
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE 
	   ( @isSingleResults=0 AND [Status] LIKE CASE WHEN '@hideMode@' = 'false' THEN '%' ELSE 'OK' END
    AND [LabCode] in ( SELECT nstr
    FROM [NKReports].[dbo].[Params_To_Table] ( @AccessList,@delimiter ) ) )
    OR
    (@isSingleResults=1 AND [LabCode] in ( SELECT nstr
    FROM [NKReports].[dbo].[Params_To_Table] ( @AccessList,@delimiter ) ) AND CAST(id AS nvarchar(50)) ='@unid@' )

  GROUP BY [Location],[LocationCode],LabCode,[Condition]

	DECLARE @t_LocationUnique as Table([Location] nvarchar(max),
    [LocationCode] int,
    LabCode nvarchar(5))
	  INSERT INTO @t_LocationUnique
  SELECT DISTINCT [Location] , [LocationCode] , LabCode
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE 
		( @isSingleResults=0 AND [Status] LIKE CASE WHEN '@hideMode@' = 'false' THEN '%' ELSE 'OK' END
    AND [LabCode] in ( SELECT nstr
    FROM [NKReports].[dbo].[Params_To_Table] ( @AccessList,@delimiter ) ) )
    OR
    ( @isSingleResults=1 AND [LabCode] in ( SELECT nstr
    FROM [NKReports].[dbo].[Params_To_Table] ( @AccessList,@delimiter ) ) AND CAST(id AS nvarchar(50))='@unid@' )
  GROUP BY [Location],[LocationCode],LabCode

	SELECT [LabProtocols].dbo.qfn_XmlToJson 
	((
	  SELECT
      t1.[Location]
		  , (SELECT t2.[Condition]
			 , (SELECT ELE.[ID]
			   	, ELE.[Serial]
				, CASE WHEN ELE.[LastCheckCount] > 5000 THEN 'Требуется проверка' ELSE 
		 		 CASE WHEN ( datediff(d, ELE.[CertificationDate], getdate() )>=365 AND ELE.[Status]<>'Util' ) THEN 'Требуется испытание' ELSE ELE.[Status] END END AS [Status]
				, CASE WHEN ELE.[CommissioningDate] IS NULL THEN 'Нет данных' ELSE CONVERT(nchar(10),ELE.[CommissioningDate],103) END AS CommissioningDate
				, CASE WHEN ELE.[CertificationDate] IS NULL THEN 'Нет данных' ELSE CONVERT(nchar(10),ELE.[CertificationDate],103) END AS CertificationDate
				, CASE WHEN ELE.[LastCheckDate] IS NULL THEN 'Нет данных' ELSE CONVERT(nchar(10),ELE.[LastCheckDate],103) END AS LastCheckDate
				, ELE.[Score]
				, ELE.[CommissioningCount]
				, ELE.[LastCheckCount]
			   , (SELECT TOP 1
            ItemVal
          FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History]
          WHERE EntityID = ELE.ID AND Item = N'Фиксация поджигов перед отправкой в ЦСМ'
          ORDER BY Created DESC) AS [CertificationCount]
				, CASE WHEN ELE.[LastAutoCounterDate] IS NULL THEN 'Нет данных' ELSE CONVERT(nchar(19),ELE.[LastAutoCounterDate],120) END AS LastAutoCounterDate
				, ELE.[LastChangedBy]
			   	, 'false' AS [onAction]
        FROM [LabProtocols].[dbo].[Ent_Lab_Entity] AS ELE

        WHERE 
		( @isSingleResults=0
          AND ELE.[Status] LIKE CASE WHEN '@hideMode@' = 'false' THEN '%' ELSE 'OK' END
          AND ELE.[Location] = t1.[Location]
          AND ELE.[LocationCode] = t1.[LocationCode]
          AND ELE.[Condition] = t2.[Condition] )
          OR
          ( @isSingleResults=1 AND ELE.[Location] = t1.[Location]
          AND ELE.[LocationCode] = t1.[LocationCode]
          AND ELE.[Condition] = t2.[Condition] AND CAST(id AS nvarchar(50))='@unid@' )
        FOR XML PATH('VD'), TYPE 

			  ) AS [VesselDetails]

      FROM @t_Location AS t2
      where t2.[Location] = t1.[Location]
        AND t2.[LocationCode] = t1.[LocationCode]
      FOR XML PATH('kk'), TYPE ) AS [ConditionDetails]

    FROM @t_LocationUnique AS t1
    FOR XML PATH('k'), TYPE 

	 ))

  END TRY
  BEGIN CATCH
	SELECT '@PARAM2@ отработал с ошибкой: '+ERROR_MESSAGE()+', Номер строки: '+CAST(ERROR_LINE() AS nvarchar(max));
  END CATCH
END