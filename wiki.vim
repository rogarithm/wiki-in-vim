function! CheckFileExists(word)
  " ex. 입력이 ExamplePage일 경우, 현재 디렉토리에
  " ExamplePage.wiki 파일이 있는지 확인
  let exists = system('ls ' . a:word . '.wiki')
  if v:shell_error
    return 'file not exists'
  else
    return 'file already exists'
  endif
endfunction

function! WrapWithBrackets()
  " 주어진 문자열을 링크 형식으로 포맷팅
  " 링크 형식: [:ExamplePage:]
  execute "normal! " . "viw\"zx"
  execute "normal! " . "i[:\<C-r>z:]\<Esc>"
endfunction

function! CreateWikiPage(word)
  " 위키 페이지 생성
  " 페이지를 만들기 전에 주어진 문자열이 카멜 케이스인지,
  " 해당 위키 파일이 이미 있는지 확인
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
  execute ':w ' . expand('%')
endfunction


function! WarpToLink()
  " 위키 페이지로 이동
  " 페이지로 이동하기 전에 주어진 문자열이 링크 형식인지,
  " 해당 위키 파일이 이미 있는지 확인
  execute "normal! " . "viW\"zy"
  let formatted_link = getreg('z')

  let link_pattern = '\v\[:<([A-Z][a-z]+)+:\]'
  let link_file_pattern = '\v<([A-Z][a-z]+)+'

  if formatted_link !~# link_pattern
    echom 'Invalid format of wiki link!'
    return
  endif

  let file_name = matchstr(formatted_link, link_file_pattern)
  let file_exists = CheckFileExists(file_name)
  if file_exists == 'file not exists'
    echom 'file not exists'
    return
  endif

  execute ":e " . file_name . ".wiki"
endfunction

nnoremap <F3> :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <F5> :call WarpToLink()<CR>
