
@echo off

if not "%GOROOT%" == "" goto :eof

echo '--------------------'
echo 'seting GOROOT = %HOMEDRIVE%\Go\Current'
echo '--------------------'

set GOROOT=%HOMEDRIVE%\Go\Current\
PATH=%PATH%;%GOROOT%\bin
