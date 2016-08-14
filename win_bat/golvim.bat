
@echo off

if "%DOTFILES_ROOT%" == "" goto :eof

setlocal
echo define gopath
call "%WIN_ENVTOOLPATH%\golang_env.bat"

rem 必要になるまでコメントアウトしておく
rem call %USERPROFILE%\call\set_Git_usr_bin.bat
rem

pushd %GOPATH%

call "lvim"

echo if you need return dirctory, use command 'popd'...

echo undef gopath
endlocal
