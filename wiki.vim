function! CreateWikiPage(word)
  let pattern = '\v<([A-Z][a-z]+)+'
  if a:word =~# pattern
    execute ':!touch ./' . shellescape(a:word) . '.wiki'
  endif
endfunction

function! WrapWithBrackets(link)
endfunction

nnoremap <F3> :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <F4> :call WrapWithBrackets(expand('<cword>'))<CR>
