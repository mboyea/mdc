#!/usr/bin/env bash

# ! this is called from mdc.sh !
# ? mdc-pdf.sh target-dir "$target_dir" bin-dir "$bin_dir" data-dir "$data_dir" ${additonal_args[@]}
# ! dependencies !
# ? pdflatex
# ? pandoc

additonal_args=()

echoerror() { echo "Error: $@" 1>&2; }

test_dependency() {
  if ! [ -x "$(command -v $1)" ]; then
    echoerror The required program "$1" is not installed
    exit 1
  fi
}

print_help() {
  echo "Use Pandoc and LaTeX to convert Markdown files to PDF"
  echo "mdc pdf [ARGUMENTS]... [MAKE ARGUMENTS]..."
  echo "_____________________________________________________"
  echo "ARGUMENTS:"
  echo "  help            --help          -h"
  echo "MAKE ARGUMENTS:"
}

interpret_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      help|--help|-h)
        is_help_arg=1
        shift
      ;;
      --target-dir)
        is_target_arg=1
        target_dir="$2"
        shift
        shift
      ;;
      --bin-dir)
        is_bin_arg=1
        bin_dir="$2"
        shift
        shift
      ;;
      --data-dir)
        is_data_arg=1
        data_dir="$2"
        shift
        shift
      ;;
      *)
        additonal_args+=("$1")
        shift
      ;;
    esac
  done
  set -- "${additonal_args[@]}"
}

compile_each_file() {
  make --directory="$target_dir" --file="$bin_dir/mdc-pdf-makefile" ${additonal_args[@]} BIN_DIR="$bin_dir" DATA_DIR="$data_dir"
}

main() {
  interpret_args "$@"
  if [[ $is_help_arg -eq 1 ]]; then
    print_help
    exit
  fi
  test_dependency pdflatex
  test_dependency pandoc
  compile_each_file
}

main "$@"
