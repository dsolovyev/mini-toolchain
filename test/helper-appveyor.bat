goto %~1


:test_start
    powershell -Command ^
        Add-AppveyorTest ^
        -Name $Env:TEST_NAME ^
        -FileName "%~2" ^
        -Outcome Running
exit /b %errorlevel%


:test_result
    setlocal

    set outcome=Failed
    if "%~3" == "pass" set outcome=Passed

    powershell -Command ^
        Update-AppveyorTest ^
        -Name $Env:TEST_NAME ^
        -FileName "%~2" ^
        -Outcome %outcome% ^
        -Duration %~4

    endlocal& ^
exit /b %errorlevel%


:save
    cd "%~2"|| exit /b 1
    if exist "%TMP%\%~n2.zip" del "%TMP%\%~n2.zip"
    7z a "%TMP%\%~n2.zip" *
    if "%~3" == "" (
        powershell -Command Push-AppveyorArtifact "%TMP%\%~n2.zip" -FileName "test\%~n2.zip"
    ) else (
        powershell -Command Push-AppveyorArtifact "%TMP%\%~n2.zip" -FileName "test\%~3\%~n2.zip"
    )
exit /b %errorlevel%

