max_compile_count=5

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
  compile_count=0
  while [[ true ]] ; do
    pdflatex -output-directory="$output_dir" -aux-directory="$build_dir" "$input_file_path" \
      -interaction=batchmode -halt-on-error -file-line-error -shell-escape "$@" \
      >/dev/null \
    # TODO: remove -aux-directory and instead manually move all build files to the build directory from the output directory
    compile_count=$(($compile_count + 1))
    # keep looping unless (allowed to compile again AND need to recompile to update LaTeX labels)
    if ! (
      [ $compile_count -lt $max_compile_count ] \
      && grep -Fxq "LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right." "$build_dir/$input_file_name.log" \
    ) ; then
      break
    fi
  done
}

main "$@"
