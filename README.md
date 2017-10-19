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

Das Skript muss wie folgt aufgerufen werden:

    merge_and_encrypt_pdfs.sh <eingabeordner> <ausgabepfad> <vorlesung> <admin-pw>

Beispiel:

    merge_and_encrypt_pdfs.sh ~/klausuren ~/Physik1.pdf Physik1 TEST-Passwort

`<eingabeordner>` ist der Pfad zu dem Ordner, in dem sich die PDF-Dateien
befinden, die zusammengeführt werden sollen.

`<ausgabepfad>` ist der Pfad, zu dem die fertige zusammengeführte PDF-Dattei
ausgegeben werden soll.

`<vorlesung>` soll die Art der Vorlesung sein, von der gerade Klausuren
zusammengeführt werden sollen, und muss einer der folgenden Werte sein:
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

Diese Information wird dazu verwendet, um Metadaten in die PDF-Datei zu schreiben.

`<admin-pw>` ist ist das Admin-Passwort für die PDF-Datei. Dieses sollte nicht
weitergegeben werden.

Das Passwort zum Anzeigen der PDF-Datei wird automatisch generiert und am Ende
ausgegeben.

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

