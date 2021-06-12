goto %~1

:TEST_no_argument
    call "%~dp0length.bat"
    if %errorlevel% neq 0 exit /b 1
exit /b 0

:TEST_empty_argument_quoted
    call "%~dp0length.bat" ""
    if %errorlevel% neq 0 exit /b 1
exit /b 0

:TEST_one_character
    call "%~dp0length.bat" a
    if %errorlevel% neq 1 exit /b 1
exit /b 0

:TEST_one_character_quoted
    call "%~dp0length.bat" "a"
    if %errorlevel% neq 1 exit /b 1
exit /b 0

:TEST_two_characters
    call "%~dp0length.bat" ab
    if %errorlevel% neq 2 exit /b 1
exit /b 0

:TEST_three_characters
    call "%~dp0length.bat" abc
    if %errorlevel% neq 3 exit /b 1
exit /b 0

:TEST_four_characters
    call "%~dp0length.bat" abcd
    if %errorlevel% neq 4 exit /b 1
exit /b 0

:TEST_five_characters
    call "%~dp0length.bat" abcde
    if %errorlevel% neq 5 exit /b 1
exit /b 0

:TEST_six_characters
    call "%~dp0length.bat" abcdef
    if %errorlevel% neq 6 exit /b 1
exit /b 0


:TEST_extra_argument
    call "%~dp0length.bat" a b
    if %errorlevel% neq -1 exit /b 1
exit /b 0


:TEST_char_space_char
    call "%~dp0length.bat" "a b"
    if %errorlevel% neq 3 exit /b 1
exit /b 0

:TEST_caret
    call "%~dp0length.bat" ^^
    if %errorlevel% neq 1 exit /b 1
exit /b 0

:TEST_two_carets
    call "%~dp0length.bat" ^^^^
    if %errorlevel% neq 2 exit /b 1
exit /b 0

:TEST_quote_within_quoted_string
    call "%~dp0length.bat" ^"^"123^"
    if %errorlevel% neq 4 exit /b 1
exit /b 0

:TEST_quotes_within_quoted_string
    call "%~dp0length.bat" ^"^"123^"^"
    if %errorlevel% neq 5 exit /b 1
exit /b 0

:TEST_quotes_and_caret_within_quoted_string
    call "%~dp0length.bat" ^"^"123^^^^^"^"
    if %errorlevel% neq 6 exit /b 1
exit /b 0

:TEST_one_caret_is_escape_symbol
    call "%~dp0length.bat" ^"a^b^"
    if %errorlevel% neq 2 exit /b 1
exit /b 0



:TEST_var_is_string_with_spaces
    set var=ab cd ef
    call "%~dp0length.bat" "%var%"
    if %errorlevel% neq 8 exit /b 1
exit /b 0

:TEST_var_is_string_with_spaces_quoted
    set "var=ab cd ef"
    call "%~dp0length.bat" "%var%"
    if %errorlevel% neq 8 exit /b 1
exit /b 0

:TEST_program_files_x86
    call "%~dp0length.bat" "C:\Program Files (x86)"
    if %errorlevel% neq 22 exit /b 1
exit /b 0

:TEST_program_files_x86_var_double
    set "var=C:\Program Files (x86)"
    call "%~dp0length.bat" "%var%;%var%"
    if %errorlevel% neq 45 exit /b 1
exit /b 0

:TEST_twenty_two_spaces
    call "%~dp0length.bat" "                      "
    if %errorlevel% neq 22 exit /b 1
exit /b 0



:: 1..100, 900..1000, 8000..8101
:TEST_mega
set /a i=0
set s=
:loop
    set /a i=%i%+1
    set s=%s%x

    call "%~dp0length.bat" "%s%"
    if %errorlevel% neq %i% echo ERROR: length test failed ^(actual=%errorlevel% expected=%i%^)>&2& exit /b 1

    if %i% equ 100 call :set_900
    if %i% equ 1000 call :set_8000
if %i% lss 8101 goto :loop

goto :skip_set
  :set_900
    set i=899
    set s=%s%%s%%s%%s%%s%%s%%s%%s%%s:~1%
  exit /b
  :set_8000
    set i=7999
    set s=%s%%s%%s%%s%%s%%s%%s%%s:~1%
  exit /b
:skip_set

exit /b 0

