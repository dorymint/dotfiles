
@echo off

setlocal

if "%DOTFILES_ROOT%" == "%USERPROFILE%\dotfiles"  goto :eof
echo setup_localenv ....
set DOTFILES_ROOT=%USERPROFILE%\dotfiles

set WIN_BATCHTOOLPATH=%DOTFILES_ROOT%\win_bat
PATH=%PATH%;%WIN_BATCHTOOLPATH%

set WIN_ENVTOOLPATH=%WIN_BATCHTOOLPATH%\env
PATH=%PATH%;%WIN_ENVTOOLPATH%

echo localenv_cmd called
call cmd

echo exit_localenv
endlocal
