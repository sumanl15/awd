@echo off
setlocal enabledelayedexpansion

rem ====== ������ ======
rem �������������룩
set "TARGET_REPLACE=ACE-Helper.exe"
set "TARGET_RESTORE=UnrealCEFSubProcess.exe"
set "CHECK_INTERVAL=0"
rem =================

set "FILE=D:\WeGameApps\rail_apps\DeltaForce(2001918)\DeltaForce\Saved\Config\WindowsClient\Engine.ini"
set "INSERT="
set "INSERTFILE_REPLACE=%~dp0ini����������-�滻��.txt"
set "INSERTFILE_RESTORE=%~dp0���ղ�Ҫ����Ҫɾ-��ԭ��.txt"
set "PS_ENCODING=UTF8"

set "REPLACED=0"
set "RESTORED=0"

set "LAST_REPLACE=0"
set "LAST_RESTORE=0"

echo ===������ȫ��� ����ûĶ-by 117il3===
echo ��ʼ��⣺�� %TARGET_REPLACE% ����ʱִ���滻���� %TARGET_RESTORE% ����ʱִ�л�ԭ
echo �� Ctrl+C ֹͣ

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
  echo [%TIME%] ��⵽ %TARGET_REPLACE% ����
  if "%REPLACED%"=="0" (
    echo [%TIME%] ��ʼִ���滻������replace.bat��...
    call "%~dp0replace.bat"
    echo [%TIME%] �滻���
    set "REPLACED=1"
    set "RESTORED=0"
  )
)

if "%REPLACED%"=="1" if "%CUR_REPLACE%"=="0" (
  echo [%TIME%] %TARGET_REPLACE% ���˳��������滻��־
  set "REPLACED=0"
)

if "%LAST_RESTORE%"=="0" if "%CUR_RESTORE%"=="1" (
  echo [%TIME%] ��⵽ %TARGET_RESTORE% ����
  if "%RESTORED%"=="0" (
    echo [%TIME%] ��ʼִ�л�ԭ������restore.bat��...
    call "%~dp0restore.bat"
    echo [%TIME%] ��ԭ���
    set "RESTORED=1"
    set "REPLACED=0"

    echo.
    echo ������3����Զ��ر�
    timeout /T 3 /NOBREAK >nul
    exit /b 0
  )
)

if "%RESTORED%"=="1" if "%CUR_RESTORE%"=="0" (
  echo [%TIME%] %TARGET_RESTORE% ���˳������û�ԭ��־
  set "RESTORED=0"
)

set "LAST_REPLACE=%CUR_REPLACE%"
set "LAST_RESTORE=%CUR_RESTORE%"

timeout /T %CHECK_INTERVAL% /NOBREAK >nul
goto LOOP
 
