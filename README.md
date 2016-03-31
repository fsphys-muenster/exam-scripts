# exam-scripts
Scripts to generate link passwords and merge and encrypt PDF files for past exams.

## Link-Passwörter
Um das Skript auszuführen, werden folgende Programme benötigt:
- Python (Version ≥ 3)
- pdflatex (muss auf der Kommandozeile ausführbar sein)

Das Skript wird ohne Parameter aufgerufen, also einfach z. B.

    python3 make_pw_list.py

oder sogar nur

    make_pw_list.py

unter Unix.

Es werden immer Passwortlisten für das gesamte aktuelle und nächste Semester
im `.txt`-, `.tex`- und `.pdf`-Format im aktuellen Ordner erzeugt.

## PDFs zusammenführen und verschlüsseln
Das Skript ist ein Unix-Shell-Skript. Zur Verwendung müssen die Programme
[pdftk](https://www.pdflabs.com/tools/pdftk-server) und [sejda](http://www.sejda.org)
installiert und über die Kommandozeile ausführbar sein. Für sejda kann auch
alternativ die Umgebungsvariable `sejda_path` auf das Verzeichnis gesetzt
werden, in dem sich die Programmdatei sejda-console befindet. Beide Programme
sind FOSS; pdftk findet sich auch z. B. in den Ubuntu-Repositories.

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

