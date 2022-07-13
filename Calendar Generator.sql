/*=======================================================================*/
/*						Calendar table generator						 */
/*	This script generates a table containing the dates and day of weeks	 */
/*		for all dates between the @FromDate and @ToDate specified		 */
/*=======================================================================*/

/*Set Variables*/
Declare @FromDate Date = ''
Declare @ToDate Date = ''

--This will set the from date to the last 12 months if not otherwise specified
set @FromDate = ISNULL(NULLIF(@FromDate,''),Dateadd(Month,-12,GETDATE()))
set @ToDate = ISNULL(NULLIF(@ToDate,''),GETDATE())

/*Drop table if it exists*/
If Object_ID('Calendar','U') is not NULL
	Drop table Calendar;

/*Create table*/
Create Table Calendar 
(ID int Identity(1,1) Primary Key
,[Date] Date
,[DayOfWeek] Varchar(20))

/*Loop and add dates to calendar*/
While @FromDate <= @ToDate
Begin

	Insert Into Calendar 
	([Date],[DayOfWeek])
	Values(@FromDate,DateName(dw,@FromDate))

	--Increment date with one day
	set @FromDate = Dateadd(Day,1,@FromDate)

End

/*Select results*/
Select * 
from Calendar