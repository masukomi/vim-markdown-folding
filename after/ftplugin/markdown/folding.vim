" Stacked and Nested fold expressions {{{1
function! StackedMarkdownFolds()
  if HeadingDepth(v:lnum) > 0
    return ">1"
  else
    return "="
  endif
endfunction

function! NestedMarkdownFolds()
  let depth = HeadingDepth(v:lnum)
  if depth > 0
    return ">".depth
  else
    return "="
  endif
endfunction

" Helpers {{{1
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function! HeadingDepth(lnum)
  let level=0
  let thisline = getline(a:lnum)
  let hashCount = len(matchstr(thisline, '^#\{1,6}'))
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

function! s:FoldText()
  let level = HeadingDepth(v:foldstart)
  let indent = repeat('#', level)
  let title = substitute(getline(v:foldstart), '^#\+\s*', '', '')
  let foldsize = (v:foldend - v:foldstart)
  let linecount = '['.foldsize.' line'.(foldsize>1?'s':'').']'
  return indent.' '.title.' '.linecount
endfunction

function! ToggleMarkdownFoldexpr()
  if &l:foldexpr == 'StackedMarkdownFolds()'
    setlocal foldexpr=NestedMarkdownFolds()
  else
    setlocal foldexpr=StackedMarkdownFolds()
  endif
endfunction

" Setup {{{1
setlocal foldmethod=expr
setlocal foldexpr=StackedMarkdownFolds()
let &l:foldtext = s:SID() . 'FoldText()'
command! -buffer FoldToggle call ToggleMarkdownFoldexpr()
" Teardown {{{1
let b:undo_ftplugin .= '
  \ | setlocal foldmethod< foldtext< foldexpr<
  \ | delcommand FoldToggle
  \ '
" vim:set fdm=marker:
