function! s:Preserve(command)
  " Save cursor position
  let l = line(".")
  let c = col(".")

  " Do the business
  execute a:command

  " Restore cursor position
  call cursor(l, c)
  " Remove search history pollution and restore last search
  call histdel("search", -1)
  let @/ = histget("search", -1)
endfunction

function! s:AddFocusTagToLine(line_num)
  let line = getline(a:line_num)
  let replace_line = substitute(line, ' do$', ', :focus do', '')
  call setline(a:line_num, replace_line)
endfunction

function! s:SearchFocusableLine()
  let example_regexp = '.*\(describe\|context\|it\).* do$'
  if match(getline('.'), example_regexp) == 0
    return line('.')
  else
    return search(example_regexp, 'b')
  endif
endfunction

function! s:AddFocusTag()
  call s:AddFocusTagToLine(s:SearchFocusableLine())
endfunction

function! s:RemoveAllFocusTags()
  call s:Preserve("%s/, :focus//e")
endfunction

" Commands
command! -nargs=0 AddFocusTag call s:AddFocusTag()
command! -nargs=0 RemoveAllFocusTags call s:RemoveAllFocusTags()
