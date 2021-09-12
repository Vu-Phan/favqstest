//
//  MainFavQuoteTVCell.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import UIKit

class MainFavQuoteTVCell: UITableViewCell {
    var itemView: FavQuoteItemView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        itemView = FavQuoteItemView.init(inView: self.contentView)
        itemView.snpSetup(top: 4, side: 24, bottom: -4)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemView.refreshLayout()
    }
    
    func setup(fromQuote: QuoteM) {
        itemView.setup(fromQuote: fromQuote)
    }
}

