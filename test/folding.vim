silent filetype plugin on

function! AssertFold(firstLine, lastLine, foldLevel)
  Expect foldclosed(a:firstLine) ==# a:firstLine
  Expect foldclosedend(a:firstLine) ==# a:lastLine
  for i in range(a:firstLine, a:lastLine)
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
    call AssertFold(1, 4, 1)
  end

  it 'opens a new fold for "## Second level heading"'
    call AssertFold(5, 8, 1)
  end

  it 'opens a new fold for "### Third level heading"'
    call AssertFold(9, 12, 1)
  end

  it 'opens a new fold for "### Another third level heading"'
    call AssertFold(13, 15, 1)
  end

end
