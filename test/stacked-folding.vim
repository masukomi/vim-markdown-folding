silent filetype plugin on

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

  it 'uses the specified settings'
    Expect &foldmethod ==# 'expr'
    Expect &foldexpr ==# 'StackedMarkdownFolds()'
    Expect &foldenable ==# 1
  end

  it 'uses foldlevel 1 for all sections'
    normal! zM
    let linecount = line('$')
    for i in range(1, linecount)
      Expect foldlevel(i) == 1
    endfor
  end

  it 'opens a new fold for "# Top level heading"'
    Expect foldclosed(3) ==# 1
    Expect foldclosedend(3) ==# 4
  end

  it 'opens a new fold for "## Second level heading"'
    Expect foldclosed(7) ==# 5
    Expect foldclosedend(7) ==# 8
  end

  it 'opens a new fold for "### Third level heading"'
    Expect foldclosed(11) ==# 9
    Expect foldclosedend(11) ==# 12
  end

  it 'opens a new fold for "### Another third level heading"'
    Expect foldclosed(13) ==# 13
    Expect foldclosedend(13) ==# 15
  end

end
