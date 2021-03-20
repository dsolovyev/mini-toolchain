@if not defined MINI_TOOLCHAIN_RUN_IN_SUBCMD "%COMSPEC%" /d /c set MINI_TOOLCHAIN_RUN_IN_SUBCMD=1^& "%~0" %*& exit /b
@echo off
if "%MINI_TOOLCHAIN_RUN_IN_SUBCMD%" == "1" set MINI_TOOLCHAIN_RUN_IN_SUBCMD=

set "arg=%2"
if defined arg echo ERROR: extra argument #2>&2& exit /b 2

set "arg=%~1"
if not defined arg echo ERROR: no arguments>&2& exit /b 2
if not "%arg%" == "all" call :run_test "%%arg%%"& exit /b

set err=0
for /r %%t in (*.test.bat) do (
    call :run_test "%%t"|| set err=1
)
if %err% neq 0 echo ERROR: some tests are failed>&2
exit /b %err%

:run_test
    echo Run test "%~1"...
    "%COMSPEC%" /d /c "%~1">"%TMP%\mini_toolchain_test.log"2>&1&& echo passed
    if %errorlevel% neq 0 echo failed& echo log:& type "%TMP%\mini_toolchain_test.log"
    del "%TMP%\mini_toolchain_test.log"
exit /b

