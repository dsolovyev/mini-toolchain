setlocal
set timebias=
for /f "tokens=1-3,*" %%A in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v ActiveTimeBias') do (
    if not "%%~C"=="" set timebias_type=%%B& set timebias=%%C
)
if not defined timebias_type set timebias=
if /i not "%timebias_type%" == "reg_dword" set timebias=
if not defined timebias echo ERROR: can't read HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation\ActiveTimeBias>&2&exit /b 1

set /a first_hex_digit=%timebias:~0,3%
if %first_hex_digit% gtr 7 if not "%timebias:~9,1%"=="" set /a timebias=(first_hex_digit ^<^< 28) ^| 0x%timebias:~3%& goto :to_exit
    set /a timebias=%timebias%
:to_exit
endlocal& set timebias=%timebias%
exit /b 0
