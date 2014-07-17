##############
# parameters #
##############
# do you want to show the commands executed ?
# Since we are using ?= for assignment it means that you can just
# set this from the command line and avoid changing the makefile...
DO_MKDBG?=0
# do you want dependency on the makefile itself ?!?
DO_ALL_DEPS:=1
# should we do the openoffice conversions?
DO_SOFFICE:=1
# -x: remove everything not known to git (not only ignore rules).
# -X: remove files in .gitignore but not everything unknown to git
# -d: remove directories also.
# -f: force.
# hard clean (may remove manually created files not yet added to the git index):
GIT_CLEAN_FLAGS:=-xdf
# soft clean (only removes .gitignore files)
#GIT_CLEAN_FLAGS:=-Xdf

#####################
# end of parameters #
#####################
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
ifeq ($(DO_SOFFICE),1)
ALL:=$(ALL) $(ODP_PPT) $(ODP_PDF)
endif

#########
# rules #
#########

.PHONY: all
all: $(ALL)

# rules about odps
$(ODP_PPT): %.ppt: %.odp $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)unoconv --format ppt $<
	$(Q)chmod 444 $@
#$(Q)scripts/DocumentConverter.py $< $@
$(ODP_PDF): %.pdf: %.odp $(ALL_DEPS)
	$(info doing [$@])
	$(Q)rm -f $@
	$(Q)unoconv --format pdf $<
	$(Q)chmod 444 $@
#$(Q)scripts/DocumentConverter.py $< $@

.PHONY: soffice
soffice:
	$(Q)soffice "-accept=socket,port=2002;urp;" > /dev/null 2> /dev/null &

.PHONY: debug
debug:
	$(info ALL is $(ALL))
	$(info ODP_SRC is $(ODP_SRC))
	$(info ODP_PPT is $(ODP_PPT))
	$(info ODP_PDF is $(ODP_PDF))

.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)git clean $(GIT_CLEAN_FLAGS) > /dev/null
