set MINI_TOOLCHAIN_TMP=
if defined TEMP set "MINI_TOOLCHAIN_TMP=%TEMP%\mini-toolchain"
if defined TMP set "MINI_TOOLCHAIN_TMP=%TMP%\mini-toolchain"

if not defined MINI_TOOLCHAIN_TMP exit /b 1
if not exist "%MINI_TOOLCHAIN_TMP%" (
    md "%MINI_TOOLCHAIN_TMP%"
    compact /c /s:"%MINI_TOOLCHAIN_TMP%"
)>nul 2>&1
if not exist "%MINI_TOOLCHAIN_TMP%" exit /b 1

exit /b 0
