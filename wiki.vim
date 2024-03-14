function! CheckFileExists(word)
  " ex. 입력이 ExamplePage일 경우, 현재 디렉토리에
  " ExamplePage.wiki 파일이 있는지 확인
  silent execute ':!ls ' . a:word . '.wiki'
  if v:shell_error
    " if문은 0이 아닌 값을 입력받았을 때 참이다.
    " 쉘 명령에 실패했을 때 v:shell_error 값으로 0이 아닌 값을 반환한다
    return 'file not exists'
  else
    " 쉘 명령에 성공했을 때 v:shell_error 값으로 0을 반환한다
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
  let pattern = '\v([A-Z][a-z]+)+'
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
  silent execute ':!touch ./' . shellescape(a:word) . '.wiki'
  call WrapWithBrackets()
  silent execute ':w ' . expand('%')
  call WarpToLink('[:' . a:word . ':]')
endfunction


function! WarpToLink(formatted_link)
  " 위키 페이지로 이동
  " 페이지로 이동하기 전에 주어진 문자열이 링크 형식인지,
  " 해당 위키 파일이 이미 있는지 확인

  let link_pattern = '\v\[\:([A-Z][a-z]+)+\:\]'
  let link_file_pattern = '\v([A-Z][a-z]+)+'

  if a:formatted_link !~# link_pattern
    echom 'Invalid format of wiki link!'
    return
  endif

  let file_name = matchstr(a:formatted_link, link_file_pattern)
  let file_exists = CheckFileExists(file_name)
  if file_exists == 'file not exists'
    echom 'file not exists'
    return
  endif

  execute ":e " . file_name . ".wiki"
endfunction

nnoremap <F3> :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <F5> :call WarpToLink(expand('<cWORD>'))<CR>
