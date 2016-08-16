
@echo off

if "%DOTFILES_ROOT%" == "" goto :eof

setlocal
echo define gopath
call "%WIN_ENVTOOLPATH%\golang_env.bat"

pushd %GOPATH%

call "gvim"

echo if you need return dirctory, use command 'popd'...

echo undef gopath
endlocal
