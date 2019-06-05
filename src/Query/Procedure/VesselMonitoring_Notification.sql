USE [LabProtocols]
GO

/****** Object:  StoredProcedure [dbo].[VesselMonitoring_Notification]    Script Date: 05/06/2019 11:17:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:           <Konstantin Golubkin>
-- Create date: <2018-07-09>
-- Last update: <2019-04-22>
-- Description:      <VesselMonitoring Notification, Estimates on 3 month >
-- =============================================
ALTER PROCEDURE [dbo].[VesselMonitoring_Notification]

AS
BEGIN
       --SELECT 0;
       DECLARE @t_Serial TABLE ([Cnt] int,[Serial] nvarchar(50),[LabCode] nvarchar(10),[LastAutoCounterDate] datetime,[CommissioningCount] int,[LastCheckCount] int );
       DECLARE @MailFrom nvarchar(max);
       DECLARE @MailTo nvarchar(max);
       DECLARE @MailCC nvarchar(max);
       DECLARE @MailHeader nvarchar(max);
       DECLARE @x nvarchar(max);
       DECLARE @counter int;
       DECLARE @humanizeIt int;
       DECLARE @txtMail nvarchar(max);
       DECLARE @CityName nvarchar(max);

       DECLARE @CurrSerial nvarchar(max);
       --DECLARE @LastAutoCounterDate datetime;
       --DECLARE @NewLastAutoCounterDate datetime;
       DECLARE @LastAutoCounterDate varchar(50);
       DECLARE @NewLastAutoCounterDate varchar(50);
       DECLARE @VesselCount int;
       DECLARE @CommissioningCount int
       DECLARE @LastCheckCount int
       DECLARE @CummMonthCount int

       DECLARE @Labcode nvarchar(50);

       DECLARE @SLIM_Server nvarchar(50);
       DECLARE @SLIM_DB nvarchar(50);
       DECLARE @SLIM_Labcode nvarchar(50);

       DECLARE @NewData_OPENQUERY nvarchar(max)

       DECLARE @t_VesselCnt TABLE (VesselCnt int)
/*============================================= Для прогноза ======================================================*/
       DECLARE @t_VesselTypes TABLE ([Cnt] INT,[LabCode] nvarchar(5),[VesselType] nvarchar(max), Limit INT, InWork INT, InReserve INT)

       DECLARE @TypeVessel nvarchar (max);
       DECLARE @Lbcd nvarchar (max);
       DECLARE @Lim int;
       DECLARE @InReserve int;

       DECLARE @MaxRes int;
       DECLARE @FrstDate datetime;
       DECLARE @LastDate datetime;
       DECLARE @currentData TABLE ([Serial] nvarchar(max), [ItemVal] nvarchar(max), m1 int, m2 int, m3 int, r int)

       DECLARE @VesselReserveCnt int;
       DECLARE @VesselFailNowCnt int;
       DECLARE @VesselFailNowName nvarchar (max);
       DECLARE @VesselFailM1Cnt int;
       DECLARE @VesselFailM1Name nvarchar (max);
       DECLARE @VesselFailM2Cnt int;
       DECLARE @VesselFailM2Name nvarchar (max);
       DECLARE @VesselFailM3Cnt int;
       DECLARE @VesselFailM3Name nvarchar (max);
       DECLARE @VesselFailTotal int;

       DECLARE @VesselFailReserveNote nvarchar (max);
       DECLARE @VesselFailNowNote nvarchar (max);
       DECLARE @VesselFailM1Note nvarchar (max);
       DECLARE @VesselFailM2Note nvarchar (max);
       DECLARE @VesselFailM3Note nvarchar (max);

       DECLARE @Link nvarchar (max);
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
       SET @Link = 'http://ruws007.sgs.net/NKReports/Default?Id=6689ec57-389c-445d-8a26-cfa437a93d96&FBCR=1\'

       /*Получаем новые данные по поджигам по все неутилизированным сосудам за период*/

       INSERT INTO @t_Serial ([Cnt], [Serial], [LabCode], [LastAutoCounterDate], [CommissioningCount], [LastCheckCount])
       SELECT ROW_NUMBER() OVER ( ORDER BY Serial ASC ), [Serial], [LabCode], [LastAutoCounterDate], [CommissioningCount], [LastCheckCount]
                                    FROM [LabProtocols].[dbo].[Ent_Lab_Entity] as ELE
                                  WHERE ELE.[Status] <>'Util'

       SET @counter = 1

       WHILE @counter <= (SELECT MAX([Cnt]) FROM @t_Serial)
       BEGIN
       /*MEMO: Зачистка временной таблицы перед каждым циклом обязательна!*/
       DELETE FROM @t_VesselCnt

              SET @LastAutoCounterDate=(SELECT [LastAutoCounterDate]  FROM @t_Serial WHERE [Cnt]=@counter)

              SET @Labcode = (SELECT [LabCode] FROM @t_Serial WHERE [Cnt] = @counter)
              /*MEMO: на KI app сервере МСК время*/
              IF @Labcode <> 'KI'
              BEGIN
                SET @NewLastAutoCounterDate=dateadd( hour, 4, getdate() )
              END
              ELSE
              BEGIN
                SET @NewLastAutoCounterDate=getdate()
              END

