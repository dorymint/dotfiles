
@echo off

if not "%SETUP_CMAKE%" == "" (
    call cmake --version
    goto :eof
)

echo setup_cmake

set SETUP_CMAKE=%USERPROFILE%\opt\cmake-3.6.1-win64-x64\bin
if not exist %SETUP_CMAKE% ( goto :eof )
path=%PATH%;%SETUP_CMAKE%

call cmake --version
