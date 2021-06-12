goto %~1

:TEST_0
    call "%~dp0int_to_hex4le.bat" 0|| exit /b 1
    if not "%result%" == "00 00 00 00" exit /b 1
exit /b 0

:TEST_1
    call "%~dp0int_to_hex4le.bat" 1|| exit /b 1
    if not "%result%" == "01 00 00 00" exit /b 1
exit /b 0

:TEST_2
    call "%~dp0int_to_hex4le.bat" 2|| exit /b 1
    if not "%result%" == "02 00 00 00" exit /b 1
exit /b 0

:TEST_7
    call "%~dp0int_to_hex4le.bat" 7|| exit /b 1
    if not "%result%" == "07 00 00 00" exit /b 1
exit /b 0

:TEST_8
    call "%~dp0int_to_hex4le.bat" 8|| exit /b 1
    if not "%result%" == "08 00 00 00" exit /b 1
exit /b 0

:TEST_9
    call "%~dp0int_to_hex4le.bat" 9|| exit /b 1
    if not "%result%" == "09 00 00 00" exit /b 1
exit /b 0

:TEST_10
    call "%~dp0int_to_hex4le.bat" 10|| exit /b 1
    if not "%result%" == "0A 00 00 00" exit /b 1
exit /b 0

:TEST_11
    call "%~dp0int_to_hex4le.bat" 11|| exit /b 1
    if not "%result%" == "0B 00 00 00" exit /b 1
exit /b 0

:TEST_12
    call "%~dp0int_to_hex4le.bat" 12|| exit /b 1
    if not "%result%" == "0C 00 00 00" exit /b 1
exit /b 0

:TEST_13
    call "%~dp0int_to_hex4le.bat" 13|| exit /b 1
    if not "%result%" == "0D 00 00 00" exit /b 1
exit /b 0

:TEST_14
    call "%~dp0int_to_hex4le.bat" 14|| exit /b 1
    if not "%result%" == "0E 00 00 00" exit /b 1
exit /b 0

:TEST_15
    call "%~dp0int_to_hex4le.bat" 15|| exit /b 1
    if not "%result%" == "0F 00 00 00" exit /b 1
exit /b 0



:TEST_16
    call "%~dp0int_to_hex4le.bat" 16|| exit /b 1
    if not "%result%" == "10 00 00 00" exit /b 1
exit /b 0

:TEST_17
    call "%~dp0int_to_hex4le.bat" 17|| exit /b 1
    if not "%result%" == "11 00 00 00" exit /b 1
exit /b 0

:TEST_23
    call "%~dp0int_to_hex4le.bat" 23|| exit /b 1
    if not "%result%" == "17 00 00 00" exit /b 1
exit /b 0

:TEST_24
    call "%~dp0int_to_hex4le.bat" 24|| exit /b 1
    if not "%result%" == "18 00 00 00" exit /b 1
exit /b 0

:TEST_25
    call "%~dp0int_to_hex4le.bat" 25|| exit /b 1
    if not "%result%" == "19 00 00 00" exit /b 1
exit /b 0

:TEST_26
    call "%~dp0int_to_hex4le.bat" 26|| exit /b 1
    if not "%result%" == "1A 00 00 00" exit /b 1
exit /b 0

:TEST_27
    call "%~dp0int_to_hex4le.bat" 27|| exit /b 1
    if not "%result%" == "1B 00 00 00" exit /b 1
exit /b 0

:TEST_28
    call "%~dp0int_to_hex4le.bat" 28|| exit /b 1
    if not "%result%" == "1C 00 00 00" exit /b 1
exit /b 0

:TEST_29
    call "%~dp0int_to_hex4le.bat" 29|| exit /b 1
    if not "%result%" == "1D 00 00 00" exit /b 1
exit /b 0

:TEST_30
    call "%~dp0int_to_hex4le.bat" 30|| exit /b 1
    if not "%result%" == "1E 00 00 00" exit /b 1
exit /b 0

:TEST_31
    call "%~dp0int_to_hex4le.bat" 31|| exit /b 1
    if not "%result%" == "1F 00 00 00" exit /b 1
exit /b 0

:TEST_32
    call "%~dp0int_to_hex4le.bat" 32|| exit /b 1
    if not "%result%" == "20 00 00 00" exit /b 1
exit /b 0



:TEST_127
    call "%~dp0int_to_hex4le.bat" 127|| exit /b 1
    if not "%result%" == "7F 00 00 00" exit /b 1
