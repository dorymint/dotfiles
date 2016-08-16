
@echo off
echo  check DOTFILES_ROOT

if "%DOTFILES_ROOT%" == "" (
    echo local_environment is no setup
    echo cmd_exit!
    pause
    exit(1)
)

echo is valid
