@ECHO OFF
chcp 65001 > nul
setlocal enabledelayedexpansion
set /a sum=0
set /a success=0
set /a fail=0

:: 检查是否有拖拽的文件或文件夹作为参数
if "%~1" neq "" (
    :: 检查参数是文件夹还是文件
    if exist "%~1\*" (
        :: 如果是文件夹，使用该文件夹作为搜索路径
        set "target_dir=%~1"
        echo 正在安装文件夹: !target_dir! 中的所有APK文件
        echo ************************************************************
        echo.
        :: 将指定文件夹中的文件列表写入临时文件
        dir /b /s "!target_dir!\*.apk" > filelist.txt
    ) else (
        :: 如果是文件，使用该文件所在的文件夹作为搜索路径
        set "target_dir=%~dp1"
        echo 检测到单个APK文件: %~1
        echo 正在安装该文件所在文件夹: !target_dir! 中的所有APK文件
        echo ************************************************************
        echo.
        :: 将该文件夹中的文件列表写入临时文件
        dir /b /s "!target_dir!\*.apk" > filelist.txt
    )
) else (
    :: 如果没有拖拽的文件或文件夹，使用当前目录
    echo 正在安装当前目录及其子目录中的所有APK文件
    :: 将当前目录中的文件列表写入临时文件
    dir /b /s *.apk > filelist.txt
)

:: 检查安装失败文件文件夹是否存在，如果不存在则创建
if not exist "%~dp0安装失败文件\" (
    mkdir "%~dp0安装失败文件"
    echo 创建安装失败文件文件夹: "%~dp0安装失败文件"
)

:: 在安装失败文件文件夹中创建带年月日时分的子文件夹
:: 获取年、月、日、时、分
set "year=%date:~0,4%"
set "month=%date:~5,2%"
set "day=%date:~8,2%"
set "hour=%time:~0,2%"
set "minute=%time:~3,2%"

:: 移除前导零
set /a month=1%month%-100
set /a day=1%day%-100
set /a hour=1%hour%-100
set /a minute=1%minute%-100

:: 处理凌晨时间的空格问题
if %hour% lss 10 set "hour=0%hour%"

:: 组合成YYYY_M_D_H_M格式
set "datetime=%year%_%month%_%day%_%hour%_%minute%"
set "fail_dir=%~dp0安装失败文件\%datetime%"
mkdir "!fail_dir!"
echo 创建本次安装失败文件保存目录: "!fail_dir!"
echo ************************************************************
echo.

:: 按字母顺序排序文件列表
for /f "delims=" %%x in ('sort filelist.txt') do (
    set /a sum=sum+1
    echo !sum! 请等待，正在安装 %%x

    %~dp0adb.exe install -r "%%x"
    if !errorlevel! equ 0 (
        set /a success=success+1
        echo 安装成功!
    ) else (
        set /a fail=fail+1
        echo 安装失败!
        echo 将失败的APK文件复制到本次安装失败文件目录...
        copy "%%x" "!fail_dir!\" > nul
        if !errorlevel! equ 0 (
            echo 复制成功: %%~nxx
        ) else (
            echo 复制失败: %%~nxx
        )
    )

    echo.
)

:: 清除临时文件
del filelist.txt

echo ----------------------------------------
echo 安装总结:
echo 总计安装数量: !sum!
echo 成功安装数量: !success!
echo 失败安装数量: !fail!
echo ----------------------------------------
pause