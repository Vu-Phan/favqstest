//
//  PrError.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 18/08/2021.
//

import Foundation

public extension Pr {
    class error {
        var domain: String = "PRDomain"
        var code: Int = -1
        var log: String = ""
        var loc: String = ""
        var text: String = ""
        
        static func handle(_ error: Error?, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) -> Pr.error? {
            guard let error = error else {
                return nil
            }
            return Pr.error(error, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        init(code: Int = -1, log: String = "", loc: String = "", filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            self.code = code
            self.log = log
            self.loc = loc.isEmpty ? log : ""
            
            Pr.log.e("""
            
                ❌ PRError domain=\(domain) - code=\(code) - log=\(log)
                    loc=\(loc)
                    text=\(text)
            
            """, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        init(_ error: Error?, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            guard let error = error else {
                return
            }
            self.domain = error._domain
            self.code = error._code
            self.loc = error.localizedDescription
            
            //        handleFIRAuthError(error)
            //        handleGIDError(error)
            
            Pr.log.e("""
            
                ❌ \(error)
                ❌ PRError domain=\(domain) - code=\(code) - log=\(log)
                    loc=\(loc)
                    text=\(text)
            
            """, filename: filename, line: line, column: column, funcName: funcName)
        }
    }

}
