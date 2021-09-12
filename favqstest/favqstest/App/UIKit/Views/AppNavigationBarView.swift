import UIKit
import SnapKit

protocol AppNavigationBarViewDelegate {
    func didDisplayDefaultBar(sender: AppNavigationBarView)
    func didDisplayExpandBar(sender: AppNavigationBarView)
}

class AppNavigationBarView: UIView {
    enum Icon: String {
        case none = "NONE"
        case close = "xmark"
        case back = "arrow.left"
        case checkmarkSeal = "checkmark.seal"
        case logout = "xmark.seal"
        case home = "house"
        case search = "magnifyingglass"
        case more = "ellipsis"
        case filter = "line.horizontal.3.decrease"
        case refresh = "arrow.clockwise.circle"
    }
    // MARK:
    // MARK: + Attr
    var viewSrc = UIView()
    var view: UIView!
    // MARK: _ Xib
    @IBOutlet weak var statusBarView: UIView!
    // MARK: __ Content
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLeftActionView: UIView!
    @IBOutlet weak var contentLeftActionFillView: UIView!
    @IBOutlet weak var contentLeftActionButton: UIButton!
    @IBOutlet weak var contentRightActionView: UIView!
    @IBOutlet weak var contentRightActionFillView: UIView!
    @IBOutlet weak var contentRightActionButton: UIButton!
    @IBOutlet weak var contentMainView: UIView!
    @IBOutlet weak var contentMainTitleLabel: UILabel!
    @IBOutlet weak var contentLogoImageView: UIImageView!
    var contentSeparatorView: AppSeparatorView!
    // MARK: __ Expand
    @IBOutlet weak var expandView: UIView!
    @IBOutlet weak var expandContentView: UIView!
    @IBOutlet weak var fullBackgroundContentView: UIView!
    var expandSeparatorView: AppSeparatorView!
    // MARK: _ UI
    private var expandMode = false
    private let navigationBarHeightBase: CGFloat = 44
    private var navigationBarHeight: CGFloat = 44
    private var navigationBarExpandHeight: CGFloat = 120
    // -
    private var navigationBarFullBackground = false
    
    
    
    // MARK:
    // MARK: + Public
    // MARK: _ Expand
    var expandDragThreshold = true
    var expandAuto = true
    var navigationBarExpandHeightBase: CGFloat = 120 {
        didSet {
            navigationBarExpandHeight = navigationBarHeight + navigationBarExpandHeightBase
        }
    }
    
    // MARK: __ Closures
    var onLeftActionTap: (() -> Void)?
    var onRightActionTap: (() -> Void)?
    var onExpandDisplayed: (() -> Void)?
    var onDefaultDisplayed: (() -> Void)?
    
