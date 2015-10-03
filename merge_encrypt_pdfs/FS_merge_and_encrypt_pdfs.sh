#!/bin/sh
# Author: Simon May
# Date: 2015-03-13
# Merges & encrypts the PDF files in the directory in #1; output file name in #2;
#     lecture name in #3; admin PW in #4

lecture_list=''
for i in 'Physik1' 'Physik2' 'Physik3' 'Physik4' 'Physik5' 'Physik6' 'Mathe1' 'Mathe2' 'Mathe3' 'Mathe4' 'CP' 'Chemie' 'Informatik'; do
	lecture_list="$lecture_list    $i\n"
done
# check if all required arguments are set
if [ -z ${1+x} ] || [ -z ${2+x} ] || [ -z ${3+x} ]; then
	echo 'Verwendung:'
	echo
	echo ' Parameter #1: Ordner, der die PDF-Dateien enthält'
	echo ' Parameter #2: Pfad für die Ausgabedatei'
	echo ' Parameter #3: Um welche Vorlesung geht es? Mögliche Werte:'
	echo ' Parameter #4: Admin-Passwort für die PDF-Datei'
	echo "$lecture_list"
	exit 0
fi

# initialization
input_dir=$1
output_path=$2
lecture=$3
admin_pw=$4
output_dir=$(dirname "$output_path")
output_name=$(basename "$output_path")

lecture_author='Professoren des FB Physik der WWU – Weitergabe nicht gestattet!'
case $lecture in
	'Physik1')
		lecture_title='Altklausuren zu Physik I'
		lecture_subject='Physik I: Dynamik der Teilchen und Teilchensysteme'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Mechanik'
		;;
	'Physik2')
		lecture_title='Altklausuren zu Physik II'
		lecture_subject='Physik II: Thermodynamik und Elektromagnetismus'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Thermodynamik, Elektromagnetismus'
		;;
	'Physik3')
		lecture_title='Altklausuren zu Physik III'
		lecture_subject='Physik III: Wellen und Quanten'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Elektrodynamik'
		;;
	'Physik4')
		lecture_title='Altklausuren zu Physik IV'
		lecture_subject='Atom- und Quantenphysik'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Quantenmechanik, Atomphysik'
		;;
	'Physik5')
		lecture_title='Altklausuren zu Physik V'
		lecture_subject='Physik V: Quantentheorie'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Quantentheorie'
		;;
	'Physik6')
		lecture_title='Altklausuren zu Physik VI'
		lecture_subject='Physik VI: Statistische Physik'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Statistische Physik'
		;;
	'Mathe1')
		lecture_title='Altklausuren zu Mathematik für Physiker I'
		lecture_subject='Grundlagen der Mathematik: Mathematik für Physiker I'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Analysis'
		;;
	'Mathe2')
		lecture_title='Altklausuren zu Mathematik für Physiker II'
		lecture_subject='Grundlagen der Mathematik: Mathematik für Physiker II'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Lineare Algebra'
		;;
	'Mathe3')
		lecture_title='Altklausuren zu Mathematik für Physiker III'
		lecture_subject='Integrationstheorie'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Integrationstheorie'
		;;
	'Mathe4')
		lecture_title='Altklausuren zu Mathematik für Physiker IV'
		lecture_subject='Mathematik für Physiker IV'
		lecture_keywords='Physik, Klausur, Klausuren, Scans'
		;;
	'CP')
		lecture_title='Altklausuren zu Computational Physics'
		lecture_subject='Computational Physics: Einführung in das wissenschaftliche Programmieren'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Fortran'
		;;
	'Chemie')
		lecture_title='Altklausuren zu Chemie (Fachübergreifende Studien)'
		lecture_subject='Chemie für Physiker'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Chemie'
		;;
	'Informatik')
		lecture_title='Altklausuren zu Informatik (Fachübergreifende Studien)'
		lecture_subject='Informatik'
		lecture_keywords='Physik, Klausur, Klausuren, Scans, Informatik'
		;;
	*)
		echo 'Die Vorlesung "'"$lecture"'" ist nicht bekannt!'
		echo 'Mögliche Werte sind:'
		echo "$lecture_list"
		exit 1
		;;
esac
user_pw="$lecture"'-'$(date '+%Y-%m-%dT%H:%M')

"$sejda_path"sejda-console merge \
	--bookmarks one_entry_each_doc \
	--directory "$input_dir" --output "/tmp/$output_name"'_1.pdf'
status=$?
if [ $status -ne 0 ]; then
	echo 'Ein Fehler ist aufgetreten!'
	exit 1
fi

pdftk "/tmp/$output_name"'_1.pdf' stamp 'FS_logo_stamp.pdf' output "/tmp/$output_name"
status=$?
rm "/tmp/$output_name"'_1.pdf'
if [ $status -ne 0 ]; then
	echo 'Ein Fehler ist aufgetreten!'
	exit 1
fi

"$sejda_path"sejda-console setmetadata \
	--title "$lecture_title" \
	--subject "$lecture_subject" \
	--author "$lecture_author" \
	--keywords "$lecture_keywords" \
	--overwrite \
	--files "/tmp/$output_name" --output "/tmp/$output_name"
status=$?
if [ $status -ne 0 ]; then
	echo 'Ein Fehler ist aufgetreten!'
	exit 1
fi

"$sejda_path"sejda-console encrypt \
	--encryptionType aes_128 \
	--allow print copy modifyannotations fill screenreaders assembly degradedprinting \
	--userPassword "$user_pw" \
	--adminstratorPassword "$admin_pw" \
	--files "/tmp/$output_name" --output "$output_dir"
status=$?
rm "/tmp/$output_name"
if [ $status -ne 0 ]; then
	echo 'Ein Fehler ist aufgetreten!'
	exit 1
fi

echo
echo 'User PW:' "$user_pw"

