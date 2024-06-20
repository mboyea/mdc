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

all : $(BUILDS) $(OUTS)

$(OUT_DIR)/%.pdf : $(BUILD_DIR)/%.tex
	@mkdir -p "$(OUT_DIR)"
	@echo "Compiling $@...";
	@-pdflatex -interaction=batchmode -halt-on-error -file-line-error -shell-escape -output-directory="$(OUT_DIR)" -aux-directory="$(BUILD_DIR)" "$<" $(LATEX_ARGS)

$(BUILD_DIR)/%.tex : $(SRC_DIR)/%.md
	@mkdir -p "$(BUILD_DIR)"
	@echo "Compiling $@..."; pandoc --from=markdown --to=latex --standalone --output="$@" "$<" $(PANDOC_ARGS)
clean :
	@echo "Cleaning..."; $(RM) -r $(BUILD_DIR) $(OUTS)

.PHONY: all clean
