# yourwriting-frontend
'yourwriting' is note application that can generate your own font and use it on this application. 

### Service

- 사용자의 글씨체를 바탕으로 폰트를 생성하고 이를 이용해 글을 작성할 수 있는 어플
- 이 프로젝트의 제작 배경과 과정은 [youtubeLink](https://www.youtube.com/watch?v=snZSz7RWGZE&list=LL&index=5&t=24s)
<br/>

### Stacks

<img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white"><img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"><img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white">

### Cowork tools
<img src="https://img.shields.io/badge/Notion-%23000000.svg?style=for-the-badge&logo=notion&logoColor=white"><img src="https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white"><img src="https://img.shields.io/badge/-Swagger-%23Clojure?style=for-the-badge&logo=swagger&logoColor=white"><img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"><img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">

<br/>

### 핵심 기능

**로그인 기능**

- 회원가입을 통해 사용자의 아이디 생성이 가능함.
- 생성된 아이디를 통해 다른 기기에서도 자유롭게 글을 작성할 수 있음.
  
**폰트 생성 기능**

- 자음과 모음 40개를 차례로 직접 기기를 이용해 canvas에 그리고 이를 저장해 서버로 전송. (핸드폰, 아이패드 가능)
- 폰트서버(flask)에 40개를 모아 한번에 전송. PNG파일로 전송하며 이 때 각 파일의 제목을 01~40으로 함.
- 폰트서버에서 폰트를 생성 후 프론트로 전송. 프론트에서 받은 폰트를 getApplicationDocumentsDirectory()를 이용해 각 모바일 기기의 sandbox에 저장해 사용함.

**노트 기능**

- 노트목록은 노트서버(spring)에서 받아와 최신 날짜부터 차례로 정렬됨.
- 플러스 버튼을 눌러서 노트 생성 가능.
- 직접 만든 폰트로 작성되며 날짜와 제목도 함께 기록됨.
- 생성된 버튼을 길게 누르면 GestureDetector의 onLongPress을 이용해 delete note 함수가 실행됨.
- 글 작성시에는 글씨크기 조절, 이미지 추가 등도 가능함.


<br/>

### 기여

**프로젝트 기획**

- 프로젝트의 기획, figma를 이용한 디자인, 생성된 폰트를 더 정확하게 발전시키는 과정, 프론트의 모든 개발 과정에 적극적으로 참여함.
- 팀장으로서 매주 발표, 영상 제작을 맡아서 진행함.
- 'Development of User-Customized Korean Font Generation and Handwriting Application Using Python' 논문 작성에 적극적으로 참여하고 이에 대해 교수님과 소통하며 발전시킴.

**기능 구현**

- 앱 내 모든 화면을 구현하고 서버와의 연결, 앱의 빌드 등 프론트엔드에서 필요한 모든 기능을 구현함.
- 폰트 생성 서버에서 폰트를 조합하고 생성하는 과정, 특히 겹받침 폰트를 생성하는 부분과 폰트 크기를 일괄적으로 맞추기 위해 사이즈 조절하는 기능을 구현함.
- 폰트 노이즈를 줄이고 더 실제와 비슷한 폰트를 구현하기 위해 openCV와 python라이브러리를 결합하여 기능을 구현함.

**테스트**

- xcode를 이용해 휴대폰과 아이패드에 앱을 다운받고 이를 이용해 전시회 기간동안 다양한 폰트를 생성하고 이를 이용해 글을 작성함. 이후 구글폼QR을 준비해 사용자 평가도 진행함.

<br/>

### 앱 팜플렛 및 사용화면

**팜플렛**

<img width="518" src="https://github.com/yourwriting/yourwriting-front/assets/52371699/258a0fcb-9092-48ce-8ee6-37818ef5bb81">

<br/>
<br/>

**사용화면**

<img height="406" alt="loading" src="https://github.com/yourwriting/yourwriting-front/assets/52371699/8b25341b-d4be-4488-8627-d62a681331d9">
 <img height="406" alt="login" src="https://github.com/yourwriting/yourwriting-front/assets/52371699/4b2cb253-4992-4057-9892-f2e58325a977">
<br>
<img height="406" alt="home" src="https://github.com/yourwriting/yourwriting-front/assets/52371699/8f5fdd06-bda6-47b8-96db-34abed3d0cd2">
 <img height="406" alt="generator" src="https://github.com/yourwriting/yourwriting-front/assets/52371699/3ab2bc17-7942-4c6e-a93c-5071b6122282">
 <img height="406" alt="writing" src="https://github.com/yourwriting/yourwriting-front/assets/52371699/abad47a0-23e6-4346-add0-aa64296009f7">

