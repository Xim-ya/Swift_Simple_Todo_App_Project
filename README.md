## 목차
- [학습 내용](#학습-내용)
- [요약](#요약)
- [학습 키워드](#학습-키워드)


## 학습 내용
간단한 TodoApp을 만들며 `UITableView`에 대한 내용을 중점적으로 학습 


## 요약

| Index | Detail                                                                                                                                                                                                                              |
|-------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 구현 영상 | https://www.youtube.com/watch?v=7RWjXMwmy1c|
| 구현 기간 | **2022.03.25(하루)**                                                                                                                                                                                                                  |
| 기술 스택 | - Swift UIkit                                                                                                                                                                                                                       |
| 구현 기능 | - UITableView 를 이용하여 Todo 리스트를 화면에 보여줌. <br/> - TableView의 Cell을 클릭하면 Cell에 체크 아이콘이 Toggle됨 <br> - Todo를 입력받고 Cell 추가 & 기존 Cell 삭제 <br> - `moveRowAt` Table View 메소드를 활용하여 Todo 아이템들을 정렬 <br> - 사용자가 앱을 종료해도 기존 Todo 데이터를 Local에 저장 | 



## 학습 키워드
- [Tableview](#TableView) 
  - delegate
    - didSelectRowAt
  - datasource
    - numberOfRowInSection
    - cellForRowAt

- selector
  - AddTarget
  
- [Set NavigationController without Storyboard](#Set-TableView-Delegate,-DataSource-Protocol)

- [Local Database Storage](#UserDefaults-(Local-Data-Base-Storage))
  - userDefaults
    - Load From Local Storage
    - Save to Local Storage



## TableView
- 화면에 목록을 표시하기 위한 UI 구성요소.
- Flutter에서 `ListView` 위젯과 비슷한 역할을 수행

### Datasource & Delegate위임
- TableView를 사용하기 위해서는 `Delegate` & `DataSource` Protocol 채택하여 구현 필요
```
TableView는 Delegate, Dqatasource에 정의에 따라 사용자에게 어떻게 뷰와 유저 인터렉션을 제공할지 결정하게 됨.
```
- TableView 에서 인터렉션이 일어 났을 때 Controller에 직접 전달하면 안됨
  - Swift에서는 이런 경우 `Delegate`을 사용하여 특정 이벤트 값을 Controller에 전달하는 방식을 채택함 
  - Flutter `Listview` 위젯과 기능적으로 비슷하지만 Flutter에서는 뷰 위젯이 직접적으로 인터렉션 이벤트를 값을 처리한다는 점에서 다른 부분이 있음.  
  
- DataSource
  - 데이터를 받아 뷰를 그려주는 역할

- Delegate
  - TableView의 동작과 외관을 담당. 
  - 뷰는 Delegate 의존하여 업데이트함.
  


###Set TableView Delegate, DataSource Protocol 
- ViewController Extension 내에서 필요 프로토콜 채택 

```swift
/* Table Datatsource Protocal */
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    /* DataSource Method */
    
    // 1) 각 센션에 표시할 행(cell)의 개수를 묻는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         ....
    }
    
    // 2) 특정 인덱스 Row의 Cell에 대한 정보를 넣어 Cell를 반환하는 메소드 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	 ....
    }
    
    
    /* DataSource Method */
    
    // 3) Cell에 특정 인터렉션이 일어날 때 이벤트를 처리하는 delegate method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ....
    }
}
```
- DataSource 프로토콜을 채택하게 되면 위와 필수로 선언해줘야 하는 메소드가 존재


## Set NavigationController without Storyboard

SceneDelegate.swift 
```
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /* No story Board Setting */
        // 윈도우 씬을 가져옴
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 윈도우 크기 설정
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // View Controller 인스턴스 가져오기
        let vc = ViewController()
        
        // 네비게이션 컨트롤러 설정
        let navVC = UINavigationController(rootViewController: vc)
        
        // Root View Controller 설정
        window?.rootViewController = navVC
        
        // 설정한 윈도우를 보이게 끔 설정
        window?.makeKeyAndVisible()
        
        // 윈도우씬 설정
        window?.windowScene = windowScene
    }
    
    .....
    
}       
```
- SceneDelegate 소스파일 안에서 위와 같은 단계로 스토리보드 없이 NavigationController와 Root View Controller을 설정할 수 있음.

##UserDefaults (Local Data Base Storage) 
- 어플리케이션 디버깅 시 사용자의 기본 `Local Database`를 key-value 매핑된 값을 저장하는 인터페이스
- 간단하게 데이터 저장소라고 이해할 수 있음
- 주요 기능
  - 기본 객체 저장
    - swift안에 있는 float, Int, double, Bool, URL 등 기본적으로 제공하는 자료구조와 NSData, NSString, NSNumber NS관련 자료구조 또한 저장 가능.
  - 파일 참조 유지
    - `option:includingResourceValuesForKeys:relateTo1` 메서드를 사용하여 NSURL 북마크 데이터를 생성하여 파일 URL에 대한 데이터가 손실되지 않게 도와줌.
  - UserDefaults 값 변경에 대한 알림
    - Default Notification Center을 통해 UserDefaults 값이 변경될 때마다 알림을 받을 수 있음



### 출처 
https://daesiker.tistory.com/68 <br>
https://eunjios.github.io/syntax/table-view-syntax/




