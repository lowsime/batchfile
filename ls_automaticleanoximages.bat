@echo off
setlocal enabledelayedexpansion

title Verificatore Immagini ox_inventory
echo VERIFICATORE E ELIMINATORE IMMAGINI NON REFERENZIATE
echo.

set "lua_files="
set "image_folder="
set /a file_count=0
set /a image_count=0

:import_lua
echo Inserisci i percorsi dei file Lua (uno per linea)
echo Scrivi 'fine' per terminare:
echo.

:input_lua_loop
set /p "lua_file=File Lua %file_count%: "
if "!lua_file!"=="" goto input_lua_loop
if /i "!lua_file!"=="fine" goto end_lua_input

if not exist "!lua_file!" (
    echo File non trovato: !lua_file!
    goto input_lua_loop
)

set /a file_count+=1
set "lua_files=!lua_files! "!lua_file!""
echo File aggiunto: !lua_file!
goto input_lua_loop

:end_lua_input
if %file_count%==0 (
    echo Nessun file Lua specificato
    pause
    exit /b 1
)

:import_images
echo.
set /p "image_folder=Inserisci il percorso della cartella immagini: "
if "!image_folder!"=="" (
    echo Nessuna cartella specificata
    pause
    exit /b 1
)

if not exist "!image_folder!\" (
    echo Cartella non trovata: !image_folder!
    goto import_images
)

dir /b "!image_folder!\*.png" "!image_folder!\*.jpg" "!image_folder!\*.jpeg" >nul 2>&1
if errorlevel 1 (
    echo Nessuna immagine trovata: !image_folder!
    pause
    exit /b 1
)

dir /b "!image_folder!\*.png" "!image_folder!\*.jpg" "!image_folder!\*.jpeg" > images.tmp
for /f %%i in ('type images.tmp ^| find /c /v ""') do set /a image_count=%%i

type nul > combined.lua.tmp
for %%f in (%lua_files%) do type "%%~f" >> combined.lua.tmp

echo.
echo ANALISI IN CORSO...
echo File Lua: %file_count%
echo Immagini: %image_count%
echo.

set /a unused_count=0
echo. > unused_images.txt
echo IMMAGINI NON REFERENZIATE ELIMINATE >> unused_images.txt
echo ================================ >> unused_images.txt
echo.

for /f "delims=" %%i in (images.tmp) do (
    set "image_name=%%~ni"
    set "found=0"
    
    findstr /i /m /c:"\"!image_name!\"" combined.lua.tmp >nul && set found=1
    if !found!==0 findstr /i /m /c:"'!image_name!'" combined.lua.tmp >nul && set found=1
    if !found!==0 findstr /i /m /c:"!image_name!" combined.lua.tmp >nul && set found=1
    
    if !found!==0 (
        echo %%i >> unused_images.txt
        set /a unused_count+=1
        echo !unused_count!. %%i - ELIMINATA
        del "!image_folder!\%%i"
    )
)

del images.tmp
del combined.lua.tmp

echo.
echo OPERAZIONE COMPLETATA
echo Immagini eliminate: !unused_count!
echo Elenco salvato in unused_images.txt
echo.

pause
