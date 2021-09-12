//
//  FavQuoteItemView.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import UIKit

class FavQuoteItemView: UIView {
    var view: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    // MARK: + View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        initXib()
        setupUI()
    }
    
    init(inView: UIView) {
        super.init(frame: inView.pr_frameSize())
        initXib()
        inView.addSubview(self)
        setupUI()
    }
    
    private func initXib() {
        view = FavQuoteItemView.pr_nibView(forOwner: self)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        view.frame = bounds
    }
    
    
    // MARK: - Public
    func setup(fromQuote quote: QuoteM) {
        quoteLabel.text = "\"\(quote.body)\""
        authorLabel.text = "- \(quote.author)"
        
        let favIcon = UIImage.systemImage("heart.fill", size: 8, color: UIColor.red)
        let favoriteAttr = NSAttributedString.pr_setupImageWithText([
            favIcon,
            " \(quote.favoriteCount)"
        ])
        favoriteLabel.attributedText = favoriteAttr
        
        let upvoteIcon = UIImage.systemImage("arrow.up", size: 8, color: UIColor.app.text)
        let downvoteIcon = UIImage.systemImage("arrow.down", size: 8, color: UIColor.app.text)
        let voteAttr = NSAttributedString.pr_setupImageWithText([
            upvoteIcon,
            "\(quote.upvotesCount) / ",
            downvoteIcon,
            "\(quote.downvotesCount)",
        ])
        voteLabel.attributedText = voteAttr
        
        var tags = ""
        quote.tags.forEach({
            tags += "#\($0) "
        })
        tagsLabel.text = tags
    }
    
    
    // MARK: - UI
    private func setupUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 16.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.app.border.cgColor
        
        quoteLabel.pr_setup(font: UIFont.app.headline2, color: UIColor.app.text, lines: 0)
        authorLabel.pr_setup(font: UIFont.app.body2, color: UIColor.app.main)
        separatorView.backgroundColor = UIColor.app.border
        favoriteLabel.pr_setup(font: UIFont.app.caption1, color: UIColor.app.text03)
        voteLabel.pr_setup(font: UIFont.app.caption1, color: UIColor.app.text03)
        tagsLabel.pr_setup(font: UIFont.app.caption1, color: UIColor.app.text03)
    }
}

