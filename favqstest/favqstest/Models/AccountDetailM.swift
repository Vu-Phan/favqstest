//
//  AccountDetailM.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import SwiftyJSON

struct AccountDetailM {
    var email: String = ""
    var privateFavoritesCount: Int = 0
    var themeId: Int = 1
    var proExpirationDate: Date? = nil
    
    init() {}
    
    init(fromJSON JSON: JSON) {
        email = JSON["email"].stringValue
        privateFavoritesCount = JSON["private_favorites_count"].intValue
        themeId = JSON["active_theme_id"].intValue
        proExpirationDate = ServiceManager.shared.getDate(fromString: JSON["pro_expiration"].stringValue)
    }
}

