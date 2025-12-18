@ECHO OFF
setlocal enabledelayedexpansion

:: 检查是否有拖放的文件
if "%~1"=="" (
    echo Please drag and drop an APK file onto this script.
    pause
    exit /b
)

:: 确保拖放的是 .apk 文件
if /i not "%~x1"==".apk" (
    echo The file you dragged is not an APK file. Please drag and drop a valid APK file.
    pause
    exit /b
)

:: 安装 APK 文件
echo Installing "%~1" ...
%~dp0adb.exe install -r "%~1"

if %errorlevel% equ 0 (
    echo Installation successful.
) else (
    echo Installation failed. Please check the error above.
)

pause
