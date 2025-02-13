@echo off
setlocal enabledelayedexpansion
title Modifica Nomi File
color 0a

echo Inserisci il percorso della cartella:
set /p cartella=

if not exist "%cartella%" (
    echo La cartella specificata non esiste.
    pause
    exit /b
)

echo Inserisci la parte del nome da cambiare:
set /p vecchiaparte=

echo Inserisci la nuova parte del nome:
set /p nuovaparte=

if "%vecchiaparte%"=="" (
    echo La parte del nome da cambiare non può essere vuota.
    pause
    exit /b
)

if "%nuovaparte%"=="" (
    echo La nuova parte del nome non può essere vuota.
    pause
    exit /b
)

for %%f in ("%cartella%\*") do (
    set "nomefile=%%~nf"
    if "!nomefile:%vecchiaparte%=!" neq "!nomefile!" (
        ren "%%f" "!nomefile:%vecchiaparte%=%nuovaparte%!%%~xf"
    )
)

echo Modifica completata.
pause
