max_recompiles=5

# ! this is called from the Makefile !
# ? compile-pdf.sh "file.tex" "output-dir" "build-dir" $(LATEX_ARGS)
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
  i=0
  while [[ true ]] ; do
    pdflatex -output-directory="$output_dir" -aux-directory="$build_dir" "$input_file_path" \
      -interaction=batchmode -halt-on-error -file-line-error -shell-escape "$@" \
      >/dev/null \
    # TODO: remove -aux-directory and instead manually move all build files to the build directory from the output directory
    i=$(($i + 1))
    # grep -Fxq "$FILENAME" my_list.txt
    # [ $i -lt $max_recompiles ] 
    # if not (can compile again AND should rerun to update labels) break loop
    if ! (
      [ $i -lt $max_recompiles ] \
      && grep -Fxq "LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right." "$build_dir/$input_file_name.log" \
    ) ; then
      break
    fi
  done
}

main "$@"
