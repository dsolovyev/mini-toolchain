setlocal

set "str=%~2"
if defined str exit /b -1

set "str=%~1"
if not defined str exit /b 0
::set str

:: naive implementation
::set /a len=0
::
:::loop
::    set "str=%str:~1%"
::    ::set str
::    set /a len+=1
::if defined str goto :loop

set /a r=1
:search_r
    rem r=%r%
    call set "s=%%str:~%r%,1%%"
    rem s="%s%"
if defined s set /a "r=(r+1 << 1) - 1"& goto :search_r

set /a "len=r+1 >> 1"
call set "str=%%str:~%len%%%"
::set str
if not defined str exit /b %len%
set /a r-=len
rem r=%r%

set /a l=0
:search_m
    set /a "m=l+r >> 1"
    rem m=%m% l=%l% r=%r%
    call set "s=%%str:~%m%,1%%"
    rem s="%s%"
    if defined s (set /a l=m+1) else (set /a r=m)
    rem m=%m% l=%l% r=%r%
if %l% neq %r% goto :search_m

set /a len+=l

exit /b %len%

