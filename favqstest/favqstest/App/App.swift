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


