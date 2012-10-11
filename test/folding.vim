silent filetype plugin on

function! AssertRangeFoldlevel(firstLine, lastLine, foldLevel)
  for i in range(a:firstLine, a:lastLine)
    Expect foldlevel(i) == a:foldLevel
  endfor
endfunction

function! AssertRangeIsFoldedWithLevel(firstLine, lastLine, foldLevel)
  Expect foldclosed(a:firstLine) ==# a:firstLine
  Expect foldclosedend(a:firstLine) ==# a:lastLine
  call AssertRangeFoldlevel(a:firstLine, a:lastLine, a:foldLevel)
endfunction

function! AssertRangeIsUnfoldedWithLevel(firstLine, lastLine, foldLevel)
  for i in range(a:firstLine, a:lastLine)
    Expect foldclosed(i) ==# -1
    Expect foldclosedend(i) ==# -1
    Expect foldlevel(i) == a:foldLevel
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
    call AssertRangeIsFoldedWithLevel(1, 4, 1)
  end

  it 'opens a new fold for "## Second level heading"'
    call AssertRangeIsFoldedWithLevel(5, 8, 1)
  end

  it 'opens a new fold for "### Third level heading"'
    call AssertRangeIsFoldedWithLevel(9, 12, 1)
  end

  it 'opens a new fold for "### Another third level heading"'
    call AssertRangeIsFoldedWithLevel(13, 15, 1)
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

    Expect foldclosed(1) ==# 1
    Expect foldclosedend(1) ==# 15
  end

  it 'foldlevel=1: unfolds h1 headings'
    setlocal foldlevel=1
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsUnfoldedWithLevel(1, 4, 1)
    Expect foldclosed(5) ==# 5
    Expect foldclosedend(5) ==# 15
  end

  it 'foldlevel=2: unfolds (h1 and) h2 headings'
    setlocal foldlevel=2
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsUnfoldedWithLevel(1, 4, 1)
    call AssertRangeIsUnfoldedWithLevel(5, 8, 2)
  end

  it 'foldlevel=3: unfolds (h1, h2, and) h3 headings'
    setlocal foldlevel=3
    call AssertRangeFoldlevel(1, 4, 1)
    call AssertRangeFoldlevel(5, 8, 2)
    call AssertRangeFoldlevel(9, 15, 3)

    call AssertRangeIsUnfoldedWithLevel(1, 4, 1)
    call AssertRangeIsUnfoldedWithLevel(5, 8, 2)
    call AssertRangeIsUnfoldedWithLevel(9, 15, 3)
  end

end
