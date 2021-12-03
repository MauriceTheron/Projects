Alter Procedure Split_String @Delimiter Varchar(20),@InputString Varchar(max)
as
Begin

	/*Get Delimiter count in string*/
	Declare @Delmiter_Count int
	Select @Delmiter_Count = Len(@InputString) - Len(Replace(@InputString,@Delimiter,''))

	/*Loop for each Delimiter*/
	Declare @Run int = 0
	Declare @Start int = 0

	/*Drop table if it exists*/
	If Object_ID('Tempdb..#Return_Rows','U') is not NULL
		Drop table #Return_Rows;

	Create Table #Return_Rows 
	(RunCnt int,FieldValue Varchar(max))

	While @Run <= @Delmiter_Count

	Begin

		If @Run <> @Delmiter_Count
		Begin
			Insert into #Return_Rows
			Select @Run,Left(@InputString,CHARINDEX(@Delimiter,@InputString)-1)
		End
		Else
		Begin
			Insert into #Return_Rows
			Select @Run,@InputString
		End

		set @InputString = Right(@InputString,Len(@InputString) - Len(Left(@InputString,CHARINDEX(@Delimiter,@InputString))))

		set @Run = @Run + 1

	End



	/*Get criteria for Dynamic Pivot*/

	Declare @PvtList Varchar(max) = ''

	Select @PvtList =	
			Case
				When RunCnt = 0
					Then @PvtList + '[' + Convert(Varchar(50),RunCnt) + ']'
				Else @PvtList + ',[' + Convert(Varchar(50),RunCnt) + ']'
			End
	from #Return_Rows


	/*Pivot Results to columns instead of Rows*/

	Exec ('
	Select *
	from (
		Select *
		from #Return_Rows
		) as Dta
	PIVOT
	(
	Max(FieldValue)
	For RunCnt
	 in (
			'+@PvtList+'
		)
	) PvtDta
	')

End