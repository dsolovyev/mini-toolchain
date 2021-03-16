setlocal
    set "x=%~1"
    if "%~1" == "-2147483648" set "x=(-2147483647-1)"

    set /a y="%x% & 15"
    call :digit %y%
    set a=%hex%
    set /a y="%x%>>4 & 15"
    call :digit %y%
    set a=%hex%%a%

    set /a y="%x%>>8 & 15"
    call :digit %y%
    set b=%hex%
    set /a y="%x%>>12 & 15"
    call :digit %y%
    set b=%hex%%b%


    set /a y="%x%>>16 & 15"
    call :digit %y%
    set c=%hex%
    set /a y="%x%>>20 & 15"
    call :digit %y%
    set c=%hex%%c%

    set /a y="%x%>>24 & 15"
    call :digit %y%
    set d=%hex%
    set /a y="%x%>>28 & 15"
    call :digit %y%
    set d=%hex%%d%
endlocal& set "result=%a% %b% %c% %d%"
exit /b 0

:digit
    if %1 leq 9 (set hex=%1& exit /b) else goto :hex_%1
    :hex_10
        set hex=A& exit /b
    :hex_11
        set hex=B& exit /b
    :hex_12
        set hex=C& exit /b
    :hex_13
        set hex=D& exit /b
    :hex_14
        set hex=E& exit /b
    :hex_15
        set hex=F& exit /b
