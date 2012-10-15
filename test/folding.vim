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

describe 'Stacked Folding with underlines'
  before
    silent tabnew test/underlines.md
    setlocal filetype=markdown
    setlocal foldmethod=expr
    setlocal foldexpr=StackedMarkdownFolds()
    setlocal foldenable
  end
  after
    silent tabclose
  end
  it 'creates a fold for each section'
    setlocal foldlevel=0
    call AssertRangeFoldlevel(1, 9, 1)
    call AssertRangeIsFolded(1, 5)
    call AssertRangeIsFolded(6, 9)
  end

  it 'opens specified folds when told to'
    setlocal foldlevel=0
    normal! 1Gza
    call AssertRangeIsStretched(1, 5)
    call AssertRangeIsFolded(6, 9)

    setlocal foldlevel=0
    normal! 7Gza
    call AssertRangeIsFolded(1, 5)
    call AssertRangeIsStretched(6, 9)
  end

end

describe 'HeadingDepth'
  before
    silent tabnew test/headings.md
    setlocal filetype=markdown
    setlocal foldmethod=expr
    setlocal foldexpr=StackedMarkdownFolds()
    setlocal foldenable
  end

  it 'returns zero for non-heading lines'
    Expect HeadingDepth(1)  ==# 0
    Expect HeadingDepth(6)  ==# 0
    Expect HeadingDepth(8)  ==# 0
    Expect HeadingDepth(9)  ==# 0
    Expect HeadingDepth(11) ==# 0
    Expect HeadingDepth(13) ==# 0
    Expect HeadingDepth(15) ==# 0
  end

  it 'returns the heading level for lines that lead with #'
    Expect HeadingDepth(2) ==# 1
    Expect HeadingDepth(3) ==# 2
    Expect HeadingDepth(4) ==# 3
    Expect HeadingDepth(5) ==# 4
  end

  it 'returns heading level for non-blank lines underlined by - or ='
    Expect HeadingDepth(7) ==# 1
    Expect HeadingDepth(10) ==# 2
  end
end

describe 'FoldText'

  before
    silent tabnew test/example.md
    setlocal filetype=markdown
    setlocal foldmethod=expr
    setlocal foldexpr=StackedMarkdownFolds()
    setlocal foldtext=FoldText()
    setlocal foldenable
    setlocal foldlevel=0
  end
  after
    silent tabclose
  end

  it 'uses the current heading'
    Expect foldtextresult('1')  ==# 'Topmost heading'
    Expect foldtextresult('5')  ==# 'Second level heading'
    Expect foldtextresult('9')  ==# 'Third level heading'
    Expect foldtextresult('13') ==# 'Another third level heading'
  end

end
