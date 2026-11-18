#if canImport(UIKit)
import UIKit

/// 고정된 페이지 목록을 가로 방향으로 순환해 표시합니다.
public final class InfinitePagingController: UIPageViewController {
  private let pageCount: Int
  private let makePage: (Int) -> UIView
  private let onPageChange: (Int) -> Void

  /// 시작 페이지와 각 페이지의 콘텐츠를 지정합니다.
  public init(
    pageCount: Int,
    initialIndex: Int,
    makePage: @escaping (Int) -> UIView,
    onPageChange: @escaping (Int) -> Void
  ) {
    self.pageCount = max(0, pageCount)
    self.makePage = makePage
    self.onPageChange = onPageChange
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    delegate = self
    dataSource = pageCount > 1 ? self : nil
    if pageCount > 0 {
      showPage(at: min(max(0, initialIndex), pageCount - 1))
    }
  }

  /// 코드로 구성하는 페이지 컨트롤러입니다.
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  /// 현재 표시 중인 페이지의 콘텐츠입니다.
  public var currentPageView: UIView? { viewControllers?.first?.view }

  /// 유효한 인덱스의 페이지로 즉시 이동합니다.
  public func showPage(at index: Int) {
    guard (0..<pageCount).contains(index),
          (viewControllers?.first as? Page)?.index != index else { return }
    setViewControllers([Page(index: index, content: makePage(index))], direction: .forward, animated: false)
  }
}

extension InfinitePagingController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  /// 첫 페이지의 이전 페이지로 마지막 페이지를 제공합니다.
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard pageCount > 1, let page = viewController as? Page else { return nil }
    let index = page.index == 0 ? pageCount - 1 : page.index - 1
    return Page(index: index, content: makePage(index))
  }

  /// 마지막 페이지의 다음 페이지로 첫 페이지를 제공합니다.
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard pageCount > 1, let page = viewController as? Page else { return nil }
    let index = (page.index + 1) % pageCount
    return Page(index: index, content: makePage(index))
  }

  /// 사용자가 페이지 전환을 완료하면 새 인덱스를 전달합니다.
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard completed, let page = viewControllers?.first as? Page else { return }
    onPageChange(page.index)
  }
}

private final class Page: UIViewController {
  let index: Int

  /// 페이지의 위치와 표시할 콘텐츠를 연결합니다.
  init(index: Int, content: UIView) {
    self.index = index
    super.init(nibName: nil, bundle: nil)
    view = content
  }

  /// 코드로 구성하는 페이지입니다.
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
}
#endif
