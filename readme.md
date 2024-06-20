---
title: Pandoc Scripts
author: [Matthew Terrance Carlos Boyea]
date: "2024-09-30"
lang: en
subject: pandoc
keywords: [windows, linux, pandoc, markdown, md, latex, tex, gnumake, makefile, pdf, scripts]
---
## A scripts to compile plaintext Markdown + LaTeX documents using Pandoc + Makefile

I use these scripts to process documents at work.

### Install (Windows w/o Administrator Privileges)

- Install [Pandoc for Windows](https://github.com/jgm/pandoc/releases/)
- Install [MiKTeX (LaTeX for Windows)](https://miktex.org/download)
- Install [MSYS2 (Linux build tools for Windows)](https://www.msys2.org/)
- Install Git, Makefile, and WatchExec: In MSYS2 UCRT64, run `pacman -S git make mingw-w64-ucrt-x86_64-watchexec`
- In MSYS2 UCRT64, `cd` to the directory you want to install this repository and run `git clone https://github.com/mboyea/pandoc-scripts`
- In `C:\msys64\home\<user>\.bashrc` add line `alias mdpdf='<path>/pandoc-scripts/mdpdf.sh'`
- In `C:\msys64\home\<user>\.bash_profile` add line `if [ -f ~/.bashrc ]; then . ~/.bashrc; fi`
- In `C:/msys64/ucrt64.ini` uncomment line `MSYS2_PATH_TYPE=inherit`

### Install (Arch Linux)

- Run `pacman -S texlive-basic texlive-latexrecommended texlive-latexextra texlive-fontsrecommended`
- Install Pandoc: Get `pandoc-bin` from AUR **or** `pandoc-cli` from pacman *(do not install both)*
- [Clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository#cloning-a-repository) to a directory on your computer. That directory will be referred to as `root`.

### Install (NixOS Home Manager)

- Add packages to the config file:

```sh
git
pandoc
texliveFull
gnumake
```

- Rebuild the config file with `home-manager switch`.
- [Clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository#cloning-a-repository) to a directory on your computer. That directory will be referred to as `root`.

### Compile PDFs

- `pandoc --from=markdown --to=pdf --standalone --output="ErrorMemo.pdf" "ErrorMemo.md"`
- `bash --init-file <(cd path/to/directory/with/makefile && make -C path/to/directory/with/target/files)`
