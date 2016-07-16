##############
# parameters #
##############
# do you want to show the commands executed ?
DO_MKDBG:=0
# do you want dependency on the makefile itself ?!?
DO_ALL_DEPS:=1
# do you want to do 'ppt' from 'odp'?
DO_FMT_ODP_PPT:=1
# do you want to do 'pdf' from 'odp'?
DO_FMT_ODP_PDF:=1
# do you want to do 'html' from 'mkd'?
DO_FMT_MKD_HTML:=1
# do you want to do 'pdf' from 'tex'?
DO_FMT_TEX_PDF:=1

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
ODP_PPT:=$(addprefix out/,$(addsuffix .ppt,$(ODP_BAS)))
ODP_PDF:=$(addprefix out/,$(addsuffix .pdf,$(ODP_BAS)))
ifeq ($(DO_FMT_ODP_PPT),1)
ALL+=$(ODP_PPT)
endif
ifeq ($(DO_FMT_ODP_PDF),1)
ALL+=$(ODP_PDF)
endif
all: $(ALL)

# markdown
MKD_SRC:=$(shell find mkd -name "*.mkd")
MKD_BAS:=$(basename $(MKD_SRC))
MKD_HTML:=$(addprefix out/,$(addsuffix .html,$(MKD_BAS)))
ifeq ($(DO_FMT_MKD_HTML),1)
ALL+=$(MKD_HTML)
endif
all: $(ALL)

# beamer
TEX_SRC:=$(shell find beamer -name "*.tex")
TEX_BAS:=$(basename $(TEX_SRC))
TEX_PDF:=$(addprefix out/,$(addsuffix .pdf,$(TEX_BAS)))
ifeq ($(DO_FMT_TEX_PDF),1)
ALL+=$(TEX_PDF)
endif
all: $(ALL)

#########
# rules #
#########

.DEFAULT_GOAL=all
.PHONY: all
all: $(ALL)

# rules about odps
$(ODP_PPT): out/%.ppt: %.odp $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)mkdir -p $(dir $@)
	$(Q)unoconv --timeout 5 --output $@ --format ppt $<
	$(Q)chmod 444 $@
$(ODP_PDF): out/%.pdf: %.odp $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)mkdir -p $(dir $@)
	$(Q)unoconv --timeout 5 --output $@ --format pdf $<
	$(Q)chmod 444 $@
# rules about markdown
$(MKD_HTML): out/%.html: %.mkd $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)mkdir -p $(dir $@)
	$(Q)markdown $< > $@
	$(Q)chmod 444 $@
# rules about beamer
$(TEX_PDF): out/%.pdf: %.tex $(ALL_DEPS)
	$(info doing [$@])
	$(Q)mkdir -p $(dir $@)
	$(Q)scripts/wrapper_pdflatex.pl $< $@
	$(Q)rm -f $(basename $@).log $(basename $@).aux $(basename $@).nav $(basename $@).out $(basename $@).snm $(basename $@).toc $(basename $@).vrb

.PHONY: all_odp
all_odp: $(ODP_PPT) $(ODP_PDF)

.PHONY: all_mkd
all_mkd: $(MKD_HTML)

.PHONY: all_beamer
all_beamer: $(TEX_PDF)

.PHONY: debug
debug:
	$(info doing [$@])
	$(info ALL is $(ALL))
	$(info ODP_SRC is $(ODP_SRC))
	$(info ODP_PPT is $(ODP_PPT))
	$(info ODP_PDF is $(ODP_PDF))
	$(info MKD_SRC is $(MKD_SRC))
	$(info MKD_HTML is $(MKD_HTML))
	$(info TEX_SRC is $(TEX_SRC))
	$(info TEX_HTML is $(TEX_HTML))

.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)git clean -xdf > /dev/null
