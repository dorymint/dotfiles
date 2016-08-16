
@echo off
if "%DOTFILES_ROOT%" == "" goto :eof


setlocal
echo define pyenv
call "%WIN_ENVTOOLPATH%\python_env.bat"

call "gvim32"

echo undef pyenv
endlocal
