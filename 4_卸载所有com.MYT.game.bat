@echo off

setlocal enabledelayedexpansion

REM 获取设备中所有已安装的应用包名
adb shell pm list packages > packages.txt

REM 逐行读取 packages.txt 文件
for /f "delims=" %%i in (packages.txt) do (
    REM 判断包名是否包含 com.MYT.game
    echo %%i | findstr /i "com.MYT.game" > nul
    if !errorlevel! equ 0 (
        REM 提取包名并卸载应用
        set "line=%%i"
        set "package=!line:~8!"
        echo Uninstalling !package!...
        adb uninstall !package!
    )
)

REM 清理临时文件
del packages.txt

endlocal
 
echo. 卸载完毕 
pause