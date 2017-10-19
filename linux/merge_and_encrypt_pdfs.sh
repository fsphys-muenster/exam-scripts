#!/bin/sh
# Merges & encrypts the PDF files in the current directory
#  lecture/module name in #1; admin password in #2;
#  user password in #3 (optional)

echo 'Linux-Skript zum Zusammenführen und Verschlüsseln von PDF-Dateien'

# common initialization
course_list=''
for x in 'Physik1' 'Physik2' 'Physik3' 'Physik4' 'Physik5' 'Physik6' 'Mathe1' \
	'Mathe2' 'Mathe3' 'Mathe4' 'CP' 'Chemie' 'Informatik' 'PhysikA'; do
	course_list="$course_list    $x\n"
done
input_dir=.
error_msg="\nEin Fehler ist aufgetreten!"
# “encrypted” default password
user_pw_default='2ENZQXzT'

# the parameters can either be set interactively or as arguments
# if no arguments were given: ask interactively
if [ $# -eq 0 ]; then
	while [ -z "$course" ]; do
		echo 'Um welche Vorlesung/welches Modul geht es? Mögliche Werte:'
		echo "$course_list"
		read course
	done
	while [ -z "$admin_pw" ]; do
		echo 'Bitte ein Administrator-Passwort für die PDF-Datei angeben:'
		read admin_pw
	done
	echo 'Bitte ein Nutzer-Passwort für die PDF-Datei angeben (optional):'
	read user_pw
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

echo 'Führe PDF-Dateien zusammen…'

course_author='Professoren des FB Physik der WWU – Weitergabe nicht gestattet!'
case $(echo "$course" | tr '[:upper:]' '[:lower:]') in
	'physik1')
		course_title='Altklausuren zu Physik I'
		course_subject='Physik I: Dynamik der Teilchen und Teilchensysteme'
		course_keywords='Physik, Klausur, Klausuren, Scans, Mechanik'
		;;
	'physik2')
		course_title='Altklausuren zu Physik II'
		course_subject='Physik II: Thermodynamik und Elektromagnetismus'
		course_keywords='Physik, Klausur, Klausuren, Scans, Thermodynamik, Elektromagnetismus'
		;;
	'physik3')
		course_title='Altklausuren zu Physik III'
		course_subject='Physik III: Wellen und Quanten'
		course_keywords='Physik, Klausur, Klausuren, Scans, Elektrodynamik'
		;;
	'physik4')
		course_title='Altklausuren zu Physik IV'
		course_subject='Atom- und Quantenphysik'
		course_keywords='Physik, Klausur, Klausuren, Scans, Quantenmechanik, Atomphysik'
		;;
	'physik5')
		course_title='Altklausuren zu Physik V'
		course_subject='Physik V: Quantentheorie'
		course_keywords='Physik, Klausur, Klausuren, Scans, Quantentheorie'
		;;
	'physik6')
		course_title='Altklausuren zu Physik VI'
		course_subject='Physik VI: Statistische Physik'
		course_keywords='Physik, Klausur, Klausuren, Scans, Statistische Physik'
		;;
	'mathe1')
		course_title='Altklausuren zu Mathematik für Physiker I'
		course_subject='Grundlagen der Mathematik: Mathematik für Physiker I'
		course_keywords='Physik, Klausur, Klausuren, Scans, Analysis'
		;;
	'mathe2')
		course_title='Altklausuren zu Mathematik für Physiker II'
		course_subject='Grundlagen der Mathematik: Mathematik für Physiker II'
		course_keywords='Physik, Klausur, Klausuren, Scans, Lineare Algebra'
		;;
	'mathe3')
		course_title='Altklausuren zu Mathematik für Physiker III'
		course_subject='Integrationstheorie'
		course_keywords='Physik, Klausur, Klausuren, Scans, Integrationstheorie'
		;;
	'mathe4')
		course_title='Altklausuren zu Mathematik für Physiker IV'
		course_subject='Mathematik für Physiker IV'
		course_keywords='Physik, Klausur, Klausuren, Scans'
		;;
	'cp')
		course_title='Altklausuren zu Computational Physics'
		course_subject='Computational Physics: Einführung in das wissenschaftliche Programmieren'
		course_keywords='Physik, Klausur, Klausuren, Scans, Fortran'
		;;
	'chemie')
		course_title='Altklausuren zu Chemie (Fachübergreifende Studien)'
		course_subject='Chemie für Physiker'
		course_keywords='Physik, Klausur, Klausuren, Scans, Chemie'
		;;
	'informatik')
		course_title='Altklausuren zu Informatik (Fachübergreifende Studien)'
		course_subject='Informatik'
		course_keywords='Physik, Klausur, Klausuren, Scans, Informatik'
		;;
	'physika')
		course_title='Altklausuren zu Physik A'
		course_subject='Physik A: Physik für Naturwissenschaftler'
		course_keywords='Physik, Klausur, Klausuren, Scans, Nebenfach'
		;;
	*)
		echo "Die Vorlesung/das Modul „${lecture}“ ist nicht bekannt!"
		echo 'Mögliche Werte sind:'
		echo "$course_list"
		exit 1
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

