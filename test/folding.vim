" Helpful mapping for executing specs:
" nnoremap <leader>r :wa <bar> ! ../vspec/bin/vspec ../vspec/ . test/folding.vim<CR>
silent filetype plugin on

function! PopulateBuffer(content)
  silent put =a:content
  1 delete
endfunction

describe 'setting filetype=markdown'

  before
    silent tabnew test/samples/blank.md
    setlocal filetype=markdown
  end

  after
    silent tabclose
  end

  it 'applies foldmethod=expr'
    Expect &l:foldmethod ==# 'expr'
  end

  it 'applies foldexpr=StackedMarkdownFolds()'
    Expect &l:foldexpr ==# 'StackedMarkdownFolds()'
  end

  it 'applies foldtext=FoldText()'
    Expect &l:foldtext =~# '<SNR>\d_FoldText()'
  end

  it 'creates :FoldToggle command'
    Expect exists(':FoldToggle') == 2
  end

end

describe 'setting filetype!=markdown'

  before
    silent tabnew test/samples/blank.md
    setlocal filetype=markdown
  end

  after
    silent tabclose
  end

  it 'resets foldmethod to global default'
    setlocal filetype=
    Expect &l:foldmethod ==# 'manual'
  end

  it 'resets foldexpr to global default'
    setlocal filetype=
    Expect &l:foldexpr ==# '0'
  end

  it 'resets foldtext to global default'
    setlocal filetype=
    Expect &l:foldtext =~# 'foldtext()'
  end

  it 'destroys :FoldToggle command'
    setlocal filetype=
    Expect exists(':FoldToggle') == 0
  end

end

describe 'HeadingDepth'

  before
    silent tabnew
    setlocal filetype=markdown
  end

  after
    silent tabclose!
  end

  it 'returns 0 for blank lines'
    call PopulateBuffer('')
    Expect HeadingDepth(1)  ==# 0
    Expect HeadingDepth(2)  ==# 0
  end

  it 'returns 0 for lines of content'
    call PopulateBuffer([
          \ 'lorem ipsum dolor sit amet',
          \ 'consequeteur blah blah'
          \ ])
    Expect HeadingDepth(1)  ==# 0
    Expect HeadingDepth(2)  ==# 0
  end

  it 'returns 1 for "# Level one headings"'
    call PopulateBuffer('# Level one heading')
    Expect HeadingDepth(1)  ==# 1
  end

  it 'returns 2 for "## Level two headings"'
    call PopulateBuffer('## Level two headings')
    Expect HeadingDepth(1)  ==# 2
  end

  it 'returns 3 for "### Level three headings"'
    call PopulateBuffer('### Level three headings')
    Expect HeadingDepth(1)  ==# 3
  end

  it 'returns 1 for === underscored headings'
    call PopulateBuffer([
          \ 'Level one heading',
          \ '=================',
          \ ])
    Expect HeadingDepth(1)  ==# 1
    Expect HeadingDepth(2)  ==# 0
  end

  it 'returns 2 for --- underscored headings'
    call PopulateBuffer([
          \ 'Level two heading',
          \ '-----------------',
          \ ])
    Expect HeadingDepth(1)  ==# 2
    Expect HeadingDepth(2)  ==# 0
  end

  it 'ignores --- and === when preceded by a blank line'
    call PopulateBuffer([
          \ '=================',
          \ '',
          \ '=================',
          \ '',
          \ '-----------------',
          \ '',
          \ '-----------------',
          \ ])
    Expect HeadingDepth(1)  ==# 0
    Expect HeadingDepth(2)  ==# 0
    Expect HeadingDepth(3)  ==# 0
    Expect HeadingDepth(4)  ==# 0
    Expect HeadingDepth(5)  ==# 0
    Expect HeadingDepth(6)  ==# 0
    Expect HeadingDepth(7)  ==# 0
  end

end

describe 'Stacked Folding'

  before
    silent tabnew test/samples/lorem.md
    setlocal filetype=markdown
  end

  after
    silent tabclose!
  end

  it 'creates a fold for each section'
    setlocal foldlevel=0
    for i in range(1, 15)
      Expect foldlevel(i) ==# 1
    endfor
    for i in range(1,4)
      Expect foldclosed(i) ==# 1
      Expect foldclosedend(i) ==# 4
    endfor
    for i in range(5,8)
      Expect foldclosed(i) ==# 5
      Expect foldclosedend(i) ==# 8
    endfor
    for i in range(9, 12)
      Expect foldclosed(i) ==# 9
      Expect foldclosedend(i) ==# 12
    endfor
    for i in range(13, 15)
      Expect foldclosed(i) ==# 13
      Expect foldclosedend(i) ==# 15
    endfor
  end

  it 'opens specified folds when told to'
    setlocal foldlevel=0
    normal! 1Gza
    for i in range(1, 4)
      Expect foldclosed(i) ==# -1
      Expect foldclosedend(i) ==# -1
    endfor
    for i in range(5,8)
      Expect foldclosed(i) ==# 5
      Expect foldclosedend(i) ==# 8
    endfor
    for i in range(9, 12)
      Expect foldclosed(i) ==# 9
      Expect foldclosedend(i) ==# 12
    endfor
    for i in range(13, 15)
      Expect foldclosed(i) ==# 13
      Expect foldclosedend(i) ==# 15
    endfor
  end

end

describe 'FoldText'

  before
    silent tabnew test/samples/lorem.md
    setlocal filetype=markdown
  end

  after
    silent tabclose!
  end

  " TODO: return to this after implementing foldexpr
  " it 'uses "# level one" headings as is'
  "   call PopulateBuffer([
  "         \ '# Level one heading',
  "         \ '',
  "         \ 'Lorem ipsum dolor sit amet...',
  "         \ ])
  "   Expect foldtextresult('1') ==# '# Level one heading [2 lines]'
  " end

end
