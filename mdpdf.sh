#!/bin/bash

target_dir=pwd
# script_dir=dirname "$(readlink -f "$0")"

# TODO test pandoc, pdflatex, watchexec

print_help() {
	echo "Use Pandoc to convert Markdown+LaTeX to PDF"
	echo "mdpdf [OPTION]... [FILE]..."
	echo
	echo "OPTIONS:"
	echo "  -h        --help"
	echo "  -w        --watch"
}

# bash --init-file <(cd $script_dir && make -C $target_dir)

# if not matched with any option, print help
print_help
