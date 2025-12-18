@echo off
:: 检查设备是否连接
adb devices | findstr /C:"device" >nul
if %errorlevel% neq 0 (
    echo 设备未连接！
    pause
    exit /b
)

:: 获取所有已安装应用的包名
echo 正在获取安装的应用程序列表...
adb shell pm list packages -3 > packages.txt

:: 清空输出文件
echo. > installed_apps.txt

:: 循环读取每个包名并获取应用名称
for /f "tokens=2 delims=:" %%i in (packages.txt) do (
    echo 正在处理包名：%%i
    :: 使用 `dumpsys` 命令获取应用的名称
    adb shell dumpsys package %%i | findstr /R /C:"label=" > temp.txt
    set /p appname=<temp.txt
    echo 包名：%%i 应用名称：%appname:label= % >> installed_apps.txt
)

:: 清理临时文件
del packages.txt
del temp.txt

echo 完成！应用信息已保存到 installed_apps.txt
pause
