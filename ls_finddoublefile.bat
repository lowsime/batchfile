@echo off
setlocal enabledelayedexpansion

:START
echo Inserisci l'estensione del file (esempio: ymap, exe, bat):
set /p "ext="
if "!ext!"=="" (
    echo Estensione non valida!
    goto :START
)
set "ext=!ext:*.=!"
set "ext=!ext:.=!"

echo Inserisci il percorso della cartella:
set /p "folder="

if not "%folder:~-1%"=="\" set "folder=%folder%\"
if not exist "%folder%" (
    echo La cartella non esiste.
    exit /b
)

echo Contando i file .!ext!...
set "total=0"
for /r "%folder%" %%F in (*.!ext!) do set /a "total+=1"
echo Trovati !total! file .!ext!.
echo.

if !total! equ 0 (
    echo Nessun file .!ext! trovato.
    exit /b
)

echo Analizzando i file...
set "output=duplicati_!ext!.txt"
if exist "%output%" del "%output%"

set "processed="
set "current=0"

for /f %%a in ('copy /Z "%~f0" nul') do set "CR=%%a"

for /r "%folder%" %%A in (*.!ext!) do (
    set /a "current+=1"
    set /a "percent=(current*100)/total"
    <nul set /p "=Scansione file: !current!/!total! [!percent!%%]!CR!"
    
    set "fileName=%%~nxA"
    set "filePath=%%A"
    
    if not defined processed[!fileName!] (
        set "count=0"
        set "fileList="
        
        for /r "%folder%" %%B in (*.!ext!) do (
            if "%%~nxB"=="!fileName!" (
                set /a "count+=1"
                set "fileList=!fileList!"%%B" "
            )
        )
        
        if !count! gtr 1 (
            echo.
            echo [DUPLICATO] !fileName!
            set "processed[!fileName!]=1"
            (for %%F in (!fileList!) do echo %%F) >> "%output%"
            echo -------------------- >> "%output%"
        )
    )
)

echo.
echo Controllo completato. I duplicati .!ext! sono salvati in "%output%".
pause
