
@echo off

if "%DOTFILES_ROOT%" == "" goto :eof
if not "%GOPATH%" == "" goto :eof
call "%DOTFILES_ROOT%\win_bat\env\gorootenv.bat"

echo --------------------
echo seting GOPATH = %USERPROFILE%\golang
echo --------------------

set GOPATH=%USERPROFILE%\golang
PATH=%PATH%;%GOPATH%\bin
