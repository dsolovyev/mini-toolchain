setlocal

if "%~1" == "--test-process" goto :test_process

cd /d "%~dp0"

call .\mktemp_dir.bat mktemp_dir.test.
if "%result%" == "%TMP%" exit /b 1
if "%result%" == "%TEMP%" exit /b 1
set "ORIGINAL_TMP=%TMP%"
if exist "%ORIGINAL_TMP%\mktemp_dir.test.failed" del "%ORIGINAL_TMP%\mktemp_dir.test.failed">nul|| exit /b 1
set "TMP=%result%"
set "TEMP=%result%"

set /a jobs=NUMBER_OF_PROCESSORS*4 - 1
if %jobs% lss 1 set jobs=1

set result=0
set /a n=0
:do_parallel_jobs
    set /a n+=1

    set /a i=1
    :run_job
        set err=0
        del "%TMP%\process_%i%.log">nul 2>&1
        if exist "%TMP%\process_%i%.log" set err=1
        if %err% neq 0 if %n% equ 1 echo ERROR: can't run subprocess>&2& set result=1& goto :loop_clean_up
        if %err% neq 0 goto :run_job

        start /b "parallel run %%i" "%COMSPEC%" /b /c call %~nx0 --test-process %i% >"%TMP%\process_%i%.log"
        set /a i+=1
    if %i% leq %jobs% goto :run_job

    "%COMSPEC%" /b /c call %~nx0 --test-process 0 >"%TMP%\process_0.log"
    if not exist "%ORIGINAL_TMP%\mktemp_dir.test.ok" goto :loop_clean_up
    if exist "%ORIGINAL_TMP%\mktemp_dir.test.failed" goto :loop_clean_up
if %n% lss 20 goto :do_parallel_jobs


:loop_clean_up
    rd /s /q "%TMP%">nul 2>&1
if exist "%TMP%" goto :loop_clean_up
echo cleaned up>&2

if not exist "%ORIGINAL_TMP%\mktemp_dir.test.ok" echo ERROR: test failed>&2& set result=1
del "%ORIGINAL_TMP%\mktemp_dir.test.ok">nul

if exist "%ORIGINAL_TMP%\mktemp_dir.test.failed" echo ERROR: test failed>&2& set result=1& del "%ORIGINAL_TMP%\mktemp_dir.test.failed"
exit /b %result%


:test_process
    set /a id=%~2
    call .\mktemp_dir.bat
    if %errorlevel% neq 0 (
        (if 1 == 0 echo.)>"%ORIGINAL_TMP%\mktemp_dir.test.failed"
        echo test_process ^(%id%^): call .\mktemp_dir.bat failed>&2
        exit /b 1
    )

    (cmd /d /c echo %id%)>"%result%\id.txt"
    set err=1
    set "actual_id=^<N/A^>"
    for /f %%L in (%result%\id.txt) do (
        if %%L equ %id% set err=0
        set "actual_id=%%L"
    )

    if %err% equ 0 (
        (if 1 == 0 echo.)>"%ORIGINAL_TMP%\mktemp_dir.test.ok"
    ) else (
        (if 1 == 0 echo.)>"%ORIGINAL_TMP%\mktemp_dir.test.failed"
        echo test_process ^(%id%^): bad id=%actual_id% in "%result%\id.txt">&2
        exit /b 1
    )
exit /b 0
