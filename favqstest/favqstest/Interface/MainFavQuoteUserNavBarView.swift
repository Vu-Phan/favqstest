//
//  MainFavQuoteUserNavBarView.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import UIKit
import Kingfisher

class MainFavQuoteUserNavBarView: UIView {
    var pictureImageView: UIImageView!
    var loginLabel: UILabel!
    var favoriteCountLabel: UILabel!
    
    
    // MARK: - View
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() { super.init(frame: .zero) }
    init(inView: UIView) {
        super.init(frame: .zero)
        inView.addSubview(self)
        self.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(0)
        })
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pictureImageView.clipsToBounds = true
        pictureImageView.layer.cornerRadius = 24
        pictureImageView.layer.borderWidth = 1.0
        pictureImageView.layer.borderColor = UIColor.app.border.cgColor
    }
    
    func initView() {
        let viewContainer = UIView(in: self)
        viewContainer.backgroundColor = UIColor.clear
        viewContainer.snpSetup(top: 0, side: 24, bottom: 0)
        
        pictureImageView = UIImageView(in: viewContainer)
        pictureImageView.backgroundColor = UIColor.app.border
        pictureImageView.contentMode = .scaleAspectFill
        
        pictureImageView.snp.makeConstraints({ make in
            make.top.leading.equalToSuperview()
            make.height.width.equalTo(48)
            make.bottom.equalTo(-24)
        })
        
    
        loginLabel = UILabel(in: viewContainer)
        loginLabel.pr_setup(font: UIFont.app.headline2, color: UIColor.app.main)
        loginLabel.text = ""
        loginLabel.snp.makeConstraints({ make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(pictureImageView.snp.trailing).offset(16)
            make.height.equalTo(24)
        })
        
        favoriteCountLabel = UILabel(in: viewContainer)
        favoriteCountLabel.pr_setup(font: UIFont.app.body1, color: UIColor.app.text)
        favoriteCountLabel.text = ""
        favoriteCountLabel.snp.makeConstraints({ make in
            make.top.equalTo(loginLabel.snp.bottom).offset(8)
            make.leading.equalTo(loginLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(pictureImageView.snp.bottom)
        })
    }
    
    // MARK: - Public
    func setup(pictureUrl: String, login: String, favoriteCount: Int) {
        pictureImageView.kf.setImage(with: URL(string: pictureUrl))
        
        loginLabel.text = login
        
        let favIcon = UIImage.systemImage("heart.fill", size: 12, color: UIColor.red)
        let favoriteAttr = NSAttributedString.pr_setupImageWithText([
            favIcon,
            " \(favoriteCount)"
        ])
        favoriteCountLabel.attributedText = favoriteAttr
    }
}
