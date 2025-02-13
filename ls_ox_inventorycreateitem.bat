@echo off
setlocal enabledelayedexpansion

openfiles >nul 2>&1
if not %errorlevel%==0 (
    echo Richiedi permessi di amministratore...
    powershell.exe -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

echo Questo script creerà una cartella sul desktop e genererà un file .lua.
echo Vuoi continuare? (S/N)
set /p permission=

if /i "%permission%" neq "S" (
    echo Operazione annullata.
    exit /b
)

set /p filename=Nome file (es. mt_metallo): 
set /p label=Nome da Visualizzare: 
set /p description=Descrizione (Scrivi nil se non vuoi metterlo): 
set /p weight=Peso (Scrivi nil se non vuoi metterlo): 

set desktop=%userprofile%\Desktop
set folder=%desktop%\ls_items

if not exist "%folder%" mkdir "%folder%"

(
echo ["!filename!"] = {
echo    label = "!label!",
if not "!description!"=="nil" (
    echo    description = "!description!",
)
if not "!weight!"=="nil" (
    echo    weight = !weight!,
)
echo },
) > "%folder%\!filename!.lua"

if "!description!"=="nil" (
    powershell.exe -command "(gc \"%folder%\!filename!.lua\") -replace 'description = \".*\",', '' | Out-File -encoding ASCII \"%folder%\!filename!.lua\""
)
if "!weight!"=="nil" (
    powershell.exe -command "(gc \"%folder%\!filename!.lua\") -replace 'weight = .*,' , '' | Out-File -encoding ASCII \"%folder%\!filename!.lua\""
)

echo Il file !filename!.lua è stato creato nella cartella ls_items sul desktop.
pause
