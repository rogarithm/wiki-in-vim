function! CreateWikiPage(word)
  let pattern = '\v<([A-Z][a-z]+)+'
  if a:word =~# pattern
    execute ':!touch ./' . shellescape(a:word) . '.wiki'
  endif
endfunction

function! WrapWithBrackets()
  " 링크 포맷팅할 문자열을 지우면서 z 레지스터에 저장한다
  execute "normal! " . "viw\"zx"
  " 저장된 문자열을 확인한다
  :echo getreg('z')
  " [:을 입력하고, 레지스터에 저장한 문자열을 입력하고, :]을 입력한다
  execute "normal! " . "i[:\<C-r>z:]\<Esc>"
endfunction

nnoremap <F3> :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <F4> :call WrapWithBrackets()<CR>
