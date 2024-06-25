# ! dependencies:
# pandoc
# pdflatex
# ? example usage:
# bash --init-file <(cd "$makefile_script_dir" && make -C "$target_dir" PANDOC_ARGS="--top-level-division=chapter --template="$template_file")

# directories
SRC_DIR := .
BUILD_DIR := build
OUT_DIR := .
PANDOC_ARGS ?=
LATEX_ARGS ?=

# file lists
MDS := $(wildcard $(SRC_DIR)/*.md)
BUILDS := $(patsubst $(SRC_DIR)/%,$(BUILD_DIR)/%,$(MDS:.md=.tex))
OUTS := $(patsubst $(BUILD_DIR)/%,$(OUT_DIR)/%,$(BUILDS:.tex=.pdf))

# constant values
METADATA_DATE_ARG := --metadata="date:$(shell date '+%B %e, %Y')"
BOLD := $(shell tput bold)
SGR0 := $(shell tput sgr0)

all : $(BUILDS) $(OUTS)

$(OUT_DIR)/%.pdf : $(BUILD_DIR)/%.tex
	@mkdir -p "$(OUT_DIR)"
	@echo "Compiling $(BOLD)$@$(SGR0)..."
	@-pdflatex -interaction=batchmode -halt-on-error -file-line-error -shell-escape -output-directory="$(OUT_DIR)" -aux-directory="$(BUILD_DIR)" "$<" $(LATEX_ARGS) \
  >/dev/null

$(BUILD_DIR)/%.tex : $(SRC_DIR)/%.md
	@mkdir -p "$(BUILD_DIR)"
	@echo "Compiling $(BOLD)$@$(SGR0)..."
	@-FILE_TEMPLATE_ARG=$$(sed -n 's/^template_:[ ][ ]*\(.*\)/\1/p' $< | sed 's/^\(..*\)$$/--template=\1/') \
    && pandoc --from=markdown --to=latex --standalone "$<" --output="$@" $$FILE_TEMPLATE_ARG $(METADATA_DATE_ARG) $(PANDOC_ARGS)
# TODO: only use $(shell date) if "date:" cannot be found in YAML
# TODO: add in-file YAML --defaults support using "defaults_:"

clean :
	@echo "Cleaning..."; $(RM) -r $(BUILD_DIR) $(OUTS)

.PHONY: all clean