    // MARK:
    // MARK: + View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        initXib()
        setupUI()
    }
    
    init(inView: UIView, expandMode: Bool = false) {
        super.init(frame: inView.pr_frameSize())
        viewSrc = inView
        initXib()
        inView.addSubview(self)
        
        self.expandMode = expandMode
        
        initConstraints()
        setupUI()
    }
    
    private func initXib() {
        view = AppNavigationBarView.pr_nibView(forOwner: self, nibName: "AppNavigationBarView")
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        view.frame = bounds
        frame = bounds
    }
    
    private func initConstraints() {
        self.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        handleStatusBar(true)
    }
    
    private func handleStatusBar(_ display: Bool, top: CGFloat = 0) {
        let statusBarHeight:CGFloat = display ? self.pr_getSafeOffset().top : top
        self.statusBarView.pr_setConstraint([.height: statusBarHeight])
        
        navigationBarHeight = navigationBarHeightBase + statusBarHeight
        navigationBarExpandHeight = navigationBarHeight + navigationBarExpandHeightBase
        viewSrc.pr_setConstraint([.height: navigationBarHeight])
    }
    
    
    // MARK:
    // MARK: + UI
    private func setupUI() {
        self.backgroundColor = UIColor.app.content
        self.view.backgroundColor = UIColor.app.content
        statusBarView.backgroundColor = UIColor.app.content
        contentView.backgroundColor = UIColor.app.content
        
        contentMainView.backgroundColor = .clear
        contentLeftActionView.backgroundColor = .clear
        contentRightActionView.backgroundColor = .clear
        
        expandView.backgroundColor = .clear
        expandContentView.backgroundColor = .clear
        fullBackgroundContentView.backgroundColor = .clear
        fullBackgroundContentView.clipsToBounds = true
        
        contentSeparatorView = AppSeparatorView(.bottom, inView: contentView)

        contentLeftActionFillView.pr_round(radius: contentLeftActionFillView.pr_width / 2)
        contentRightActionFillView.pr_round(radius: contentRightActionFillView.pr_width / 2)
        
        contentMainTitleLabel.backgroundColor = .clear
        contentMainTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        contentMainTitleLabel.textColor = UIColor.app.text
        contentMainTitleLabel.textAlignment = .center
        
        if expandMode {
            contentSeparatorView.alpha = 0
            
            expandSeparatorView = AppSeparatorView(.bottom, inView: expandView)
            expandSeparatorView.isHidden = false
        }
        fullBackgroundContentView.alpha = 0
    }
    
    private func getImage(fromIcon: Icon) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 16,
                                                 weight: .medium,
                                                 scale: .default)
        let image = UIImage(systemName: fromIcon.rawValue,
                            withConfiguration: config)
        return image
    }
    
    
    // MARK: _ Xib handlers
    @IBAction func contentLeftActionButtonUpInsideHandler(_ sender: Any) {
        onLeftActionTap?()
    }
    
    @IBAction func contentRightActionButtonUpInsideHandler(_ sender: Any) {
        onRightActionTap?()
    }
    
    
    // MARK:
    // MARK: + Public
    func hide(withStatusBar: Bool = false) {
        let statusBarHeight:CGFloat = withStatusBar ? 0 : self.pr_getSafeOffset().top
        viewSrc.pr_setConstraint([.height: statusBarHeight])
    }
    
    func show() {
        viewSrc.pr_setConstraint([.height: navigationBarHeight])
    }
    
    func removeStatusBar(forTop: CGFloat = 0) {
        handleStatusBar(false, top: forTop)
    }
    
    func setupLogo(_ isDisplay: Bool) {
        contentMainView.isHidden = isDisplay
        contentLogoImageView.isHidden = !isDisplay
    }
    
    func setupLeftAction(icon: Icon, color: UIColor = UIColor.black, fillColor: UIColor = UIColor.app.border) {
        if icon == .none {
            contentLeftActionView.isHidden = true
        } else {
            contentLeftActionView.isHidden = false
            
            contentLeftActionFillView.backgroundColor = fillColor
            contentLeftActionButton.setImage(getImage(fromIcon: icon), for: .normal)
            contentLeftActionButton.pr_setImageColor(color)
        }
    }
    
    func setupRightAction(icon: Icon, color: UIColor = UIColor.black, fillColor: UIColor = UIColor.app.border) {
        if icon == .none {
            contentRightActionView.isHidden = true
        } else {
            contentRightActionView.isHidden = false
            
            contentRightActionFillView.backgroundColor = fillColor
            contentRightActionButton.setImage(getImage(fromIcon: icon), for: .normal)
            contentRightActionButton.pr_setImageColor(color)
        }
    }

    func setupTitle(_ title: String) {
        setupLogo(false)
        contentMainTitleLabel.text = title
    }
    
    
    // MARK: -
    // MARK: - Expand
    
    private func setupExpandUI() {
        expandContentView.backgroundColor = .clear
    }
    
    @objc private func animateVCView() {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.90,
                       initialSpringVelocity: 0.10,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.viewSrc.superview?.layoutIfNeeded()
                       }, completion: { (complete) in
                        self.displayHandler()
                       })
    }
    
    private var displayHandlerStateDefault = false
    private func displayHandler() {
        if self.viewSrc.pr_height < self.navigationBarHeight + 10 {
            /// - Trigger closure only once
            if !displayHandlerStateDefault {
                contentMainTitleLabel.pr_fadeIn()
                contentSeparatorView.pr_fadeIn()
                expandContentView.pr_fadeOut()
                fullBackgroundContentView.pr_fadeOut()
                
                onDefaultDisplayed?()
            }
            displayHandlerStateDefault = true
        } else {
            /// - Trigger closure only once
            if displayHandlerStateDefault {
                contentMainTitleLabel.pr_fadeOut()
                contentSeparatorView.pr_fadeOut()
                expandContentView.pr_fadeIn()
                if navigationBarFullBackground {
                    fullBackgroundContentView.pr_fadeIn()
                }
                
                onExpandDisplayed?()
            }
            displayHandlerStateDefault = false
        }
    }
    
    
    // MARK:
    // MARK: + Public
    public func displayDefaultBar() {
        viewSrc.pr_setConstraint([.height: navigationBarHeight])
        contentMainTitleLabel.pr_fadeIn()
        expandContentView.pr_fadeOut()
        contentSeparatorView.pr_fadeIn()
    }
    
    public func displayExpandBar() {
        viewSrc.pr_setConstraint([.height: navigationBarExpandHeight])
        contentMainTitleLabel.pr_fadeOut()
        expandContentView.pr_fadeIn()
        contentSeparatorView.pr_fadeOut()
    }
    
    public func updateExpandHeight(_ newHeight: CGFloat? = nil) {
        if let newHeight = newHeight {
            navigationBarExpandHeightBase = newHeight
        } else {
            navigationBarExpandHeightBase = expandContentView.pr_height
        }

        viewSrc.pr_setConstraint([.height: navigationBarHeight])
        //self.view.pr_setConstraint([.height: navigationBarHeight])
    }
    
    public func setupFullBackground() {
        navigationBarFullBackground = true
        fullBackgroundContentView.alpha = 1
    }
    
    
    // MARK:
    // MARK: + Scroll view delegate handlers
    private var navHeightBeginDrag:CGFloat      = 64
    private var lastTranslationY:CGFloat        = 0
    private var initScrollViewOffset:CGFloat    = 0
    
    /// to call in corresponding scroll view delegate methods
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       // GG.log.d("Scroll view wil begin dragging")
        /// - lastTranslationY = last position to know which vertical direction is the gesture (up / down)
        /// - navHeightBeginDrag = height of navBar when begin dragging
        navHeightBeginDrag = self.viewSrc.pr_height
        lastTranslationY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        initScrollViewOffset = scrollView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        //GG.log.d("Scroll view did end dragging")
        /// - Make sure that nav bar height is correctly display after interaction
        if scrollView.contentOffset.y <= 0 {
            if expandAuto {
                self.viewSrc.pr_setConstraint([.height: navigationBarExpandHeight])
                scrollView.setContentOffset(.zero, animated: false)
                animateVCView()
            } else {
                if self.viewSrc.pr_height > navigationBarExpandHeight {
                    self.viewSrc.pr_setConstraint([.height: navigationBarExpandHeight])
                    scrollView.setContentOffset(.zero, animated: false)
                    animateVCView()
                }
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translationY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let isGestureUp = translationY <= lastTranslationY ? true : false
        let gestureState = scrollView.panGestureRecognizer.state
        let threshold = (Pr.device.getScreenSize().height / 5) * 2
        /*
        var stateDb = ""
        switch gestureState {
            case .began:
                stateDb = "BEGAN"
            case .cancelled:
                stateDb = "CANCELLED"
            case .changed:
                stateDb = "CHANGED"
            case .ended:
                stateDb = "ENDED"
            case .failed:
                stateDb = "FAILED"
            case .possible:
                stateDb = "POSSIBLE"
            default:
                break
        }
        GG.log.d("Gesture State = \(stateDb)")
        // */
        
        if gestureState == .changed {
            if isGestureUp {
                //GG.log.d("^^^ Gesture UP")
                /// - Shrink navigation bar until it reach the default one
                if viewSrc.pr_height > navigationBarHeight {
                    var height = navHeightBeginDrag + (translationY - initScrollViewOffset)
                    if height < navigationBarHeight {
                        height = navigationBarHeight
                    }
                    
                    var dragHandler = true
                    if expandDragThreshold && height > threshold {
                        dragHandler = false
                    }
                    if dragHandler {
                        viewSrc.pr_setConstraint([.height: height])
                        scrollView.setContentOffset(.zero, animated: false)
                    }
                    
                }
                /// - When reach to default navigation bar height, let the scroll view do its thing normally
            } else {
                //GG.log.d("vvv Gesture DOWN")
                /// - If scroll view's content is at top, expand navigation bar
                if scrollView.contentOffset.y <= 0 {
                    let height = navHeightBeginDrag + (translationY - initScrollViewOffset)
                    
                    var dragHandler = true
                    if expandDragThreshold && height > threshold {
                        dragHandler = false
                    }
                    if dragHandler {
                        viewSrc.pr_setConstraint([.height: height])
                        scrollView.setContentOffset(.zero, animated: false)
                    }
                }
            }
        } else if gestureState == .possible {
            /// - Condition when gesture is released but it still animating (ex: flick gesture)
            if scrollView.contentOffset.y <= 0 {
                
                
                /// - isContentNotEnough is to know if content of scroll view needs to be display with reduce nav bar in case of few items *BUGGY*
                let isContentNotEnough = false
                //if scrollView.contentSize.height < scrollView.pr_height && scrollView.contentSize.height > scrollView.pr_height //- navigationBarExpandHeightBase {
                    //isContentNotEnough = true
                //}
                if isContentNotEnough {
                    //viewSrc.pr_setHeightConstraint(navigationBarHeight)
                } else {
                    viewSrc.pr_setConstraint([.height: navigationBarExpandHeight])
                    scrollView.setContentOffset(.zero, animated: false)
                    animateVCView()
                }
            }

            if isGestureUp {
                if scrollView.contentOffset.y > 0 && viewSrc.pr_height > navigationBarHeight {
                    viewSrc.pr_setConstraint([.height: navigationBarHeight])
                    animateVCView()
                }
            }
        }
        
        lastTranslationY = translationY
        displayHandler()
    }
}
