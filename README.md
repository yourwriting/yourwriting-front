# yourwriting-frontend
'yourwriting' is note application that can generate your own font and use it on this application. 

### Service

- 사용자의 글씨체를 바탕으로 폰트를 생성하고 이를 이용해 글을 작성할 수 있는 어플
- 이 프로젝트의 제작 배경과 과정은 [YoutubeLink](https://www.youtube.com/watch?v=snZSz7RWGZE&list=LL&index=5&t=24s)

<br/>
### Stacks
<img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white"><img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"><img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white">

### Cowork tools
<img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"><img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">

<br/>

### 핵심 기능

**폰트 생성 기능**

- 자음과 모음 40개를 차례로 직접 기기를 이용해 그리고 이를 이용해 폰트를 생성함. (핸드폰, 아이패드 모두 가능)

**노트 기능**

- 노트목록은 최신 날짜부터 차례로 정렬됨.
- + 버튼을 눌러서 노트 생성 가능.
- 직접 만든 폰트로 작성되며 날짜와 제목도 함께 기록됨.
- 생성된 버튼을 길게 누르면 GestureDetector의 onLongPress을 이용해 delete note 함수가 실행됨.


<br/>

### 기여한 부분

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

### 앱 템플릿 및 사용화면
