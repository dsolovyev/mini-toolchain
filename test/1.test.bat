goto %~1

:TEST_1_plus_1_equals_2
    if not "%test_global_var%" == "12345" exit /b 1
    set /a val=1+1
    if %val% equ 2 exit /b 0
exit /b 1


:PARAMS_arg_is_abc_or_123
    if not "%test_global_var%" == "12345" exit /b 1
    set TEST_PARAMS=arg
    set TEST_PARAMS[arg]=abc 123
exit /b 0

:TEST_arg_is_abc_or_123
    if not "%test_global_var%" == "12345" exit /b 1
    if "%arg%" == "abc" exit /b 0
    if "%arg%" == "123" exit /b 0
exit /b 1


:PARAMS_2args
    if not "%test_global_var%" == "12345" exit /b 1
    set TEST_PARAMS=num str
    set TEST_PARAMS[num]=2 3 5
    set TEST_PARAMS[str]=string1 "string2 with spaces"
exit /b 0

:TEST_2args
    if not "%test_global_var%" == "12345" exit /b 1
    if "%num%" == "2" if "%str%" == "string1" exit /b 0
    if "%num%" == "2" if "%str%" == "string2 with spaces" exit /b 0
    if "%num%" == "3" if "%str%" == "string1" exit /b 0
    if "%num%" == "3" if "%str%" == "string2 with spaces" exit /b 0
    if "%num%" == "5" if "%str%" == "string1" exit /b 0
    if "%num%" == "5" if "%str%" == "string2 with spaces" exit /b 0
exit /b 1


:INIT
    set test_global_var=12345
exit /b 0

:CLEANUP
    if not "%test_global_var%" == "12345" exit /b 1
exit /b 0

