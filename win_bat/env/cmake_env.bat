
@echo off

if not "%SETUP_CMAKE%" == "" (
  echo cmake setup is correct
  call cmake --version
  goto :eof
)

echo start cmake setup

set SETUP_CMAKE=%USERPROFILE%\opt\cmake\latest\cmake\bin
if not exist %SETUP_CMAKE% (
  echo cmake not found
  goto :eof
)
path=%PATH%;%SETUP_CMAKE%

call cmake --version
