#!/usr/bin/python3

'''
this script will install all the required packages that you need on
ubuntu to compile and work with this package.
'''

import subprocess # for check_call

packs=[
	# for translating between various formats
	'unoconv',
	# for converting mkd files to html
	'markdown',
	# for beamer presentations
	'texlive-latex-base',
]

args=['sudo','apt-get','install','--assume-yes']
args.extend(packs)
subprocess.check_call(args)
