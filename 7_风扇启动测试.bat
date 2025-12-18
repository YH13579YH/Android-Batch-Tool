
@echo off
echo. 请检查风扇是否运转

set INTERVAL= 1
:Again  
adb.exe shell < shellOrder.sh
timeout %INTERVAL%

goto Again

pause




