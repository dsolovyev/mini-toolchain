setlocal

if "%~1" == "--test-process" goto :test_process

cd /d "%~dp0"

call .\mktemp_dir.bat %~n0.
set "CUR_TMP=%result%"

set /a jobs=NUMBER_OF_PROCESSORS*4 - 1
if %jobs% lss 1 set jobs=1

set result=0
set /a n=0
:do_parallel_jobs
    set /a n+=1

    set /a i=1
    :run_job
        set err=0
        del "%CUR_TMP%\process_%i%.log">nul 2>&1
        if exist "%CUR_TMP%\process_%i%.log" set err=1
        if %err% neq 0 if %n% equ 1 echo ERROR: can't run subprocess>&2& set result=1& goto :loop_clean_up
        if %err% neq 0 goto :run_job
    
        start /b "parallel run %%i" "%COMSPEC%" /b /c call %~nx0 --test-process %i% >"%CUR_TMP%\process_%i%.log"
        set /a i+=1
    if %i% leq %jobs% goto :run_job

    "%COMSPEC%" /b /c call %~nx0 --test-process 0 >"%CUR_TMP%\process_0.log"
    if exist "%TMP%\%~n0.failed" goto :loop_clean_up
    if not exist "%TMP%\%~n0.ok" goto :loop_clean_up
if %n% lss 40 goto :do_parallel_jobs

:loop_wait_all
    del "%CUR_TMP%\process_*.log">nul 2>&1
if exist "%CUR_TMP%\process_*.log" goto :loop_wait_all

:loop_clean_up
    rd /s /q "%CUR_TMP%">nul 2>&1
if exist "%CUR_TMP%" goto :loop_clean_up
echo cleaned up>&2

if exist "%TMP%\%~n0.failed" echo ERROR: test failed>&2& set result=1& del "%TMP%\%~n0.failed"

if "%result%" == "0" if not exist "%TMP%\%~n0.ok" echo ERROR: test failed>&2& set result=1
del "%TMP%\%~n0.ok">nul

exit /b %result%


:test_process
    set /a id=%~2
    call .\lock.bat --acquire "%CUR_TMP%\test.lock"
    if %errorlevel% neq 0 (
        (if 1 == 0 echo.)>"%TMP%\%~n0.failed"
        echo test_process ^(%id%^): call \lock.bat --acquire "%CUR_TMP%\test.lock" failed>&2
        exit /b 1
    )

    (cmd /d /c echo %id%)>"%CUR_TMP%\id.txt"
    set err=1
    set "actual_id=^<N/A^>"
    for /f %%L in (%CUR_TMP%\id.txt) do (
        if %%L equ %id% set err=0
        set "actual_id=%%L"
    )

    call .\lock.bat --release "%CUR_TMP%\test.lock"
    if %errorlevel% neq 0 echo test_process ^(%id%^): call .\lock.bat --release "%CUR_TMP%\test.lock" failed>&2& set err=1
    if %err% neq 0 (
        (if 1 == 0 echo.)>"%TMP%\%~n0.failed"
        echo test_process ^(%id%^): bad id=%actual_id% in "%CUR_TMP%\id.txt">&2
        exit /b 1
    )
    (if 1 == 0 echo.)>"%TMP%\%~n0.ok"
exit /b 0
