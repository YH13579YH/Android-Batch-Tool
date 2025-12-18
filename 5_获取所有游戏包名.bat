@echo off

REM 获取设备中所有已安装的应用包名
adb shell pm list packages | findstr "com.MYT.game" > packages.txt

endlocal

pause
