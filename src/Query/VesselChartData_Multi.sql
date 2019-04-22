IF ('@PARAM2@' = 'VesselChartData_Multi')
BEGIN
  BEGIN TRY

 /* DECLARE @tempItemGroup table (ItemGroup  nvarchar(max),[created] date )*/
  DECLARE @tempItemGroup table (ItemGroup nvarchar(max),
    [created] nvarchar(max) )
  INSERT INTO @tempItemGroup
  SELECT distinct
    ELEH.[ItemGroup] AS [ItemGroup]
   /* ,CAST( ELEH.[created] as date) AS [created]*/
	, LEFT(CONVERT(varchar, [Created],112),6)
  FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] AS ELEH
  WHERE ELEH.[EntityID] IN ( SELECT id
    FROM [LabProtocols].[dbo].[Ent_Lab_Entity] AS ELE2
    WHERE ELE2.[Condition] ='@Condition@' AND ELE2.[Location]='@Location@')
    AND ELEH.ITEMGROUP IS NOT NULL
 /* ORDER BY [created] ASC*/

  SELECT [LabProtocols].dbo.qfn_XmlToJson (( 
	SELECT ELE2.SERIAL
	, (SELECT ELEH.[ItemGroup]
			, ELEH.[ItemVal]
      FROM [LabProtocols].[dbo].[Ent_Lab_Entity] AS ELE
        INNER JOIN [LabProtocols].[dbo].[Ent_Lab_Entity_History] AS ELEH
        ON ELE.id=ELEH.[EntityID]
      WHERE ELEH.ITEMGROUP IS NOT NULL
        AND ELE.[Condition] = '@Condition@'
        AND ELE.[Location] = '@Location@'
        AND ELE2.SERIAL = ELE.SERIAL
      ORDER BY ELEH.[Created] asc
      FOR XML PATH('ll'), TYPE	
	 ) AS vd

	, (SELECT ItemGroup
      from @tempItemGroup
      ORDER BY [created] ASC
      FOR XML PATH('kk'),ROOT('Category'),TYPE )

    FROM [LabProtocols].[dbo].[Ent_Lab_Entity] AS ELE2
    WHERE ELE2.[Condition] = '@Condition@'
      AND ELE2.[Location] = '@Location@'
    FOR xml path('a'),type	
  ))

  END TRY
  BEGIN CATCH
	SELECT '@PARAM2@ отработал с ошибкой: '+ERROR_MESSAGE()+', Номер строки: '+CAST(ERROR_LINE() AS nvarchar(max));
  END CATCH
END