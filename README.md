This plugin enables folding by section headings in markdown documents.

## Features

This plugin adds the ability to fold the following markdown elements:

* Headings and everything under them
* Fenced code blocks

![example screenshot of folding functionality](https://github.com/masukomi/vim-markdown-folding/raw/master/doc/example_screenshot.jpg)


## Installation

After installing `markdown-folding` using a Vim package manager ( [vim-plug](https://github.com/junegunn/vim-plug#readme), [pathogen](https://github.com/tpope/vim-pathogen#readme), [Vundle](https://github.com/VundleVim/Vundle.vim#readme), or Vim 8's native plugin system ). You will need to add the following lines to your  `~/.vimrc` file or `~/.config/nvim/init.vim` for NeoVim:

```vim
    set nocompatible
    if has("autocmd")
      filetype plugin indent on
    endif
```

The `markdown-folding` plugin provides nothing more than a `foldexpr` for markdown files. If you want syntax highlighting and other niceties, then go and get tpope's [vim-markdown][] plugin.

[vim-markdown]: https://github.com/tpope/vim-markdown
[pathogen]: https://github.com/tpope/vim-pathogen
[Vundle]: https://github.com/gmarik/vundle

## License

Created by Drew Neil. Copyright Drew Niel and all the contributors.
Distributed under the same terms as Vim itself. See `:help license`.

With community improvements by: 

* [Aaron O'Leary](https://github.com/aaren/)
* [masukomi](https://github.com/masukomi/)
* [Pierrick Roger](https://github.com/pkrog/)
* [thawk](https://github.com/thawk/)

Maintained by [masukomi](https://github.com/masukomi/)
