function! StackedMarkdownFolds()
  if match(getline(v:lnum), "^#") >= 0
    return ">1"
  else
    return "="
  endif
endfunction
