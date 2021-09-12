//
//  SessionM.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import SwiftyJSON

struct SessionM {
    var token: String = ""
    var login: String = ""
    var email: String = ""
    
    init() {}
    
    init(fromJSON JSON: JSON) {
        token = JSON["User-Token"].stringValue
        login = JSON["login"].stringValue
        email = JSON["email"].stringValue
    }
}

