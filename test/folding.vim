" Helpful mapping for executing specs:
" nnoremap <leader>r :wa <bar> ! ../vspec/bin/vspec ../vspec/ . test/folding.vim<CR>
silent filetype plugin on

function! PopulateBuffer(content)
  silent put =a:content
  1 delete
endfunction

function FoldLevelsInRange(firstLine, lastLine)
  return map(range(a:firstLine, a:lastLine), 'foldlevel(v:val)')
endfunction

function ToMatch(actualValue, foldLevel)
  return a:actualValue == repeat([a:foldLevel], len(a:actualValue))
endfunction

call vspec#customize_matcher('toMatch', function('ToMatch'))

function! FoldBoundariesInRange(firstLine, lastLine)
  return map(range(a:firstLine, a:lastLine), '[foldclosed(v:val), foldclosedend(v:val)]')
endfunction

function! AllMatch(list, value)
  for i in a:list
    if i != a:value
      return 0
    endif
  endfor
  return 1
endfunction

function! OpenFoldBoundaries(list)
  " return true for lists such as: [[-1,-1],[-1,-1],[-1,-1]]
  for i in a:list
    if i != [-1, -1]
      return 0
    endif
  endfor
  return 1
endfunction

function! ClosedFoldBoundaries(list)
  for i in a:list
    if i == [-1, -1]
      return 0
    endif
  endfor
  return 1
endfunction

call vspec#customize_matcher('toHaveBoundaries', function('AllMatch'))
call vspec#customize_matcher('toBeClosed', function('ClosedFoldBoundaries'))
call vspec#customize_matcher('toBeOpen', function('OpenFoldBoundaries'))

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

  it 'sets everything to foldlevel=1'
    setlocal foldlevel=0
    Expect FoldLevelsInRange(1,15) toMatch 1
  end

  it 'creates a separate fold for each section'
    setlocal foldlevel=0
    Expect FoldBoundariesInRange(1,4) toHaveBoundaries [1,4]
    Expect FoldBoundariesInRange(5,8) toHaveBoundaries [5,8]
    Expect FoldBoundariesInRange(9,12) toHaveBoundaries [9,12]
    Expect FoldBoundariesInRange(13,15) toHaveBoundaries [13,15]
  end

  it 'can unfold "# Top level headings"'
    setlocal foldlevel=0
    normal! 1Gza
    Expect FoldBoundariesInRange(1,4) toBeOpen
    Expect FoldBoundariesInRange(5,15) toBeClosed
  end

  it 'can unfold "## Second level headings"'
    setlocal foldlevel=0
    normal! 5Gza
    Expect FoldBoundariesInRange(1,4) toBeClosed
    Expect FoldBoundariesInRange(5,8) toBeOpen
    Expect FoldBoundariesInRange(9,15) toBeClosed
  end

  it 'can unfold "### Third level headings"'
    setlocal foldlevel=0
    normal! 15Gza
    Expect FoldBoundariesInRange(1,12) toBeClosed
    Expect FoldBoundariesInRange(13,15) toBeOpen
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

  it 'uses "# level one" headings as is'
    call PopulateBuffer([
          \ '# Level one heading',
          \ '',
          \ 'Lorem ipsum dolor sit amet...',
          \ ])
    TODO
    Expect foldtextresult('1') ==# '# Level one heading [2 lines]'
  end

end
