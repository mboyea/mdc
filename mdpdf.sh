#!/bin/bash

target_dir="$(pwd)"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
template_dir="$script_dir/templates"
make_file="$script_dir/Makefile"
make_args=()

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
  echo "  -h        --help"
  echo "  -w        --watch"
  echo "  -t FILE   --template FILE"
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
      -t|--template)
        is_template_arg=1
        template_file="$(template_dir)/$2"
        shift
        shift
      ;;
      -*|--*)
        echoerror "The option "$1" is not recognized"
        exit 1
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
  cp "$make_file" "$target_dir/Makefile"
  if [[ $is_template_arg -eq 1 ]]; then
    make -C "$target_dir" TEMPLATE_FILE="$template_file" ${make_args[@]}
  else
    make -C "$target_dir" ${make_args[@]}
  fi
  rm "$target_dir/Makefile"
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
