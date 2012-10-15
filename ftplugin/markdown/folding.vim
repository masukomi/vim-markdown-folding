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

function! FoldText()
  let title = getline( v:foldstart )
  let title = substitute(title, '^#\+\s*', '', '')
  return title
endfunction
