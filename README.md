# InfinitePaging

고정된 페이지 목록을 가로로 순환해 표시하는 UIKit용 Swift 패키지입니다. 마지막 페이지에서 다음으로 넘기면 첫 페이지로, 첫 페이지에서 이전으로 넘기면 마지막 페이지로 이동합니다. 각 페이지에 표시할 뷰는 앱에서 제공합니다.

Swift 6.0 이상, iOS 16 이상을 지원합니다. UIKit 외에 외부 의존성이 없습니다.

## 설치

Xcode의 **File → Add Package Dependencies**에서 `https://github.com/swift-man/InfinitePaging.git`을 추가하고 `InfinitePaging` product를 선택합니다.

`Package.swift`에서 버전을 고정하려면 다음과 같이 추가합니다.

```swift
.package(url: "https://github.com/swift-man/InfinitePaging.git", exact: "0.1.0")
```

사용하는 타깃의 의존성에 `.product(name: "InfinitePaging", package: "InfinitePaging")`을 추가합니다.

## 사용

`InfinitePagingController`를 자식 뷰 컨트롤러로 연결합니다. `makePage`는 호출될 때마다 해당 인덱스의 새 뷰를 반환합니다.

```swift
import InfinitePaging
import UIKit

final class GalleryViewController: UIViewController {
  /// 예제 페이지 세 장을 가로로 순환해 표시합니다.
  override func viewDidLoad() {
    super.viewDidLoad()

    let paging = InfinitePagingController(
      pageCount: 3,
      initialIndex: 0,
      makePage: { index in
        let label = UILabel()
        label.text = "\(index + 1)번째 페이지"
        label.textAlignment = .center
        return label
      },
      onPageChange: { index in
        print("현재 페이지: \(index)")
      }
    )

    addChild(paging)
    let pagingView: UIView = paging.view
    pagingView.frame = view.bounds
    pagingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(pagingView)
    paging.didMove(toParent: self)
  }
}
```

- 페이지 인덱스는 0부터 시작합니다. 시작 인덱스가 범위를 벗어나면 가장 가까운 유효한 인덱스로 조정합니다.
- 페이지가 0개면 콘텐츠를 표시하지 않고, 1개면 스와이프를 비활성화합니다.
- `onPageChange`는 사용자가 스와이프로 페이지 전환을 완료했을 때 호출됩니다. 초기 표시와 `showPage(at:)`로 이동한 경우에는 호출되지 않습니다.
- `currentPageView`로 현재 표시 중인 콘텐츠 뷰를 조회할 수 있습니다.

## 라이선스

[MIT](LICENSE)
