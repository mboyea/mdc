#!/usr/bin/env bash

# ! this is called from the Makefile !
# ? compile-pdf.sh "file.tex" "output-dir" "build-dir" $(LATEX_ARGS)
# ! dependencies !
# ? pdflatex

max_compile_count=5

main() {
  # interpret arguments #
  input_file_path="$1"
  input_file=$(basename "$input_file_path")
  input_file_name="${input_file%.*}"
  output_dir="$2"
  build_dir="$3"
  shift
  shift
  shift
  # compile LaTeX to PDF #
  compile_count=0
  while [[ true ]] ; do
    # compile the latex (or update references in .aux build file)
    pdflatex -output-directory="$output_dir" "$input_file_path" \
      -interaction=batchmode -halt-on-error -file-line-error -shell-escape "$@" \
      >/dev/null
    compile_count=$(($compile_count + 1))
    # keep looping unless (allowed to compile again AND need to recompile to resolve LaTeX labels)
    if (
      [ $compile_count -lt $max_compile_count ] \
      && grep -Fxq "LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right." "$output_dir/$input_file_name.log" \
    ) ; then
      echo "Recompiling to resolve LaTeX labels..."
    else
      break
    fi
  done
  # move log and aux files into build folder (to emulate -aux-directory argument that's only supported in MiKTeX)
  mv -t "$build_dir" "$output_dir/$input_file_name.log" "$output_dir/$input_file_name.aux"
}

main "$@"

