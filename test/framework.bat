@echo off
setlocal disabledelayedexpansion enableextensions

set "arg=%2"
if defined arg echo ERROR: extra argument #2>&2& exit /b 2

set "search_pattern=%~1"
if not defined search_pattern echo ERROR: no arguments>&2& exit /b 2
if "%search_pattern%" == "all" set search_pattern=*.test.bat

for /r %%t in (%search_pattern%) do (
    call :run_test_script "%%t" || exit /b 1
)


exit /b 0



:run_test_script
    setlocal
    set SCRIPT_TESTS=
    set SCRIPT_HAS_INIT=0
    set SCRIPT_HAS_CLEANUP=0
    for /f usebackq^ tokens^=1^ delims^=^"^ eol^= %%l in ("%~1") do (
        if "%%l" == ":INIT" set SCRIPT_HAS_INIT=1
        if "%%l" == ":CLEANUP" set SCRIPT_HAS_CLEANUP=1
        call :add_test_and_params "%%l"
    )
    set SCRIPT_
exit /b 0

:add_test_and_params
    set "line=%~1"
    if "%line:~0,6%" == ":TEST_" (
        echo test "%line:~6%"
        if defined SCRIPT_TESTS (
            set SCRIPT_TESTS=%SCRIPT_TESTS% %line:~6%
        ) else (
            set SCRIPT_TESTS=%line:~6%
        )
    )
    if "%line:~0,8%" == ":PARAMS_" (
        echo test "%line:~8%" has parameter^(s^)
        set "SCRIPT_TEST_HAS_PARAM_%line:~8%=1"
    )
exit /b






set err=0
for /r %%t in (*.test.bat) do (
    call :run_test "%%t"|| set err=1
)
if %err% neq 0 echo ERROR: some tests are failed>&2
exit /b %err%

:run_test
    setlocal
    echo Run test "%~1"...
    "%COMSPEC%" /d /c "%~1">"%TMP%\mini_toolchain_test.log"2>&1&& echo PASSED
    set err=%errorlevel%
    if %err% neq 0 echo Test FAILED "%~1"& echo logs:& type "%TMP%\mini_toolchain_test.log"
    del "%TMP%\mini_toolchain_test.log"
exit /b %err%

