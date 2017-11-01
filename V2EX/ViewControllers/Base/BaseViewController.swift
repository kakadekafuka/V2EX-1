import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var interactivePopDisabled: Bool = false

//    // MARK: Properties
//    lazy private(set) var className: String = {
//        return type(of: self).description().components(separatedBy: ".").last ?? ""
//    }()

    // MARK: Initializing

    deinit {
        log.verbose("DEINIT: \(self.className)")
    }
    
    // MARK: Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        var style = UIStatusBarStyle.default
        ThemeStyle.style
            .asObservable()
            .subscribeNext { theme in
                style = theme.statusBarStyle
        }.disposed(by: rx.disposeBag)
        return style
    }
    
    // MARK: Layout Constraints
    
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
//        view.backgroundColor = Theme.Color.bgColor

        setupSubviews()
        
        view.setNeedsUpdateConstraints()
        
        setupRx()

        setupTheme()
    }

    func setupTheme() {
        ThemeStyle.style.asObservable()
            .subscribeNext { [weak self] theme in
                self?.view.backgroundColor = theme.bgColor
            }.disposed(by: rx.disposeBag)
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func setupSubviews() {
        // Override point
    }
    
    func setupConstraints() {
        // Override point
    }
    
    func setupRx() {
        // Override point
    }

    // MARK: Action
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
