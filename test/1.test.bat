goto "%1"

:TEST_1_plus_1_equals_2
    set /a val=1+1
    if %val% equ 22222 exit /b 0
exit /b 1


:PARAMS_arg_is_abc_or_123
    set TEST_PARAMS=arg
    set TEST_PARAMS[arg]=abc 123 xxx
exit /b 0

:TEST_arg_is_abc_or_123
    if "%arg%" == "abc" exit /b 0
    if "%arg%" == "123" exit /b 0
exit /b 1


:PARAMS_2args
    set TEST_PARAMS=num str
    set TEST_PARAMS[num]=2 3 5
    set TEST_PARAMS[str]=string1 "string2 with spaces"
exit /b 0


:INIT
    echo Hello from INIT
exit /b 0

:CLEANUP
    echo Hello from CLEANUP
exit /b 0

