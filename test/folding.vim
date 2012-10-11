silent filetype plugin on

function! AssertRangeFoldlevel(firstLine, lastLine, foldLevel)
  for i in range(a:firstLine, a:lastLine)
    Expect foldlevel(i) ==# a:foldLevel
  endfor
endfunction

function! AssertRangeIsFolded(firstLine, lastLine)
  for i in range(a:firstLine, a:lastLine)
    Expect foldclosed(i) ==# a:firstLine
    Expect foldclosedend(i) ==# a:lastLine
  endfor
endfunction

function! AssertRangeIsStretched(firstLine, lastLine)
  for i in range(a:firstLine, a:lastLine)
    Expect foldclosed(i) ==# -1
    Expect foldclosedend(i) ==# -1
  endfor
endfunction

describe 'Stacked Folding'
  before
    silent tabnew test/example.md
    setlocal filetype=markdown
    setlocal foldmethod=expr
    setlocal foldexpr=StackedMarkdownFolds()
    setlocal foldenable
  end
  after
    silent tabclose
  end

  it 'uses the specified local settings'
    Expect &foldmethod ==# 'expr'
    Expect &foldexpr ==# 'StackedMarkdownFolds()'
    Expect &foldenable ==# 1
  end

  it 'creates a fold for each section'
    setlocal foldlevel=0
    call AssertRangeFoldlevel(1, 15, 1)
    call AssertRangeIsFolded(1, 4)
    call AssertRangeIsFolded(5, 8)
    call AssertRangeIsFolded(9, 12)
    call AssertRangeIsFolded(13, 15)
  end

  it 'opens specified folds when told to'
    setlocal foldlevel=0
    normal! 1Gza
    call AssertRangeIsStretched(1, 4)
    call AssertRangeIsFolded(5, 8)
    call AssertRangeIsFolded(9, 12)
    call AssertRangeIsFolded(13, 15)
  end

end

describe 'Nested Folding'
  before
    silent tabnew test/example.md
    setlocal filetype=markdown
    setlocal foldmethod=expr
    setlocal foldexpr=NestedMarkdownFolds()
    setlocal foldenable
  end
  after
    silent tabclose
  end

  it 'foldlevel=0: folds everything'
    setlocal foldlevel=0
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsFolded(1, 15)
  end

  it 'foldlevel=1: unfolds h1 headings'
    setlocal foldlevel=1
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsStretched(1, 4)
    call AssertRangeIsFolded(5, 15)
  end

  it 'foldlevel=2: unfolds h1 and h2 headings'
    setlocal foldlevel=2
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsStretched(1, 8)
    call AssertRangeIsFolded(9, 12)
    call AssertRangeIsFolded(13, 15)
  end

  it 'foldlevel=3: unfolds h1, h2, and h3 headings'
    setlocal foldlevel=3
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsStretched(1, 15)
  end

end
