
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

DECLARE @TypeVessel nvarchar (max);
DECLARE @Lim int
DECLARE @InReserve int;

DECLARE @VesselFailReserveNote nvarchar (max);
DECLARE @VesselFailNowNote nvarchar (max);
DECLARE @VesselFailM1Note nvarchar (max);
DECLARE @VesselFailM2Note nvarchar (max);
DECLARE @VesselFailM3Note nvarchar (max);

/*Design*/
SET @TypeVessel = 'Тип 1 - IKA C5010';
SET @Lim = 10000
/**/
SET @InReserve = 4;
SET @VesselFailNowCnt = 1;
SET @VesselFailM1Cnt = 2
SET @VesselFailM2Cnt = 2
SET @VesselFailM3Cnt = 4
SET @VesselFailTotal = @VesselFailNowCnt+@VesselFailM1Cnt+@VesselFailM2Cnt+@VesselFailM3Cnt
SET @VesselFailNowName = 'NAME'
SET @VesselFailM1Name= 'M1 NAME'
SET @VesselFailM2Name= 'M2 NAME'
SET @VesselFailM3Name= 'M3 NAME'
/*MEMO: Или число или NULL*/
SET @VesselReserveCnt = 1


	   SET @VesselFailReserveNote = (
	SELECT CASE 
	  WHEN @VesselFailTotal = 0 AND @VesselReserveCnt IS NULL
	  THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга не обнаружено критического лимита эксплуатации в ' 
			+ CAST(@Lim as nvarchar(50)) + ' поджигов, но резерв сосудов <b>отсутствует</b>.<br>'
			+'Рекомендуется восполнить резерв на следующее количество: ' + CAST(@InReserve as nvarchar(50) )+'.'

	 WHEN @VesselFailTotal = 0 AND @VesselReserveCnt < @InReserve
	 THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга не обнаружено критического лимита эксплуатации в ' 
			+ CAST(@Lim as nvarchar(50)) + ' поджигов, однако имеющийся резерв ('
			+ CAST(@VesselReserveCnt as nvarchar(50) )+') <b>меньше</b> установленного ('+ CAST(@InReserve as nvarchar(50) )+').<br>'
			+'Рекомендуется восполнить резерв на следующее количество: ' + CAST(@InReserve-@VesselReserveCnt as nvarchar(50) )+'.'
	 WHEN @VesselFailTotal = 0 and @VesselReserveCnt >= @InReserve
	 THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга не обнаружено критического лимита эксплуатации в ' 
			+ CAST(@Lim as nvarchar(50)) + ' поджигов. Имеющиеся резервы ('
			+ CAST(@VesselReserveCnt as nvarchar(50) )+') достаточны.'

	 WHEN @VesselFailTotal <> 0 AND @VesselReserveCnt >= @VesselFailTotal
	 THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга обнаружены <b>превышения</b> критического лимита эксплуатации в ' 
			+ CAST(@Lim as nvarchar(50) )+ ' поджигов. Имеющиеся резервы ('+ CAST(@VesselReserveCnt as nvarchar(50) )+') покрывают требуемые замены ('
			+ CAST( @VesselFailTotal as nvarchar(50))+'). Анализ, созданный системой мониторинга на основании данных за прошлые периоды:' 

	 WHEN @VesselFailTotal <> 0  AND @VesselReserveCnt is null
	 THEN 'Для сосудов "'+ @TypeVessel+'", согласно модели, в ближайшие 3 месяца системой мониторинга обнаружены <b>превышения</b> критического лимита эксплуатации в ' 
			+ CAST(@Lim as nvarchar(50) )+ ' поджигов, однако резерв сосудов <b>отсутствует</b>. Анализ, созданный системой мониторинга на основании данных за прошлые периоды:' 

	  WHEN @VesselFailTotal <> 0 and @VesselReserveCnt <= @VesselFailTotal
	  THEN 'Для сосудов "'+ @TypeVessel+'" в ближайшие 3 месяца системой мониторинга обнаружены <b>превышения</b> критического лимита эксплуатации в ' 
			+ CAST(@Lim as nvarchar(50) )+ ' поджигов. Имеющиеся резервы ('+ CAST(@InReserve as nvarchar(50) )+') не покрывают требуемые замены ('
			+ CAST( @VesselFailTotal as nvarchar(50))+'). Анализ, созданный системой мониторинга на основании данных за прошлые периоды:'
	  END )
	  /*============================= Сейчас =======================*/
	  /*Когда покрывают*/
	SET @VesselFailNowNote = ( SELECT 

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
	  /*============================= Через месяц =======================*/
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
	  /*============================= Через 2 месяца =======================*/
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
	  /*============================= Через 3 месяца =======================*/
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
	/*============================= Подготавливаем к вставке в письмо =======================*/
	  SET @VesselFailReserveNote = ( SELECT CASE WHEN @VesselFailReserveNote IS NULL THEN '' ELSE @VesselFailReserveNote+'<br>' END )
	  SET @VesselFailNowNote = ( SELECT CASE WHEN @VesselFailNowNote IS NULL THEN '' ELSE '<h3>Анализ текущей ситуации</h3>'+@VesselFailNowNote+'<br>' END )
	  SET @VesselFailM1Note = ( SELECT CASE WHEN @VesselFailM1Note IS NULL THEN '' ELSE '<h3>Модель ситуации через 1 месяц</h3>'+@VesselFailM1Note+'<br>' END )
	  SET @VesselFailM2Note = ( SELECT CASE WHEN @VesselFailM2Note IS NULL THEN '' ELSE '<h3>Модель ситуации через 2 месяца</h3>'+@VesselFailM2Note+'<br>' END )
	  SET @VesselFailM3Note = ( SELECT CASE WHEN @VesselFailM3Note IS NULL THEN '' ELSE '<h3>Модель ситуации через 3 месяца</h3>'+@VesselFailM3Note+'<br>' END )


SELECT @VesselFailNowCnt AS VesselFailNowCnt
	  ,@VesselFailM1Cnt AS VesselFailM1Cnt
	  ,@VesselFailM2Cnt AS VesselFailM2Cnt
	  ,@VesselFailM3Cnt AS VesselFailM3Cnt
	  ,@VesselReserveCnt as VesselReserveCnt
	  ,@VesselFailTotal as VesselFailTotal
	  ,@VesselFailReserveNote AS VesselFailReserveNote
	  ,@VesselFailNowNote AS VesselFailNowNote
	  ,@VesselFailM1Note AS VesselFailM1Note
	  ,@VesselFailM2Note AS VesselFailM2Note
	  ,@VesselFailM3Note AS VesselFailM3Note