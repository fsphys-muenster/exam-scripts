# Skripts für das Learnweb-System (2016)

## Protokoll-Script (Windows - FSPC)
Um die Arbeit mit den Skripten zu erleichtern wurde ein Skript geschrieben, dass direkt vom FSPC ausgeführt werden kann. Dabei werden die PDFs mittels Benutzer- und Administrator-Passwort verschlüsselt, sowie mit Metadaten und Wasserzeichen versehen.

Die Benutzung erfolgt ähnlich zu dem vorherigen Skript. Alle benötigten binaries liegen dem Skript bereits bei. Dabei wird vorrangig die Software Coherent PDF Command Line Tools (http://community.coherentpdf.com/ der Version 15.04.2016) verwendet.

Das Skript muss wie folgt aufgerufen werden:

    Protokoll-Skript.bat [Eingabeordner] [Admin-PW] [User-PW]
	
Parameter #1: Ordner der PDF-Dateien. Dieser Ordner sollte eine "meta.info"-Datei beinhalten! Falls keine Meta-Datei gefunden wurde wird ein allgemeiner Eintrag erzeugt.
Parameter #2: Admin-PW der PDFs
Parameter #3: User-PW der PDFs

Die meta.info kann wie folgt aussehen:

	title="Altklausuren zu Physik II"
	author="Professoren des Fachbereichs Physik der WWU Muenster. Weitergabe nicht gestattet!"
	subject="Physik II: Thermodynamik und Elektromagnetismus"
	keywords="Physik,Klausur,WWU Muenster,Physik3,Scans,Thermodynamik,Elektromagnetismus"

Alle Parameter werden ohne Leerzeichen angegeben! Die Ausgabe Erfolgt im Ordner "Protokoll-Skript-Ausgabe" des Ausfuehrungsortes.