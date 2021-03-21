setlocal

set "prefix=%~1"
if not defined prefix set prefix=mktemp_

set /a i=0
:loop
    if %i% equ 2147483647 echo ERROR: can't create directory in "%TMP%">&2& exit /b 1
    set /a i+=1
    md "%TMP%\%prefix%%i%" >nul 2>&1
if %errorlevel% neq 0 goto :loop

endlocal& set "result=%TMP%\%prefix%%i%"
