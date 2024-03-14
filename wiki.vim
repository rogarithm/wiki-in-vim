function! CheckFileExists(word)
  let exists = system('ls ' . a:word . '.wiki')
  if v:shell_error
    return 'file not exists'
  else
    return 'file already exists'
  endif
endfunction

function! WrapWithBrackets()
  " 포맷팅할 링크 문자열을 z 레지스터에 저장 후 지운다
  execute "normal! " . "viw\"zx"
  " 포맷팅해서 다시 입력한다
  execute "normal! " . "i[:\<C-r>z:]\<Esc>"
endfunction

function! CreateWikiPage(word)
  let pattern = '\v<([A-Z][a-z]+)+'
  let file_exists = CheckFileExists(a:word)
  echo file_exists
  if a:word !~# pattern
    echom 'file name is not right convention; use camel case'
    return
  endif
  if file_exists == 'file already exists'
    echom 'file already exists'
    return
  endif
  execute ':!touch ./' . shellescape(a:word) . '.wiki'
  call WrapWithBrackets()
endfunction


function! WarpToLink()
  execute "normal! " . "viW\"zy"
  let formattedLink = getreg('z')

  let linkPattern = '\v\[:<([A-Z][a-z]+)+:\]'
  let linkFilePattern = '\v<([A-Z][a-z]+)+'

  if formattedLink !~# linkPattern
    echom 'Invalid format of wiki link!'
    return
  endif

  let fileName = matchstr(formattedLink, linkFilePattern)
  echom "FILENAME: " . fileName
  let file_exists = CheckFileExists(fileName)
  if file_exists == 'file not exists'
    echom 'file not exists'
    return
  endif

  execute ":e " . fileName . ".wiki"
endfunction

nnoremap <F3> :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <F4> :call WrapWithBrackets()<CR>
nnoremap <F5> :call WarpToLink()<CR>
nnoremap <F6> :call SumAllUp(expand('<cword>'))<CR>