exit /b 0

:TEST_128
    call "%~dp0int_to_hex4le.bat" 128|| exit /b 1
    if not "%result%" == "80 00 00 00" exit /b 1
exit /b 0

:TEST_255
    call "%~dp0int_to_hex4le.bat" 255|| exit /b 1
    if not "%result%" == "FF 00 00 00" exit /b 1
exit /b 0



:TEST_256
    call "%~dp0int_to_hex4le.bat" 256|| exit /b 1
    if not "%result%" == "00 01 00 00" exit /b 1
exit /b 0

:TEST_257
    call "%~dp0int_to_hex4le.bat" 257|| exit /b 1
    if not "%result%" == "01 01 00 00" exit /b 1
exit /b 0

:TEST_272
    call "%~dp0int_to_hex4le.bat" 272|| exit /b 1
    if not "%result%" == "10 01 00 00" exit /b 1
exit /b 0

:TEST_273
    call "%~dp0int_to_hex4le.bat" 273|| exit /b 1
    if not "%result%" == "11 01 00 00" exit /b 1
exit /b 0

:TEST_1024
    call "%~dp0int_to_hex4le.bat" 1024|| exit /b 1
    if not "%result%" == "00 04 00 00" exit /b 1
exit /b 0

:TEST_4096
    call "%~dp0int_to_hex4le.bat" 4096|| exit /b 1
    if not "%result%" == "00 10 00 00" exit /b 1
exit /b 0

:TEST_32767
    call "%~dp0int_to_hex4le.bat" 32767|| exit /b 1
    if not "%result%" == "FF 7F 00 00" exit /b 1
exit /b 0

:TEST_32768
    call "%~dp0int_to_hex4le.bat" 32768|| exit /b 1
    if not "%result%" == "00 80 00 00" exit /b 1
exit /b 0

:TEST_65535
    call "%~dp0int_to_hex4le.bat" 65535|| exit /b 1
    if not "%result%" == "FF FF 00 00" exit /b 1
exit /b 0



:TEST_65536
    call "%~dp0int_to_hex4le.bat" 65536|| exit /b 1
    if not "%result%" == "00 00 01 00" exit /b 1
exit /b 0

:TEST_1193046
    call "%~dp0int_to_hex4le.bat" 1193046|| exit /b 1
    if not "%result%" == "56 34 12 00" exit /b 1
exit /b 0

:TEST_8388607
    call "%~dp0int_to_hex4le.bat" 8388607|| exit /b 1
    if not "%result%" == "FF FF 7F 00" exit /b 1
exit /b 0

:TEST_16777215
    call "%~dp0int_to_hex4le.bat" 16777215|| exit /b 1
    if not "%result%" == "FF FF FF 00" exit /b 1
exit /b 0



:TEST_16777216
    call "%~dp0int_to_hex4le.bat" 16777216|| exit /b 1
    if not "%result%" == "00 00 00 01" exit /b 1
exit /b 0

:TEST_2023406814
    call "%~dp0int_to_hex4le.bat" 2023406814|| exit /b 1
    if not "%result%" == "DE BC 9A 78" exit /b 1
exit /b 0

:TEST_minus_1735812983
    call "%~dp0int_to_hex4le.bat" -1735812983|| exit /b 1
    if not "%result%" == "89 98 89 98" exit /b 1
exit /b 0

:TEST_2000000000
    call "%~dp0int_to_hex4le.bat" 2000000000|| exit /b 1
    if not "%result%" == "00 94 35 77" exit /b 1
exit /b 0

:TEST_2147483647
    call "%~dp0int_to_hex4le.bat" 2147483647|| exit /b 1
    if not "%result%" == "FF FF FF 7F" exit /b 1
exit /b 0

:TEST_minus_2147483647
    call "%~dp0int_to_hex4le.bat" -2147483647|| exit /b 1
    if not "%result%" == "01 00 00 80" exit /b 1
exit /b 0

:TEST_minus_2147483648
    call "%~dp0int_to_hex4le.bat" -2147483648|| exit /b 1
    if not "%result%" == "00 00 00 80" exit /b 1
exit /b 0

:TEST_minus_1
    call "%~dp0int_to_hex4le.bat" -1|| exit /b 1
    if not "%result%" == "FF FF FF FF" exit /b 1
exit /b 0

:TEST_minus_2
    call "%~dp0int_to_hex4le.bat" -2|| exit /b 1
    if not "%result%" == "FE FF FF FF" exit /b 1
exit /b 0

