" Setup {{{1
setlocal foldmethod=expr
" Teardown {{{1
let b:undo_ftplugin .= '
  \ | setlocal foldmethod<
  \ '
" vim:set fdm=marker:
