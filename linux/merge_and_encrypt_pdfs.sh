#!/bin/bash
# [bash is only needed for read -e]
# Merges & encrypts the PDF files in the current directory
#  lecture/module name in #1; admin password in #2;
#  user password in #3 (optional)

echo 'Linux-Skript zum Zusammenführen und Verschlüsseln von PDF-Dateien'

# common initialization
course_list=''
for x in '--- Klausuren:' \
	'Physik1' 'Physik2' 'Physik3' 'Physik4' 'Physik5' 'Physik6' 'Mathe1' \
	'Mathe2' 'Mathe3' 'Mathe4' 'CP' 'Chemie' 'Informatik' 'PhysikA' \
	'--- Mündliche Prüfungen im Bachelor:'\
	'QM-2FB' 'Signalverarbeitung' 'SdM' 'QTSP' \
	'--- Mündliche Prüfungen im Master (physikalische Vertiefungen):' \
	'Funktionale-Nanosysteme' 'Kern-Teilchenphysik' 'Materialphysik' \
	'Nichtlineare-Physik' 'Photonik-Magnonik' 'Dimensionsreduzierte-Festkörper' \
	'--- Mündliche Prüfungen im Master (fachübergreifende Studien):' \
	'Biophysik-MSc' 'Geophysik-MSc'
do
	course_list="$course_list    $x
"
done
input_dir=.
error_msg='
Ein Fehler ist aufgetreten!'
# “encrypted” default password
user_pw_default='2ENZQXzT'

# the parameters can either be set interactively or as arguments
# if no arguments were given: ask interactively
if [ $# -eq 0 ]; then
	while [ -z "$course" ]; do
		echo 'Um welche Vorlesung/welches Modul geht es? Mögliche Werte:'
		echo "$course_list"
		read -er course
	done
	while [ -z "$admin_pw" ]; do
		echo 'Bitte ein Administrator-Passwort für die PDF-Datei angeben:'
		read -er admin_pw
	done
	echo 'Bitte ein Nutzer-Passwort für die PDF-Datei angeben (optional):'
	read -er user_pw
	echo
# if there were arguments on the command line: validate and use these values
else
	# check if all required arguments are set
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo 'Verwendung:'
		echo '    Ohne Parameter aufrufen für interaktive Nutzung'
		echo '  oder'
		echo '    merge_and_encrypt_pdfs.sh <vorlesung-oder-modul> <admin-pw> [nutzer-pw]'
		echo
		echo ' Parameter #1: Um welche Vorlesung/welches Modul geht es? Mögliche Werte:'
		echo "$course_list"
		echo ' Parameter #2: Admin-Passwort für die PDF-Datei'
		echo ' Parameter #3: Nutzer-Passwort für die PDF-Datei (optional)'
		exit 1
	fi

	# initialization
	course=$1
	admin_pw=$2
	user_pw=$3
fi

# post-processing of parameters
output_path="${course}_$(date '+%H-%m-%S').pdf"
output_dir=$(dirname "$output_path")
output_name=$(basename "$output_path")
# use the default password if there was no user password given as argument
if [ -z "$user_pw" ]; then
	user_pw=$(echo "$user_pw_default" | tr '[A-Za-z]' '[N-ZA-Mn-za-m]')
fi

echo 'Führe PDF-Dateien im aktuellen Ordner zusammen…'

lecture_author='Professoren des Fachbereichs Physik der WWU Münster – Weitergabe nicht gestattet!'
transcript_author='Studierende des Fachbereichs Physik der WWU Münster – Weitergabe nicht gestattet!'
case $(echo "$course" | tr '[:upper:]' '[:lower:]') in
	# lectures
	physik1)
		course_title='Altklausuren zu Physik I'
		course_subject='Physik I: Dynamik der Teilchen und Teilchensysteme'
		course_keywords='Physik, Klausur, Klausuren, Scans, Mechanik'
		course_author="$lecture_author"
		;;
	physik2)
		course_title='Altklausuren zu Physik II'
		course_subject='Physik II: Thermodynamik und Elektromagnetismus'
		course_keywords='Physik, Klausur, Klausuren, Scans, Thermodynamik, Elektromagnetismus'
		course_author="$lecture_author"
		;;
	physik3)
		course_title='Altklausuren zu Physik III'
		course_subject='Physik III: Wellen und Quanten'
		course_keywords='Physik, Klausur, Klausuren, Scans, Elektrodynamik'
		course_author="$lecture_author"
		;;
	physik4)
		course_title='Altklausuren zu Physik IV'
		course_subject='Atom- und Quantenphysik'
		course_keywords='Physik, Klausur, Klausuren, Scans, Quantenmechanik, Atomphysik'
		course_author="$lecture_author"
		;;
	physik5)
		course_title='Altklausuren zu Physik V'
		course_subject='Physik V: Quantentheorie'
		course_keywords='Physik, Klausur, Klausuren, Scans, Quantentheorie'
		course_author="$lecture_author"
		;;
	physik6)
		course_title='Altklausuren zu Physik VI'
		course_subject='Physik VI: Statistische Physik'
		course_keywords='Physik, Klausur, Klausuren, Scans, Statistische Physik'
		course_author="$lecture_author"
		;;
	mathe1)
		course_title='Altklausuren zu Mathematik für Physiker I'
		course_subject='Grundlagen der Mathematik: Mathematik für Physiker I'
		course_keywords='Physik, Klausur, Klausuren, Scans, Analysis'
		course_author="$lecture_author"
		;;
	mathe2)
		course_title='Altklausuren zu Mathematik für Physiker II'
		course_subject='Grundlagen der Mathematik: Mathematik für Physiker II'
		course_keywords='Physik, Klausur, Klausuren, Scans, Lineare Algebra'
		course_author="$lecture_author"
		;;
	mathe3)
		course_title='Altklausuren zu Mathematik für Physiker III'
		course_subject='Integrationstheorie'
		course_keywords='Physik, Klausur, Klausuren, Scans, Integrationstheorie'
		course_author="$lecture_author"
		;;
	mathe4)
		course_title='Altklausuren zu Mathematik für Physiker IV'
		course_subject='Mathematik für Physiker IV'
		course_keywords='Physik, Klausur, Klausuren, Scans'
		course_author="$lecture_author"
		;;
	cp)
		course_title='Altklausuren zu Computational Physics'
		course_subject='Computational Physics: Einführung in das wissenschaftliche Programmieren'
		course_keywords='Physik, Klausur, Klausuren, Scans, Fortran'
		course_author="$lecture_author"
		;;
	chemie)
		course_title='Altklausuren zu Chemie (Fachübergreifende Studien)'
		course_subject='Chemie für Physiker'
		course_keywords='Physik, Klausur, Klausuren, Scans, Chemie'
		course_author="Professoren des Fachbereichs Chemie/Pharmazie der WWU Münster – Weitergabe nicht gestattet!"
		;;
	informatik)
		course_title='Altklausuren zu Informatik (Fachübergreifende Studien)'
		course_subject='Informatik'
		course_keywords='Physik, Klausur, Klausuren, Scans, Informatik'
		course_author="Professoren des Fachbereichs Mathematik/Informatik der WWU Münster – Weitergabe nicht gestattet!"
		;;
	physika)
		course_title='Altklausuren zu Physik A'
		course_subject='Physik A: Physik für Naturwissenschaftler'
		course_keywords='Physik, Klausur, Klausuren, Scans, Nebenfach'
		course_author="$lecture_author"
		;;
	# oral exams
	# bachelor
	qm-2fb)
		course_title='Prüfungsprotokolle zum Modul „Atom- und Quantenphysik“'
		course_subject='Atom- und Quantenphysik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Quantenmechanik, Atomphysik'
		course_author="$transcript_author"
	;;
	signalverarbeitung)
		course_title='Prüfungsprotokolle zum Modul „Messtechnik und Signalverarbeitung“'
		course_subject='Messtechnik und Signalverarbeitung'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Messtechnik, Signalverarbeitung'
		course_author="$transcript_author"
	;;
	sdm)
		course_title='Prüfungsprotokolle zum Modul „Struktur der Materie“'
		course_subject='Struktur der Materie'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Materie, Kernphysik, Teilchenphysik, Festkörperphysik'
		course_author="$transcript_author"
	;;
	qtsp)
		course_title='Prüfungsprotokolle zum Modul „Quantentheorie und statistische Physik“'
		course_subject='Quantentheorie und statistische Physik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Quantentheorie, statistische Physik'
		course_author="$transcript_author"
	;;
	# master
	funktionale-nanosysteme)
		course_title='Prüfungsprotokolle zum Modul „Funktionale Nanosysteme“'
		course_subject='Physikalische Vertiefung: Funktionale Nanosysteme'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, Nanophysik, Nanosysteme'
		course_author="$transcript_author"
	;;
	kern-teilchenphysik)
		course_title='Prüfungsprotokolle zum Modul „Kern- und Teilchenphysik“'
		course_subject='Physikalische Vertiefung: Kern- und Teilchenphysik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, Kernphysik, Teilchenphysik, Elementarteilchen'
		course_author="$transcript_author"
	;;
	materialphysik)
		course_title='Prüfungsprotokolle zum Modul „Materialphysik“'
		course_subject='Physikalische Vertiefung: Materialphysik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, Materialphysik'
		course_author="$transcript_author"
	;;
	nichtlineare-physik)
		course_title='Prüfungsprotokolle zum Modul „Nichtlineare Physik“'
		course_subject='Physikalische Vertiefung: Nichtlineare Physik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, nichtlinear'
		course_author="$transcript_author"
	;;
	photonik-magnonik)
		course_title='Prüfungsprotokolle zum Modul „Photonik und Magnonik“'
		course_subject='Physikalische Vertiefung: Photonik und Magnonik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, Photonik, Magnonik'
		course_author="$transcript_author"
	;;
	dimensionsreduzierte-festkörper)
		course_title='Prüfungsprotokolle zum Modul „Physik dimensionsreduzierter Festkörper“'
		course_subject='Physikalische Vertiefung: Physik dimensionsreduzierter Festkörper'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, dimensionsreduzierte Festkörper'
		course_author="$transcript_author"
	;;
	# minor (master)
	biophysik-msc)
		course_title='Prüfungsprotokolle zum Modul „Fachübergreifende Studien: Biophysik“'
		course_subject='Fachübergreifende Studien: Biophysik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, Biophysik'
		course_author="$transcript_author"
	;;
	geophysik-msc)
		course_title='Prüfungsprotokolle zum Modul „Fachübergreifende Studien: Geophysik“'
		course_subject='Fachübergreifende Studien: Geophysik'
		course_keywords='Physik, Prüfung, mündlich, Protokoll, Master, Geophysik'
		course_author="$transcript_author"
	;;
	# default
	*)
		echo "Achtung: Die Vorlesung/das Modul „${course}“ ist nicht bekannt!"
		echo 'Mögliche Werte sind:'
		echo "$course_list"
		echo 'Für die Metadaten der PDF-Datei werden generische Werte eingesetzt.'
		echo

		course_title='Altklausur/Prüfungsprotokoll am Fachbereich Physik der WWU Münster'
		course_subject='Klausur/Prüfungsprotokoll'
		course_keywords='Physik, Klausur, Klausuren, Protokoll, WWU Münster'
		course_author='Studierende oder Professoren des Fachbereichs Physik der WWU Münster – Weitergabe nicht gestattet!'
		;;
esac

# merge PDF files
sejda-console merge \
	--bookmarks one_entry_each_doc \
	--directory "$input_dir" --matchingRegEx '(?i)(?!^FS_logo_stamp.pdf$).*' \
	--output "/tmp/$output_name"'_1.pdf' \
	>/dev/null
status=$?
if [ $status -ne 0 ]; then
	echo $error_msg
	echo 'Die PDF-Dateien konnten nicht zusammengeführt werden – vielleicht ist'
	echo 'eine der Dateien nicht lesbar?'
	exit 2
fi

# add FSPHYS logo stamp on background of every page in merged PDF file
pdftk "/tmp/$output_name"'_1.pdf' stamp 'FS_logo_stamp.pdf' output "/tmp/$output_name"
status=$?
rm "/tmp/$output_name"'_1.pdf'
if [ $status -ne 0 ]; then
	echo $error_msg
	exit 3
fi

# set metadata on merged (& stamped) PDF file
sejda-console setmetadata \
	--title "$course_title" \
	--subject "$course_subject" \
	--author "$course_author" \
	--keywords "$course_keywords" \
	--overwrite \
	--files "/tmp/$output_name" --output "/tmp/$output_name" \
	>/dev/null
status=$?
if [ $status -ne 0 ]; then
	echo $error_msg
	exit 4
fi

# encrypt merged PDF file (set user & admin PW)
sejda-console encrypt \
	--encryptionType aes_128 \
	--allow print copy modifyannotations fill screenreaders assembly degradedprinting \
	--userPassword "$user_pw" \
	--administratorPassword "$admin_pw" \
	--files "/tmp/$output_name" --output "$output_dir" \
	>/dev/null
status=$?
rm "/tmp/$output_name"
if [ $status -ne 0 ]; then
	echo $error_msg
	echo "Eventuell kann auf den Pfad „$output_path“"
	echo 'nicht zugegriffen werden oder die Datei existiert bereits.'
	exit 5
fi

echo
echo 'PDF-Dateien erfolgreich zusammengeführt!'
echo "Ausgabe-Datei:           $output_path"
echo "Administrator-Passwort:  $admin_pw"
echo "Nutzer-Passwort:         $user_pw"

