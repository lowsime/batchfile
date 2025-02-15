@echo off
setlocal enabledelayedexpansion

set "FILE_CORRELATI_MAPP=*.ytd *.ymt *.ydr *.ydd *.ytyp *.ybn *.ycd *.ymap *.ynv *.ytyp *.ypt"
set "CARTELLA=%~dp0"
set "OUTPUT_DUPLICATI=ls_nomifile.txt"
set "OUTPUT_ELIMINATI=ls_file_eliminati.txt"

del "%OUTPUT_DUPLICATI%" > nul 2>&1
del "%OUTPUT_ELIMINATI%" > nul 2>&1

set "COLLISIONI=0"
call :scansiona_cartella "%CARTELLA%"

if "!COLLISIONI!" gtr 0 (
    echo Trovati !COLLISIONI! file duplicati.
    set /p "scelta=Vuoi eliminare i file duplicati? (SI/NO): "
    if /I "!scelta!"=="SI" (
        call :elimina_duplicati
        echo Tutti i file duplicati sono stati eliminati. Vedi %OUTPUT_ELIMINATI% per i dettagli.
    ) else (
        echo I file duplicati sono stati mantenuti. Vedi %OUTPUT_DUPLICATI% per i dettagli.
    )
) else (
    echo I tuoi assets sono corretti!
)

pause
exit /b 0

:scansiona_cartella
set "CART=%~1"
for /r "%CART%" %%F in (%FILE_CORRELATI_MAPP%) do (
    set "NOMEFILE=%%~nxF"
    if defined FILES[!NOMEFILE!] (
        echo !FILES[!NOMEFILE!]!>> "%OUTPUT_DUPLICATI%"
        echo %%~dpnxF>> "%OUTPUT_DUPLICATI%"
        set /a COLLISIONI+=1
    ) else (
        set "FILES[!NOMEFILE!]=%%~dpnxF"
    )
)
exit /b 0

:elimina_duplicati
for /f "delims=" %%L in (%OUTPUT_DUPLICATI%) do (
    if exist "%%L" (
        del "%%L"
        echo %%L >> "%OUTPUT_ELIMINATI%"
    )
)
exit /b 0
