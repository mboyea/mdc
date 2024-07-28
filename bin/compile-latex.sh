#!/usr/bin/env bash

# ! this is called from the Makefile !
# ? compile-latex.sh "file.md" "file.pdf" "data-dir" $(PANDOC_ARGS)
# ! dependencies !
# ? pandoc

main() {
  # interpret arguments #
  input_file="$1"
  output_file="$2"
  data_dir="$3"
  shift
  shift
  shift
  # intepret metadata #
  # if template_: found in header, use the following value as argument --template
  TEMPLATE_FILE_ARG=$(sed -n 's/^template_:[ ][ ]*\(.*\)/\1/p' "$input_file" | sed 's/^\(..*\)$/--template=\1/' | { grep . || echo '--template=default'; })
  # if default_: found in header, use the following value as argument --defaults
  DEFAULTS_FILES_ARG=$(sed -n 's/^default_:[ ][ ]*\(.*\)/\1/p' "$input_file" | sed 's/^\(..*\)$/--defaults=\1/' | { grep . || echo '--defaults=letterpaper'; })
  # if date: not found in header, use the current date as argument --metadata=date
  METADATA_DATE_ARG=$(sed -n 's/^date:[ ][ ]*\(.*\)/\1/p' "$input_file" | sed 's/^\(..*\)$/--metadata=/' | { grep . || echo "--metadata=date:$(date '+%B %e, %Y')"; })
  # compile Markdown to LaTeX #
  pandoc --from=markdown --to=latex --standalone "$input_file" --output="$output_file" --data-dir="$data_dir" "$DEFAULTS_FILES_ARG" "$TEMPLATE_FILE_ARG" "$METADATA_DATE_ARG" "$@"
}

main "$@"

