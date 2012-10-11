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

function! AssertRangeIsUnfolded(firstLine, lastLine)
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
    normal! zM
  end
  after
    silent tabclose
  end

  it 'uses the specified local settings'
    Expect &foldmethod ==# 'expr'
    Expect &foldexpr ==# 'StackedMarkdownFolds()'
    Expect &foldenable ==# 1
  end

  it 'opens a new fold for "# Top level heading"'
    call AssertRangeIsFolded(1, 4)
  end

  it 'opens a new fold for "## Second level heading"'
    call AssertRangeIsFolded(5, 8)
  end

  it 'opens a new fold for "### Third level heading"'
    call AssertRangeIsFolded(9, 12)
  end

  it 'opens a new fold for "### Another third level heading"'
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
    normal! zM
  end
  after
    silent tabclose
  end

  it 'foldlevel=0: collapses everything below h1'
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

    call AssertRangeIsUnfolded(1, 4)
    call AssertRangeIsFolded(5, 15)
  end

  it 'foldlevel=2: unfolds (h1 and) h2 headings'
    setlocal foldlevel=2
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsUnfolded(1, 8)
    call AssertRangeIsFolded(9, 12)
    call AssertRangeIsFolded(13, 15)
  end

  it 'foldlevel=3: unfolds (h1, h2, and) h3 headings'
    setlocal foldlevel=3
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsUnfolded(1, 15)
  end

end
