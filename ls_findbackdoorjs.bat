@echo off
setlocal enabledelayedexpansion

set "parole_chiave=eval exec spawn child_process base64 decode require import fetch XMLHttpRequest Function"
set "bersaglio=percorso-della-directory-o-file"

if exist "%bersaglio%" (
    if exist "%bersaglio%\*" (
        for /r "%bersaglio%" %%f in (*.js) do (
            set "file=%%f"
            for %%k in (%parole_chiave%) do (
                findstr /n /i /c:"%%k" "!file!" >nul && (
                    echo Possibile backdoor trovata in: !file!
                    findstr /n /i /c:"%%k" "!file!" | findstr /c:"%%k"
                )
            )
        )
    ) else (
        if exist "%bersaglio%" (
            for %%k in (%parole_chiave%) do (
                findstr /n /i /c:"%%k" "%bersaglio%" >nul && (
                    echo Possibile backdoor trovata in: %bersaglio%
                    findstr /n /i /c:"%%k" "%bersaglio%" | findstr /c:"%%k"
                )
            )
        )
    )
) else (
    echo Percorso non trovato: %bersaglio%
)

echo Scansione completata.
pause
