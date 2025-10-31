@echo off
setlocal

set "TARGETS=replace.bat restore.bat 点我一键ini过检.bat"

set /p "NEWPATH=请输入Engine.ini的路径（例如E:\DeltaForce\Saved\Config\WindowsClient\Engine.ini）："
if "%NEWPATH%"=="" (
  echo 未输入路径，已退出。
  exit /b 1
)

set "PS1=%TEMP%\replace_file_line_temp_fix2.ps1"
> "%PS1%" echo param([string]$file,[string]$newPath)
>> "%PS1%" echo if (-not (Test-Path -LiteralPath $file)) { Write-Error "文件不存在: $file"; exit 1 }
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
>> "%PS1%" echo if (-not $replaced) { Write-Error '未找到匹配的 set \"FILE= 行' ; exit 1 }
>> "%PS1%" echo Set-Content -LiteralPath $file -Value $lines -Encoding Default -Force

echo.
echo 开始更新Engine.ini路径
echo set "FILE=%NEWPATH%"
echo.

for %%F in (%TARGETS%) do (
  if exist "%%~fF" (
    echo 正在处理：%%~fF
    powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%" "%%~fF" "%NEWPATH%"
    if errorlevel 1 (
      echo 错误：无法修改 %%~fF
    ) else (
      echo 完成：已修改 %%~fF
    )
  ) else (
    echo 跳过：文件不存在 %%~fF
  )
)

if exist "%PS1%" del /f /q "%PS1%"

echo.
echo Engine.ini路径更新完成，程序将在3秒后退出
timeout /T 3 /NOBREAK >nul

endlocal
exit /b 0
 