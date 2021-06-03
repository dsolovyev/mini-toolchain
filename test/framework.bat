@echo off
setlocal disabledelayedexpansion enableextensions

set "arg=%2"
if defined arg echo ERROR: extra argument #2>&2& exit /b 2

set "search_pattern=%~1"
if not defined search_pattern echo ERROR: no arguments>&2& exit /b 2
if "%search_pattern%" == "all" set search_pattern=*.test.bat

set GLOBAL_TOTAL=0
set GLOBAL_PASSED=0
for /r %%t in (%search_pattern%) do (
    if exist "%%t" (
        call :run_test_script "%%t" || exit /b 1
        set /a GLOBAL_TOTAL += SCRIPT_TOTAL
        set /a GLOBAL_PASSED += SCRIPT_PASSED
    )
)

echo GLOBAL_TOTAL=%GLOBAL_TOTAL%
echo GLOBAL_PASSED=%GLOBAL_PASSED%
if %GLOBAL_TOTAL% neq %GLOBAL_PASSED% exit /b 1
exit /b 0



:run_test_script
    setlocal
    set SCRIPT_TESTS=
    set SCRIPT_HAS_INIT=0
    set SCRIPT_HAS_CLEANUP=0
    set SCRIPT_TOTAL=0
    set SCRIPT_PASSED=0
    echo Running tests in script "%~1"...
    for /f usebackq^ tokens^=1^ delims^=^"^ eol^= %%l in ("%~1") do (
        if "%%l" == ":INIT" set SCRIPT_HAS_INIT=1
        if "%%l" == ":CLEANUP" set SCRIPT_HAS_CLEANUP=1
        call :parse_test_and_params "%%l"|| (echo ERROR: bad test script "%~1">&2& exit /b 1)
    )

    if "%SCRIPT_HAS_INIT%" == "1" (
        call "%~1" INIT|| (echo ERROR: "%~1" INIT failed>&2& exit /b 1)
    )
    for %%n in (%SCRIPT_TESTS%) do (
        call :run_test "%~1" "%%~n"|| (echo ERROR: "%~1" testing failed>&2& exit /b 1)
        set /a SCRIPT_TOTAL += TEST_TOTAL
        set /a SCRIPT_PASSED += TEST_PASSED
        echo.
    )
    if "%SCRIPT_HAS_CLEANUP%" == "1" (
        call "%~1" CLEANUP|| (echo ERROR: "%~1" CLEANUP failed>&2& exit /b 1)
    )
    echo SCRIPT_TOTAL=%SCRIPT_TOTAL%
    echo SCRIPT_PASSED=%SCRIPT_PASSED%
    echo.
    endlocal ^
    & set "SCRIPT_TOTAL=%SCRIPT_TOTAL%" ^
    & set "SCRIPT_PASSED=%SCRIPT_PASSED%"& ^
exit /b 0


:parse_test_and_params
    set "line=%~1"
    if "%line:~0,6%" == ":TEST_" (
        if defined SCRIPT_TESTS (
            set "SCRIPT_TESTS=%SCRIPT_TESTS% %line:~6%"
        ) else (
            set "SCRIPT_TESTS=%line:~6%"
        )
    )
    if "%line:~0,8%" == ":PARAMS_" (
        set "SCRIPT_PARAMS_%line:~8%=1"
    )
exit /b 0


:run_test
    setlocal
    set TEST_TOTAL=0
    set TEST_PASSED=0

    call set TEST_PARAMS=%%SCRIPT_PARAMS_%~2%%
    if not defined TEST_PARAMS (
        call :do_run_test "%~1" "%~2"|| exit /b 1
    ) else (
        echo Test %~2 has parameters
        call "%~1" "PARAMS_%~2"|| (
            echo ERROR: can't get parameters for test "%~2">&2
            exit /b 1
        )
        call :run_parameterized_test "%~1" "%~2" 0|| exit /b 1
        call echo TEST_TOTAL=%%TEST_TOTAL%%
        call echo TEST_PASSED=%%TEST_PASSED%%
    )
    endlocal ^
    & set /a "TEST_TOTAL=%TEST_TOTAL%" ^
    & set /a "TEST_PASSED=%TEST_PASSED%"& ^
exit /b 0


:do_run_test
    if not defined TEST_COMBINATION_STR (
        echo Running %~2 ...
    ) else (
        echo Running %~2^(%TEST_COMBINATION_STR%^) ...
    )
    set /a TEST_TOTAL += 1

    "%COMSPEC%" /c echo off^& call "%~1" "TEST_%~2"
    if %errorlevel% == 0 (
        set /a TEST_PASSED += 1
        echo PASSED
    ) else (
        echo FAILED>&2
    )
exit /b 0


:run_parameterized_test
    setlocal
    set TEST_COMBINATION_NUM=%~3
    if "%TEST_COMBINATION_NUM%" == "0" (
        set TEST_COMBINATION_NUM=1
        set TEST_COMBINATION_STR=
    )
    set TEST_PARAM_CUR=
    for /f "usebackq tokens=1,* delims= "eol^= %%c in ('%TEST_PARAMS%') do (
        set "TEST_PARAM_CUR=%%c"
        set "TEST_PARAMS=%%d"
        goto :run_parameterized_test__ok
    )
        echo ERROR: %%TEST_PARAMS%% is empty>&2
        exit /b 1
    :run_parameterized_test__ok

    set "TEST_COMBINATION_STR_PREV=%TEST_COMBINATION_STR%"
    call set "TEST_PARAM_CUR_VALUES=%%TEST_PARAMS[%TEST_PARAM_CUR%]%%"

    set TEST_PARAM_CUR_AT_LEAST_1=
    for %%v in (%TEST_PARAM_CUR_VALUES%) do (
        set TEST_PARAM_CUR_AT_LEAST_1=1
        set "%TEST_PARAM_CUR%=%%~v"

        if not defined TEST_COMBINATION_STR_PREV (
            set "TEST_COMBINATION_STR=%TEST_PARAM_CUR%=%%v"
        ) else (
            set "TEST_COMBINATION_STR=%TEST_COMBINATION_STR%, %TEST_PARAM_CUR%=%%v"
        )

        if defined TEST_PARAMS (
            call :run_parameterized_test "%~1" "%~2" %%TEST_COMBINATION_NUM%%
        ) else (
            call :do_run_test "%~1" "%~2"
            set /a TEST_COMBINATION_NUM += 1
        )
    )
    if not defined TEST_PARAM_CUR_AT_LEAST_1 (
        echo ERROR: no values for parameter "%TEST_PARAM_CUR%">&2
        exit /b 1
    )
    endlocal ^
    & set "TEST_COMBINATION_NUM=%TEST_COMBINATION_NUM%" ^
    & set /a "TEST_TOTAL=%TEST_TOTAL%" ^
    & set /a "TEST_PASSED=%TEST_PASSED%"& ^
exit /b 0

