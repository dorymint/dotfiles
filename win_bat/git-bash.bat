
@echo off
if "%DOTFILES_ROOT%" == "" goto :eof

setlocal
call "%programfiles%/Git/git-bash.exe"
endlocal
