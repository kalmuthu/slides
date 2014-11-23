##############
# parameters #
##############
# do you want to show the commands executed ?
DO_MKDBG:=0
# do you want dependency on the makefile itself ?!?
DO_ALL_DEPS:=1

########
# code #
########
ALL:=

# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

# dependency on the makefile itself
ifeq ($(DO_ALL_DEPS),1)
ALL_DEPS:=Makefile
else
ALL_DEPS:=
endif

# odps
ODP_SRC:=$(shell find odp -name "*.odp")
ODP_BAS:=$(basename $(ODP_SRC))
ODP_PPT:=$(addsuffix .ppt,$(ODP_BAS))
ODP_PDF:=$(addsuffix .pdf,$(ODP_BAS))
ALL+=$(ODP_PPT) $(ODP_PDF)
all: $(ALL)

# markdown
MKD_SRC:=$(shell find mkd -name "*.mkd")
MKD_BAS:=$(basename $(MKD_SRC))
MKD_HTML:=$(addsuffix .html,$(MKD_BAS))
ALL+=$(MKD_HTML)
all: $(ALL)

# beamer
BEAMER_SRC:=$(shell find beamer -name "*.tex")
BEAMER_BAS:=$(basename $(BEAMER_SRC))
BEAMER_PDF:=$(addsuffix .pdf,$(BEAMER_BAS))
ALL+=$(BEAMER_PDF)
all: $(ALL)

#########
# rules #
#########

.DEFAULT_GOAL=all
.PHONY: all
all: $(ALL)

# rules about odps
$(ODP_PPT): %.ppt: %.odp $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)unoconv --format ppt $<
	$(Q)chmod 444 $@
$(ODP_PDF): %.pdf: %.odp $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)unoconv --format pdf $<
	$(Q)chmod 444 $@
# rules about markdown
$(MKD_HTML): %.html: %.mkd $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)markdown $< > $@
	$(Q)chmod 444 $@
# rules about beamer
$(BEAMER_PDF): %.pdf: %.tex $(ALL_DEPS)
	$(info doing [$@])
	$(Q)scripts/wrapper_pdflatex.pl $< $@
	$(Q)rm -f $(basename $<).log $(basename $<).aux $(basename $<).nav $(basename $<).out $(basename $<).snm $(basename $<).toc $(basename $<).vrb

.PHONY: all_odp
all_odp: $(ODP_PPT) $(ODP_PDF)

.PHONY: all_mkd
all_mkd: $(MKD_HTML)

.PHONY: all_beamer
all_beamer: $(BEAMER_PDF)

.PHONY: debug
debug:
	$(info doing [$@])
	$(info ALL is $(ALL))
	$(info ODP_SRC is $(ODP_SRC))
	$(info ODP_PPT is $(ODP_PPT))
	$(info ODP_PDF is $(ODP_PDF))
	$(info MKD_SRC is $(MKD_SRC))
	$(info MKD_HTML is $(MKD_HTML))
	$(info BEAMER_SRC is $(BEAMER_SRC))
	$(info BEAMER_HTML is $(BEAMER_HTML))

.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)git clean -xdf > /dev/null
