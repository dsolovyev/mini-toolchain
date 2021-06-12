@echo off
setlocal disabledelayedexpansion enableextensions

set "arg=%3"
if defined arg echo ERROR: extra argument #3>&2& exit /b 2

set "TEST_REPORT_HELPER=%~2"

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
    set SCRIPT_WORKSPACE_IN=
    call :create_script_workspace "%~1"|| (echo ERROR: ws creation for "%~1" failed>&2& exit /b 1)
    pushd "%SCRIPT_WORKSPACE%"|| (echo ERROR: can't change dir to "%SCRIPT_WORKSPACE%">&2& exit /b 1)
    set SCRIPT_WORKSPACE_IN=1

    call :run_test_script_in_ws "%~1"|| goto :run_test_script__save_ws

    popd& set SCRIPT_WORKSPACE_IN=

    if %SCRIPT_TOTAL% equ %SCRIPT_PASSED% (
        call :delete_script_workspace|| (
            echo ERROR: ws deletion for "%~1" failed>&2
            goto :run_test_script__save_ws
        )
    )
    exit /b 0

  :run_test_script__save_ws
    call :save_workspace "%SCRIPT_WORKSPACE%"|| (echo WARNING: ws saving for "%~1" failed>&2)
    if defined SCRIPT_WORKSPACE_IN popd
exit /b 1


:run_test_script_in_ws
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
    setlocal
    if not defined TEST_COMBINATION_STR (
        set "TEST_NAME=%~2"
        set "TEST_WORKSPACE=%~2"
    ) else (
        set "TEST_NAME=%~2(%TEST_COMBINATION_STR%)"
        set "TEST_WORKSPACE=%~2.%TEST_COMBINATION_NUM%"
    )
    echo Running %TEST_NAME% ...
    set /a TEST_TOTAL += 1

    call :create_test_workspace "%TEST_WORKSPACE%"|| (echo ERROR: ws creation for test "%~2" failed>&2& exit /b 1)
    pushd "%TEST_WORKSPACE%"|| (echo ERROR: can't change dir to "%TEST_WORKSPACE%">&2& exit /b 1)

    call :publish_test_start "%~1"|| (echo WARNING: can't publish test start>&2)

    set "t_sta=%TIME%"

    "%COMSPEC%" /c call "%~1" "TEST_%~2">"%~2.log" 2>&1
    set err=%errorlevel%

    set "t_end=%TIME%"
    set /a s=((%t_sta:~0,2%*60 + 1%t_sta:~3,2%-100)*60 + 1%t_sta:~6,2%-100)*100 + 1%t_sta:~9,2%-100
    set /a e=((%t_end:~0,2%*60 + 1%t_end:~3,2%-100)*60 + 1%t_end:~6,2%-100)*100 + 1%t_end:~9,2%-100
    set /a "d = (e-s + 8640000) %% 8640000"
    set /a duration=d*10

    if %err% == 0 (
        set /a TEST_PASSED += 1
        echo PASSED
        call :publish_test_result "%~1" pass "%duration%"|| (echo WARNING: can't publish test result>&2)
    ) else (
        echo FAILED>&2
        call :publish_test_result "%~1" fail "%duration%"|| (echo WARNING: can't publish test result>&2)
        call :save_workspace "%TEST_WORKSPACE%" "%SCRIPT_WORKSPACE%"|| (echo ERROR: ws saving for test "%~2" failed>&2& popd& exit /b 1)
    )

    popd
    if %err% == 0 (
        call :delete_test_workspace|| (
            echo ERROR: ws deletion for test "%~2" failed>&2
            exit /b 1
        )
    )

    endlocal ^
    & set /a "TEST_TOTAL=%TEST_TOTAL%" ^
    & set /a "TEST_PASSED=%TEST_PASSED%"& ^
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
            call :run_parameterized_test "%~1" "%~2" %%TEST_COMBINATION_NUM%%|| exit /b 1
        ) else (
            call :do_run_test "%~1" "%~2"|| exit /b 1
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



:create_script_workspace
    set "SCRIPT_WORKSPACE=%TMP%\%~n1"
    md "%SCRIPT_WORKSPACE%"|| (echo ERROR: can't create dir "%SCRIPT_WORKSPACE%">&2& exit /b 1)
exit /b 0

:delete_script_workspace
    rd /s /q "%SCRIPT_WORKSPACE%"|| (echo ERROR: can't remove dir "%SCRIPT_WORKSPACE%">&2& exit /b 1)
exit /b 0


:create_test_workspace
    set "TEST_WORKSPACE=%CD%\%~1"
    md "%TEST_WORKSPACE%"|| (echo ERROR: can't create dir "%TEST_WORKSPACE%">&2& exit /b 1)
exit /b 0

:delete_test_workspace
    rd /s /q "%TEST_WORKSPACE%"|| (echo ERROR: can't remove dir "%TEST_WORKSPACE%">&2& exit /b 1)
exit /b 0


:save_workspace
    if not defined TEST_REPORT_HELPER exit /b 0
    echo INFO: saving workspace "%~1">&2
  setlocal
    set err=0
    cd "%~1"|| (set err=1& goto :save_workspace__end)
    if "%~2" == "" (
        call "%~dp0%TEST_REPORT_HELPER%.bat" save "%~1"|| (set err=1& goto :save_workspace__end)
    ) else (
        call "%~dp0%TEST_REPORT_HELPER%.bat" save "%~1" "%~n2"|| (set err=1& goto :save_workspace__end)
    )
    :save_workspace__end
  endlocal& ^
exit /b %err%


:publish_test_start
    if not defined TEST_REPORT_HELPER exit /b 0
    call "%~dp0%TEST_REPORT_HELPER%.bat" test_start "%~1"
exit /b %errorlevel%

:publish_test_result
    if not defined TEST_REPORT_HELPER exit /b 0
    call "%~dp0%TEST_REPORT_HELPER%.bat" test_result "%~1" "%~2" "%~3"
exit /b %errorlevel%

