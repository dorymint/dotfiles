
@echo off

setlocal
call %USERPROFILE%\dotfiles\win_bat\set_python.bat

rem 必要になるまでコメントアウトしておく
rem @call %USERPROFILE%\dotfiles\batch\set_Git_usr_bin.bat
rem

call %USERPROFILE%\opt\vim74-kaoriya-win32\vim.exe

rem undef path to python
endlocal
