
echo runastest
echo %~1
echo %~2

rem tset
rem goto :eof

set arguments="/c","mklink","%1","%2"

powershell.exe -Command Start-Process ^
    -FilePath "cmd" ^
    -ArgumentList %arguments% ^
    -Verb Runas
