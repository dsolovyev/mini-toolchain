setlocal
cd string

setlocal& call .\length.bat
if %errorlevel% neq 0 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ""
if %errorlevel% neq 0 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat a
if %errorlevel% neq 1 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat "a"
if %errorlevel% neq 1 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ab
if %errorlevel% neq 2 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat abc
if %errorlevel% neq 3 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat abcd
if %errorlevel% neq 4 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat abcde
if %errorlevel% neq 5 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat abcdef
if %errorlevel% neq 6 echo ERROR: test failed>&2& exit /b 1
endlocal


setlocal& call .\length.bat a b
if %errorlevel% neq -1 echo ERROR: test failed>&2& exit /b 1
endlocal


setlocal& call .\length.bat "a b"
if %errorlevel% neq 3 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ^^
if %errorlevel% neq 1 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ^^^^
if %errorlevel% neq 2 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ^"^"123^"
if %errorlevel% neq 4 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ^"^"123^"^"
if %errorlevel% neq 5 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ^"^"123^^^^^"^"
if %errorlevel% neq 6 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat ^"a^b^"
if %errorlevel% neq 2 echo ERROR: test failed>&2& exit /b 1
endlocal



setlocal& set var=ab cd ef
call .\length.bat "%var%"
if %errorlevel% neq 8 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& set "var=ab cd ef"
call .\length.bat "%var%"
if %errorlevel% neq 8 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat "C:\Program Files (x86)"
if %errorlevel% neq 22 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& set "var=C:\Program Files (x86)"
call .\length.bat "%var%;%var%"
if %errorlevel% neq 45 echo ERROR: test failed>&2& exit /b 1
endlocal

setlocal& call .\length.bat "                      "
if %errorlevel% neq 22 echo ERROR: test failed>&2& exit /b 1
endlocal



setlocal
echo off
set /a i=0
set s=
:loop
    set /a i=%i%+1
    set s=%s%x

    call .\length.bat "%s%"
    if %errorlevel% neq %i% echo ERROR: length test failed ^(actual=%errorlevel% expected=%i%^)>&2& exit /b 1

    if %i% equ 100 call :set_900
    if %i% equ 1000 call :set_8000
if %i% lss 8101 goto :loop

goto :skip_set
  :set_900
    set i=899
    set s=%s%%s%%s%%s%%s%%s%%s%%s%%s:~1%
  exit /b
  :set_8000
    set i=7999
    set s=%s%%s%%s%%s%%s%%s%%s%%s:~1%
  exit /b
:skip_set
echo on
endlocal


:tests_passed
echo %~nx0: all tests passed
exit /b 0

