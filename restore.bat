@echo off
rem ====== 配置区 ======
set "FILE=D:\WeGameApps\rail_apps\DeltaForce(2001918)\DeltaForce\Saved\Config\WindowsClient\Engine.ini"
set "INSERT="
set "INSERTFILE=%~dp0留空不要动不要删-还原用.txt"
set "PS_ENCODING=UTF8"
rem =================

set "PSFILE=%TEMP%\modify_engine_replace_after_blank.ps1"

> "%PSFILE%" echo param([string]$path,[string]$insert,[string]$insertFile,[string]$encoding)
>> "%PSFILE%" echo if (-not (Test-Path -LiteralPath $path)) { Write-Error "文件不存在: $path"; exit 1 }
>> "%PSFILE%" echo $lines = Get-Content -LiteralPath $path -ErrorAction Stop
>> "%PSFILE%" echo if ($lines.Count -eq 0) { Write-Error "文件为空"; exit 1 }
>> "%PSFILE%" echo $result = New-Object System.Collections.Generic.List[string]
>> "%PSFILE%" echo $result.Add($lines[0])
>> "%PSFILE%" echo $i = 1
>> "%PSFILE%" echo while ($i -lt $lines.Count -and $lines[$i].Trim() -ne '') {
>> "%PSFILE%" echo     $result.Add($lines[$i])
>> "%PSFILE%" echo     $i++
>> "%PSFILE%" echo }
>> "%PSFILE%" echo if ($i -lt $lines.Count -and $lines[$i].Trim() -eq '') {
>> "%PSFILE%" echo     $result.Add('') 
>> "%PSFILE%" echo } else {
>> "%PSFILE%" echo     $result.Add('')
>> "%PSFILE%" echo }
>> "%PSFILE%" echo if ($insertFile -and (Test-Path -LiteralPath $insertFile)) {
>> "%PSFILE%" echo     $ins = Get-Content -LiteralPath $insertFile -ErrorAction Stop
>> "%PSFILE%" echo     foreach ($ln in $ins) { $result.Add($ln) }
>> "%PSFILE%" echo } elseif ($insert -ne $null -and $insert -ne '') {
>> "%PSFILE%" echo     $result.Add($insert)
>> "%PSFILE%" echo }
>> "%PSFILE%" echo switch ($encoding) {
>> "%PSFILE%" echo     'Default' { Set-Content -LiteralPath $path -Value $result -Encoding Default -Force; break }
>> "%PSFILE%" echo     default { Set-Content -LiteralPath $path -Value $result -Encoding UTF8 -Force; break }
>> "%PSFILE%" echo }

powershell -NoProfile -ExecutionPolicy Bypass -File "%PSFILE%" "%FILE%" "%INSERT%" "%INSERTFILE%" "%PS_ENCODING%"
set "EXITCODE=%ERRORLEVEL%"

if exist "%PSFILE%" del /f /q "%PSFILE%"

exit /b %EXITCODE%
 
