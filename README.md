# learnweb-scripts
 Scripts to merge and encrypt PDF files for past exams and oral exam
 transcripts on the [student council’s Learnweb course](https://sso.uni-muenster.de/LearnWeb/learnweb2/course/view.php?id=4789).

## [Linux](linux/)
### PDFs zusammenführen und verschlüsseln
Das Skript ist ein Unix-Shell-Skript. Zur Verwendung müssen die Programme
[pdftk](https://www.pdflabs.com/tools/pdftk-server) und
[sejda](https://github.com/torakiki/sejda)
installiert und über die Kommandozeile ausführbar sein. Beide Programme
sind FOSS; pdftk findet sich auch z. B. in den Ubuntu-Repositories.

Am einfachsten ist es, das Skript ohne Angabe von Parametern auszuführen. Die
erforderlichen Angaben werden dann interaktiv erfragt.

---

Es ist auch möglich, die Angaben für das Skript als Parameter auf der
Kommandozeile zu übergeben. In diesem Fall muss das Skript wie folgt aufgerufen
werden:

    merge_and_encrypt_pdfs.sh <vorlesung-oder-modul> <admin-pw> [nutzer-pw]

Beispiel:

    merge_and_encrypt_pdfs.sh Physik1 TEST-Admin-Passwort

`<vorlesung-oder-modul>` soll die Art der Vorlesung bzw. der Name des Moduls
sein, von der gerade Klausuren zusammengeführt werden sollen, und muss einer
der folgenden Werte sein (Groß-/Kleinschreibung wird nicht beachtet):
- Klausuren:
  - `Physik1`
  - `Physik2`
  - `Physik3`
  - `Physik4`
  - `Physik5`
  - `Physik6`
  - `Mathe1`
  - `Mathe2`
  - `Mathe3`
  - `Mathe4`
  - `CP`
  - `Chemie`
  - `Informatik`
  - `PhysikA`
- Mündliche Prüfungen im Bachelor:
  - `QM-2FB`
  - `Signalverarbeitung`
  - `SdM`
  - `QTSP`
- Mündliche Prüfungen im Master (physikalische Vertiefungen):
  - `Funktionale-Nanosysteme`
  - `Kern-Teilchenphysik`
  - `Materialphysik`
  - `Nichtlineare-Physik`
  - `Photonik-Magnonik`
  - `Dimensionsreduzierte-Festkörper`
- Mündliche Prüfungen im Master (fachübergreifende Studien):
  - `Biophysik-MSc`
  - `Geophysik-MSc`

Diese Information wird dazu verwendet, um Metadaten in die PDF-Datei zu schreiben.

`<admin-pw>` ist das Admin-Passwort für die PDF-Datei. Dieses sollte nicht
weitergegeben werden.

`[nutzer-pw]` ist das Passwort zum Anzeigen der PDF-Datei. Die Angabe ist
*optional*; wird hier nichts angegeben, wird ein Standard-Passwort verwendet und
am Ende ausgegeben.

Für die Ein- und Ausgabe wird der Ordner verwendet, von dem aus das Skript
ausgeführt wird. Am besten kann man also das Skript in den Ordner mit den
Dateien kopieren, die man bearbeiten möchte, und von dort aus ausführen.

## [Windows](windows/)
### Protokoll-Script (Windows)
Um die Arbeit mit den Skripten zu erleichtern wurde ein Skript geschrieben, dass direkt auf Windows ausgeführt werden kann. Dabei werden die PDFs mittels Benutzer- und Administrator-Passwort verschlüsselt, sowie mit Metadaten und Wasserzeichen versehen.

Die Benutzung erfolgt ähnlich zu dem vorherigen Skript. Alle benötigten binaries liegen dem Skript bereits bei. Dabei wird vorrangig die Software Coherent PDF Command Line Tools (http://community.coherentpdf.com/ der Version 15.04.2016) verwendet.

Das Skript muss wie folgt aufgerufen werden:

    Protokoll-Skript.bat [Eingabeordner] [Admin-PW] [User-PW]
	
Parameter #1: Ordner der PDF-Dateien. Dieser Ordner sollte eine "meta.info"-Datei beinhalten! Falls keine Meta-Datei gefunden wurde wird ein allgemeiner Eintrag erzeugt. Ggf. muss der Ordner in "..." gesetzt werden, wenn dieser Anführungszeichen enthält.

Parameter #2: Admin-PW der PDFs

Parameter #3: User-PW der PDFs

Die meta.info kann wie folgt aussehen:

	title="Altklausuren zu Physik II"
	author="Professoren des Fachbereichs Physik der WWU Muenster. Weitergabe nicht gestattet!"
	subject="Physik II: Thermodynamik und Elektromagnetismus"
	keywords="Physik,Klausur,WWU Muenster,Physik3,Scans,Thermodynamik,Elektromagnetismus"

Alle Parameter werden ohne Leerzeichen angegeben! Die Ausgabe Erfolgt im Ordner "Protokoll-Skript-Ausgabe" des Ausfuehrungsortes.

