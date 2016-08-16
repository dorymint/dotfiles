
@echo off
if "%DOTFILES_ROOT%" == "" goto :eof

echo call_Local_vim...
echo parameter is ignored
call "%USERPROFILE%\opt\vim\latest\vim74-kaoriya-win64\vim.exe" .
