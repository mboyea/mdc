# ! this is called from the Makefile !
# ? compile-pdf.sh "file.tex" "output-dir" "build-dir" $(LATEX_ARGS)
main() {
  # interpret arguments #
  input_file="$1"
  output_dir="$2"
  build_dir="$3"
  shift
  shift
  shift
  # compile LaTeX to PDF #
  # TODO: detect for "Warning*Rerun" in "./build/$file_name.aux" and if found rerun up to 5 times
  # TODO: make cross-platform by adding logic to replace -aux-directory so MikTex isn't required - do in a bash script
  pdflatex -output-directory="$output_dir" -aux-directory="$build_dir" "$input_file" \
    -interaction=batchmode -halt-on-error -file-line-error -shell-escape "$@" \
    >/dev/null
}

main "$@"
