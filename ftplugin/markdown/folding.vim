function! StackedMarkdownFolds()
  if match(getline(v:lnum), "^#") >= 0
    return ">1"
  else
    return "="
  endif
endfunction

function! NestedMarkdownFolds()
  if match(getline(v:lnum), "^#\\{6}") >= 0
    return ">6"
  elseif match(getline(v:lnum), "^#\\{5}") >= 0
    return ">5"
  elseif match(getline(v:lnum), "^#\\{4}") >= 0
    return ">4"
  elseif match(getline(v:lnum), "^#\\{3}") >= 0
    return ">3"
  elseif match(getline(v:lnum), "^#\\{2}") >= 0
    return ">2"
  elseif match(getline(v:lnum), "^#\\{1}") >= 0
    return ">1"
  else
    return "="
  endif
endfunction

