@echo off
:: Verifica i permessi di amministratore e richiede i permessi se necessario
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Richiedendo permessi di amministratore...
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

echo Caricamento in corso...
ping localhost -n 5 > nul
echo Pulizia in corso...

:: Cancella il contenuto del cestino
rd /s /q %systemdrive%\$Recycle.bin

:: Cancella il contenuto della cartella "Recente"
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*"

echo Operazione completata.
pause
