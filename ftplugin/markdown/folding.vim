function! HeadingDepth(lnum)
  let level = 0
  let thisline = getline(a:lnum)
  let hashes = matchstr(thisline, '^#\{1,6}')
  let hashCount = len(hashes)
  if hashCount > 0
    let level = hashCount
  else
    if match(thisline, '^.\+$') >= 0
      let nextline = getline(a:lnum + 1)
      if match(nextline, '^===') >= 0
        let level = 1
      elseif match(nextline, '^---') >= 0
        let level = 2
      endif
    endif
  endif
  return level
endfunction

function! StackedMarkdownFolds()
  let thisline    = getline(v:lnum)
  let nextline    = getline(v:lnum + 1)
  let leadinghash = "^#"
  let underline   = '\v^[-=]{3,}$'

  if match(thisline, leadinghash) >= 0
\ || match(nextline, underline) >= 0
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

