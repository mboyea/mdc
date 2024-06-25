#!/bin/bash

target_dir="$(pwd)"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
data_dir="$script_dir/data"
template_dir="$data_dir/templates"
make_file="$script_dir/Makefile"
make_args=()
pandoc_args=()
pandoc_args+=("--data-dir='$data_dir'")
latex_args=()

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

compile_pdf() {
  if ! [[ "$target_dir" == "$script_dir" ]]; then
    cp "$make_file" "$target_dir/Makefile"
  fi

  make -C "$target_dir" ${make_args[@]} PANDOC_ARGS="${pandoc_args[@]}" LATEX_ARGS="${latex_args[@]}"

  if ! [[ "$target_dir" == "$script_dir" ]]; then
    rm "$target_dir/Makefile"
  fi
}

main() {
  interpret_args "$@"
  if [[ $is_help_arg -eq 1 ]]; then
    print_help
    exit
  fi
  test_dependency pandoc
  test_dependency pdflatex
  compile_pdf
}

main "$@"
