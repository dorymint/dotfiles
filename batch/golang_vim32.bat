
@echo off

setlocal
call "%USERPROFILE%\dotfiles\batch\set_golang.bat"

rem 必要になるまでコメントアウトしておく
rem call %USERPROFILE%\call\set_Git_usr_bin.bat
rem

pushd %GOPATH%

call "%USERPROFILE%\opt\vim74-kaoriya-win32\vim.exe"

echo if you need return dirctory, use command 'popd'...

rem undef gopath
endlocal
