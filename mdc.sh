#!/usr/bin/env bash

target_dir="$(pwd)"
mdc_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
bin_dir="$mdc_dir/bin"
data_dir="$mdc_dir/data"
additonal_args=()

echoerror() { echo "Error: $@" 1>&2; }

print_help() {
  echo "Use Pandoc to convert Markdown files to other formats"
  echo "mdc [SCRIPT] [ARGUMENTS]..."
  echo "_____________________________________________________"
  echo "SCRIPTS:"
  echo "  help            --help          -h"
  echo "  pdf"
}

interpret_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      help|--help|-h)
        is_help_arg=1
        shift
      ;;
      pdf)
        is_pdf_arg=1
        : "${script:="$bin_dir/mdc-pdf.sh"}"
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

main() {
  interpret_args "$@"
  if [[ $is_help_arg -eq 1 ]]; then
    if [[ -n "$script" ]]; then
      "$script" --help
    else
      print_help
    fi
  elif [[ -n "$script" ]]; then
    "$script" --target-dir "$target_dir" --bin-dir "$bin_dir" --data-dir "$data_dir" ${additonal_args[@]}
  else
    echoerror "No valid script identified among arguments '${additonal_args[@]}'"
    echo "Run 'mdc --help' to see a list of valid scripts"
    exit 1
  fi
}

main "$@"
