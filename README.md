This plugin enables folding by section headings in markdown documents.

## Features

This plugin adds the ability to fold the following markdown elements:

* Headings and everything under them
* Fenced code blocks

![example screenshot of folding functionality](https://github.com/masukomi/vim-markdown-folding/raw/master/doc/example_screenshot.jpg)

## Usage
By default this plugin will use "Stacked" folding which looks like this when
everything is folded. 

```
  1 ##    Topmost heading                         [3 lines]---------------------------
  5 ###   Second level heading                    [3 lines]---------------------------
  9 ####  Third level heading                     [3 lines]---------------------------
 13 ####  Another third level heading             [2 lines]---------------------------
```

You can use "Nested" folding, where folding the "Topmost heading"
will also nest all the deeper sections under it.

```
  1 ##    Topmost heading                         [14 lines]--------------------------
```

To toggle between the two folding styles use `:FoldToggle`

If you'd like to have it default to "Nested" folding add this to your `~/.vim/filetype.vim`

```vim
autocmd FileType markdown set foldexpr=NestedMarkdownFolds()
```


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

## Troubleshooting

First, Vim must recognize the file you are in as a Markdown file. `set filetype?`
should return `filetype=markdown`. If it doesn't you may want to tweak your
`filetype.vim` to make sure it knows to associate your current file extension
with Markdown. In the short term you can `:set filetype=markdown`

There are a variety of ways Vim can be instructed to "fold" things. When you add
a plugin to support a new language / format the plugin will tell Vim "Hey here's
the method to use for figuring out the start and end of a fold with this language". 
This plugin uses a `foldmethod` of
`expr`. Running `:set foldmethod?` should return 
`foldmethod=expr`. If you see something else then you've likely got some other
Vim configuration overriding the setting in the plugin. If, after running 
`:set foldmethod=expr`, things still aren't working, then something is most likely
amiss in your `~/.vimrc` (or `~/.config/nvim/init.vim` if you use NeoVim).


## Contributing
PRs are always a welcome thing, but it should be noted that the current intent is to keep this plugin pretty focused on folding Markdown. 

All new PRs should include tests. If you're fixing a bug please add a test to make sure it never comes back. If you're adding a new feature please add tests to make sure we never break it with future changes. 

The tests are currently all contained in `t/folding.vim` 

### Running Tests
The test setup requires Ruby. For those unfamiliar with Ruby development you'll want to cd into the `vim-markdown-folding` directory and run the following commands in the terminal.

Install bundler if you don't have it already.

`gem install bundler`

Tell bundler to install the required dependencies

`bundle install`

Tell bundler to run the tests

`bundle exec rake test`

The end of the output should look something like this

```
t/folding.vim .. ok
All tests successful.
Files=1, Tests=41,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.57 cusr  0.12 csys =  0.73 CPU)
Result: PASS
```




## License

Created by [Drew Neil](https://github.com/nelstrom). Copyright Drew Niel and all the contributors.
Distributed under the same terms as Vim itself. See `:help license`.

With community improvements by: 

* [Aaron O'Leary](https://github.com/aaren/)
* [masukomi](https://github.com/masukomi/)
* [Pierrick Roger](https://github.com/pkrog/)
* [thawk](https://github.com/thawk/)

Maintained by [masukomi](https://github.com/masukomi/)
