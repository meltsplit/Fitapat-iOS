#  Configuration 정보

## Configuration은 총 4개의 파일이 존재한다.
- Config Docs.md
- Config.swift
- Debug-GoogleService-Info.plist
- Release-GoogleService-Info.plist
- Debug.xcconfig
- Release.xcconfig

### Config Docs
- 현재 보고 있는 파일

### Config.swift
- Config 상수 편하게 쓰기 위한 Swift 파일

### GoogleService-Info.plist
- Firebase를 사용하기 위해 필요한 파일
- Debug용과 Release용이 있다.
- Firebase는 파일명이 GoogleService-Info.plist 을 따라가기에 
  Target > Build phases > Firebase plist에 Debug/Release여부에 따라 
  파일명을 Release-GoogleService-Info -> GoogleService-Info.plist 로 바꿔주는 작업을 거친다.

### Debug.xcconfig, Release.xcconfig
- Debug / Release 빌드 설정값을 달리 하기위해 분리된 xcconfig 파일

### 각 파일이 담고있는 Key-Value
- App Name
- Base URL
- Kakao App Key
- Bundle Identifier
- App Icon
