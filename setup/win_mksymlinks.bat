
@echo off

@echo make symboliclinks
@echo require administrative environment

setlocal
set DOT_VIM_PATH=%USERPROFILE%\dotfiles\vim
set DOTFILE_SETUP=%USERPROFILE%\dotfiles\setup

rem vim 
if exist %USERPROFILE%\_vimrc (
    goto :eof
) else (
    call %DOTFILE_SETUP%\runastest.bat "%USERPROFILE%\_vimrc" "%DOT_VIM_PATH%\vimrc"
)
if exist %USERPROFILE%\_gvimrc (
    goto :eof    
) else (
    call %DOTFILE_SETUP%\runastest.bat "%USERPROFILE%\_gvimrc" "%DOT_VIM_PATH%\gvimrc"
)

rem setup_toolpath_ref
if exist %USERPROFILE%\setup_toolpath.bat (
    goto :eof
) else (
    call %DOTFILE_SETUP%\runastest.bat "%USERPROFILE%\setup_toolpath.bat" "%USERPROFILE%\dotfiles\setup\setup_toolpath.bat"
)

call cmd

endlocal