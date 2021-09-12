import UIKit
import SnapKit

class AppButton: UIButton {
    private enum Style {
        case style1
        case style1Border
        case style1Custom
        case style2
    }
    var buttonHeight: CGFloat = 44
    private var selectedStyle:Style = .style1
    
    // MARK: - Init & override
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() { super.init(frame: .zero) }
    init(inView: UIView) {
        super.init(frame: .zero)
        inView.addSubview(self)
    }
    
    override func refreshLayout() {
        switch selectedStyle {
            case .style1, .style1Custom:
                self.clipsToBounds = true
                self.layer.cornerRadius = self.pr_height / 2
                break
            default:
                break
        }
    }
    
    
    // MARK: - Public
    func remakeConstraints(_ closure: ((_ make: ConstraintMaker) -> Void)) {
        self.snp.removeConstraints()
        self.snp.makeConstraints({ make in
            make.height.equalTo(buttonHeight)
            closure(make)
        })
    }
    
    func style1(text: String, icon: UIImage? = nil) {
        selectedStyle = .style1
        
        style1Custom(
            text        : text,
            textColor   : UIColor.app.textButton02,
            icon        : icon,
            bgColor     : UIColor.app.main)
    }
    
    func style1Border(text: String, icon: UIImage? = nil) {
        selectedStyle = .style1Border
        
        style1Custom(
            text        : text,
            textColor   : UIColor.app.main,
            icon        : icon,
            bgColor     : UIColor.app.mainAccent,
            borderWidth : 2,
            borderColor : UIColor.app.main)
    }
    
    func style1Custom(text: String, textColor: UIColor, icon: UIImage?, bgColor: UIColor, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.app.border) {
        selectedStyle = .style1Custom
        
        setupHeight(44)
        self.layer.cornerRadius = self.pr_height / 2
        pr_setBackgroundColor(bgColor, for: .normal)
        self.clipsToBounds = true
        
        
        self.setTitle(text.uppercased(), for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = UIFont.app.button1
        
        setupIcon(icon)
        setupBorder(width: borderWidth, color: borderColor)
    }
    
    func style2(text: String) {
        selectedStyle = .style2
        
        setupHeight(16)
        self.backgroundColor = .clear
        
        self.setTitle(text, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.setTitleColor(UIColor.app.main, for: .normal)
        self.titleLabel?.font = UIFont.app.caption2
        
        setupIcon(nil)
        setupBorder(width: 0)
    }
    
    // MARK: - Setup
    private func setupHeight(_ value:CGFloat) {
        buttonHeight = value
        self.snp.makeConstraints({ make in
            make.height.equalTo(value)
        })
    }
    
    private func setupIcon(_ image: UIImage?) {
        if let image = image {
            self.setImage(image, for: .normal)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
        } else {
            self.setImage(nil, for: .normal)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func setupBorder(width: CGFloat, color: UIColor = UIColor.app.border) {
        if width > 0 {
            self.layer.borderWidth = width
            self.layer.borderColor = color.cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
