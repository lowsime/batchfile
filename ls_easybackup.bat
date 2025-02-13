@echo off
setlocal enabledelayedexpansion

echo Seleziona il disco di destinazione:
set i=1
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        echo !i!. %%d:\
        set disks[!i!]=%%d:
        set /a i=!i!+1
    )
)

set /p scelta=Inserisci il numero del disco di destinazione: 
set destinazionebackup=!disks[%scelta%]!

set /p percorso=Inserisci il percorso del file o della cartella da salvare: 

if exist "%percorso%\" (
    set tipo=cartella
) else (
    set tipo=file
)

if not exist "%destinazionebackup%\Backup\" (
    mkdir "%destinazionebackup%\Backup\"
)

echo Caricamento in corso...
ping localhost -n 3 > nul

echo Eseguendo il backup dei %tipo%...
powershell -Command "Compress-Archive -Path '%percorso%' -DestinationPath '%destinazionebackup%\Backup\backup.zip'"

echo Backup completato.
pause
