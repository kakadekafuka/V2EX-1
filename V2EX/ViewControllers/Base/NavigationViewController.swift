import UIKit

class NavigationViewController: UINavigationController {

    var fullScreenPopGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        setAppearance()
        setFullScreenPopGesture()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), action: {
                self.popViewController(animated: true)
            })
        }
        super.pushViewController(viewController, animated: true)
    }
}


extension NavigationViewController {
    
    fileprivate func setAppearance() {
//        navigationBar.barTintColor = Theme.Color.navColor
//        navigationBar.tintColor = Theme.Color.globalColor
//        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Theme.Color.globalColor]

        ThemeStyle.style.asObservable()
            .subscribeNext { [weak self] theme in
//                self?.navigationBar.barTintColor = theme.navColor
//                self?.navigationBar.tintColor = theme.titleColor
                self?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.titleColor]
                self?.navigationBar.barStyle = theme == .day ? .default : .black
            }.disposed(by: rx.disposeBag)
    }
    
    /// 解决自定义backItem后手势失效的问题， 并修改为全屏返回
    func setFullScreenPopGesture() {
        let target = self.interactivePopGestureRecognizer?.delegate
        let targetView = self.interactivePopGestureRecognizer!.view
        let handler: Selector = NSSelectorFromString("handleNavigationTransition:");
        let fullScreenGesture = UIPanGestureRecognizer(target: target, action: handler)
        fullScreenPopGesture = fullScreenGesture
        fullScreenGesture.delegate = self
        targetView?.addGestureRecognizer(fullScreenGesture)
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == .phone
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .none
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}

extension NavigationViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    
//        if (topViewController as BaseViewController).interactivePopDisabled {
//            return false
//        }

        if childViewControllers.count <= 1 {
            return false
        }

        // 手势响应区域
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let location = panGestureRecognizer.location(in: view)
        let offset = panGestureRecognizer.translation(in: panGestureRecognizer.view)
//        let ret = 0 < offset.x && location.x <= 40 // x < 40 可以响应返回手势
        let ret =  0 < offset.x && location.x < view.width // 全屏返回手势
        return ret
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
