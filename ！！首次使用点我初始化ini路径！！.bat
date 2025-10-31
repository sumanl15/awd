@echo off
setlocal

set "TARGETS=replace.bat restore.bat ����һ��ini����.bat"

set /p "NEWPATH=������Engine.ini��·��������E:\DeltaForce\Saved\Config\WindowsClient\Engine.ini����"
if "%NEWPATH%"=="" (
  echo δ����·�������˳���
  exit /b 1
)

set "PS1=%TEMP%\replace_file_line_temp_fix2.ps1"
> "%PS1%" echo param([string]$file,[string]$newPath)
>> "%PS1%" echo if (-not (Test-Path -LiteralPath $file)) { Write-Error "�ļ�������: $file"; exit 1 }
>> "%PS1%" echo $lines = Get-Content -LiteralPath $file -ErrorAction Stop
>> "%PS1%" echo $pattern = '^\s*set\s*\"FILE\s*='
>> "%PS1%" echo $replaced = $false
>> "%PS1%" echo for ($i=0; $i -lt $lines.Count; $i++) {
>> "%PS1%" echo     if ([System.Text.RegularExpressions.Regex]::IsMatch($lines[$i], $pattern, 'IgnoreCase')) {
>> "%PS1%" echo         $lines[$i] = 'set "FILE=' + $newPath + '"'
>> "%PS1%" echo         $replaced = $true
>> "%PS1%" echo         break
>> "%PS1%" echo     }
>> "%PS1%" echo }
>> "%PS1%" echo if (-not $replaced) { Write-Error 'δ�ҵ�ƥ��� set \"FILE= ��' ; exit 1 }
>> "%PS1%" echo Set-Content -LiteralPath $file -Value $lines -Encoding Default -Force

echo.
echo ��ʼ����Engine.ini·��
echo set "FILE=%NEWPATH%"
echo.

for %%F in (%TARGETS%) do (
  if exist "%%~fF" (
    echo ���ڴ���%%~fF
    powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" "%%~fF" "%NEWPATH%"
    if errorlevel 1 (
      echo �����޷��޸� %%~fF
    ) else (
      echo ��ɣ����޸� %%~fF
    )
  ) else (
    echo �������ļ������� %%~fF
  )
)

if exist "%PS1%" del /f /q "%PS1%"

echo.
echo Engine.ini·��������ɣ�������3����˳�
timeout /T 3 /NOBREAK >nul

endlocal
exit /b 0
 