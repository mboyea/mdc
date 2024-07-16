#!/bin/bash

target_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
bin_dir="$script_dir/bin"
data_dir="$script_dir/data"
make_args=()
pandoc_args=()
latex_args=()
template_dir="$data_dir/templates"

echoerror() { echo "Error: $@" 1>&2; }

test_dependency() {
  if ! [ -x "$(command -v $1)" ]; then
    echoerror The required program "$1" is not installed
    exit 1
  fi
}

print_help() {
  echo "Use Pandoc to convert Markdown+LaTeX to PDF"
  echo "mdpdf [OPTIONS]... [MAKE ARGUMENTS]..."
  echo "___________________________________________"
  echo "OPTIONS:"
  echo "  -h            --help"
  echo "  -w            --watch"
  echo "  -p STRING     --pandoc-args STRING"
  echo "  -l STRING     --latex-args STRING"
  echo "  -t FILE       --template FILE"
}

interpret_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        is_help_arg=1
        shift
      ;;
      -w|--watch)
        is_watch_arg=1
        shift
        echoerror "The option "--watch" is not yet supported"
      ;;
      -p|--pandoc-args)
        is_pandoc_args=1
        pandoc_args+=("$2")
        shift
        shift
      ;;
      -l|--latex-args)
        is_latex_args=1
        latex_args+=("$2")
        shift
        shift
      ;;
      -t|--template)
        is_template_arg=1
        template_file="$template_dir/$2"
        pandoc_args+=("--template='$template_file'")
        shift
        shift
      ;;
      *)
        make_args+=("$1")
        shift
      ;;
    esac
  done
  set -- "${make_args[@]}"
}

compile_each_file() {
  # place dependencies within target folder (due to limitations with GNUMake)
  if ! [[ "$target_dir" == "$script_dir" ]]; then
    rm -f "$target_dir/Makefile"
    cp "$script_dir/Makefile" "$target_dir/Makefile"
  fi
  rm -rf "$target_dir/mdpdf-bin"
  cp -r "$bin_dir" "$target_dir/mdpdf-bin"

  # use make to compile each pdf
  make -C "$target_dir" ${make_args[@]} DATA_DIR="$data_dir" PANDOC_ARGS="${pandoc_args[@]}" LATEX_ARGS="${latex_args[@]}"

  # remove dependencies from target folder
  if ! [[ "$target_dir" == "$script_dir" ]]; then
    rm "$target_dir/Makefile"
  fi
  rm -r "$target_dir/mdpdf-bin"
}

main() {
  interpret_args "$@"
  if [[ $is_help_arg -eq 1 ]]; then
    print_help
    exit
  fi
  test_dependency pandoc
  test_dependency pdflatex
  compile_each_file
}

main "$@"
