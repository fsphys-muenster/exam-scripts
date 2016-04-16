#!/usr/bin/env python3
import datetime
import glob
import math
import os
import random
import string
from dateutil.relativedelta import *

def is_ss(date):
	return date.month in range(4, 10)

# first: determine which dates to generate passwords for
today = datetime.date.today()
date_start = today
# get dates for current and next semester
ws_start = datetime.date(today.year, 10, 1)
if ws_start > today and not is_ss(today):
	ws_start -= relativedelta(years=1)
ss_start = datetime.date(today.year, 4, 1)
if ss_start < today and not is_ss(today):
	ss_start += relativedelta(years=1)
# figure out which semester we're in
if is_ss(today):
	date_start = ss_start
else:
	date_start = ws_start
# start and end date for this and the next semester
# start date is Monday before the start of the semester
date_start_this = date_start + relativedelta(weekday=MO(-1))
date_end_this = date_start + relativedelta(months=6)
date_end_this = datetime.date(date_end_this.year, date_end_this.month, 1) + \
	relativedelta(weekday=MO(+1))
date_start_next = date_end_this
date_end_next = date_start_next + relativedelta(months=6)
date_end_next = datetime.date(date_end_next.year, date_end_next.month, 1) + \
	relativedelta(weekday=MO(+1))

TEX_DOC_START = r'''
\documentclass[a4paper, 12pt, landscape, ngerman]{scrartcl}
\usepackage{babel}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[left=1.7cm, right=2.7cm, top=2cm, bottom=3cm]{geometry}
\usepackage{stubs}

\pagestyle{empty}

\begin{document}

\Huge
\centering
'''
TEX_PAGE_END = r'''

\vspace{3cm}
\stubs[20]{10cm}{\currpw}
\clearpage
'''
TEX_DOC_END = r'''

\end{document}
'''

def which_semester(date):
	if is_ss(date):
		return 'SS {}'.format(date.year)
	else:
		return 'WS {}/{}'.format(date.year, date.year + 1)

def timedelta_in_weeks(date_start, date_end):
	return math.ceil((date_end - date_start) / datetime.timedelta(weeks=1))

def generate_files(date_start, date_end):
	print(date_start, date_end)
	semester_text = which_semester(date_start + datetime.timedelta(weeks=2))
	tex_page_start = r'''
	\vspace*{0.5cm}
	\textbf{Linkpasswörter ''' + semester_text + r'''}

	\vspace{3cm}
	'''
	tex_file_name = 'linkpasswoerter_' + semester_text.replace('/', '-').replace(' ', '_')
	weeks_in_semester = timedelta_in_weeks(date_start, date_end)

	# generate passwords
	chars = list((set(string.ascii_letters) | set(string.digits)) - set('1IlO0'))
	passwords = []
	for _ in range(weeks_in_semester):
		passwords.append(''.join(random.choice(chars) for _ in range(8)))

	# generate .pdf and .txt file
	date = date_start
	txt_doc = ''
	tex_body = ''
	for i in range(weeks_in_semester):
		day_start = '{:%d.%m.}'.format(date)
		date += datetime.timedelta(weeks=1)
		day_end = '{:%d.%m.}'.format(date - datetime.timedelta(days=1))
		txt_week_text = '{}–{}: {}\n'.format(day_start, day_end, passwords[i])
		tex_week_text = r'\def\currpw{{{}–{}:~~\texttt{{{}}}}}\currpw'.format(
			day_start, day_end, passwords[i])
		txt_doc += txt_week_text
		tex_body += tex_page_start + tex_week_text + TEX_PAGE_END
	tex_doc = TEX_DOC_START + tex_body + TEX_DOC_END

	with open(tex_file_name + '.txt', 'w') as txt_file:
		txt_file.write(txt_doc)
	with open(tex_file_name + '.tex', 'w') as tex_file:
		tex_file.write(tex_doc)
	os.system('pdflatex -interaction=nonstopmode ' + tex_file_name + '.tex')

generate_files(date_start_this, date_end_this)
generate_files(date_start_next, date_end_next)
aux_files = glob.glob('*.log') + glob.glob('*.gz') + glob.glob('*.aux')
try:
	for f in aux_files:
		os.remove(f)
except OSError:
	pass

