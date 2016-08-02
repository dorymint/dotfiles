rem
rem this file is disuse?
rem

@echo off

call git --version 2> nul
if %ERRORLEVEL% == 0 goto :eof

call "%PROGRAMFILES%\Git\git-cmd.exe"

echo --------------------
echo set Git
echo --------------------

call git --version

