
@echo off
echo  check DOTFILES_ROOT

if "%DOTFILES_ROOT%" == "" (
    echo 'do not called setup_localenv.bat'
    echo 'cmd_exit!'
    pause
    exit(1)
)

echo is valid