setlocal

set "action=%~1"
if not defined action exit /b 2
set "file=%~2"
if not defined file exit /b 2
set "buffer=%~3"
if not defined buffer exit /b 2
set "nothing=%4"
if defined nothing exit /b 2

call "%~dp0..\string\length.bat" "%file%"
set file_len=%errorlevel%& if %errorlevel% lss 0 echo ERROR: %~nx0: bad "%%file%%" length>&2& exit /b 1

call "%~dp0..\string\length.bat" "%buffer: =%"
set buffer_len2=%errorlevel%& if %errorlevel% lss 0 echo ERROR: %~nx0: bad "%%buffer%%" length>&2& exit /b 1
set /a "mod=buffer_len2 & 1"
if %mod% neq 0 (echo ERROR: %~nx0: bad "%%buffer%%" - not divisible by 2 ^(first check failed^))>&2& exit /b 1
set /a "buffer_size=buffer_len2 >> 1"

call "%~dp0..\string\length.bat" "%buffer%"
set buffer_len=%errorlevel%& if %errorlevel% lss 0 echo ERROR: %~nx0: bad "%%buffer%%" length>&2& exit /b 1
:: 1: 00 - 2
:: 2: 00 01 - 5
:: 3: 00 01 02 - 8
:: 4: 00 01 02 03 - 11
:: 5: 00 01 02 03 04 - 14
set /a "mod=(buffer_len+1) %% 3"
if %mod% neq 0 (echo ERROR: %~nx0: bad "%%buffer%%" - not divisible by 2 ^(second check failed^))>&2& exit /b 1
set /a "buffer_size_check=(buffer_len+1) / 3"
if %buffer_size% neq %buffer_size_check% (echo ERROR: %~nx0: bad "%%buffer%%" - %buffer_size% ^!= %buffer_size_check% ^(third check failed^))>&2& exit /b 1

call "%~dp0..\string\length.bat" "%MINI_TOOLCHAIN_TMP%"
set dir_len=%errorlevel%& if %errorlevel% lss 0 echo ERROR: %~nx0: bad "%%MINI_TOOLCHAIN_TMP%%" length>&2& exit /b 1



:: evaluate block size taking into account cmd.exe's limitation of maximum line length after expansion
:: the line:
::    copy /y /b "out.exe"+"C:\Temp\bin\4D.tmp"+"C:\Temp\bin\5A.tmp" "out.exe">nul

::                     "   C:\Temp  \bin\  4D.tmp  "   +
set /a each_byte_len = 1 + dir_len +  5   +  6  +  1 + 1

if not defined MINI_TOOLCHAIN_MAX_CMD_LINE set MINI_TOOLCHAIN_MAX_CMD_LINE=8000
if not defined MINI_TOOLCHAIN_MAX_OUTPUT_SIZE (
    set /a "MINI_TOOLCHAIN_MAX_OUTPUT_SIZE = (MINI_TOOLCHAIN_MAX_CMD_LINE - 150 - 2*file_len) / each_byte_len"
)

if %MINI_TOOLCHAIN_MAX_OUTPUT_SIZE% leq 0 echo ERROR: block size %MINI_TOOLCHAIN_MAX_OUTPUT_SIZE% is negative or zero>&2& exit /b 2

set /a expanded_line_len = 150 + file_len + MINI_TOOLCHAIN_MAX_OUTPUT_SIZE*each_byte_len + file_len
if %expanded_line_len% geq %MINI_TOOLCHAIN_MAX_CMD_LINE% (
    (echo ERROR: block size %MINI_TOOLCHAIN_MAX_OUTPUT_SIZE% leads to line_len=%expanded_line_len% that is ^>= %MINI_TOOLCHAIN_MAX_CMD_LINE%)>&2
    exit /b 2
)



set /a max_len = 3*MINI_TOOLCHAIN_MAX_OUTPUT_SIZE - 1
set /a max_len_plus_1 = max_len + 1
rem max_len=%max_len%

if "%action%" == "--create" set "append_file="& goto :loop
if "%action%" == "--append" set "append_file="%%file%%"+"& goto :loop
exit /b 2

:loop
    rem append_file='%append_file%'

    :: buffer_size after this 'if' means size for buffer_rem
    if %buffer_size% leq %MINI_TOOLCHAIN_MAX_OUTPUT_SIZE% set buffer_size=0& goto :skip_buf_remainder
        call set "buffer_rem=%%buffer:~%max_len_plus_1%%%"
        call set "buffer=%%buffer:~0,%max_len%%%"
        set /a buffer_size = buffer_size - MINI_TOOLCHAIN_MAX_OUTPUT_SIZE
        rem buffer="%buffer%"
        rem buffer_rem="%buffer_rem%"
        rem buffer_size=%buffer_size%
    :skip_buf_remainder

    :: Example
    ::   buffer=4D 5A
    ::   MINI_TOOLCHAIN_TMP=C:\Temp
    ::   file=out.txt
    :: then the line 'call copy ...' will be expanded to
    ::   copy /y /b "C:\Temp\bin\4D.tmp"+"C:\Temp\bin\5A.tmp" "out.exe">nul

    call copy /y /b %append_file%^"%MINI_TOOLCHAIN_TMP%\bin\%%buffer: =.tmp^"+^"%MINI_TOOLCHAIN_TMP%\bin\%%.tmp^" "%%file%%">nul
    if not %errorlevel% == 0 exit /b %errorlevel%
    if %buffer_size% == 0 exit /b 0
    set "buffer=%buffer_rem%"
    if not defined append_file set "append_file="%%file%%"+"
goto :loop
