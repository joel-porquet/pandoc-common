# No implicit rules
MAKEFLAGS += -rR

## Get current directory where this very file is located
current_dir := $(dir $(lastword $(MAKEFILE_LIST)))

## Define and check external programs
PANDOC := pandoc
ifeq (,$(shell command -v $(PANDOC) 2>/dev/null))
$(error Could not find executable '$(PANDOC)' in PATH)
endif

## Find all files under a directory
find_files = $(shell find $(1) -type f)

## List of markdown files and resulting html files
# get explicit md files out of $(src)
md := $(filter %.md,$(src))
# scan recursively directories from $(src)
md-dirs := $(filter-out $(md),$(src))
ifneq ($(md-dirs),)
md += $(filter %.md,$(call find_files,$(md-dirs)))
endif
html := $(md:%.md=%.html)
pdf := $(md:%.md=%.pdf)

## Extra dependencies for all targets
dep += $(addprefix $(current_dir),pygmentize.py)
dep += $(addprefix $(current_dir),code.css)
dep += $(addprefix $(current_dir),main.css)

## Command management and quiet mode
ifneq ($(V),1)
Q = @
quiet = quiet_
else
Q =
quiet =
endif

echo-cmd = $(if $($(quiet)cmd_$(1)),\
	echo '  $($(quiet)cmd_$(1))';)
cmd = @$(echo-cmd) $(cmd_$(1))

## Our main rule building all our targets
all: $(html)

## Markdown to HTML rule
quiet_cmd_pandoc = PANDOC $@
      cmd_pandoc = $(PANDOC) \
				   -s --self-contained \
				   --toc --toc-depth=1 -N \
				   --webtex \
				   --resource-path=.:$(current_dir) \
				   --filter $(addprefix $(current_dir),pygmentize.py) \
				   --css $(addprefix $(current_dir),main.css) \
				   --css $(addprefix $(current_dir),code.css) \
				   $< -o $@
%.html: %.md $(dep)
	$(call cmd,pandoc)

## PDF main rule
pdf: $(html) $(pdf)

## HTML to pdf rule
quiet_cmd_pdfgen = PDF $@
      cmd_pdfgen = chromium --headless --disable-gpu \
				  --print-to-pdf=$@ \
				  file://$(abspath $<) \
				  2>/dev/null
%.pdf: %.html
	$(call cmd,pdfgen)

## Clean rule
clean:
	$(Q)rm -f $(html) $(pdf)

