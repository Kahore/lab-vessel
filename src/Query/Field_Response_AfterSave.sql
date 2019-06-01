DECLARE @iError INT;

IF ('@PARAM2@' = 'SaveVessel')
BEGIN
  SET @iError = 0;
  IF '@Status@' ='' or '@Status@' = NULL
  BEGIN
    SET @Status='OK'
  END
  ELSE 
  BEGIN
    SET @Status=ltrim(rtrim('@Status@'))
  END

  BEGIN TRY

	IF ('@CommissioningDate@'<>'' and '@CommissioningDate@'<>'/' and '@CommissioningDate@'<>N'Нет данных' and '@CommissioningDate@'<>N'null')
	BEGIN
    BEGIN TRY 
      SET @CommissioningDate=CONVERT(date,'@CommissioningDate@',103) 
    END TRY
		BEGIN CATCH 
      SELECT 'Ошибка в дате подачи заявления' 
    END CATCH
    SET @iError = @iError + 1
  END
	ELSE
	BEGIN
    SET @CommissioningDate=NULL
  END

	IF ('@CertificationDate@'<>'' and '@CertificationDate@'<>'/' and '@CertificationDate@'<>N'Нет данных' and '@CertificationDate@'<>N'null')
	BEGIN
    BEGIN TRY 
      SET @CertificationDate=CONVERT(date,'@CertificationDate@',103)
      END TRY
		BEGIN CATCH 
      SELECT 'Ошибка в дате подачи заявления' 
    END CATCH
    SET @iError = @iError + 1
  END
	/* ELSE
		BEGIN
    SET @CertificationDate=NULL
  END */

	IF ('@LastCheckDate@'<>'' and '@LastCheckDate@'<>'/' and '@LastCheckDate@'<>N'Нет данных'and '@LastCheckDate@'<>N'null')
	BEGIN
    BEGIN TRY 
      SET @LastCheckDate=CONVERT(date,'@LastCheckDate@',103) 
    END TRY
		BEGIN CATCH
      SELECT 'Ошибка в дате подачи заявления'
    END CATCH
    SET @iError = @iError + 1
  END
	ELSE
	BEGIN
    SET @LastCheckDate=NULL
  END

	IF ('@Score@'='2')
	BEGIN
    SET @DecommissioningDate=GETDATE()
    SET @Status = 'Util'
    SET @Condition = 'Выведена из эксплуатации ' + (SELECT [Condition]
    FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
    WHERE CAST([ID] AS nvarchar(50)) = '@unid@')

    SET @NewLastAutoCounterDate = dateadd(hour,4,getdate())

    INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
      ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
    VALUES
      (NewID(), '@unid@', 'Выведена из эксплуатации', NULL , @DecommissioningDate , @NewLastAutoCounterDate, '@UserName@')
  END
	ELSE
	BEGIN
    SET @DecommissioningDate=NULL
    SET @Condition = ltrim(rtrim('@Condition@'))
  END

    IF ('@Condition@'<>'' and '@Serial@'<>'' and '@Location@'<>'' AND '@CommissioningDate@' <> '' AND '@Score@' <>'' AND '@VesselType@' <> '')
	  BEGIN
    IF (@iError = 0)
    BEGIN
      IF ('@unid@' like '%unid%' or '@unid@'='')
		  BEGIN
        SET @Serial = ( SELECT [Serial]
        FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
        WHERE [Serial] =ltrim(rtrim('@Serial@')) )
        IF @Serial is null
		    BEGIN
          SET @NewVesselID = NewID()
          SET @NewLastAutoCounterDate=dateadd(hour,4,getdate())

          INSERT  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ INTO [LabProtocols].[dbo].[Ent_Lab_Entity]
            ( [ID]
            ,[Condition]
            ,[Serial]
            ,[Status]
            ,[CommissioningDate]
            ,[CertificationDate]
            ,[LastCheckDate]
            ,[Score]
            ,[CommissioningCount]
            ,[LastCheckCount]
            ,[Location]
            ,[LocationCode]
            ,[LabCode]
            ,[LastChangedBy]
            ,[VesselType]
            )
          VALUES
            (@NewVesselID
						 , @Condition
						 , ltrim(rtrim('@Serial@'))
						 , @Status
						 , @CommissioningDate
						 , @CertificationDate
						 , @LastCheckDate
						, ltrim(rtrim('@Score@')) 
						, 0
						, 0
						, '@Location@', (SELECT TOP 1
                [Code]
              FROM [RUWS002].[AllVostok].[dbo].[Ref_Location] as a
              WHERE a.[Name] = '@Location@')
						, (SELECT TOP 1
                [LabCode]
              FROM [LabProtocols].[dbo].[Ent_Laboratories]
              WHERE [CityName] = '@Location@')

						, '@UserName@'
						, '@VesselType@'
						)

          INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
            ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
          VALUES
            (NewID(), @NewVesselID, 'Создание записи', NULL , @Condition+'-'+'@Location@', @NewLastAutoCounterDate, '@UserName@')

          /*Создание истории для месячного накопления для графиков*/
          INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
            ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
          VALUES
            (NewID(), @NewVesselID, 'Поджиги', CAST( YEAR( @NewLastAutoCounterDate ) AS CHAR(4) ) + '-'+ LEFT( DATENAME ( MONTH, @NewLastAutoCounterDate ),3 ), 0, @NewLastAutoCounterDate, '@UserName@')

          IF (@CertificationDate IS NOT NULL)
			    BEGIN
            INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
              ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
            VALUES
              (NewID(), @NewVesselID, 'Фиксация поджигов перед отправкой в ЦСМ', NULL , '0', @NewLastAutoCounterDate, '@UserName@')
          END

        END/* SERIAL check */
		    ELSE
		    BEGIN
          SELECT 'Сосуд уже существует'
        END
      END
		ELSE
		BEGIN
        SET @NewLastAutoCounterDate = dateadd(hour,4,getdate())
        /*Сброс счётчика после проверки сосуда*/
        SET @LastCheckDateCheck = (SELECT [LastCheckDate]
        FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
        WHERE CAST([ID] AS nvarchar(50))='@unid@')

        IF @LastCheckDateCheck <> @LastCheckDate
			  BEGIN
          UPDATE [LabProtocols].[dbo].[Ent_Lab_Entity]
          SET [LastCheckCount]=0
          WHERE CAST([ID] AS nvarchar(50))='@unid@'

          INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
            ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
          VALUES
            (NewID(), '@unid@', 'Периодическая проверка', NULL , 'с ' + CAST(@LastCheckDateCheck AS nvarchar(10) ) + ' по ' + CAST(@LastCheckDate AS nvarchar(10) ) , @NewLastAutoCounterDate, '@UserName@')
        END

        SET @LocationOld = (SELECT [Location]
        FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
        WHERE CAST([ID] AS nvarchar(50))='@unid@')

        IF @LocationOld <> '@Location@'
			  BEGIN
          INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
            ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
          VALUES
            (NewID(), '@unid@', 'Смена локации', NULL , 'из ' + @LocationOld + ' в ' + '@Location@' , @NewLastAutoCounterDate, '@UserName@')
        END

        SET @StatusOld = (SELECT [Condition]
        FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
        WHERE CAST([ID] AS nvarchar(50)) = '@unid@')

        IF @StatusOld <> @Condition
			  BEGIN
          INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
            ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
          VALUES
            (NewID(), '@unid@', 'Смена статуса', NULL , @Condition , @NewLastAutoCounterDate, '@UserName@')
        END

        SET @ScoreOld = (SELECT [Score]
        FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
        WHERE CAST([ID] AS nvarchar(50)) = '@unid@')

        IF @ScoreOld <> ltrim(rtrim('@Score@')) 
			  BEGIN
          INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
            ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
          VALUES
            (NewID(), '@unid@', 'Изменена оценка', NULL , ltrim(rtrim('@Score@')), @NewLastAutoCounterDate, '@UserName@')
        END

        SET @CertificationDateOld = (SELECT [CertificationDate]
        FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
        WHERE CAST([ID] AS nvarchar(36)) = '@unid@')

        IF @CertificationDateOld <> @CertificationDate
			  BEGIN
          INSERT INTO  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
            ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
          VALUES
            (NewID(), '@unid@', 'Фиксация поджигов перед отправкой в ЦСМ', NULL , (SELECT CAST([CommissioningCount] AS nvarchar(10))
              FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
              WHERE CAST([ID] AS nvarchar(36)) = '@unid@'), @NewLastAutoCounterDate, '@UserName@')
        END

        UPDATE  /*POST SERVICE LAB VesselMonitoringBackend @PARAM2@, @UserName@, @GetDate@*/ [LabProtocols].[dbo].[Ent_Lab_Entity]
			SET [Condition] = @Condition
				,[Serial] = ltrim(rtrim('@Serial@'))
				,[Status] = @Status
				,[CommissioningDate] = @CommissioningDate
				,[CertificationDate] = @CertificationDate
				,[LastCheckDate] = @LastCheckDate
				,[Score] = ltrim(rtrim('@Score@')) 

				,[DecommissioningDate] = @DecommissioningDate
				,[Location] = '@Location@'
				,[LocationCode] = (SELECT TOP 1
          [Code]
        FROM [RUWS002].[AllVostok].[dbo].[Ref_Location] as a
        WHERE a.[Name] = '@Location@')
				,[LabCode] = (SELECT TOP 1
          [LabCode]
        FROM [LabProtocols].[dbo].[Ent_Laboratories]
        WHERE [CityName] = '@Location@')
 				,[LastChangedBy] = '@UserName@'
				,[VesselType] = '@VesselType@'
				WHERE CAST([ID] AS nvarchar(50))='@unid@'
        SET @NewVesselID = '@unid@'
      END
    END/*iError*/
  END
	ELSE 
	BEGIN
    SELECT char(10)+'Не все обязательные поля заполнены'
  END

    SELECT [LabProtocols].dbo.qfn_XmlToJson 
	((
	  SELECT
      @NewVesselID as unid
	  , (SELECT
        ELEH.[Item]
		  , ELEH.[ItemVal]
		 , ELEH.[CreatedBy]
	   , convert(char(19),ELEH.[Created],120)  AS [Created]
      FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] as ELEH
      WHERE CAST(ELEH.[EntityID] AS nvarchar(36)) = @NewVesselID AND ELEH.[ItemGroup] IS NULL
        AND ELEH.[Created] = @NewLastAutoCounterDate
      ORDER BY Created DESC
      FOR xml path('HistoryPart'),root('HistoryPart'),type)
    FOR xml path('vd'),type
	  ))

END TRY
BEGIN CATCH
	SELECT '@PARAM2@ отработал с ошибкой: '+ERROR_MESSAGE()+', Номер строки: '+CAST(ERROR_LINE() AS nvarchar(max));
END CATCH
END
/* END OF  SaveVessel */