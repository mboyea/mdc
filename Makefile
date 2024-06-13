# ! dependencies:
# pandoc
# pdflatex
# ? example usage:
# bash --init-file <(cd "$makefile_script_dir" && make -C "$target_dir" TEMPLATE_FILE="$template_file" PANDOC_ARGS="--top-level-division=chapter")

# directories
SRC_DIR := .
BUILD_DIR := build
OUT_DIR := .
PANDOC_ARGS ?=

# file lists
MDS := $(wildcard $(SRC_DIR)/*.md)
BUILDS := $(patsubst $(SRC_DIR)/%,$(BUILD_DIR)/%,$(MDS:.md=.tex))
OUTS := $(patsubst $(BUILD_DIR)/%,$(OUT_DIR)/%,$(BUILDS:.tex=.pdf))

all : $(BUILDS) $(OUTS)

$(OUT_DIR)/%.pdf : $(BUILD_DIR)/%.tex
	@mkdir -p "$(OUT_DIR)"
	@echo "Compiling $@..."; pdflatex -interaction=batchmode -shell-escape -output-directory="$(OUT_DIR)" -aux-directory="$(BUILD_DIR)" "$<"

$(BUILD_DIR)/%.tex : $(SRC_DIR)/%.md
	@mkdir -p "$(BUILD_DIR)"
ifndef TEMPLATE_FILE
	@echo "Compiling $@..."; pandoc --from=markdown --to=latex --standalone --output="$@" "$<" $(PANDOC_ARGS)
else
	@echo "Compiling $@..."; pandoc --from=markdown --to=latex --template="$(TEMPLATE_FILE)" --standalone --output="$@" "$<" $(PANDOC_ARGS)
endif
clean :
	@echo "Cleaning..."; $(RM) -r $(BUILDS) $(OUTS)

.PHONY: all clean
