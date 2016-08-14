
@echo off

call python -V 2> nul
if %ERRORLEVEL% == 0 goto :eof

PATH=%PATH%;%LOCALAPPDATA%\Programs\Python\Python35-32
PATH=%PATH%;%LOCALAPPDATA%\Programs\Python\Python35-32\Scripts

echo --------------------
echo seting python...
echo --------------------
call python -V

