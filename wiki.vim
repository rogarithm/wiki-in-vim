function! SumAllUp()
  let exists = system('ls AndThere.wiki')
  if v:shell_error
    echo 'fail!'
  else
    echo 'success!'
  endif
endfunction

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

function! WarpToLink()
  " 위키 링크 형식이 맞는지 확인하기 위해 커서 주변 문자열을 z 레지스터에 저장한다
  execute "normal! " . "viW\"zy"
  let formattedLink = getreg('z')

  let linkPattern = '\v\[:<([A-Z][a-z]+)+:\]'
  let linkFilePattern = '\v<([A-Z][a-z]+)+'
  " 주어진 문자열이 위키 링크 형식이면
  if formattedLink =~# linkPattern
    let fileName = matchstr("[:CamelCasedKeyword:]", linkFilePattern)
    " 그 위키 파일을 연다
    execute ":e " . fileName . ".wiki"
  else
    echom 'Invalid format of wiki link!'
  endif
endfunction

nnoremap <F3> :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <F4> :call WrapWithBrackets()<CR>
nnoremap <F5> :call WarpToLink()<CR>
nnoremap <F6> :call SumAllUp()<CR>
