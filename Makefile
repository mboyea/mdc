# ! dependencies:
# pandoc
# pdflatex
# ? example usage:
# bash --init-file <(cd "$makefile_script_dir" && make -C "$target_dir" PANDOC_BEFORE_ARGS="--data-dir='$data_dir'" PANDOC_ARGS="--top-level-division=chapter --template="$template_file")

# directories
SRC_DIR := .
BUILD_DIR := build
OUT_DIR := .
PANDOC_BEFORE_ARGS ?=
PANDOC_ARGS ?=
LATEX_ARGS ?=

# file lists
MDS := $(wildcard $(SRC_DIR)/*.md)
BUILDS := $(patsubst $(SRC_DIR)/%,$(BUILD_DIR)/%,$(MDS:.md=.tex))
OUTS := $(patsubst $(BUILD_DIR)/%,$(OUT_DIR)/%,$(BUILDS:.tex=.pdf))

# constant values
CURRENT_DATE := $(shell date '+%B %e, %Y')
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
	@-TEMPLATE_FILE_ARG=$$(sed -n 's/^template_:[ ][ ]*\(.*\)/\1/p' $< | sed 's/^\(..*\)$$/--template=\1/') \
		&& DEFAULTS_FILES_ARG=$$(sed -n 's/^default_:[ ][ ]*\(.*\)/\1/p' $< | sed 's/^\(..*\)$$/--defaults=\1/' | { grep . || echo '--defaults=letterpaper'; }) \
		&& METADATA_DATE_ARG="--metadata='date: $(CURRENT_DATE)'" \
		&& pandoc --from=markdown --to=latex --standalone "$<" --output="$@" $(PANDOC_BEFORE_ARGS) $$TEMPLATE_FILE_ARG $$DEFAULTS_FILES_ARG $(PANDOC_ARGS)
# TODO: use $(METADATA_DATE_ARG) if "date:" cannot be found in YAML

clean :
	@echo "Cleaning..."; $(RM) -r $(BUILD_DIR) $(OUTS)

.PHONY: all clean
