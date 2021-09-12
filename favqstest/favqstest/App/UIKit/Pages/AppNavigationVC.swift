//
//  AppNavigationVC.swift
//  Wizbind
//
//  Created by Vu Phan on 18/08/2021.
//

import UIKit

class AppNavigationVC: UIViewController {
    // MARK: + Xib
    @IBOutlet private weak var navigationBarContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    // MARK: + UI
    var navigationBar = AppNavigationBarView()
    private let containerViewBottom = "containerViewBottomCSTID"
    var prTransitioningDelegate = Pr.present.transitioningDelegate.init(to: .slideUp, drag: true)
    // MARK: + Public
    public var isNavigationBarHidden: Bool!
    public var isNavigationBarExpand: Bool!
    public var isKeyboardHandlerEnable: Bool!
    public var isKeyboardHideOnTap: Bool!
    
    
    
    // MARK: - View Controller
    required init?(coder: NSCoder) {
        super.init(nibName: AppNavigationVC.pr_typeName, bundle: nil)
    }
    
    init() {
        super.init(nibName: AppNavigationVC.pr_typeName, bundle: nil)
        isNavigationBarHidden = false
        isNavigationBarExpand = false
        isKeyboardHandlerEnable = true
        isKeyboardHideOnTap = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func loadView() {
        super.loadView()
        
        if isKeyboardHandlerEnable {
            self.pr_keyboardSetupHandler()
        }
        if isKeyboardHideOnTap {
            _ = self.containerView.pr_setupKeyboardHideOnTap()
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
    }
    
    override func pr_keyboardHandler(willDisplay: Bool, withRect: CGRect, animationDuration: TimeInterval) {
        if willDisplay {
            let bottomValue = -withRect.height + self.view.pr_getSafeOffset().bottom
            self.view.pr_setConstraint(forId: containerViewBottom,
                                       withValue: bottomValue)
        } else {
            self.view.pr_setConstraint(forId: containerViewBottom,
                                       withValue: 0)
        }
        keyboard(willDisplay: willDisplay, withRect: withRect, animationDuration: animationDuration)
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: - UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.app.content
        
        navigationBarContainerView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        isNavigationBarExpand = isNavigationBarHidden ? false : isNavigationBarExpand
        
        navigationBar = AppNavigationBarView(inView: navigationBarContainerView, expandMode: isNavigationBarExpand)
        navigationBar.setupTitle("")
        navigationBar.setupLeftAction(icon: .none)
        navigationBar.setupRightAction(icon: .none)
        
        if isNavigationBarHidden {
            navigationBar.hide()
        }
    }
    
    
    // MARK: - Public
    func addScrollableContentView() -> (scrollView: UIScrollView, contentView: UIView) {
        let contentScrollView = UIScrollView()
        contentScrollView.backgroundColor = .clear
        contentScrollView.clipsToBounds = false
        containerView.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints({ make in
            make.edges.equalTo(0)
        })
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        contentScrollView.addSubview(contentView)
        contentView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        })
        
        return (scrollView: contentScrollView, contentView: contentView)
    }
    
    // MARK: + Keyboard
    public func keyboard(willDisplay: Bool, withRect: CGRect, animationDuration: TimeInterval) {
        // - To override to make ui stuff when keyboard will show/hide
    }
    
}

