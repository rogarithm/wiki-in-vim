## vim에서 위키 문서를 만들고, 문서 간 이동할 수 있는 단축키를 제공하는 위키 엔진

### 경험한 불편함
- 회사 업무와 개인적인 기록을 디렉토리 기반으로 관리할 때, 필요한 문서를 찾거나 디렉토리 구조를 변경하기가 번거로웠음

### 구현한 것
- vimscript를 사용하여 위키 문서에 대한 CRUD 기능과 유효성 검증 로직을 구현

### 프로그램으로 개선한 것
- 문서 간 이동과 관리가 간단해졌고, 문서 구조를 처음부터 고민할 필요 없이 작성 내용에만 집중할 수 있게 됨

### 설치 방법
**심볼릭 링크 없이 사용 시**
 1. 위키를 만들려는 디렉토리에 wiki.vim 파일을 옮긴다
```
cd ~/path/to/project && cp /path/to/wiki.vim ./wiki.vim
```
 2. wiki 디렉토리, 인덱스 파일을 만든다
```
mkdir wiki && touch index
```
 3. vimrc 파일에 다음과 같은 위키 설정을 추가한다. 이 설정은 위키로 쓸 디렉토리에서 인덱스 파일을 열었을 때 wiki.vim 스크립트를 자동으로 불러온다
```
autocmd! BufReadPost ~/path/to/project/index source %:h/wiki.vim
```

### 사용 방법
- 설치 후 인덱스 파일을 열고 문서를 작성하면 된다
- 새로운 위키 문서를 추가하고 싶으면 카멜 케이스로 문서명을 쓰고, `,wc` 단축키를 입력한다
- 위키 문서로 이동하고 싶으면 위키 문서 링크 위에 커서를 두고 `,ww` 단축키를 입력한다
- 위키 문서의 이름을 바꾸고 싶으면 위키 문서 링크 위에 커서를 두고 `,wr` 단축키를 입력한다. 그러면 vim 하단 콘솔 창에 이름을 어떻게 바꿀지 묻는 메시지가 뜨고, 여기에 입력한 값을 새로운 위키 문서 이름으로 바꿔준다
