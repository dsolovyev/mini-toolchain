setlocal
cd datetime
::month     1   2   3   4   5   6   7   8   9  10  11  12
::days     31  28  31  30  31  30  31  31  30  31  30  31
::days sum  0  31  59  90 120 151 181 212 243 273 304 334 365


rem months in 1970

setlocal& call .\cdate.bat 1970 1 1 0 0 0& echo on
set /a secs=24*60*60*0
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 2 1 0 0 0& echo on
set /a secs=24*60*60*31
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 3 1 0 0 0& echo on
set /a secs=24*60*60*59
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 4 1 0 0 0& echo on
set /a secs=24*60*60*90
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 5 1 0 0 0& echo on
set /a secs=24*60*60*120
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 6 1 0 0 0& echo on
set /a secs=24*60*60*151
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 7 1 0 0 0& echo on
set /a secs=24*60*60*181
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 8 1 0 0 0& echo on
set /a secs=24*60*60*212
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 9 1 0 0 0& echo on
set /a secs=24*60*60*243
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 10 1 0 0 0& echo on
set /a secs=24*60*60*273
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 11 1 0 0 0& echo on
set /a secs=24*60*60*304
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 12 1 0 0 0& echo on
set /a secs=24*60*60*334
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal


rem days in 1971

setlocal& call .\cdate.bat 1971 1 1 0 0 0& echo on
set /a secs=24*60*60*365
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1971 12 1 0 0 0& echo on
set /a secs=24*60*60*(365+334)
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1971 12 31 0 0 0& echo on
set /a secs=24*60*60*(365+364)
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal


rem days in 1972

setlocal& call .\cdate.bat 1972 1 1 0 0 0& echo on
set /a secs=24*60*60*730
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

rem 29 Feb 1972
setlocal& call .\cdate.bat 1972 3 1 0 0 0& echo on
set /a secs=24*60*60*(730+31+29)
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1973 1 1 0 0 0& echo on
set /a secs=24*60*60*(730+366)
if %cdate% neq %secs% echo ERROR: test failed>&2& exit /b 1
endlocal


rem units

setlocal& call .\cdate.bat 1970 1 1 0 0 1& echo on
if %cdate% neq 1 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 1 1 0 1 0& echo on
if %cdate% neq 60 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 1 1 1 0 0& echo on
if %cdate% neq 3600 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 1 2 0 0 0& echo on
if %cdate% neq 86400 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 1970 2 1 0 0 0& echo on
if %cdate% neq 2678400 echo ERROR: test failed>&2& exit /b 1
endlocal


rem miscellaneous

setlocal& call .\cdate.bat 2021 3 9 19 45 50& echo on
if %cdate% neq 1615319150 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 1 1 0 0 0& echo on
if %cdate% neq 1704067200 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 1 31 0 0 0& echo on
if %cdate% neq 1706659200 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 2 1 0 0 0& echo on
if %cdate% neq 1706745600 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 2 2 0 0 0& echo on
if %cdate% neq 1706832000 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 2 28 0 0 0& echo on
if %cdate% neq 1709078400 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 2 29 0 0 0& echo on
if %cdate% neq 1709164800 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 3 1 0 0 0& echo on
if %cdate% neq 1709251200 echo ERROR: test failed>&2& exit /b 1
endlocal


rem negative hour

setlocal& call .\cdate.bat 2024 2 29 21 0 0& echo on
set cdate_expected=%cdate%
echo off& call .\cdate.bat 2024 3 1 -3 0 0& echo on
if %cdate% neq %cdate_expected% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 2 28 22 0 0& echo on
set cdate_expected=%cdate%
echo off& call .\cdate.bat 2024 2 29 -2 0 0& echo on
if %cdate% neq %cdate_expected% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2023 12 31 19 0 0& echo on
set cdate_expected=%cdate%
echo off& call .\cdate.bat 2024 1 1 -5 0 0& echo on
if %cdate% neq %cdate_expected% echo ERROR: test failed>&2& exit /b 1
endlocal

rem negative minute

setlocal& call .\cdate.bat 2024 2 29 21 0 0& echo on
set cdate_expected=%cdate%
echo off& call .\cdate.bat 2024 3 1 0 -180 0& echo on
if %cdate% neq %cdate_expected% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2024 2 28 22 0 0& echo on
set cdate_expected=%cdate%
echo off& call .\cdate.bat 2024 2 29 0 -120 0& echo on
if %cdate% neq %cdate_expected% echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 2023 12 31 19 0 0& echo on
set cdate_expected=%cdate%
echo off& call .\cdate.bat 2024 1 1 0 -300 0& echo on
if %cdate% neq %cdate_expected% echo ERROR: test failed>&2& exit /b 1
endlocal

rem negative second

setlocal& call .\cdate.bat 2021 12 31 23 59 59& echo on
set cdate_expected=%cdate%
echo off& call .\cdate.bat 2022 1 1 0 0 -1& echo on
if %cdate% neq %cdate_expected% echo ERROR: test failed>&2& exit /b 1
endlocal


rem https://en.wikipedia.org/wiki/Year_2038_problem
rem INT_MAX
setlocal& call .\cdate.bat 2038 1 19 3 14 7& echo on
if %cdate% neq 2147483647 echo ERROR: test failed>&2& exit /b 1
endlocal

rem INT_MAX + 1 ==> INT_MIN
setlocal& call .\cdate.bat 2038 1 19 3 14 8& echo on
if %cdate% neq -2147483648 echo ERROR: test failed>&2& exit /b 1
endlocal

rem INT_MAX + 2 ==> INT_MIN+1
setlocal& call .\cdate.bat 2038 1 19 3 14 9& echo on
if %cdate% neq -2147483647 echo ERROR: test failed>&2& exit /b 1
endlocal


rem leading and trailing zeros

setlocal& call .\cdate.bat 02009 08 09 08 09 08& echo on
if %cdate% neq 1249805348 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 00002009 00008 0000009 00000008 000009 000008& echo on
if %cdate% neq 1249805348 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\cdate.bat 00002010 00010 0000030 00000020 000030 000050& echo on
if %cdate% neq 1288470650 echo ERROR: test failed>&2& exit /b 1
endlocal

echo cdate.test.bat: all tests passed
