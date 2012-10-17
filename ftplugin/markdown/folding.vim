function! NestedMarkdownFolds()
  let depth = HeadingDepth(v:lnum)
  if depth > 0
    return ">".depth
  else
    return "="
  endif
endfunction

function! StackedMarkdownFolds()
  if HeadingDepth(v:lnum) > 0
    return ">1"
  else
    return "="
  endif
endfunction

function! HeadingDepth(lnum)
  let level = 0
  let thisline = getline(a:lnum)
  let hashes = matchstr(thisline, '^#\{1,6}')
  let hashCount = len(hashes)
  if hashCount > 0
    let level = hashCount
  else
    if thisline != ''
      let nextline = getline(a:lnum + 1)
      if nextline =~ '^==='
        let level = 1
      elseif nextline =~ '^---'
        let level = 2
      endif
    endif
  endif
  return level
endfunction

function! FoldText()
  let level = HeadingDepth(v:foldstart)
  let indent = repeat('#', level)
  let title = substitute(getline(v:foldstart), '^#\+\s*', '', '')
  let foldsize = (v:foldend - v:foldstart)+1
  return indent.' '.title.' ['.foldsize.' lines]'
endfunction

function! ToggleMarkdownFoldexpr()
  if &l:foldexpr == 'StackedMarkdownFolds()'
    setlocal foldexpr=NestedMarkdownFolds()
  else
    setlocal foldexpr=StackedMarkdownFolds()
  endif
endfunction
command! FoldToggle call ToggleMarkdownFoldexpr()

if !exists('g:markdown_fold_style')
  let g:markdown_fold_style = 'stacked'
endif

setlocal foldmethod=expr
setlocal foldtext=FoldText()
let &l:foldexpr =
  \ g:markdown_fold_style ==# 'nested'
  \ ? 'NestedMarkdownFolds()'
  \ : 'StackedMarkdownFolds()'

