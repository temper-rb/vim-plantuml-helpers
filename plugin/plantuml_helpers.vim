if exists('b:plantuml_mirrorassoc_plugin')
  finish
endif
let b:plantuml_mirrorassoc_plugin = 1

function! s:mirror_symmetric_assoc()
  let cursorpos = getpos(".")
  normal! 0
  silent! s/\v(\w+)\s(".*")*\s*([\*o#x}+^]*)([\.-]+)([\*o#x}+^]*)\s(".*")*\s*(\w+)/\7 \6 \5\4\3 \2 \1/ | nohl
  call setpos('.', cursorpos)
endfunction

function! s:remove_token(token)
  normal! 0
  call search(a:token, '', line("."))
  let command="d".strlen(a:token)."l"
  execute "normal! ".command
endfunction

function! s:mirror_directed_association(search_token, mirror_token, arrow_end)
  let cursorpos = getpos(".")
  call s:remove_token(a:search_token)
  call s:mirror_symmetric_assoc()
  let line = getline(".")
  call setline(cursorpos[1], substitute(line, a:arrow_end, a:mirror_token, ""))
  call setpos('.', cursorpos)
endfunction

function! s:make_search_token(association, linetype, association_type)
  if a:association_type=="left"
    return a:association.a:linetype
  else
    return a:linetype.a:association
  endif
endfunction

function! s:make_arrow_end(linetype, arrowhead, association_type)
  if a:association_type=="left"
    return a:linetype.a:arrowhead
  else
    return a:arrowhead.a:linetype
  endif
endfunction

function! s:get_association_direction(association) 
  if matchstr(a:association, "<")=="<"
    return "left"
  endif

  return "right"
endfunction


function! s:is_association_present(association, linetype)
  let to_find = s:make_search_token(a:association, a:linetype, s:get_association_direction(a:association))
  if search(to_find, '', line("."))
    return 1
  endif
  return 0
endfunction

function! MirrorAssoc() 
  let cursorpos = getpos(".")
  let linetypes=['-', '\.']
  let associations = [['<|', '|>'], ['|>', '<|'], ['<', '>'], ['>', '<']]
  normal! 0
  let directed_association_found=0
  for linetype in linetypes
    for association in associations
      let association_to_mirror=association[0]
      let mirrored_association=association[1]
      if s:is_association_present(association_to_mirror, linetype)
        let directed_association_found = 1
        let mirrored_arrow_end = s:make_arrow_end(linetype,"\\s", s:get_association_direction(association_to_mirror))
        let mirrored_association_end=s:make_arrow_end(linetype,mirrored_association,s:get_association_direction(association_to_mirror))
        call s:mirror_directed_association(association_to_mirror, mirrored_association_end, mirrored_arrow_end)
        break
      endif
     endfor
     if directed_association_found
       break
     endif
  endfor
  if !directed_association_found
    call s:mirror_symmetric_assoc()
  endif
  call setpos('.',cursorpos)
endfunction

command! MirrorAssoc call MirrorAssoc()
noremap <silent> _ma :MirrorAssoc<CR>
