This plugin enables folding by section headings in markdown documents.

## Installation

I recommend installing `markdown-folding` using [Pathogen](https://github.com/tpope/vim-pathogen) or [Vundle](https://github.com/gmarik/vundle). Your `vimrc` file must contain these lines at the very least:

    set nocompatible
    if has("autocmd")
      filetype plugin indent on
    endif

The `markdown-folding` plugin provides nothing more than a `foldexpr` for markdown files. If you want syntax highlighting and other niceties, then go and get tpope's [vim-markdown](https://github.com/tpope/vim-markdown) plugin.
