setlocal

set "lock_file=%~2"
if not defined lock_file exit /b 2

if "%~1" == "--acquire" goto :loop_acquire
if "%~1" == "--release" goto :release
exit /b 2


:loop_acquire
    if exist "%lock_file%" goto :loop_acquire
    (
        (
            if exist "%lock_file%" goto :loop_acquire
            (if 1 == 0 echo.)>"%lock_file%"
            goto :acquired
        )>"%lock_file%.acquiring"
    ) 2>nul
goto :loop_acquire

:acquired
    del "%lock_file%.acquiring">nul 2>&1
exit /b 0


:release
    if not exist "%lock_file%" exit /b 1
    del "%lock_file%">nul
exit /b
