---
title: Pandoc Scripts
author: [Matthew Terrance Carlos Boyea]
lang: en
subject: pandoc
keywords: [windows, linux, pandoc, markdown, md, latex, tex, gnumake, makefile, pdf, scripts]
---
## Scripts to compile plaintext Markdown documents into other formats using Pandoc + Makefile

I use these scripts to process documents at work.

### Install (Windows w/o Administrator Privileges)

- Install [Pandoc for Windows](https://github.com/jgm/pandoc/releases/)
- Install [MiKTeX (LaTeX for Windows)](https://miktex.org/download)
- Install [MSYS2 (Linux build tools for Windows)](https://www.msys2.org/)
- Install Git, Makefile, and WatchExec: In MSYS2 UCRT64, run `pacman -S git make mingw-w64-ucrt-x86_64-watchexec`
- Clone this repository: In MSYS2 UCRT64, `cd` to the directory you want to install this repository and run `git clone https://github.com/mboyea/pandoc-scripts`
- In `C:\msys64\home\<user>\.bashrc` add line `alias mdpdf='<INSERT_PATH_TO_PANDOC_SCRIPTS>/pandoc-scripts/mdpdf.sh'`
- In `C:\msys64\home\<user>\.bash_profile` add line `if [ -f ~/.bashrc ]; then . ~/.bashrc; fi`
- In `C:\msys64\ucrt64.ini` uncomment line `MSYS2_PATH_TYPE=inherit`

### Install (Arch Linux)

- Run `pacman -S texlive-basic texlive-latexrecommended texlive-latexextra texlive-fontsrecommended`
- Install Pandoc: Get `pandoc-bin` from AUR **or** `pandoc-cli` from pacman *(do not install both)*
- Clone this repository: In your shell, `cd` to the directory you want to install this repository and run `git clone https://github.com/mboyea/pandoc-scripts`
- In your `.bashrc`, add line `alias mdpdf='<INSERT_PATH_TO_PANDOC_SCRIPTS>/pandoc-scripts/mdpdf.sh'`
- In your `.bash_profile` add line `if [ -f ~/.bashrc ]; then . ~/.bashrc; fi`

### Install (NixOS Home Manager)

- Add packages to the config file:

```sh
git
pandoc
texliveFull
gnumake
```

- Rebuild the config file with `home-manager switch`.
- Clone this repository: In your shell, `cd` to the directory you want to install this repository and run `git clone https://github.com/mboyea/pandoc-scripts`
- In your `.bashrc`, add line `alias mdpdf='<INSERT_PATH_TO_PANDOC_SCRIPTS>/pandoc-scripts/mdpdf.sh'`
- In your `.bash_profile` add line `if [ -f ~/.bashrc ]; then . ~/.bashrc; fi`

### Script Usage

Type `<script-name> -h` into the terminal to view the supported usage of that script.

| script-name | description |
|:----------- |:----------- |
| `mdpdf` | compile .md files (Markdown) int .pdf files (Portable Display Format) |
