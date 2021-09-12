import UIKit

class AppSeparatorView: UIView {
    enum Position {
        case top
        case bottom
        case middleTop
        case middleBottom
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.app.separator
    }
    
    init(inView: UIView) {
        super.init(frame: .zero)
        inView.addSubview(self)
        
        self.backgroundColor = UIColor.app.separator
    }
    
    init(_ position: Position, inView: UIView) {
        super.init(frame: .zero)
        inView.addSubview(self)
        
        self.backgroundColor = UIColor.app.separator
        self.snp.makeConstraints({make in
            make.height.equalTo(1)
            switch position {
                case .top:
                    make.top.equalTo(0)
                    make.leading.trailing.equalTo(0)
                    break
                case.bottom:
                    make.bottom.equalTo(0)
                    make.leading.trailing.equalTo(0)
                    break
                case.middleTop:
                    make.trailing.equalTo(0)
                    make.top.equalTo(0)
                    make.leading.equalTo(56)
                    break
                case.middleBottom:
                    make.trailing.equalTo(0)
                    make.bottom.equalTo(0)
                    make.leading.equalTo(56)
                    break
            }
        })
    }
}

