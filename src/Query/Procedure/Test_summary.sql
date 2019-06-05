
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
SET @TypeVessel = '��� 1 - IKA C5010';
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
/*MEMO: ��� ����� ��� NULL*/
SET @VesselReserveCnt = 1


	   SET @VesselFailReserveNote = (
	SELECT CASE 
	  WHEN @VesselFailTotal = 0 AND @VesselReserveCnt IS NULL
	  THEN '��� ������� "'+ @TypeVessel+'", �������� ������, � ��������� 3 ������ �������� ����������� �� ���������� ������������ ������ ������������ � ' 
			+ CAST(@Lim as nvarchar(50)) + ' ��������, �� ������ ������� <b>�����������</b>.<br>'
			+'������������� ���������� ������ �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'.'

	 WHEN @VesselFailTotal = 0 AND @VesselReserveCnt < @InReserve
	 THEN '��� ������� "'+ @TypeVessel+'", �������� ������, � ��������� 3 ������ �������� ����������� �� ���������� ������������ ������ ������������ � ' 
			+ CAST(@Lim as nvarchar(50)) + ' ��������, ������ ��������� ������ ('
			+ CAST(@VesselReserveCnt as nvarchar(50) )+') <b>������</b> �������������� ('+ CAST(@InReserve as nvarchar(50) )+').<br>'
			+'������������� ���������� ������ �� ��������� ����������: ' + CAST(@InReserve-@VesselReserveCnt as nvarchar(50) )+'.'
	 WHEN @VesselFailTotal = 0 and @VesselReserveCnt >= @InReserve
	 THEN '��� ������� "'+ @TypeVessel+'", �������� ������, � ��������� 3 ������ �������� ����������� �� ���������� ������������ ������ ������������ � ' 
			+ CAST(@Lim as nvarchar(50)) + ' ��������. ��������� ������� ('
			+ CAST(@VesselReserveCnt as nvarchar(50) )+') ����������.'

	 WHEN @VesselFailTotal <> 0 AND @VesselReserveCnt >= @VesselFailTotal
	 THEN '��� ������� "'+ @TypeVessel+'", �������� ������, � ��������� 3 ������ �������� ����������� ���������� <b>����������</b> ������������ ������ ������������ � ' 
			+ CAST(@Lim as nvarchar(50) )+ ' ��������. ��������� ������� ('+ CAST(@VesselReserveCnt as nvarchar(50) )+') ��������� ��������� ������ ('
			+ CAST( @VesselFailTotal as nvarchar(50))+'). ������, ��������� �������� ����������� �� ��������� ������ �� ������� �������:' 

	 WHEN @VesselFailTotal <> 0  AND @VesselReserveCnt is null
	 THEN '��� ������� "'+ @TypeVessel+'", �������� ������, � ��������� 3 ������ �������� ����������� ���������� <b>����������</b> ������������ ������ ������������ � ' 
			+ CAST(@Lim as nvarchar(50) )+ ' ��������, ������ ������ ������� <b>�����������</b>. ������, ��������� �������� ����������� �� ��������� ������ �� ������� �������:' 

	  WHEN @VesselFailTotal <> 0 and @VesselReserveCnt <= @VesselFailTotal
	  THEN '��� ������� "'+ @TypeVessel+'" � ��������� 3 ������ �������� ����������� ���������� <b>����������</b> ������������ ������ ������������ � ' 
			+ CAST(@Lim as nvarchar(50) )+ ' ��������. ��������� ������� ('+ CAST(@InReserve as nvarchar(50) )+') �� ��������� ��������� ������ ('
			+ CAST( @VesselFailTotal as nvarchar(50))+'). ������, ��������� �������� ����������� �� ��������� ������ �� ������� �������:'
	  END )
	  /*============================= ������ =======================*/
	  /*����� ���������*/
	SET @VesselFailNowNote = ( SELECT 

	  CASE WHEN @VesselFailNowCnt <> 0 AND @VesselFailNowCnt<= @VesselReserveCnt  THEN 
			'� ������ ������ ��������� ������ ��� S/N: ' +@VesselFailNowName + '.<br>'
			+'��������� ������� ��������� ��������� ������ ('+ CAST( @VesselFailNowCnt as nvarchar(50))+').<br>'
			+ '����� ������ ������ ������� ����� �����: ' + CAST(@VesselReserveCnt-@VesselFailNowCnt as nvarchar(50) ) +'.<br>'
			+ '<ul>��� ���������� ������ � ������ ������ ���������: '
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve-(@VesselReserveCnt-@VesselFailNowCnt) as nvarchar(50) )+'</li></ul>'
	  /*����� �� ���������*/
	  ELSE CASE WHEN  @VesselFailNowCnt <> 0 AND @VesselFailNowCnt > @VesselReserveCnt THEN 
			'� ������ ������ ��������� ������ ��� S/N: ' +@VesselFailNowName + '.<br>'
			+'��������� ������� �� ��������� ��������� ������ ('+ CAST( @VesselFailNowCnt as nvarchar(50))+').<br>'
			+ '<ul>��� ���������� ������ � ������ ������ ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' + CAST(@VesselFailNowCnt-@VesselReserveCnt as nvarchar(50) ) +'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
	  /*����� � �������� ����*/
	  ELSE CASE WHEN  @VesselFailNowCnt <> 0 AND @VesselReserveCnt IS NULL  THEN 
			'� ������ ������ ��������� ������ ��� S/N: ' +@VesselFailNowName + '.<br>'
			+'������������� ������� �� ��������� ��������� ������ ('+ CAST( @VesselFailNowCnt as nvarchar(50))+').<br>'
			+ '<ul>��� ���������� ������ � ������ ������ ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' + CAST(@VesselFailNowCnt as nvarchar(50) ) +'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
	  END END END
	  )
	  /*============================= ����� ����� =======================*/
	  /*����� ���������*/

	  SET @VesselFailM1Note  = ( SELECT
	  CASE WHEN @VesselFailM1Cnt <> 0 AND @VesselFailM1Cnt + @VesselFailNowCnt <= @VesselReserveCnt THEN 
			'����� 1 ����� ����������� ������ ��� S/N: ' +@VesselFailM1Name + '.<br>' 
			+'��������� ������ ������� ��������� ��������������� ����� 1 ����� ������, � ������ ������� ��������.<br>'
			+ '����� ������ ������ ������� ����� 1 ����� ����� �����: ' + CAST(@VesselReserveCnt-@VesselFailM1Cnt-@VesselFailNowCnt as nvarchar(50) ) +'.<br>'
			+ '<ul>��� ���������� ������ ����� 1 ����� ���������:'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve-(@VesselReserveCnt-@VesselFailM1Cnt-@VesselFailNowCnt) as nvarchar(50) )+'.</li></ul>'
	  /*����� �� ���������*/
	   ELSE CASE WHEN  @VesselFailM1Cnt <> 0 AND @VesselFailM1Cnt+@VesselFailNowCnt>@VesselReserveCnt THEN 
			'����� 1 ����� ����������� ������ ��� S/N: ' +@VesselFailM1Name +'.<br>' 
			+'��������� ������ ������� �� ��������� ��������������� ����� 1 ����� ������, � ������ ������� ��������.<br>'
			+ '<ul>��� ���������� ������ ����� 1 ����� ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' + CAST(@VesselFailM1Cnt as nvarchar(50) ) +'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'.</li></ul>'
	  /*����� � �������� ����*/
	   ELSE CASE WHEN  @VesselFailM1Cnt <> 0 AND @VesselReserveCnt IS NULL THEN 
			'����� 1 ����� ����������� ������ ��� S/N: ' +@VesselFailM1Name +'.<br>' 
			+'������������� ������� �� ��������� ��������������� ����� 1 ����� ������, � ������ ������� ��������.<br>'
			+ '<ul>��� ���������� ������ ����� 1 ����� ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' + CAST(@VesselFailM1Cnt as nvarchar(50) ) +'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'.</li></ul>'
	  END END END 
	  )
	  /*============================= ����� 2 ������ =======================*/
	  	/*����� ���������*/
	  SET @VesselFailM2Note = ( SELECT 
	  	  CASE WHEN @VesselFailM2Cnt <> 0 AND @VesselFailM2Cnt + @VesselFailM1Cnt + @VesselFailNowCnt <= @VesselReserveCnt THEN 
			'����� 2 ������ ����������� ������ ��� S/N: ' +@VesselFailM2Name + '.<br>' 
			+'��������� ������ ������� ��������� ��������������� ����� 2 ������ ������, � ������ �������� �� ������� �������. <br>'
			+ '����� ������ ������ ������� ����� 2 ������ ����� �����: ' + CAST(@VesselReserveCnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt as nvarchar(50) ) +'. '
			+ '<ul>��� ���������� ������ ����� 2 ������ ���������:'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' 
			+ CAST(@InReserve-(@VesselReserveCnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt) as nvarchar(50) ) +'</li></ul>'
	  /*����� �� ���������*/
	   ELSE CASE WHEN  @VesselFailM2Cnt <> 0 AND @VesselFailM2Cnt+@VesselFailM1Cnt+@VesselFailNowCnt>@VesselReserveCnt  THEN 
	   		'����� 2 ������ ����������� ������ ��� S/N: ' +@VesselFailM2Name +'.<br>' 
			+'��������� ������ ������� �� ��������� ��������������� ����� 2 ������ ������, � ������ �������� �� ������� �������.<br>'
			+ '<ul>��� ���������� ������ ����� 2 ������ ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' + 
			CASE when @VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt)<0 then CAST(@VesselFailM2Cnt as nvarchar(50)) else
			CAST(@VesselFailM2Cnt - (@VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt)) as nvarchar(50) ) end+'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
	  /*����� � �������� ����*/
	   ELSE CASE WHEN  @VesselFailM2Cnt <> 0 AND @VesselReserveCnt IS NULL THEN 
	   		'����� 2 ������ ����������� ������ ��� S/N: ' +@VesselFailM2Name +'.<br>' 
			+'������������� ������� �� ��������� ��������������� ����� 2 ������ ������, � ������ �������� �� ������� �������.<br>'
			+ '<ul>��� ���������� ������ ����� 2 ������ ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' + CAST(@VesselFailM2Cnt as nvarchar(50) ) +'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
	  END END END 
	  )
	  /*============================= ����� 3 ������ =======================*/
	/*����� ���������*/
		SET @VesselFailM3Note = ( SELECT 
	  CASE WHEN @VesselFailM3Cnt <> 0 AND @VesselFailM3Cnt+@VesselFailM2Cnt + @VesselFailM1Cnt + @VesselFailNowCnt <= @VesselReserveCnt THEN 
			'����� 3 ������ ����������� ������ ��� S/N: ' +@VesselFailM3Name + '.<br>' 
			+'��������� ������ ������� ��������� ��������������� ����� 3 ������ ������, � ������ �������� �� ������� �������.<br>'
			+ '����� ������ ������ ������� ����� 3 ������ ����� �����: ' 
			+ CAST(@VesselReserveCnt-@VesselFailM3Cnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt as nvarchar(50) ) +'. '
			+ '<ul>��� ���������� ������ ����� 3 ������ ���������:'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' 
			+ CAST(@InReserve-(@VesselReserveCnt-@VesselFailM3Cnt-@VesselFailM2Cnt-@VesselFailM1Cnt-@VesselFailNowCnt) as nvarchar(50) ) +'</li></ul>'
	  /*����� �� ���������*/
	   ELSE CASE WHEN  @VesselFailM3Cnt <> 0 AND @VesselFailM3Cnt+@VesselFailM2Cnt+@VesselFailM1Cnt+@VesselFailNowCnt>@VesselReserveCnt  THEN 
	   		'����� 3 ������ ����������� ������ ��� S/N: ' +@VesselFailM3Name +'.<br>' 
			+'��������� ������ ������� �� ��������� ��������������� ����� 3 ������ ������, � ������ �������� �� ������� �������.<br>'
			+ '<ul>��� ���������� ������ ����� 3 ������ ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' 
			+ CASE WHEN @VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt+@VesselFailM2Cnt)<0 THEN CAST(@VesselFailM3Cnt as nvarchar(50)) ELSE
			CAST(@VesselFailM3Cnt - (@VesselReserveCnt - (@VesselFailNowCnt+@VesselFailM1Cnt+@VesselFailM2Cnt)) as nvarchar(50) ) END+'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
	  /*����� � �������� ����*/
	   ELSE CASE WHEN  @VesselFailM3Cnt <> 0 AND @VesselReserveCnt IS NULL THEN
	   		'����� 3 ������ ����������� ������ ��� S/N: ' +@VesselFailM3Name +'<br>' 
			+'������������� ������� �� ��������� ��������������� ����� 3 ������ ������, � ������ �������� �� ������� �������.<br>'
			+ '<ul>��� ���������� ������ ����� 3 ������ ���������:'
			+ '<li>����� ������ ��� ������� ��� ������� � ����������: ' + CAST(@VesselFailM3Cnt as nvarchar(50) ) +'</li>'
			+ '<li>���������� ������ ������� �� ��������� ����������: ' + CAST(@InReserve as nvarchar(50) )+'</li></ul>'
	  END END END 
	  )
	/*============================= �������������� � ������� � ������ =======================*/
	  SET @VesselFailReserveNote = ( SELECT CASE WHEN @VesselFailReserveNote IS NULL THEN '' ELSE @VesselFailReserveNote+'<br>' END )
	  SET @VesselFailNowNote = ( SELECT CASE WHEN @VesselFailNowNote IS NULL THEN '' ELSE '<h3>������ ������� ��������</h3>'+@VesselFailNowNote+'<br>' END )
	  SET @VesselFailM1Note = ( SELECT CASE WHEN @VesselFailM1Note IS NULL THEN '' ELSE '<h3>������ �������� ����� 1 �����</h3>'+@VesselFailM1Note+'<br>' END )
	  SET @VesselFailM2Note = ( SELECT CASE WHEN @VesselFailM2Note IS NULL THEN '' ELSE '<h3>������ �������� ����� 2 ������</h3>'+@VesselFailM2Note+'<br>' END )
	  SET @VesselFailM3Note = ( SELECT CASE WHEN @VesselFailM3Note IS NULL THEN '' ELSE '<h3>������ �������� ����� 3 ������</h3>'+@VesselFailM3Note+'<br>' END )


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