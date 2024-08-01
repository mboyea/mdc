# ! dependencies:
# pandoc
# pdflatex
# tput
# ./mdpdf-bin/compile-tex.sh

# directories
SRC_DIR := .
BUILD_DIR := pdf-build
OUT_DIR := .
DATA_DIR ?=
BIN_DIR ?=
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
	@if pdflatex --version | grep -q 'MikTeX'; then \
		(export TEXINPUTS="$(DATA_DIR)" && "$(BIN_DIR)/compile-pdf.sh" "$<" "$(OUT_DIR)" "$(BUILD_DIR)" $(LATEX_ARGS)) \
	else \
		(export TEXINPUTS=".;$(DATA_DIR);" && "$(BIN_DIR)/compile-pdf.sh" "$<" "$(OUT_DIR)" "$(BUILD_DIR)" $(LATEX_ARGS)) \
	fi

$(BUILD_DIR)/%.tex : $(SRC_DIR)/%.md
	@mkdir -p "$(BUILD_DIR)"
	@echo "Building $(BOLD)$@$(SGR0)..."
	@"$(BIN_DIR)/compile-latex.sh" "$<" "$@" "$(DATA_DIR)" $(PANDOC_ARGS)

clean :
	@echo "Cleaning..."; $(RM) -r $(BUILD_DIR) $(OUTS)

.PHONY: all clean
