" Setup {{{1
setlocal foldmethod=expr
command! -buffer FoldToggle
" Teardown {{{1
let b:undo_ftplugin .= '
  \ | setlocal foldmethod<
  \ | delcommand FoldToggle
  \ '
" vim:set fdm=marker:
