goto %~1

::month     1   2   3   4   5   6   7   8   9  10  11  12
::days     31  28  31  30  31  30  31  31  30  31  30  31
::days sum  0  31  59  90 120 151 181 212 243 273 304 334 365


rem months in 1970

:TEST_1970_jan_01_equals_0
    call "%~dp0cdate.bat" 1970 1 1 0 0 0
    if %cdate% neq 0 exit /b 1
exit /b 0

:TEST_1970_feb_01_equals_31_days
    call "%~dp0cdate.bat" 1970 2 1 0 0 0
    set /a secs=24*60*60*31
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_mar_01_equals_59_days
    call "%~dp0cdate.bat" 1970 3 1 0 0 0
    set /a secs=24*60*60*59
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_apr_01_equals_90_days
    call "%~dp0cdate.bat" 1970 4 1 0 0 0
    set /a secs=24*60*60*90
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_may_01_equals_120_days
    call "%~dp0cdate.bat" 1970 5 1 0 0 0
    set /a secs=24*60*60*120
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_jun_01_equals_151_days
    call "%~dp0cdate.bat" 1970 6 1 0 0 0
    set /a secs=24*60*60*151
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_jul_01_equals_181_days
    call "%~dp0cdate.bat" 1970 7 1 0 0 0
    set /a secs=24*60*60*181
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_aug_01_equals_212_days
    call "%~dp0cdate.bat" 1970 8 1 0 0 0
    set /a secs=24*60*60*212
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_sep_01_equals_243_days
    call "%~dp0cdate.bat" 1970 9 1 0 0 0
    set /a secs=24*60*60*243
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_oct_01_equals_273_days
    call "%~dp0cdate.bat" 1970 10 1 0 0 0
    set /a secs=24*60*60*273
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_nov_01_equals_304_days
    call "%~dp0cdate.bat" 1970 11 1 0 0 0
    set /a secs=24*60*60*304
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1970_dec_01_equals_334_days
    call "%~dp0cdate.bat" 1970 12 1 0 0 0
    set /a secs=24*60*60*334
    if %cdate% neq %secs% exit /b 1
exit /b 0


rem days in 1971

:TEST_1971_jan_01_equals_365_days
    call "%~dp0cdate.bat" 1971 1 1 0 0 0
    set /a secs=24*60*60*365
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1971_dec_01_equals_1y_and_334_days
    call "%~dp0cdate.bat" 1971 12 1 0 0 0
    set /a secs=24*60*60*(365+334)
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1971_dec_31_equals_1y_and_364_days
    call "%~dp0cdate.bat" 1971 12 31 0 0 0
    set /a secs=24*60*60*(365+364)
    if %cdate% neq %secs% exit /b 1
exit /b 0


rem days in 1972

:TEST_1972_jan_01_equals_730_days
    call "%~dp0cdate.bat" 1972 1 1 0 0 0
    set /a secs=24*60*60*730
    if %cdate% neq %secs% exit /b 1
exit /b 0

rem 29 Feb 1972
:TEST_1972_mar_01_check_29_days_in_feb_in_leap_year_1972
    call "%~dp0cdate.bat" 1972 3 1 0 0 0
    set /a secs=24*60*60*(730+31+29)
    if %cdate% neq %secs% exit /b 1
exit /b 0

:TEST_1973_jan_01_check_366_days_in_leap_year_1972
    call "%~dp0cdate.bat" 1973 1 1 0 0 0
    set /a secs=24*60*60*(730+366)
    if %cdate% neq %secs% exit /b 1
exit /b 0


rem units

:TEST_1_second
    call "%~dp0cdate.bat" 1970 1 1 0 0 1
    if %cdate% neq 1 exit /b 1
exit /b 0

:TEST_1_minute
    call "%~dp0cdate.bat" 1970 1 1 0 1 0
    if %cdate% neq 60 exit /b 1
exit /b 0

:TEST_1_hour
    call "%~dp0cdate.bat" 1970 1 1 1 0 0
    if %cdate% neq 3600 exit /b 1
exit /b 0

:TEST_1_day
    call "%~dp0cdate.bat" 1970 1 2 0 0 0
    if %cdate% neq 86400 exit /b 1
exit /b 0

:TEST_1_month
    call "%~dp0cdate.bat" 1970 2 1 0 0 0
    if %cdate% neq 2678400 exit /b 1
exit /b 0


rem miscellaneous

:TEST_2021_mar_9_19_45_50
    call "%~dp0cdate.bat" 2021 3 9 19 45 50
    if %cdate% neq 1615319150 exit /b 1
exit /b 0

:TEST_2024_jan_1
    call "%~dp0cdate.bat" 2024 1 1 0 0 0
    if %cdate% neq 1704067200 exit /b 1
exit /b 0

:TEST_2024_jan_31
    call "%~dp0cdate.bat" 2024 1 31 0 0 0
    if %cdate% neq 1706659200 exit /b 1
exit /b 0

:TEST_2024_feb_1
    call "%~dp0cdate.bat" 2024 2 1 0 0 0
    if %cdate% neq 1706745600 exit /b 1
exit /b 0

:TEST_2024_feb_2
    call "%~dp0cdate.bat" 2024 2 2 0 0 0
    if %cdate% neq 1706832000 exit /b 1
exit /b 0

:TEST_2024_feb_28
    call "%~dp0cdate.bat" 2024 2 28 0 0 0
    if %cdate% neq 1709078400 exit /b 1
exit /b 0

:TEST_2024_feb_29
    call "%~dp0cdate.bat" 2024 2 29 0 0 0
    if %cdate% neq 1709164800 exit /b 1
exit /b 0

:TEST_2024_mar_1
    call "%~dp0cdate.bat" 2024 3 1 0 0 0
    if %cdate% neq 1709251200 exit /b 1
exit /b 0


rem negative hour

:TEST_negative_hour_cross_month
    call "%~dp0cdate.bat" 2024 2 29 21 0 0
    set cdate_expected=%cdate%
    call "%~dp0cdate.bat" 2024 3 1 -3 0 0
    if %cdate% neq %cdate_expected% exit /b 1
exit /b 0

:TEST_negative_hour_cross_day
    call "%~dp0cdate.bat" 2024 2 28 22 0 0
    set cdate_expected=%cdate%
    call "%~dp0cdate.bat" 2024 2 29 -2 0 0
    if %cdate% neq %cdate_expected% exit /b 1
exit /b 0

:TEST_negative_hour_cross_year
    call "%~dp0cdate.bat" 2023 12 31 19 0 0
    set cdate_expected=%cdate%
    call "%~dp0cdate.bat" 2024 1 1 -5 0 0
    if %cdate% neq %cdate_expected% exit /b 1
exit /b 0


rem negative minute

:TEST_negative_minute_cross_month
    call "%~dp0cdate.bat" 2024 2 29 21 0 0
    set cdate_expected=%cdate%
    call "%~dp0cdate.bat" 2024 3 1 0 -180 0
    if %cdate% neq %cdate_expected% exit /b 1
exit /b 0

:TEST_negative_minute_cross_day
    call "%~dp0cdate.bat" 2024 2 28 22 0 0
    set cdate_expected=%cdate%
    call "%~dp0cdate.bat" 2024 2 29 0 -120 0
    if %cdate% neq %cdate_expected% exit /b 1
exit /b 0

:TEST_negative_minute_cross_year
    call "%~dp0cdate.bat" 2023 12 31 19 0 0
    set cdate_expected=%cdate%
    call "%~dp0cdate.bat" 2024 1 1 0 -300 0
    if %cdate% neq %cdate_expected% exit /b 1
exit /b 0


rem negative second

:TEST_negative_second_cross_year
    call "%~dp0cdate.bat" 2021 12 31 23 59 59
    set cdate_expected=%cdate%
    call "%~dp0cdate.bat" 2022 1 1 0 0 -1
    if %cdate% neq %cdate_expected% exit /b 1
exit /b 0


rem https://en.wikipedia.org/wiki/Year_2038_problem

:TEST_2038_problem_INT_MAX
    call "%~dp0cdate.bat" 2038 1 19 3 14 7
    if %cdate% neq 2147483647 exit /b 1
exit /b 0

:TEST_2038_problem_INT_MAX_plus_1
    call "%~dp0cdate.bat" 2038 1 19 3 14 8
    if %cdate% neq -2147483648 exit /b 1
exit /b 0

:TEST_2038_problem_INT_MAX_plus_2
    call "%~dp0cdate.bat" 2038 1 19 3 14 9
    if %cdate% neq -2147483647 exit /b 1
exit /b 0


rem leading and trailing zeros

:TEST_leading_zeros
    call "%~dp0cdate.bat" 02009 08 09 08 09 08
    if %cdate% neq 1249805348 exit /b 1
exit /b 0

:TEST_leading_zeros_multiple
    call "%~dp0cdate.bat" 00002009 00008 0000009 00000008 000009 000008
    if %cdate% neq 1249805348 exit /b 1
exit /b 0

:TEST_leading_zeros_mutliple_valid_octal
    call "%~dp0cdate.bat" 00002010 00010 0000030 00000020 000030 000050
    if %cdate% neq 1288470650 exit /b 1
exit /b 0

