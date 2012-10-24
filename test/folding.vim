" Helpful mapping for executing specs:
" nnoremap <leader>r :wa <bar> ! ../vspec/bin/vspec ../vspec/ . test/folding.vim<CR>
silent filetype plugin on

describe 'Markdown filetype'
  it 'applies foldmethod=expr'
    silent tabnew test/samples/blank.md
    setlocal filetype=markdown
    Expect &l:foldmethod ==# 'expr'
  end

end
