" Helpers {{{1
function! HeadingDepth(lnum)
  let level=0
  let thisline = getline(a:lnum)
  let hashCount = len(matchstr(thisline, '^#\{1,6}'))
  if hashCount > 0
    let level = hashCount
  endif
  return level
endfunction
" Setup {{{1
setlocal foldmethod=expr
command! -buffer FoldToggle
" Teardown {{{1
let b:undo_ftplugin .= '
  \ | setlocal foldmethod<
  \ | delcommand FoldToggle
  \ '
" vim:set fdm=marker:
