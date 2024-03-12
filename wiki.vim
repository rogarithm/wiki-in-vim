function! CreateWikiPage(word)
  let pattern = '\v<([A-Z][a-z]+)+'
  if a:word =~# pattern
    execute ':!touch ./' . shellescape(a:word) . '.wiki'
  endif
endfunction

function! WrapWithBrackets()
  " 포맷팅할 링크 문자열을 z 레지스터에 저장 후 지운다
  execute "normal! " . "viw\"zx"
  " 포맷팅해서 다시 입력한다
  execute "normal! " . "i[:\<C-r>z:]\<Esc>"
endfunction

nnoremap <F3> :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <F4> :call WrapWithBrackets()<CR>
