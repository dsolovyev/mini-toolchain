setlocal
pushd "%MY_TMP%"
makecab /d RptFileName=cur_datetime.rpt /d InfFileName=cur_datetime.inf /f nul>nul
set cur_year=
set cur_the_rest=
for /f "tokens=4-9* delims=: "eol^= %%A in (cur_datetime.rpt) do (
    set cur_month=%%A
    set cur_day=%%B
    set cur_hour=%%C
    set cur_minute=%%D
    set cur_second=%%E
    set cur_year=%%F
    set cur_the_rest=%%G
    goto :first_line_is_needed_only
)
:first_line_is_needed_only
del cur_datetime.rpt cur_datetime.inf>nul
popd

if defined cur_the_rest echo ERROR: bad datetime format>&2& exit /b 1
if not defined cur_year echo ERROR: bad datetime format>&2& exit /b 1

goto :%cur_month% >nul 2>&1 || (echo ERROR: bad datetime format>&2& exit /b 1)
echo ERROR: bad datetime format>&2
exit /b 1
:Jan
    set cur_month=01& goto :to_exit
:Feb
    set cur_month=02& goto :to_exit
:Mar
    set cur_month=03& goto :to_exit
:Apr
    set cur_month=04& goto :to_exit
:May
    set cur_month=05& goto :to_exit
:Jun
    set cur_month=06& goto :to_exit
:Jul
    set cur_month=07& goto :to_exit
:Aug
    set cur_month=08& goto :to_exit
:Sep
    set cur_month=09& goto :to_exit
:Oct
    set cur_month=10& goto :to_exit
:Nov
    set cur_month=11& goto :to_exit
:Dec
    set cur_month=12& goto :to_exit

:to_exit
endlocal& set cur_year=%cur_year%& set cur_month=%cur_month%& set cur_day=%cur_day%& set cur_hour=%cur_hour%& set cur_minute=%cur_minute%& set cur_second=%cur_second%

