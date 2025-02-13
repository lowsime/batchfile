@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Richiedendo permessi di amministratore...
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

echo Caricamento in corso...
ping localhost -n 5 > nul
echo Pulizia in corso...

for /f "usebackq" %%i in (`powershell -Command "((New-Object -ComObject Shell.Application).NameSpace(10).Items() | Measure-Object).Count"`) do set numero=%%i
if %numero%==0 (
    echo Il cestino e gia vuoto. Operazione annullata.
    pause
    exit /b
)

rd /s /q %systemdrive%\$Recycle.bin
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*"

echo Operazione completata.
pause
