'''
dependencies for this project
'''

def populate(d):
    d.packs=[
        # for translating between various formats
        'unoconv',
        # for converting mkd files to html
        'markdown',
        # for beamer presentations
        'texlive-latex-base',
        # for asciidoc presentations (a2x(1))
        'asciidoc',
    ]

def getdeps():
    return [
        __file__, # myself
    ]
