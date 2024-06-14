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

  make -C "$target_dir" ${make_args[@]}

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