/*
MEMO: Блок для процедуры каждое первое число - берём минус один день для закрытия кумулятивного месячного счётчика 
например, getdate возвращает 2018-10-01 08:05:10.321 
после преобразований получаем 2018-09-30 23:59:59.001
*/
                     IF CAST( DAY(@NewLastAutoCounterDate) AS CHAR(2) )  = 1 
                     BEGIN
                       SET @NewLastAutoCounterDate = CONVERT( date, dateadd( Day, -1, @NewLastAutoCounterDate ) ) 
                       SET @NewLastAutoCounterDate = CONVERT( datetime, dateadd( Day, 1, dateadd( Second, -1, @NewLastAutoCounterDate ) ) )
                     END

              SET @CurrSerial = (SELECT [Serial] FROM @t_Serial WHERE [Cnt] = @counter)

              SET @CommissioningCount = (SELECT [CommissioningCount]  FROM @t_Serial WHERE [Cnt] = @counter )
             SET @LastCheckCount = (SELECT [LastCheckCount] FROM @t_Serial WHERE [Cnt] = @counter )

              SET @SLIM_Server = ( SELECT [SLIM_Server] FROM [LabProtocols].[dbo].[Ent_Laboratories] WHERE [LabCode] = @Labcode ) 
              SET @SLIM_DB =( SELECT [SLIM_DB] FROM [LabProtocols].[dbo].[Ent_Laboratories] WHERE [LabCode] = @Labcode ) 
              SET @SLIM_Labcode = ( SELECT [SLIM_Labcode] FROM [LabProtocols].[dbo].[Ent_Laboratories] WHERE [LabCode] = @Labcode ) 

              SET @LastAutoCounterDate = CONVERT(char(23),try_parse(@LastAutoCounterDate as datetime2 using 'en-GB'),121) 
              SET @NewLastAutoCounterDate = CONVERT(char(23),try_parse(@NewLastAutoCounterDate as datetime2 using 'en-GB'),121)

              SET @NewData_OPENQUERY='SELECT * FROM OPENQUERY('+@SLIM_Server+','+
              '''
              SELECT /*VesselMonitoring_Notification, GetDate()*/ COUNT(PJCSA.CUID)
                           FROM ['+@SLIM_Server+'].['+@SLIM_DB+'].dbo.[PROFJOB_CUID_SCHEME_ANALYTE] AS PJCSA
                                  INNER JOIN ['+@SLIM_Server+'].['+@SLIM_DB+'].dbo.[PROFJOB_CUID_SCHEME] AS PJCS
                                         ON PJCSA.LABCODE=PJCS.LABCODE
                                         AND PJCSA.PRO_JOB=PJCS.PRO_JOB
                                         AND PJCSA.CUID=PJCS.CUID
                                         AND PJCSA.SCH_CODE=PJCS.SCH_CODE AND PJCSA.SCHVERSION=PJCS.SCHVERSION
                           WHERE PJCSA.SCH_CODE =''''COCV__BOMB_VALUE''''
                           AND PJCSA.ANALYTECODE=''''BOMB_ID'''' 
                           AND PJCSA.FINALVALUE='''''+@CurrSerial+'''''
                           AND PJCS.ANALYSED between '''''+@LastAutoCounterDate+''''' and '''''+@NewLastAutoCounterDate+'''''
                           '')'

                     INSERT @t_VesselCnt
                     exec (@NewData_OPENQUERY)

              SET @VesselCount = ( SELECT TOP 1 VesselCnt FROM @t_VesselCnt )

              SET @CommissioningCount = @CommissioningCount+@VesselCount
              SET @LastCheckCount = @LastCheckCount+@VesselCount

                UPDATE /*VesselMonitoring_Notification, GetDate()*/ [LabProtocols].[dbo].[Ent_Lab_Entity]
                SET [CommissioningCount] = @CommissioningCount
                     ,[LastCheckCount] = @LastCheckCount 
                      ,[LastAutoCounterDate] = @NewLastAutoCounterDate
                     ,[LastChangedBy] = 'Auto_Procedure'
                WHERE [SERIAL] = @CurrSerial

                           IF @VesselCount IS NOT NULL
                           BEGIN
                                  INSERT INTO /*VesselMonitoring_Notification, GetDate()*/  [LabProtocols].[dbo].[Ent_Lab_Entity_History]
                                                ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
                             VALUES (NewID(),(SELECT ID FROM [LabProtocols].[dbo].[Ent_Lab_Entity] WHERE [SERIAL]=@CurrSerial ),'Поджиги',NULL,@VesselCount,@NewLastAutoCounterDate,'Auto_Procedure')
                   
                              SET @CummMonthCount = ( SELECT CAST([ItemVal] AS int) FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] 
                                                                                                       WHERE [EntityID] = (SELECT ID FROM [LabProtocols].[dbo].[Ent_Lab_Entity] WHERE [SERIAL] = @CurrSerial ) AND [ItemGroup] = CAST(YEAR(@NewLastAutoCounterDate) AS CHAR(4)) + '-'+ LEFT(DATENAME ( MONTH , @NewLastAutoCounterDate ),3) 
                                                                                            )
                             IF @CummMonthCount IS NULL
                             BEGIN
       /*Берём куммулятивные данные прошлого месяца*/
                              SET @CummMonthCount = ( SELECT TOP 1 CAST([ItemVal] AS int) FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] 
                                                                                                        WHERE [EntityID] = (SELECT ID FROM [LabProtocols].[dbo].[Ent_Lab_Entity] WHERE [SERIAL] = @CurrSerial ) AND [ItemGroup] IS NOT NULL ORDER BY [Created] DESC
                                                                                                   )

                                  INSERT INTO /*VesselMonitoring_Notification, GetDate()*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
                                                                ([ID],[EntityID],[Item],[ItemGroup] ,[ItemVal] ,[Created],[CreatedBy])
                                                VALUES (NewID(),(SELECT ID FROM [LabProtocols].[dbo].[Ent_Lab_Entity] WHERE [SERIAL]=@CurrSerial ),'Поджиги', CAST(YEAR(@NewLastAutoCounterDate) AS CHAR(4)) + '-'+ LEFT(DATENAME ( MONTH , @NewLastAutoCounterDate ),3),@CummMonthCount+@VesselCount, @NewLastAutoCounterDate,'Auto_Procedure')
                             END
                             ELSE
                             BEGIN
                                  UPDATE /*VesselMonitoring_Notification, GetDate()*/ [LabProtocols].[dbo].[Ent_Lab_Entity_History]
                                         SET [ItemVal] = @CummMonthCount+@VesselCount
                                  WHERE [EntityID] = (SELECT ID FROM [LabProtocols].[dbo].[Ent_Lab_Entity] WHERE [SERIAL]= @CurrSerial ) AND [ItemGroup] = CAST(YEAR(@NewLastAutoCounterDate) AS CHAR(4)) + '-' + LEFT(DATENAME ( MONTH , @NewLastAutoCounterDate ),3) 
                              END
                        END /*END OF VesselCount check*/

              SET @counter = @counter + 1
       END
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
/*Ищем с новыми данными те, по которым должна пройти рассылка*/
       DECLARE @t_Location AS table ([Cnt] int,[CityName] nvarchar(50) )

       INSERT INTO @t_Location ([Cnt],[CityName])
       SELECT ROW_NUMBER() OVER ( ORDER BY LabCode ASC ), [CityName] 
                                  FROM [LabProtocols].[dbo].[Ent_Laboratories] AS Lab
                                  WHERE Lab.[CityName] in ( SELECT [Lab] FROM  [LabProtocols].[dbo].[Ent_MailOrderSettings] where [ReportType]='VesselMonitoring')

       SET @counter = 1

       WHILE @counter <= (SELECT MAX([Cnt]) FROM @t_Location)
       BEGIN

              SET @MailFrom = 'Rucoalsu.Novokuznetsk@sgs.com'

              SET @MailTo = ( SELECT [To] FROM [LabProtocols].[dbo].[Ent_MailOrderSettings] WHERE [Lab] = ( SELECT [CityName] FROM  @t_Location WHERE @counter=[Cnt] ) AND [ReportType]='VesselMonitoring' )
                           
              SET @MailCC = ( SELECT [CC] FROM [LabProtocols].[dbo].[Ent_MailOrderSettings] WHERE [Lab] = ( SELECT [CityName] FROM  @t_Location WHERE @counter=[Cnt] ) AND [ReportType]='VesselMonitoring' )
              
              SET @CityName = ( SELECT [CityName] FROM  @t_Location WHERE @counter=[Cnt] )

              Set @humanizeIt = (SELECT count([Serial])
                     FROM [LabProtocols].[dbo].[Ent_Lab_Entity] AS ELE
                     WHERE  ELE.[LastCheckCount]  >=5000
                     AND ELE.[Status] <>'Util'
                     AND ELE.[Location] = ( SELECT [CityName] FROM  @t_Location WHERE @counter=[Cnt] ) 
                                           
              )
                     IF ( @humanizeIt = 1 ) 
                     BEGIN 
                           SET @txtMail = 'Добрый день, данная автоматическая рассылка уведомляет, что по калориметрическому сосуду'
                           SET @MailHeader = @CityName +' VesselMonitoring Notification'
                     END
                     ELSE IF( @humanizeIt > 1 )
                     BEGIN 
                           SET @txtMail = 'Добрый день, данная автоматическая рассылка уведомляет, что по калориметрическим сосудам:' +'<br>'
                           SET @MailHeader = @CityName +' VesselMonitoring Notification'
                     END
                     ELSE
                     BEGIN 
                           SET @txtMail = NULL
                           SET @MailHeader = NULL
                     END

              SET @txtMail= @txtMail + '<br>' + (
                     SELECT 'S/N '+ELE.[Serial]+' количество поджигов: '+ CAST(ELE.[LastCheckCount] as nvarchar(100)) +'. Накопительное количество поджигов: '+CAST(ELE.[CommissioningCount] as nvarchar(100)) +'. Текущая оценка: '+CAST(ELE.[Score] as nvarchar(2))+'<br>'
                     FROM [LabProtocols].[dbo].[Ent_Lab_Entity] AS ELE
                     WHERE ELE.[LastCheckCount]  >=5000
                     AND ELE.[Status] <>'Util'
                     AND ELE.[Location] = ( SELECT [CityName] FROM  @t_Location WHERE @counter=[Cnt]) 
                                           
              FOR XML PATH('') )

              SET @txtMail = @txtMail + '<br>'+'<span>Больше деталей, а так же остальные сосуды доступны по <a href="'+@Link+'">cсылке</a></span>'

              IF ( @txtMail IS NOT NULL )
              BEGIN
                     BEGIN TRY
                           INSERT INTO /*VesselMonitoring_Notification, GetDate()*/ [RUWS002].[AllVostok].[dbo].[DB_Settings_SendMail]
                           ([id],
                           [applicationid],
                           [from],
                           [to],
                           [cc],
                           [subject],
                           [body],
                           [retries],
                           [Attachments],
                           [issent],
                           [iserror],
                           [isworking],
                           [isdone])
                           VALUES      
                           (NEWID()
                           ,'LabOrder'
                           ,@MailFrom
                           ,@MailTo
                           ,@MailCC
                           ,@MailHeader
                           ,'<div>'+@txtMail+'</div>'
                           ,'2'
                           ,''
                           ,'False'
                           ,'False'
                           ,'False'
                           ,'False' );
                     END TRY
                     BEGIN CATCH
                           INSERT INTO /*VesselMonitoring_Notification, GetDate()*/ [RUWS002].[AllVostok].[dbo].[DB_Settings_SendMail]
                           ([id],
                           [applicationid],
                           [from],
                           [to],
                           [cc],
                           [subject],
                           [body],
                           [retries],
                           [Attachments],
                           [issent],
                           [iserror],
                           [isworking],
                           [isdone])
                           VALUES      
                           (NEWID()
                           ,'LabOrder'
                           ,@MailFrom
                           ,@MailFrom
                           ,NULL
                           ,@MailHeader +' ERROR'
                           ,'VesselMonitoring Notification отработал с ошибкой: '+ERROR_MESSAGE()+', Номер строки: '+CAST( ERROR_LINE() AS nvarchar(max) )
                           ,'2'
                           ,''
                           ,'False'
                           ,'False'
                           ,'False'
                           ,'False' );  
                     END CATCH
              END
              SET @counter = @counter + 1
       END  /*Конец цикла поиска новых данных*/
       
       IF (@counter is null) --Блок для отработки процедуры в случае, когда ничего не найдено
       BEGIN
              SET @counter=0
       END
/*========================================================================= Прогноз =====================================================================*/
/*============================================================= Подготавливаем типы для анализа =========================================================*/
       INSERT INTO @t_VesselTypes 
              SELECT DISTINCT /*VesselMonitoring_Estimates, GetDate()*/
              ROW_NUMBER() OVER ( ORDER BY ELE.[LabCode] ASC),
              ELE.[LabCode]
              ,[VesselType]
              ,CAST (ELES.ItemVal AS INT)
              ,CAST (ELES2.ItemVal AS INT)
              ,CAST (ELES3.ItemVal AS INT)
              FROM [LabProtocols].[dbo].[Ent_Lab_Entity] as ELE
                     INNER JOIN  [LabProtocols].[dbo].[Ent_Lab_Entity_Estimates] as ELES
                           ON ELE.[LabCode] = ELES.[LabCode]
                           AND ELE.[VesselType] = ELES.[Item]
                     INNER JOIN  [LabProtocols].[dbo].[Ent_Lab_Entity_Estimates] as ELES2
                           ON ELE.[LabCode] = ELES2.[LabCode]
                           AND ELE.[VesselType] = ELES2.[Item]
                     INNER JOIN  [LabProtocols].[dbo].[Ent_Lab_Entity_Estimates] as ELES3
                           ON ELE.[LabCode] = ELES3.[LabCode]
                           AND ELE.[VesselType] = ELES3.[Item]
              WHERE ELE.[Status] <>'Util'
                     AND ELES.[ItemGroup] = 'Limit'
                     AND ELES2.[ItemGroup] = 'InWork'
                     AND ELES3.[ItemGroup] = 'InReserve'
              GROUP BY ELE.[VesselType],ELE.[LabCode],ELES.ItemVal,ELES2.ItemVal,ELES3.ItemVal,ELES.[ItemGroup]

       SET @counter = 1

       WHILE @counter <= (SELECT MAX([Cnt]) FROM @t_VesselTypes)
       BEGIN

              SET @TypeVessel = ( SELECT [VesselType] FROM @t_VesselTypes WHERE [Cnt] = @counter )
              SET @Lbcd = ( SELECT [LabCode] FROM @t_VesselTypes WHERE [Cnt] = @counter )
              SET @Lim = ( SELECT [Limit] FROM @t_VesselTypes WHERE [Cnt] = @counter )
              SET @InReserve = ( SELECT [InReserve] FROM @t_VesselTypes WHERE [Cnt] = @counter )
              /*=================================================== Подготавливаем список сосудов по локации и типу =========================================================*/
              INSERT INTO @currentData
              SELECT * 
              FROM (
              SELECT /*VesselMonitoring_Estimates, GetDate()*/ ELE.[Serial] ,ELEH.[ItemVal], m1 = NULL, m2 = NULL, m3 = NULL, r = row_number() over (partition by [EntityID] order by [Created] desc) 
              FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] AS ELEH
              INNER JOIN [LabProtocols].[dbo].[Ent_Lab_Entity] AS ELE
              ON ELE.ID = ELEH.[EntityID]

              WHERE ELEH.[EntityID] IN ( 
                     SELECT [ID] FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
                     WHERE [VesselType] = @TypeVessel
                       AND [LabCode] = @Lbcd
                       AND [Status] = 'OK'
                       AND [Condition] <> 'Химики'
                       AND Item = 'Поджиги'
                       AND [ItemGroup] is not null
                       AND [ItemVal] <> '0' 
                )
                     ) a 
              WHERE r = 1

                     SET @FrstDate = dateadd(hour,4,getdate() )
                     SET @LastDate = dateadd(hour,4,getdate() )
       
                     SET @FrstDate = CONVERT( date, DATEADD( MONTH, -1, @FrstDate ) ) 

                     SET @FrstDate = DATEADD(DAY,-DAY(@FrstDate)+1,@FrstDate)
              /*=================================================== Узнаём максимум поджигов за прошлый месяц =========================================================*/
              SET @MaxRes = (      SELECT MAX(qu) from (
                           SELECT SUM(CAST([ItemVal] AS int)) AS qu
              
                     FROM [LabProtocols].[dbo].[Ent_Lab_Entity_History] AS eleh
                     WHERE [EntityID] in ( SELECT ID FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
                           WHERE [VesselType] = @TypeVessel
                             AND [LabCode] = @Lbcd
                             AND [Status] = 'OK'
                             AND [Condition] <> 'Химики'
                             AND [Item] = 'Поджиги'
                             AND [ItemGroup] IS NULL
                             AND [ItemVal] <> '0' 
                )
                AND [CREATED] BETWEEN @FrstDate AND CAST(EOMONTH(@FrstDate) AS datetime)
                GROUP BY [EntityID]
                ) AS qu
                )
                IF @MaxRes IS NOT NULL
                BEGIN
                     /*=================================================== Интерполируем линейную модель на 3 месяца ===========================================*/
                           UPDATE @currentData
                           SET m1 = [ItemVal] + @MaxRes,
                                  m2 = [ItemVal] + @MaxRes * 2,
                                  m3 = [ItemVal] + @MaxRes * 3
                     /*======================================================== Считаем имеющиеся резервы =========================================================*/
                           SET @VesselReserveCnt = ( SELECT MAX(r) FROM (
                           SELECT ROW_NUMBER() OVER ( ORDER BY [Serial] ASC) AS r FROM [LabProtocols].[dbo].[Ent_Lab_Entity]
                             WHERE [VesselType] = @TypeVessel
                             AND [LabCode] = @Lbcd
                             AND [Status] = 'OK'
                             AND [Condition] <> 'Химики'
                             AND [CommissioningCount]<= 1000
                             ) r )
                     /*======================================================= Считаем сколько нужно резерва =========================================================*/
                       SET @VesselFailNowCnt =  ( SELECT MAX(r) FROM ( SELECT ROW_NUMBER() OVER (ORDER BY [Serial] ASC) AS r FROM @currentData WHERE ItemVal >=@Lim ) as r )
                       SET @VesselFailNowName = ( SELECT [Serial] +', ' FROM @currentData WHERE ItemVal >=@Lim FOR XML PATH ('') )
                       SET @VesselFailNowName = ( SUBSTRING(@VesselFailNowName, 1,len(@VesselFailNowName)-1) )

                       SET @VesselFailM1Cnt =  ( SELECT MAX(r) FROM ( SELECT ROW_NUMBER() OVER (ORDER BY [Serial] ASC) AS r FROM @currentData WHERE m1 >=@Lim AND ItemVal<=@Lim) as r)
                       SET @VesselFailM1Name = ( SELECT [Serial] +', ' FROM @currentData WHERE m1 >=@Lim AND ItemVal<=@Lim FOR XML PATH (''))
                       SET @VesselFailM1Name = ( SUBSTRING(@VesselFailM1Name, 1,len(@VesselFailM1Name)-1) )

                       SET @VesselFailM2Cnt = ( SELECT MAX(r) FROM ( SELECT ROW_NUMBER() OVER (ORDER BY [Serial] ASC) AS r FROM @currentData WHERE m2 >=@Lim AND ItemVal<=@Lim AND m1<=@Lim ) as r)
                       SET @VesselFailM2Name = ( SELECT [Serial] +', ' FROM @currentData WHERE m2 >=@Lim AND ItemVal<=@Lim AND m1<=@Lim FOR XML PATH (''))
                       SET @VesselFailM2Name = ( SUBSTRING(@VesselFailM2Name, 1,len(@VesselFailM2Name)-1) )

                       SET @VesselFailM3Cnt =  ( SELECT MAX(r) FROM ( SELECT ROW_NUMBER() OVER (ORDER BY [Serial] ASC) AS r FROM @currentData WHERE m3 >=@Lim AND ItemVal<=@Lim AND m1<=@Lim AND m2<=@Lim ) as r)
                       SET @VesselFailM3Name = ( SELECT [Serial] +', ' FROM @currentData WHERE m3 >=@Lim AND ItemVal<=@Lim AND m1<=@Lim AND m2<=@Lim FOR XML PATH (''))
                       SET @VesselFailM3Name = ( SUBSTRING(@VesselFailM3Name, 1,len(@VesselFailM3Name)-1) )

                       SET @VesselFailNowCnt = CASE WHEN @VesselFailNowCnt IS NULL THEN 0  ELSE @VesselFailNowCnt END
                       SET @VesselFailM1Cnt = CASE WHEN @VesselFailM1Cnt IS NULL THEN 0  ELSE @VesselFailM1Cnt END
                       SET @VesselFailM2Cnt = CASE WHEN @VesselFailM2Cnt IS NULL THEN 0  ELSE @VesselFailM2Cnt END
                       SET @VesselFailM3Cnt = CASE WHEN @VesselFailM3Cnt IS NULL THEN 0  ELSE @VesselFailM3Cnt END

                       SET @VesselFailTotal = @VesselFailNowCnt + @VesselFailM1Cnt + @VesselFailM2Cnt+ @VesselFailM3Cnt
                       /*====================================================== Общая фраза в письмо ============================================================================*/
                       SET @VesselFailReserveNote = (
                           SELECT CASE
                           /*Когда ок, без резерва*/
                             WHEN @VesselFailTotal = 0 AND @VesselReserveCnt IS NULL
                             THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга не обнаружено критического лимита эксплуатации в ' 
                                         + CAST(@Lim as nvarchar(50)) + ' поджигов, но резерв сосудов <b>отсутствует</b>.<br>'
                                         +'Рекомендуется восполнить резерв на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'.'
                           /*Когда ок, маленький резерв*/
                           WHEN @VesselFailTotal = 0 AND @VesselReserveCnt < @InReserve
                           THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга не обнаружено критического лимита эксплуатации в ' 
                                         + CAST(@Lim as nvarchar(50)) + ' поджигов, однако имеющийся резерв ('
                                         + CAST(@VesselReserveCnt as nvarchar(50) )+') <b>меньше</b> установленного ('+ CAST(@InReserve as nvarchar(50) )+').<br>'
                                         +'Рекомендуется восполнить резерв на следующее количество: ' + CAST(@InReserve-@VesselReserveCnt as nvarchar(50) )+'.'
                           /*Когда ок*/
                           WHEN @VesselFailTotal = 0 and @VesselReserveCnt >= @InReserve
                           THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга не обнаружено критического лимита эксплуатации в ' 
                                         + CAST(@Lim as nvarchar(50)) + ' поджигов. Имеющиеся резервы ('
                                         + CAST(@VesselReserveCnt as nvarchar(50) )+') достаточны.'
                           /*Когда покрывают*/
                           WHEN @VesselFailTotal <> 0 AND @VesselReserveCnt >= @VesselFailTotal
                           THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга обнаружены <b>превышения</b> критического лимита эксплуатации в ' 
                                         + CAST(@Lim as nvarchar(50) )+ ' поджигов. Имеющиеся резервы ('+ CAST(@VesselReserveCnt as nvarchar(50) )+') покрывают требуемые замены ('
                                         + CAST( @VesselFailTotal as nvarchar(50))+'). Анализ, созданный системой мониторинга на основании данных за прошлые периоды:'
                           /*Когда не покрывают*/
                             WHEN @VesselFailTotal <> 0 and @VesselReserveCnt <= @VesselFailTotal
                             THEN 'Для сосудов "'+ @TypeVessel+'" в ближайшие 3 месяца системой мониторинга обнаружены <b>превышения</b> критического лимита эксплуатации в ' 
                                         + CAST(@Lim as nvarchar(50) )+ ' поджигов. Имеющиеся резервы ('+ CAST(@InReserve as nvarchar(50) )+') не покрывают требуемые замены ('
                                         + CAST( @VesselFailTotal as nvarchar(50))+'). Анализ, созданный системой мониторинга на основании данных за прошлые периоды:'
                           /*Когда беда с резервом*/
                           WHEN @VesselFailTotal <> 0  AND @VesselReserveCnt is null
                           THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга обнаружены <b>превышения</b> критического лимита эксплуатации в ' 
                                         + CAST(@Lim as nvarchar(50) )+ ' поджигов, однако резерв сосудов <b>отсутствует</b>. Анализ, созданный системой мониторинга на основании данных за прошлые периоды:' 
                             END )
                             /*==================================================== Детали анализа ======================================================================================*/
                             /*======================================================== Сейчас ==========================================================================================*/
                           SET @VesselFailNowNote = ( SELECT 
                            /*Когда покрывают*/
                             CASE WHEN @VesselFailNowCnt <> 0 AND @VesselFailNowCnt<= @VesselReserveCnt  THEN 
                                         'В данный момент требуется замена для S/N: ' +@VesselFailNowName + '.<br>'
                                         +'Имеющиеся резервы покрывают требуемые замены ('+ CAST( @VesselFailNowCnt as nvarchar(50))+').<br>'
                                         + 'После замены резерв сосудов будет равен: ' + CAST(@VesselReserveCnt-@VesselFailNowCnt as nvarchar(50) ) +'.<br>'
                                         + '<ul>Для безопасной работы в данный момент требуется: '
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve-(@VesselReserveCnt-@VesselFailNowCnt) as nvarchar(50) )+'</li></ul>'
                             /*Когда не покрывают*/
                             ELSE CASE WHEN  @VesselFailNowCnt <> 0 AND @VesselFailNowCnt > @VesselReserveCnt THEN 
                                         'В данный момент требуется замена для S/N: ' +@VesselFailNowName + '.<br>'
                                         +'Имеющиеся резервы не покрывают требуемые замены ('+ CAST( @VesselFailNowCnt as nvarchar(50))+').<br>'
                                         + '<ul>Для безопасной работы в данный момент требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' + CAST(@VesselFailNowCnt-@VesselReserveCnt as nvarchar(50) ) +'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
                             /*Когда с резервом беда*/
                             ELSE CASE WHEN  @VesselFailNowCnt <> 0 AND @VesselReserveCnt IS NULL  THEN 
                                         'В данный момент требуется замена для S/N: ' +@VesselFailNowName + '.<br>'
                                         +'Отсутствующие резервы не покрывают требуемые замены ('+ CAST( @VesselFailNowCnt as nvarchar(50))+').<br>'
                                         + '<ul>Для безопасной работы в данный момент требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' + CAST(@VesselFailNowCnt as nvarchar(50) ) +'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
                             END END END
                             )
                             /*======================================================= Через месяц ==================================================================================*/
                             /*Когда покрывают*/
                             SET @VesselFailM1Note  = ( SELECT
                             CASE WHEN @VesselFailM1Cnt <> 0 AND @VesselFailM1Cnt + @VesselFailNowCnt <= @VesselReserveCnt THEN 
                                         'Через 1 месяц потребуется замена для S/N: ' +@VesselFailM1Name + '.<br>' 
                                         +'Имеющиеся сейчас резервы покрывают смоделированные через 1 месяц замены, с учётом текущей ситуации.<br>'
                                         + 'После замены резерв сосудов через 1 месяц будет равен: ' + CAST(@VesselReserveCnt-@VesselFailM1Cnt-@VesselFailNowCnt as nvarchar(50) ) +'.<br>'
                                         + '<ul>Для безопасной работы через 1 месяц требуется:'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve-(@VesselReserveCnt-@VesselFailM1Cnt-@VesselFailNowCnt) as nvarchar(50) )+'.</li></ul>'
                             /*Когда не покрывают*/
                              ELSE CASE WHEN  @VesselFailM1Cnt <> 0 AND @VesselFailM1Cnt+@VesselFailNowCnt>@VesselReserveCnt THEN 
                                         'Через 1 месяц потребуется замена для S/N: ' +@VesselFailM1Name +'.<br>' 
                                         +'Имеющиеся сейчас резервы не покрывают смоделированные через 1 месяц замены, с учётом текущей ситуации.<br>'
                                         + '<ul>Для безопасной работы через 1 месяц требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' + CAST(@VesselFailM1Cnt as nvarchar(50) ) +'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'.</li></ul>'
                              /*Когда с резервом беда*/
                              ELSE CASE WHEN  @VesselFailM1Cnt <> 0 AND @VesselReserveCnt IS NULL THEN 
                                         'Через 1 месяц потребуется замена для S/N: ' +@VesselFailM1Name +'.<br>' 
                                         +'Отсутствующие резервы не покрывают смоделированные через 1 месяц замены, с учётом текущей ситуации.<br>'
                                         + '<ul>Для безопасной работы через 1 месяц требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' + CAST(@VesselFailM1Cnt as nvarchar(50) ) +'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'.</li></ul>'
                             END END END 
                             )
                             /*========================================================= Через 2 месяца =============================================================================*/
                                  /*Когда покрывают*/
                             SET @VesselFailM2Note = ( SELECT 
                                    CASE WHEN @VesselFailM2Cnt <> 0 AND @VesselFailM2Cnt + @VesselFailM1Cnt + @VesselFailNowCnt <= @VesselReserveCnt THEN 
                                         'Через 2 месяца потребуется замена для S/N: ' +@VesselFailM2Name + '.<br>' 
                                         +'Имеющиеся сейчас резервы покрывают смоделированные через 2 месяца замены, с учётом ситуаций за прошлые периоды. <br>'
                                         + 'После замены резерв сосудов через 2 месяца будет равен: ' + CAST(@VesselReserveCnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt as nvarchar(50) ) +'. '
                                         + '<ul>Для безопасной работы через 2 месяца требуется:'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' 
                                         + CAST(@InReserve-(@VesselReserveCnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt) as nvarchar(50) ) +'</li></ul>'
                             /*Когда не покрывают*/
                              ELSE CASE WHEN  @VesselFailM2Cnt <> 0 AND @VesselFailM2Cnt+@VesselFailM1Cnt+@VesselFailNowCnt>@VesselReserveCnt  THEN 
                                         'Через 2 месяца потребуется замена для S/N: ' +@VesselFailM2Name +'.<br>' 
                                         +'Имеющиеся сейчас резервы не покрывают смоделированные через 2 месяца замены, с учётом ситуаций за прошлые периоды.<br>'
                                         + '<ul>Для безопасной работы через 2 месяца требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' + 
                                         CASE when @VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt)<0 then CAST(@VesselFailM2Cnt as nvarchar(50)) else
                                         CAST(@VesselFailM2Cnt - (@VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt)) as nvarchar(50) ) end+'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
                             /*Когда с резервом беда*/
                              ELSE CASE WHEN  @VesselFailM2Cnt <> 0 AND @VesselReserveCnt IS NULL THEN 
                                         'Через 2 месяца потребуется замена для S/N: ' +@VesselFailM2Name +'.<br>' 
                                         +'Отсутствующие резервы не покрывают смоделированные через 2 месяца замены, с учётом ситуаций за прошлые периоды.<br>'
                                         + '<ul>Для безопасной работы через 2 месяца требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' + CAST(@VesselFailM2Cnt as nvarchar(50) ) +'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
                             END END END 
                             )
                             /*======================================================== Через 3 месяца ==========================================================================*/
                           /*Когда покрывают*/
                                  SET @VesselFailM3Note = ( SELECT 
                             CASE WHEN @VesselFailM3Cnt <> 0 AND @VesselFailM3Cnt+@VesselFailM2Cnt + @VesselFailM1Cnt + @VesselFailNowCnt <= @VesselReserveCnt THEN 
                                         'Через 3 месяца потребуется замена для S/N: ' +@VesselFailM3Name + '.<br>' 
                                         +'Имеющиеся сейчас резервы покрывают смоделированные через 3 месяца замены, с учётом ситуаций за прошлые периоды.<br>'
                                         + 'После замены резерв сосудов через 3 месяца будет равен: ' 
                                         + CAST(@VesselReserveCnt-@VesselFailM3Cnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt as nvarchar(50) ) +'. '
                                         + '<ul>Для безопасной работы через 3 месяца требуется:'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' 
                                         + CAST(@InReserve-(@VesselReserveCnt-@VesselFailM3Cnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt) as nvarchar(50) ) +'</li></ul>'
                             /*Когда не покрывают*/
                              ELSE CASE WHEN  @VesselFailM3Cnt <> 0 AND @VesselFailM3Cnt+@VesselFailM2Cnt+@VesselFailM1Cnt+@VesselFailNowCnt>@VesselReserveCnt  THEN 
                                         'Через 3 месяца потребуется замена для S/N: ' +@VesselFailM3Name +'.<br>' 
                                         +'Имеющиеся сейчас резервы не покрывают смоделированные через 3 месяца замены, с учётом ситуаций за прошлые периоды.<br>'
                                         + '<ul>Для безопасной работы через 3 месяца требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' 
                                         + CASE WHEN @VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt+@VesselFailM2Cnt)<0 THEN CAST(@VesselFailM3Cnt as nvarchar(50)) ELSE
                                         CAST(@VesselFailM3Cnt - (@VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt+@VesselFailM2Cnt)) as nvarchar(50) ) END+'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
                             /*Когда с резервом беда*/
                              ELSE CASE WHEN  @VesselFailM3Cnt <> 0 AND @VesselReserveCnt IS NULL THEN
                                         'Через 3 месяца потребуется замена для S/N: ' +@VesselFailM3Name +'<br>' 
                                         +'Отсутствующие резервы не покрывают смоделированные через 3 месяца замены, с учётом ситуаций за прошлые периоды.<br>'
                                         + '<ul>Для безопасной работы через 3 месяца требуется:'
                                         + '<li>Найти замену для сосудов вне резеров в количестве: ' + CAST(@VesselFailM3Cnt as nvarchar(50) ) +'</li>'
                                         + '<li>Восполнить резерв сосудов на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
                             END END END 
                             )
                           /*===================================================== Подготавливаем к вставке в письмо ============================================================*/
                     SET @VesselFailReserveNote = ( SELECT CASE WHEN @VesselFailReserveNote IS NULL THEN '' ELSE @VesselFailReserveNote+'<br>' END )
                     SET @VesselFailNowNote = ( SELECT CASE WHEN @VesselFailNowNote IS NULL THEN '' ELSE '<h3>Анализ текущей ситуации</h3>'+@VesselFailNowNote+'<br>' END )
                     SET @VesselFailM1Note = ( SELECT CASE WHEN @VesselFailM1Note IS NULL THEN '' ELSE '<h3>Модель ситуации через 1 месяц</h3>'+@VesselFailM1Note+'<br>' END )
                     SET @VesselFailM2Note = ( SELECT CASE WHEN @VesselFailM2Note IS NULL THEN '' ELSE '<h3>Модель ситуации через 2 месяца</h3>'+@VesselFailM2Note+'<br>' END )
                     SET @VesselFailM3Note = ( SELECT CASE WHEN @VesselFailM3Note IS NULL THEN '' ELSE '<h3>Модель ситуации через 3 месяца</h3>'+@VesselFailM3Note+'<br>' END )
              END/*Когда есть максимумы*/
              ELSE
              BEGIN
                     SET @VesselFailReserveNote = ( SELECT CASE WHEN @VesselFailReserveNote IS NULL THEN '' ELSE ''+'<br>' END )
                     SET @VesselFailNowNote = ( SELECT CASE WHEN @VesselFailNowNote IS NULL THEN '<h3>К сожалению, в данный момент недостаточно данных для анализа :(</h3>' ELSE '' END )
                     SET @VesselFailM1Note = ( SELECT CASE WHEN @VesselFailM1Note IS NULL THEN '' ELSE '' END )
                     SET @VesselFailM2Note = ( SELECT CASE WHEN @VesselFailM2Note IS NULL THEN '' ELSE '' END )
                     SET @VesselFailM3Note = ( SELECT CASE WHEN @VesselFailM3Note IS NULL THEN '' ELSE '' END )
              END/*Когда есть максимумы*/
              SET @MailFrom = 'Rucoalsu.Novokuznetsk@sgs.com'

              SET @CityName = (SELECT [CityName] FROM [LabProtocols].[dbo].[Ent_Laboratories] WHERE [LabCode] = @Lbcd )

              SET @MailTo = ( SELECT [To] FROM [LabProtocols].[dbo].[Ent_MailOrderSettings] WHERE [Lab] = @CityName AND [ReportType]='VesselMonitoring' )
                           
              SET @MailCC = ( SELECT [CC] FROM [LabProtocols].[dbo].[Ent_MailOrderSettings] WHERE [Lab] = @CityName AND [ReportType]='VesselMonitoring' )

              SET @MailHeader = @CityName +' '+@TypeVessel+' VesselMonitoring Estimates'

              SET @txtMail = @VesselFailReserveNote + @VesselFailNowNote + @VesselFailM1Note + @VesselFailM2Note + @VesselFailM3Note
              SET @txtMail = @txtMail+'<hr><i>Обратите внимание, система мониторинга считает резервом сосуды, имеющие накопительно менее <b>1000</b> поджигов, вне зависимости от типа.</i>'
              SET @txtMail = @txtMail+'<br>Нужно больше деталей? Посетите <a href="'+@Link+'">cервис</a></span> мониторинга сосудов.'

              IF ( @txtMail IS NOT NULL )
              BEGIN
                INSERT INTO /*VesselMonitoring_Estimates, GetDate()*/ [RUWS002].[AllVostok].[dbo].[DB_Settings_SendMail]
                     ([id]
                     ,[applicationid]
                     ,[from]
                     ,[to]
                     ,[cc]
                     ,[subject]
                     ,[body]
                     ,[retries]
                     ,[Attachments]
                     ,[issent]
                     ,[iserror]
                     ,[isworking]
                     ,[isdone])
                VALUES      
                     (NEWID()
                     ,'LabOrder'
                     ,@MailFrom
                     ,@MailTo
                     ,@MailCC
                     ,@MailHeader
                     ,'<div>'+@txtMail+'</div>'
                     ,'2'
                     ,''
                     ,'False'
                     ,'False'
                     ,'False'
                     ,'False' );
              END

         DELETE FROM @currentData;
         SET @VesselFailTotal = NULL
         SET @counter = @counter + 1

       END /*Конец цикла прогнозов*/

       RETURN @counter;

END



GO


