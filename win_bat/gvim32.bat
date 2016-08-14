
@echo off
if "%DOTFILES_ROOT%" == "" goto :eof

echo call_gvim...
echo parameter is ignored
call "%USERPROFILE%\opt\vim74-kaoriya-win32\gvim.exe" .
