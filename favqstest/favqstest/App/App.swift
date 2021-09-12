//
//  App.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import Foundation

class App {
    // MARK: - Singleton
    static let shared = App()
    private init () {}
    
    var user: UserM? = nil
    
    func isLoginSessionExist() -> String? {
        if let _ = App.pref.get(forKey: .token) as? String,
           let login = App.pref.get(forKey: .login) as? String {
            return login
        }
        return nil
    }
    
    func saveSession(_ session: SessionM) {
        App.pref.save(forKey: .token, value: session.token)
        App.pref.save(forKey: .login, value: session.login)
    }
    
    func deleteSession() {
        App.pref.save(forKey: .token, value: nil)
        App.pref.save(forKey: .login, value: nil)
    }
}

extension App {
    struct pref {
        enum Key: String {
            case token = "PREF_SESSION_TOKEN"
            case login = "PREF_SESSION_LOGIN"
        }
        
        static func save(forKey: Key, value: Any?) {
            UserDefaults.standard.set(value, forKey: forKey.rawValue)
            UserDefaults.standard.synchronize()
        }
        
        static func get(forKey: Key) -> Any? {
            return UserDefaults.standard.object(forKey: forKey.rawValue)
        }
    }
}


