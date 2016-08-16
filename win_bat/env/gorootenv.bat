
@echo off

if not "%GOROOT%" == "" goto :eof

echo --------------------
echo seting GOROOT = %HOMEDRIVE%\Go\latest\go
echo --------------------

set GOROOT=%HOMEDRIVE%\Go\latest\go
PATH=%PATH%;%GOROOT%\bin
