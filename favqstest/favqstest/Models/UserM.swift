//
//  UserM.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import SwiftyJSON

struct UserM {
    var login: String = ""
    var pictureUrl: String = ""
    var publicFavoritesCount: Int = 0
    var followers: Int = 0
    var following: Int = 0
    var isPro: Bool = false
    var accountDetails: AccountDetailM? = nil
    
    init() {}
    
    init(fromJSON JSON: JSON) {
        login = JSON["login"].stringValue
        pictureUrl = JSON["pic_url"].stringValue
        publicFavoritesCount = JSON["public_favorites_count"].intValue
        followers = JSON["followers"].intValue
        following = JSON["following"].intValue
        isPro = JSON["pro"].boolValue
        accountDetails = AccountDetailM.init(fromJSON: JSON["account_details"])
    }
}

