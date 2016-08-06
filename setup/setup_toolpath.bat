
@echo off
echo setup_localenv
setlocal
if "%SETUP_TOOLPATH_CALLED%" == "TRUE" goto :eof

rem setting env path
rem path+=~/dotfiles/win_bat

echo setup toolpath
set SETUP_TOOLPATH_CALLED=%USERPROFILE%\dotfiles\win_bat\
if exist not %SETUP_TOOLPATH_CALLED% goto :eof
PATH=%PATH%;%SETUP_TOOLPATH_CALLED%

set SETUP_TOOLPATH_CALLED=TRUE


echo setup_cmake
set SETUP_CMAKE=%USERPROFILE%\opt\cmake-3.6.1-win64-x64\bin
if not exist %SETUP_CMAKE% ( goto :eof )
path=%PATH%;%SETUP_CMAKE%


rem localset_env_cmd
call cmd

echo exit_localenv
endlocal

