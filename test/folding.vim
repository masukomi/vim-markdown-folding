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

  it 'resets foldmethod to default'
    setlocal filetype=
    Expect &l:foldmethod ==# 'manual'
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

  it 'returns 0 for content lines'
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

end
