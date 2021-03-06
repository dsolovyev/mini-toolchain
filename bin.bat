@echo off

set "MY_TMP=%TEMP%\bin"
if defined TMP set "MY_TMP=%TMP%\bin"
if exist "%MY_TMP%" rd /s /q "%MY_TMP%"
mkdir "%MY_TMP%"

::forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(%arg1%"
pushd "%MY_TMP%"
for /f "tokens=*" %%A in ('chcp') do for %%B in (%%A) do set "cp=%%~nB"
mode con cp select=437>nul
for /l %%I in (0,1,255) do (
    call :print_bin %%I
)
mode con cp select=%cp% >nul

call :check_bin_all || echo ERROR: check_bin_all failed>&2& exit /b 1
popd

goto :EOF
::set result

::set /p="set/p"<nul
::set /p="set/p"<nul
::set /p="set/p"<nul

:byte2hex
    set /a a=%~1^&15
    if %a%==10 set a=A
    if %a%==11 set a=B
    if %a%==12 set a=C
    if %a%==13 set a=D
    if %a%==14 set a=E
    if %a%==15 set a=F
    set /a b=(%~1^>^>4)^&15
    if %b%==10 set b=A
    if %b%==11 set b=B
    if %b%==12 set b=C
    if %b%==13 set b=D
    if %b%==14 set b=E
    if %b%==15 set b=F
exit /b 0

:print_bin
    setlocal

    if %~1 equ 0 goto :print_bin__null
    if %~1 equ 10 goto :print_bin__lf
    if %~1 equ 13 goto :print_bin__cr
    if %~1 equ 34 goto :print_bin__quote
    if %~1 equ 61 goto :print_bin__equals
        call :byte2hex %1
        forfiles /p . /m bin_00.tmp /c "cmd /d /c (set /p=^0x%b%%a%)>bin_%b%%a%.tmp"<nul >nul
        goto :print_bin__end_switch
    :print_bin__null
        del bin_00.tmp >nul 2>&1
        fsutil file createnew bin_00.tmp 1 >nul
        goto :print_bin__end_switch
    :print_bin__lf
        setlocal enabledelayedexpansion
(set LF=^
%=EMPTY=%
)
        set /p=!LF!<nul>bin_0A.tmp
        endlocal
        goto :print_bin__end_switch
    :print_bin__cr
        setlocal enabledelayedexpansion
        for /f %%a in ('copy /z "%~dpf0" nul') do set "CR=%%a"
        set /p=!CR!<nul>bin_0D.tmp
        endlocal
        goto :print_bin__end_switch
    :print_bin__quote
        set /p=^"^"^"<nul>bin_22.tmp
        goto :print_bin__end_switch
    :print_bin__equals
        :: pause & copy are from "makecab" solution
        forfiles /p . /m bin_00.tmp /c "cmd /d /c (set /p=_=^0x1A)>bin_3D_5F3D1A.tmp"<nul >nul
        type bin_3D_5F3D1A.tmp| (pause>nul& findstr "=">bin_3D_3D1A0A0D.tmp)
        copy /y bin_3D_3D1A0A0D.tmp /a bin_3D.tmp /b>nul
        del bin_3D_5F3D1A.tmp bin_3D_3D1A0A0D.tmp
    :print_bin__end_switch
exit /b


:check_bin_all
    setlocal
    set res=0
    set /a i=1
    :check_bin_all__loop
        call :byte2hex %i%
        (
            dir "bin_%b%%a%.tmp"2>nul|| echo ERROR: cannot find bin_%b%%a%.tmp>&2
        ) | findstr /r /c:"1 bin_%b%%a%\.tmp$">nul|| ((echo ERROR: bin_%b%%a%.tmp size != 1)>&2& set res=1& goto :check_bin_all__next)

        fc /b bin_00.tmp bin_%b%%a%.tmp| findstr /r /c:"^00000000: 00 %b%%a%$">nul|| (echo ERROR: bad data in bin_%b%%a%.tmp>&2& set res=1)
        :check_bin_all__next
        set /a i=i+1
    if %i% leq 255 goto :check_bin_all__loop
exit /b %res%
