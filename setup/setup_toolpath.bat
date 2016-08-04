
@echo off
echo setup_localenv
setlocal
if "%SETUP_TOOLPATH_CALLED%" == "TRUE" goto :eof

rem setting env path
rem path+=~/dotfiles/win_bat

set SETUP_TOOLPATH_CALLED=%USERPROFILE%\dotfiles\win_bat\
if exist not %SETUP_TOOLPATH_CALLED% goto :eof
PATH=%PATH%;%SETUP_TOOLPATH_CALLED%

set SETUP_TOOLPATH_CALLED=TRUE

rem localset_env_cmd
call cmd

echo exit_localenv
endlocal