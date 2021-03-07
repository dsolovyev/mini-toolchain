@echo off
setlocal

set out=
set err=
:loop_args
    set "cmdline_tmp=%~1"
    if not defined cmdline_tmp goto :loop_args_end
if "%cmdline_tmp:"=%" == "/out" set "out=%~2"& shift& shift& goto :loop_args
if "%cmdline_tmp:"=%" == "/err" set "err=%~2"& shift& shift& goto :loop_args
:loop_args_end

set cmdline=
:loop_cmdline
    ::escape special characters
    ::set "cmdline_tmp=%1"
    ::set "cmdline_tmp=%cmdline_tmp:&=^&%"
    ::set "cmdline=%cmdline% %cmdline_tmp%"
    set "cmdline=%cmdline% %1"
    shift
    set "cmdline_tmp=%1"
if defined cmdline_tmp goto :loop_cmdline

::echo cmdline="%cmdline%"
if defined out if defined err goto :run_redirect_both
if defined out goto :run_redirect_out
if defined err goto :run_redirect_err

    endlocal& setlocal& (call %cmdline%)& set "t_sta=%TIME%"
    endlocal& setlocal& set "errcode=%errorlevel%"& set "t_sta=%t_sta%"
    goto :run_end
:run_redirect_out
    endlocal& setlocal& (call %cmdline%)>"%out%"& set "t_sta=%TIME%"
    endlocal& setlocal& set "errcode=%errorlevel%"& set "t_sta=%t_sta%"
    goto :run_end
:run_redirect_err
    endlocal& setlocal& (call %cmdline%)2>"%err%"& set "t_sta=%TIME%"
    endlocal& setlocal& set "errcode=%errorlevel%"& set "t_sta=%t_sta%"
    goto :run_end
:run_redirect_both
    endlocal& setlocal& (call %cmdline%)>"%out%" 2>"%err%"& set "t_sta=%TIME%"
    endlocal& setlocal& set "errcode=%errorlevel%"& set "t_sta=%t_sta%"
:run_end
set "t_end=%TIME%"

::echo t_sta=%t_sta%
::echo t_end=%t_end%

set /a s=((%t_sta:~0,2%*60 + 1%t_sta:~3,2%-100)*60 + 1%t_sta:~6,2%-100)*100 + 1%t_sta:~9,2%-100
set /a e=((%t_end:~0,2%*60 + 1%t_end:~3,2%-100)*60 + 1%t_end:~6,2%-100)*100 + 1%t_end:~9,2%-100
set /a d=e-s
set /a d_sec=d / 100
set /a d_1_100=d %% 100
if %d_1_100% leq 9 set d_1_100=0%d_1_100%
(echo.
echo real time: %d_sec%.%d_1_100% sec)>&2

exit /b %errcode%
