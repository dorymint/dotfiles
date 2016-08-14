
@echo off
if "%DOTFILES_ROOT%" == "" goto :eof

echo call_Local_vim...
echo parameter is ignored
call "%USERPROFILE%\opt\vim74-kaoriya-win32\vim.exe" .
