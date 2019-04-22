IF ('@PARAM2@' = 'Vessels_GetData_Default')
BEGIN
  BEGIN TRY

  SET @btnSave = '<input class="btn" type="button" name="save" id="save" value="Сохранить" />'
  SET @No_btnSave = '<span class="errorMsg">Нет прав на редактирование</span>'

  SET @AccessList =(SELECT [AccessQuery] FROM [NKReports].[dbo].[DB_Settings_ACL] WHERE [UserName]='@UserName@' AND [TableName]='LabVesselMonitoring')
  SET @delimiter  = ','

	SELECT [LabProtocols].dbo.qfn_XmlToJson 
	((
	  SELECT  
	  CASE WHEN @AccessList IS NOT NULL THEN @btnSave ELSE @No_btnSave END AS [Btn_Save]
	  ,( SELECT
	  (SELECT [CityName] +';'  FROM [LabProtocols].[dbo].[Ent_Laboratories] WHERE 
														(select count(nstr) from [NKreports].[dbo].[Params_to_table](@AccessList, @delimiter) where nstr=[LabCode])>0 ORDER BY [CityName] for xml path('')  
									  ) as Locations
	  ,(SELECT [Item]+';' FROM [LabProtocols].[dbo].[Ent_Type_List] WHERE [GroupTypeEng] ='VesselType' for xml path('') ) as VesselTypes
	  			FOR XML PATH ('r1'), TYPE
		) as [Lists]
	   ,CASE WHEN @AccessList IS NOT NULL THEN 'true' ELSE 'false' END AS [CanIEditVessel]
		FOR xml path(''), root
	))

  END TRY
  BEGIN CATCH
	SELECT '@PARAM2@ отработал с ошибкой: '+ERROR_MESSAGE()+', Номер строки: '+CAST(ERROR_LINE() AS nvarchar(max));
  END CATCH
END