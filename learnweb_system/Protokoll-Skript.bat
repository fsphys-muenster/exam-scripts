@ECHO off
SETLOCAL

IF "%3" == "" (
ECHO.
ECHO Windows Skript zum Erzeugen von verschluesselten PDFs [April 2016 - LA,BB]
ECHO.
ECHO Verwendung:
ECHO  Protokoll-Skript.bat [Eingabeordner] [Admin-PW] [User-PW]
ECHO.
ECHO  Parameter #1: Ordner der PDF-Dateien
ECHO                Der Ordner sollte eine meta.info beinhalten!
ECHO                Falls keine Meta-Datei gefunden wurde wird ein allgemeiner Eintrag erzeugt.
ECHO  Parameter #2: Admin-PW der PDFs
ECHO  Parameter #3: User-PW der PDFs
ECHO.
ECHO  Alle Parameter werden ohne Leerzeichen im Parameter selbst angegeben [der Eingabeordner kann ggf. mit "..." umschlossen werden]! Die Ausgabe Erfolgt im Ordner "Protokoll-Skript-Ausgabe" des Ausfuehrungsortes.
ECHO.
PAUSE
GOTO:EOF
)

:: Benutzereingaben abfangen
:: set /p EINGABE=Variable Eingeben:
:: echo %EINGABE%

ECHO.
ECHO Starte Skript mit folgenden Parametern:
ECHO Eingabeordner: %1
ECHO Admin-PW: %2
ECHO User-PW: %3
ECHO.

IF EXIST %1\meta.info (
	ECHO Werte aus meta.info werden uebernommen!
	ECHO.
	for /f "delims== tokens=1,2" %%G in (%1\meta.info) do SET %%G=%%H & if %%G==title SET title=%%H & if %%G==author SET author=%%H & if %%G==subject SET subject=%%H & if %%G==keywords SET keywords=%%H
 ) ELSE ( 
	ECHO Keine meta.info gefunden! Standardwerte werden verwendet!
	ECHO.
	SET title="Altprotokoll o. Altklausur am Fachbereich Physik der WWU"
	SET author="Studierende oder Professoren des Fachbereichs Physik der WWU Muenster. Weitergabe nicht gestattet!"
	SET subject="Protokoll o. Klausur"
	SET keywords="Physik,Klausur,Protokoll,WWU Muenster"
 )

ECHO Ausgabe erfolgt nach %cd%\Protokoll-Skript-Ausgabe\%~n1
if exist "%cd%\Protokoll-Skript-Ausgabe\%~n1" del /q "%cd%\Protokoll-Skript-Ausgabe\%~n1\*.pdf"
if not exist "%cd%\Protokoll-Skript-Ausgabe\%~n1" mkdir "%cd%\Protokoll-Skript-Ausgabe\%~n1"

:: Copy and stamp PDFs
for /R %1 %%f in (*.pdf) do %cd%\cpdf-binaries-master\Windows\cpdf.exe -stamp-on %cd%\FS_logo_stamp.pdf -scale-stamp-to-fit -i "%%~f" -o "%cd%\Protokoll-Skript-Ausgabe\%~n1\%%~nf.pdf"
:: write MetaData
for /R "%cd%\Protokoll-Skript-Ausgabe\%~n1" %%f in (*.pdf) do %cd%\cpdf-binaries-master\Windows\cpdf.exe -set-title %title% -i "%%~f" -o "%%~f"
for /R "%cd%\Protokoll-Skript-Ausgabe\%~n1" %%f in (*.pdf) do %cd%\cpdf-binaries-master\Windows\cpdf.exe -set-author %author% -i "%%~f" -o "%%~f"
for /R "%cd%\Protokoll-Skript-Ausgabe\%~n1" %%f in (*.pdf) do %cd%\cpdf-binaries-master\Windows\cpdf.exe -set-subject %subject% -i "%%~f" -o "%%~f"
for /R "%cd%\Protokoll-Skript-Ausgabe\%~n1" %%f in (*.pdf) do %cd%\cpdf-binaries-master\Windows\cpdf.exe -set-keywords %keywords% -i "%%~f" -o "%%~f"
:: encrypt PDFs
for /R "%cd%\Protokoll-Skript-Ausgabe\%~n1" %%f in (*.pdf) do %cd%\cpdf-binaries-master\Windows\cpdf.exe -encrypt AES %2 %3 -i "%%~f" -o "%%~f"

ECHO Verarbeitung erfolgreich abgeschlossen!
ECHO.




