
@echo off

if not "%GOROOT%" == "" goto :eof

echo --------------------
echo seting GOROOT = %HOMEDRIVE%\Go
echo --------------------

set GOROOT=%HOMEDRIVE%\Go
PATH=%PATH%;%GOROOT%\bin
