@echo off
setlocal disabledelayedexpansion

if not defined MY_TMP echo ERROR: %%MY_TMP%% is not defined>&2& exit /b 1

if not exist "%MY_TMP%" goto :make_tmp
    ::TODO fast check (.stamp file)
    ::rd /s /q "%MY_TMP%"
    exit /b 0
:make_tmp
mkdir "%MY_TMP%"
compact /c /s:"%MY_TMP%">nul 2>&1

pushd "%MY_TMP%"
for /f "tokens=*" %%A in ('chcp') do for %%B in (%%A) do set "cp=%%~nB"
mode con cp select=437>nul
call :write_bin 0
call :write_bin 26
for /l %%I in (1,1,25) do call :write_bin %%I
for /l %%I in (27,1,255) do call :write_bin %%I
mode con cp select=%cp% >nul

call :check_bin_all || (echo ERROR: check_bin_all failed>&2& exit /b 1)
popd

goto :EOF


:byte2hex
    set /a a=%~1^&15
    if %a% leq 9 goto :byte2hex_b
    goto :byte2hex_a_%a%
    :byte2hex_a_10
        set a=A& goto :byte2hex_b
    :byte2hex_a_11
        set a=B& goto :byte2hex_b
    :byte2hex_a_12
        set a=C& goto :byte2hex_b
    :byte2hex_a_13
        set a=D& goto :byte2hex_b
    :byte2hex_a_14
        set a=E& goto :byte2hex_b
    :byte2hex_a_15
        set a=F& goto :byte2hex_b
    :byte2hex_b
    set /a b=(%~1^>^>4)^&15
    if %b% leq 9 exit /b 0
    goto :byte2hex_b_%b%
    :byte2hex_b_10
        set b=A& exit /b 0
    :byte2hex_b_11
        set b=B& exit /b 0
    :byte2hex_b_12
        set b=C& exit /b 0
    :byte2hex_b_13
        set b=D& exit /b 0
    :byte2hex_b_14
        set b=E& exit /b 0
    :byte2hex_b_15
        set b=F& exit /b 0
exit /b 0

:write_bin
    setlocal

    :: \0
    if %~1 equ 0 goto :write_bin__null
    :: \n,\r
    if %~1 equ 10 goto :write_bin__cr_or_lf
    if %~1 equ 13 goto :write_bin__cr_or_lf
    :: "
    if %~1 equ 34 goto :write_bin__quote
    :: =
    if %~1 equ 61 goto :write_bin__hard
    :: <end-of-text-file>, can't be written using write_bin__hard nor via %=ExitCodeAscii%
    if %~1 equ 26 goto :write_bin__tolerably
    if %~1 leq 32 goto :write_bin__hard
    if %~1 gtr 127 goto :write_bin__hard
    if %~1 equ 127 goto :write_bin__tolerably
        call :byte2hex %1
        cmd /d /c exit %~1
        call set "ascii_char=%%=ExitCodeAscii%%"
        set /p="%ascii_char%">bin_%b%%a%.tmp<nul
        exit /b
    :write_bin__tolerably
        call :byte2hex %1
        forfiles /p . /m bin_00.tmp /c "cmd /v:off /d /c (set /p=^0x%b%%a%)>bin_%b%%a%.tmp"<nul >nul
        exit /b
    :write_bin__null
        del bin_00.tmp >nul 2>&1
        fsutil file createnew bin_00.tmp 1 >nul
        exit /b
    :write_bin__cr_or_lf
        call :byte2hex %1
    setlocal enabledelayedexpansion
    if %~1 equ 10 goto :write_bin__cr_or_lf_LF
for /f %%a in ('copy /z "%~dpf0" nul') do set "CR_OR_LF=%%a"
goto :write_bin__cr_or_lf_CRdone
    :write_bin__cr_or_lf_LF
(set CR_OR_LF=^
%=EMPTY=%
)
    :write_bin__cr_or_lf_CRdone
    set /p=_!CR_OR_LF!<nul>bin_%b%%a%_5F%b%%a%.tmp
    endlocal
        copy /y /b bin_%b%%a%_5F%b%%a%.tmp+bin_1A.tmp bin_%b%%a%_5F%b%%a%1A.tmp>nul
        del bin_%b%%a%_5F%b%%a%.tmp >nul 2>&1
        goto :write_bin__hard__take_middle_byte
    :write_bin__quote
        set /p=^"^"^"<nul>bin_22.tmp
        exit /b
    :write_bin__hard
        :: pause & copy are from "makecab" solution
        call :byte2hex %1
        forfiles /p . /m bin_00.tmp /c "cmd /v:off /d /c (set /p=_^0x%b%%a%0x1A)>bin_%b%%a%_5F%b%%a%1A.tmp"<nul >nul
        :write_bin__hard__take_middle_byte
        type bin_%b%%a%_5F%b%%a%1A.tmp| (pause>nul& findstr "^">bin_%b%%a%_%b%%a%1A0A0D.tmp)
        copy /y bin_%b%%a%_%b%%a%1A0A0D.tmp /a bin_%b%%a%.tmp /b>nul
        del bin_%b%%a%_5F%b%%a%1A.tmp bin_%b%%a%_%b%%a%1A0A0D.tmp >nul 2>&1
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
