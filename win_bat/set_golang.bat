
@echo off

if not "%GOPATH%" == "" goto :eof

echo --------------------
echo seting GOPATH = %USERPROFILE%\golang
echo --------------------

set GOPATH=%USERPROFILE%\golang
PATH=%PATH%;%GOPATH%\bin
