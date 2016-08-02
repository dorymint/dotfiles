
@echo off

if "%GOPATH%" == "%USERPROFILE%\golang" goto :eof

echo --------------------
echo seting GOPATH = %USERPROFILE%\golang
echo --------------------

set GOPATH=%USERPROFILE%\golang
PATH=%PATH%;%GOPATH%\bin
