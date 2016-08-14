
@echo off

echo make hard link
rem %1 is target filepath
rem %2 is new hardlink

call fsutil hardlink create "%~1" "%~2"

rem fsutilの代わりにこちらでもいい
rem mklink /H "%~1" "%~2"
rem
