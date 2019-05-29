IF ('@PARAM2@' = 'VesselFieldFiller')
BEGIN
  BEGIN TRY

 SET @btnSave = '<input class="btn" type="button" name="save" id="save" value="Сохранить" />'
  SET @No_btnSave = '<span class="errorMsg">Нет прав на редактирование</span>'

  SET @AccessList =(SELECT [AccessQuery]
  FROM [NKReports].[dbo].[DB_Settings_ACL]
  WHERE [UserName]='@UserName@' AND [TableName]='LabVesselMonitoring')
  SET @delimiter  = ','

  SET @BranchCodeCheck = ( SELECT LabCode
  from [LabProtocols].[dbo].[Ent_Lab_Entity]
  WHERE ID = '@unid@' )

	SELECT [LabProtocols].dbo.qfn_XmlToJson ((
	  SELECT
      (   SELECT /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@ @UserName@,@GetDate@*/ ELE.[Status]
	  				  , ELE.[ID]
					  , CASE WHEN ELE.[Condition] IS NULL THEN '' ELSE ELE.[Condition] END AS Condition
			   		  , CASE WHEN ELE.[CommissioningDate]  IS NULL THEN '' ELSE  convert(char(10),ELE.[CommissioningDate],103) END AS CommissioningDate 
					  , CASE WHEN ELE.[CertificationDate]  IS NULL THEN '' ELSE  convert(char(10),ELE.[CertificationDate],103) END AS CertificationDate
			   		  , CASE WHEN ELE.[Serial] IS NULL THEN '' ELSE ELE.[Serial] END AS Serial
					  , CASE WHEN ELE.[LastCheckDate]  IS NULL THEN '' ELSE  convert(char(10),ELE.[LastCheckDate],103) END AS LastCheckDate
			   		  , CASE WHEN ELE.[Score] IS NULL THEN '' ELSE ELE.[Score] END AS Score
			   		  , CASE WHEN ELE.[Location] IS NULL THEN '' ELSE ELE.[Location] END AS Location
              , CASE WHEN ELE.[VesselType] IS NULL THEN '' ELSE ELE.[VesselType] END AS [VesselType]
	   				  , CASE WHEN @BranchCodeCheck in (SELECT nstr
        FROM [NKReports].[dbo].[Params_To_Table] (@AccessList, @delimiter)) THEN @btnSave ELSE @No_btnSave END AS [Btn_Save]
	   				  , CASE WHEN @BranchCodeCheck in (SELECT nstr
        FROM [NKReports].[dbo].[Params_To_Table] (@AccessList, @delimiter)) THEN 'true' ELSE 'false' END AS [CanIEditVessel]

      FOR XML PATH ('r0'), TYPE
      ) as [Field]
  , ( SELECT
        (SELECT [CityName] +';'
        FROM [LabProtocols].[dbo].[Ent_Laboratories]
        WHERE 
														(select count(nstr)
        from [NKreports].[dbo].[Params_to_table](@AccessList, @delimiter)
        where nstr=[LabCode])>0
        ORDER BY [CityName]
        for xml path('')  
									  ) as Locations
	  , (SELECT [Item]+';'
        FROM [LabProtocols].[dbo].[Ent_Type_List]
        WHERE [GroupTypeEng] ='VesselType'
        for xml path('') ) as VesselTypes
      FOR XML PATH ('r1'), TYPE
    ) as [Lists]
    
, (SELECT /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/

        ELEH.[Item]
		  , ELEH.[ItemVal]
		 , ELEH.[CreatedBy]
	   , convert(char(19),ELEH.[Created],120)  AS [Created]
      FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] as ELEH
      WHERE CAST(ELEH.[EntityID] AS nvarchar(50)) = '@unid@' AND ELEH.[ItemGroup] IS NULL
      ORDER BY Created DESC
      FOR XML PATH ('r2'), TYPE
  ) AS [History]
  , (SELECT /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/
        ELEH.[ItemGroup] AS [ItemGroup]
		   , [ItemVal] AS [ItemVal]
		   , 5000 as [PreLim]
		   , 10000 as [Lim]

      FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] as ELEH
      WHERE CAST
(ELEH.[EntityID] AS nvarchar
(50)) = '@unid@' AND ELEH.[ItemGroup] IS NOT NULL
      ORDER BY [Created] ASC

      FOR XML PATH
('r3'), TYPE
  ) AS [ChartData]
    FROM [LabProtocols].[dbo].[Ent_Lab_Entity] as ELE
    WHERE CAST(ELE.[ID] AS nvarchar(50)) = '@unid@'
    FOR xml path(''), root																								
	))
  END TRY
  BEGIN CATCH
	SELECT '@PARAM2@ отработал с ошибкой: '+ERROR_MESSAGE()+', Номер строки: '+CAST(ERROR_LINE() AS nvarchar(max));
  END CATCH
END