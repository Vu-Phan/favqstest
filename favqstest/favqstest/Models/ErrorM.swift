//
//  ErrorM.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import SwiftyJSON

struct ErrorM {
    var errorCode: Int = 0
    var message: String = ""
    
    init() {}
    
    init(fromJSON JSON: JSON) {
        errorCode = JSON["error_code"].intValue
        message = JSON["message"].stringValue
    }
    
    static func getError(fromJSON: JSON) -> ErrorM? {
        if let _ = fromJSON["error_code"].int {
            return ErrorM.init(fromJSON: fromJSON)
        }
        return nil
    }
}

