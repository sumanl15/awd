@echo off
setlocal enabledelayedexpansion

rem ====== 配置区 ======
rem 监测进程与间隔（秒）
set "TARGET_REPLACE=ACE-Helper.exe"
set "TARGET_RESTORE=UnrealCEFSubProcess.exe"
set "CHECK_INTERVAL=0"
rem =================

set "FILE=D:\WeGameApps\rail_apps\DeltaForce(2001918)\DeltaForce\Saved\Config\WindowsClient\Engine.ini"
set "INSERT="
set "INSERTFILE_REPLACE=%~dp0ini参数放这里-替换用.txt"
set "INSERTFILE_RESTORE=%~dp0留空不要动不要删-还原用.txt"
set "PS_ENCODING=UTF8"

set "REPLACED=0"
set "RESTORED=0"

set "LAST_REPLACE=0"
set "LAST_RESTORE=0"

echo ===工具完全免费 倒卖没亩-by 117il3===
echo 开始监测：当 %TARGET_REPLACE% 启动时执行替换，当 %TARGET_RESTORE% 启动时执行还原
echo 按 Ctrl+C 停止

:LOOP
tasklist /FI "IMAGENAME eq %TARGET_REPLACE%" 2>nul | findstr /I /C:"%TARGET_REPLACE%" >nul
if %errorlevel%==0 (
  set "CUR_REPLACE=1"
) else (
  set "CUR_REPLACE=0"
)

tasklist /FI "IMAGENAME eq %TARGET_RESTORE%" 2>nul | findstr /I /C:"%TARGET_RESTORE%" >nul
if %errorlevel%==0 (
  set "CUR_RESTORE=1"
) else (
  set "CUR_RESTORE=0"
)

if "%LAST_REPLACE%"=="0" if "%CUR_REPLACE%"=="1" (
  echo [%TIME%] 检测到 %TARGET_REPLACE% 启动
  if "%REPLACED%"=="0" (
    echo [%TIME%] 开始执行替换操作（replace.bat）...
    call "%~dp0replace.bat"
    echo [%TIME%] 替换完成
    set "REPLACED=1"
    set "RESTORED=0"
  )
)

if "%REPLACED%"=="1" if "%CUR_REPLACE%"=="0" (
  echo [%TIME%] %TARGET_REPLACE% 已退出，重置替换标志
  set "REPLACED=0"
)

if "%LAST_RESTORE%"=="0" if "%CUR_RESTORE%"=="1" (
  echo [%TIME%] 检测到 %TARGET_RESTORE% 启动
  if "%RESTORED%"=="0" (
    echo [%TIME%] 开始执行还原操作（restore.bat）...
    call "%~dp0restore.bat"
    echo [%TIME%] 还原完成
    set "RESTORED=1"
    set "REPLACED=0"

    echo.
    echo 程序将在3秒后自动关闭
    timeout /T 3 /NOBREAK >nul
    exit /b 0
  )
)

if "%RESTORED%"=="1" if "%CUR_RESTORE%"=="0" (
  echo [%TIME%] %TARGET_RESTORE% 已退出，重置还原标志
  set "RESTORED=0"
)

set "LAST_REPLACE=%CUR_REPLACE%"
set "LAST_RESTORE=%CUR_RESTORE%"

timeout /T %CHECK_INTERVAL% /NOBREAK >nul
goto LOOP
 
