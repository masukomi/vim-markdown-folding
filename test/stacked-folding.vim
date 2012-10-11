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

end
