
@echo off
if "%DOTFILES_ROOT%" == "" goto :eof


setlocal
echo define pyenv
call "%WIN_ENVTOOLPATH%\python_env.bat"

rem 必要になるまでコメントアウトしておく
rem @call %USERPROFILE%\dotfiles\win_bat\env\git-cmd.bat
rem

call "gvim32"

echo undef pyenv
endlocal
