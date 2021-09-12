//
//  UIView_Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 10/09/2021.
//

import UIKit
import SnapKit

extension UIView {
    convenience init(in viewContainer: UIView) {
        self.init()
        viewContainer.addSubview(self)
    }
    
    @objc public func refreshLayout() {
        
    }
    
    func snpEdges(_ edge: CGFloat? = nil) {
        self.snp.makeConstraints({ make in
            if let edge = edge {
                make.top.leading.equalTo(edge)
                make.bottom.trailing.equalTo(-edge)
            } else {
                make.edges.equalToSuperview()
            }
        })
    }
    
    func snpSetup(top: CGFloat, from: UIView? = nil, side: CGFloat, bottom: CGFloat? = nil, snp: ((_ make: ConstraintMaker) -> Void)? = nil) {
        self.snp.makeConstraints({ make in
            if let from = from {
                make.top.equalTo(from.snp.bottom).offset(top)
            } else {
                make.top.equalTo(top)
            }
            make.leading.equalTo(side)
            make.trailing.equalTo(-side)
            if let bottom = bottom {
                make.bottom.equalTo(bottom)
            }
            if let snp = snp {
                snp(make)
            }
        })
    }
}
