function! CheckFileExists(word)
  " ex. 입력이 ExamplePage일 경우, 현재 디렉토리에
  " ExamplePage.wiki 파일이 있는지 확인
  silent execute ':!ls ./wiki/' . a:word . '.wiki'
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
  let store_wiki_name = "viw\"z"
  let replace_with_formatted_wiki_name = "s[:\<C-r>z:]\<Esc>"
  execute "normal! " . store_wiki_name . replace_with_formatted_wiki_name
endfunction

function! UnwrapBrackets(word)
  " 링크 형식 문자열에서 [:, :] 삭제
  " [:ExamplePage:] -> ExamplePage
  let link_format_wiki_name = a:word
  let brackets_unwrapped = substitute(substitute(link_format_wiki_name, '^\[:', '', ''), ':\]$', '', '')
  return brackets_unwrapped
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
  silent execute ':!touch ./wiki/' . shellescape(a:word) . '.wiki'
  call WrapWithBrackets()
  silent execute ':w ' . expand('%')
  call WarpToLink('[:' . a:word . ':]')
endfunction

"명령 실행 시 커서 위에 있는 단어를 기존 파일 이름으로 받아야 한다
"그리고 프롬프트를 띄워서 수정할 파일 이름을 입력받을 수 있어야 한다
function! RenameWikiPage(prev_file_name_with_brackets, edited_file_name)
  let prev_file_name = UnwrapBrackets(a:prev_file_name_with_brackets)
  " 해당 위키 파일이 이미 있는지 확인
  let camel_case = '\v([A-Z][a-z]+)+'
  if a:edited_file_name !~# camel_case
    echom 'invalid wiki file name: use camel case!'
    return
  endif

  let file_exists = CheckFileExists(prev_file_name)
  if file_exists == 'file not exists'
    echom 'attempt to rename wiki file that does not exists. exit...'
    return
  endif

  " 위키 페이지 이름 수정
  silent execute ':!mv ./wiki/' . prev_file_name . '.wiki ./wiki/' . a:edited_file_name . '.wiki'

  " 인덱스 페이지의 위키 링크를 수정할 링크명으로 바꾼다
  execute "normal! " . "viwx"
  execute "normal! i" . a:edited_file_name

  silent execute ':w ' . expand('%')
endfunction

function! WarpToLink(formatted_link)
  " 위키 페이지로 이동
  " 페이지로 이동하기 전에 주어진 문자열이 링크 형식인지,
  " 해당 위키 파일이 이미 있는지 확인

  let link_pattern = '\v\[\:([A-Z][a-z]+)+\:\]'
  let link_file_pattern = '\v([A-Z][a-z]+)+'

  if a:formatted_link !~# link_pattern
    echom 'WarpToLink: Invalid format of wiki link!'
    return
  endif

  let file_name = matchstr(a:formatted_link, link_file_pattern)
  let file_exists = CheckFileExists(file_name)
  if file_exists == 'file not exists'
    echom 'WarpToLink: file not exists'
    return
  endif

  execute ":e ./wiki/" . file_name . ".wiki"
endfunction

nnoremap <leader>wc :call CreateWikiPage(expand('<cword>'))<CR>
nnoremap <leader>ww :call WarpToLink(expand('<cWORD>'))<CR>
nnoremap <leader>wr :call RenameWikiPage(expand('<cWORD>'), input("type new file name: "))<CR>
