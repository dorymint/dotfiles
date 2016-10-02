rem tset
rem this batch is unstable
rem

if "%DOTFILES_ROOT%" == "" (
    echo require localenv
    goto :eof
)

echo runastest
echo %~1
echo %~2

set arguments="/c","mklink","%1","%2"

powershell.exe -Command Start-Process ^
    -FilePath "cmd" ^
    -ArgumentList %arguments% ^
    -Verb Runas
