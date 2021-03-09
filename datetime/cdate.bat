:: convert (Y-M-D h:m:s) to C 4-byte date (number of calendar seconds since 1970-01-01)
setlocal

:: remove leading zeros
for /f "tokens=* delims=0" %%A in ("%~1") do set year=%%A
for /f "tokens=* delims=0" %%A in ("%~2") do set month=%%A
for /f "tokens=* delims=0" %%A in ("%~3") do set day=%%A
for /f "tokens=* delims=0" %%A in ("%~4") do set hour=%%A
for /f "tokens=* delims=0" %%A in ("%~5") do set minute=%%A
for /f "tokens=* delims=0" %%A in ("%~6") do set second=%%A

:: use simple "%4" for detecting leap years, do not count "%400 || !%100" since those years are not in the range 1970..2038 (2000 is leap already)
::year        common years + leap years
set /a cdate=(year-1970)*365 + (year-1969)/4
::month         30 day    +   30/31  -   2 for Feb   +  31,31/30 for Aug   +   29th of Feb if leap year
set /a cdate+=(month - 1)*30 + (month / 2) - 2*((month+9)/12) + (month / 9)*(month %% 2)  +  ((4 - year %% 4)/4) * ((month+9)/12)
::day
set /a cdate+=day - 1
::hour
set /a cdate=cdate*24 + hour
::minute
set /a cdate=cdate*60 + minute
::second
set /a cdate=cdate*60 + second

endlocal& set cdate=%cdate%
exit /b 0
