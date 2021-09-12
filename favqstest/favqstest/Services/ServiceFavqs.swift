//
//  ServiceFavqs.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import Alamofire
import SwiftyJSON

class ServiceFavqs {
    // MARK: - Singleton
    static let shared = ServiceFavqs()
    private init() {}
    
    // MARK: - Services
    func getSession(login: String, pwd: String, done: @escaping ((_ session: SessionM?) -> Void)) {
        let cleanLogin = login.pr_trim()
        
        let data: [String: Any] = [
            "user" : [
                "login" : cleanLogin,
                "password": pwd]
        ]
        ServiceManager.shared.call("session", data: data, method: .post, done: { (json, error) in
            if let json = json {
                var session: SessionM?
                
                if let _ = ErrorM.getError(fromJSON: json) {
                    
                } else {
                    session = SessionM.init(fromJSON: json)
                }
                
                done(session)
            }
        }, showDebug: true)
    }
    
    func logout() {
        ServiceManager.shared.call("session", data: nil, method: .delete, done: { (json, error) in
            if let _ = json {
                
            }
        }, showDebug: true)
    }
    
    func getUser(login: String, done: @escaping ((_ user: UserM?) -> Void)) {
        ServiceManager.shared.call("users/\(login)", data: nil, method: .get, done: { (json, error) in
            var user: UserM?
            
            if let json = json {
                user = UserM(fromJSON: json)
            }
            
            done(user)
        }, showDebug: true)
    }
}
