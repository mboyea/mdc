# ! dependencies:
# pandoc
# pdflatex
# tput
# ./mdpdf-bin/compile-tex.sh

# directories
SRC_DIR := .
BUILD_DIR := build
OUT_DIR := .
DATA_DIR ?=
PANDOC_ARGS ?=
LATEX_ARGS ?=

# file lists
MDS := $(wildcard $(SRC_DIR)/*.md)
BUILDS := $(patsubst $(SRC_DIR)/%,$(BUILD_DIR)/%,$(MDS:.md=.tex))
OUTS := $(patsubst $(BUILD_DIR)/%,$(OUT_DIR)/%,$(BUILDS:.tex=.pdf))

# constant values
BOLD := $(shell tput bold)
SGR0 := $(shell tput sgr0)

all : $(BUILDS) $(OUTS)

$(OUT_DIR)/%.pdf : $(BUILD_DIR)/%.tex
	@mkdir -p "$(OUT_DIR)"
	@echo "Compiling $(BOLD)$@$(SGR0)..."
	@-pdflatex -interaction=batchmode -halt-on-error -file-line-error -shell-escape -output-directory="$(OUT_DIR)" -aux-directory="$(BUILD_DIR)" "$<" $(LATEX_ARGS) \
		>/dev/null
# TODO: detect for "Warning*Rerun" in "./build/$file_name.aux" and if found rerun up to 5 times
# TODO: make cross-platform by adding logic to replace -aux-directory so MikTex isn't required - do in a bash script

$(BUILD_DIR)/%.tex : $(SRC_DIR)/%.md
	@mkdir -p "$(BUILD_DIR)"
	@echo "Compiling $(BOLD)$@$(SGR0)..."
	@-./mdpdf-bin/compile-tex.sh "$<" "$@" "$(DATA_DIR)" $(PANDOC_ARGS)

clean :
	@echo "Cleaning..."; $(RM) -r $(BUILD_DIR) $(OUTS)

.PHONY: all clean
