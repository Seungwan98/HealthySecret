### 헬시크릿 - 칼로리 , 활동 계산 및 SNS



# 👨‍👩‍👧‍👦 팀 구성

- iOS Developer[1]
- UI/UX Designer [1]

# ❣️ 프로젝트 소개

 **건강한 비밀 , 헬시크릿**
 

### 🫵 매번 건강관리에 포기하셨던 당신 , 헬시크릿을 이용해보세요!


# ✨ 주요 기능

---

### 🔑 소셜 서비스를 통해 간편하게 이용할 수 있어요!

<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/1579d3cb-40cc-44ae-8567-2e205dd12f75">



### 👀 오늘 내가 섭취한 음식들에 대한 칼로리 및 영양 정보를 확인할 수 있어요!
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/8cca6dcd-b68b-4bb1-8d86-d62062f645b9">
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/78f26f7a-e416-4567-bbb5-ca21d71c8182">




### 👀 아침 , 점심 , 저녁 , 간식을 섭취했는지 확인하고 먹은 음식을 추가할 수 있어요!
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/665e9fb3-2eac-481c-82b7-974ebe8aa97d">
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/44ca5aa3-8b67-4c1d-851b-4447e7964382">
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/c146d840-9c25-4ce8-9ddd-bb9a2e062a79">
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/13f8a82e-af80-412a-aa02-571af6cf0152">




### 👀 오늘 총 활동 시간과 활동 칼로리를 확인하고 추가 활동을 추가할 수 있어요!
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/17efe7c3-670d-4d71-8d89-c11c2f22cd08">
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/a2169308-53e5-4ac1-add6-90b04e2da720">
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/aac88342-9454-4907-807c-2d54db2b7238">
<img width="240" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/59106efd-9de5-4111-8201-610ff4baa026">



### 📍 나의 일상을 공유할 수 있어요!                   ✍️　프로필을 꾸며보세요! 
<img width="280" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/6d86fc03-241b-4c4b-b51a-6ed2a3158575">　　　　　　　　　　　
<img width="280" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/7b130b4a-0e6b-452a-a527-9c6506e7ddb6">





### 👨‍👩‍👧‍👦 유저들의 일상을 확인할 수 있어요!             📝 댓글로 소통해 보세요!
<img width="280" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/9edcbe06-96f9-4930-bed1-81a18a14c2f6">　　　　　　　　　　　
<img width="280" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/00bf0fc1-6c87-42eb-94a1-5afd3b3e7219">





### 🔒 혼자만 알고싶은 내용은 일기를 이용해요! 
<img width="280" alt="coord" src="https://github.com/Seungwan98/HealthySecret/assets/124136512/1f1853f2-fc93-4874-b280-8dad36d5b139">




# 🛠️ 주요 사용 기술

## ➜ MVVM

### 도입 이유
- 뷰 로직과 비즈니스 로직을 분리하고 보다 나은 가독성을 원하여 도입하였습니다.

### 성과
- 데이터 바인딩을 통하여 UI 업데이트를 간소화하고 일관성을 유지하였습니다.
- 데이터들을 직관적으로 확인할 수 있었습니다.


## ➜ RxSwift

### 도입 이유
- MVVM 패턴과 가장 적합하다고 생각하여 함께 사용하게 되었습니다.
- CompletionHandler를 사용하던 도중 더 간결한 코드를 바라던 중 보다 간결하고 가독성이 좋아서 도입하게 되었습니다.


### 성과
- 코드가 보다 간결해지고 가독성이 높아질 수 있었습니다.
- MVVM패턴의 데이터 바인딩을 보다 쉽게 구현할 수 있었습니다.
- 기존 비동기 코드의 사용이 적어져 일관성 있는 코드를 사용할 수 있었습니다.

## ➜ Coordinator 패턴

### 도입 이유
- StoryBoard를 사용하지 않고 코드 베이스로 UI를 
- ViewController의 화면 전환 및 의존성을 주입하는 역할을 분리하고, 한눈에 보기 위해 적용했습니다.
### 성과
- ViewController들의 강한 결합 문제를 해결할 수 있었습니다.
- 각 Coordinator의 완료 시 바로 메모리에서 제거 해주기 편하여 메모리 낭비를 막을 수 있었습니다.

## ➜ Firebase

### 도입 이유
- 사용자 회원가입 및 탈퇴 , 로그인 및 로그아웃 , 피드 관련 기능 , 운동과 음식 정보 저장 및 모든 곳에서 정보를 저장 하기 위하여 도입하게 되었습니다.

### 성과
- Firebase Authentication과 FireStore를 결합하여 회원가입 및 로그인 기능을 구현하였습니다.
- FireStore를 통하여 유저 정보 및 음식 활동 관련 정보등을 저장하였습니다.
- Firebase Storage를 통하여 프로필 , 피드 이미지 등 이미지 관련 정보를 저장하였습니다.
- Firebase Cloud Function을 통하여 Apple회원 탈퇴 시 필요한 토큰 관련 코드들을 백엔드 코드로 실행하였습니다.



### 버그 및 문의 사항

- app dev : sinna3210@gmail.com
- app design : crong_3012@naver.com


