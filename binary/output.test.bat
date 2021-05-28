setlocal
cd binary

call ..\fs\mktemp_dir.bat test.binary.output. || exit /b 1
set "TMP=%result%"

call ..\fs\init_global_tmp.bat || exit /b 1
call .\create_template_bytes.bat || exit /b 1


call :do_tests
rd /s /q "%TMP%"& exit /b %errorlevel%




:do_tests

setlocal& call .\output.bat --create "%TMP%\size_1.bin" 00|| exit /b 1
call :check_size "%TMP%\size_1.bin" 1 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_1.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,16) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_16.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_16.bin" 16 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_16.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,32) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_32.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_32.bin" 32 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_32.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,64) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_64.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_64.bin" 64 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_64.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,128) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_128.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_128.bin" 128 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_128.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,256) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_256.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_256.bin" 256 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_256.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,512) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_512.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_512.bin" 512 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_512.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,1024) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_1024.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_1024.bin" 1024 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_1024.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,2048) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_2048.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_2048.bin" 2048 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_2048.bin"
endlocal

setlocal& set out=61
setlocal enabledelayedexpansion& for /l %%i in (2,1,2500) do set "out=!out! 0a"
endlocal& call .\output.bat --create "%TMP%\size_2500.bin" "%out%"|| exit /b 1
call :check_size "%TMP%\size_2500.bin" 2500 echo ERROR: test failed>&2|| exit /b 1
del "%TMP%\size_2500.bin"
endlocal


echo %~nx0: all tests passed
exit /b 0




:check_size
    setlocal
    set size_regex=%2
    if %2 lss 1000 goto :check_size__less_1000
        set "size_regex=%size_regex:~0,-3%.%size_regex:~-3%"
    :check_size__less_1000
    (
        dir "%~1"2>nul|| echo ERROR: cannot find "%~1">&2
    ) | findstr /r /c:"%size_regex% %~nx1$">nul|| ((echo ERROR: "%~1" size != %2, dir's OUTPUT:& dir "%~1")>&2& exit /b 1)
exit /b 0
