//
//  ServiceManager.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import Alamofire
import SwiftyJSON

class ServiceManager {
    // MARK: - Singleton
    static let shared = ServiceManager()
    private init () {}
    
    // MARK: - Call
    let baseURL = "https://favqs.com/api/"
    let apiKey = "4c6e073d6556986f683c4a7d76795c3a"
    
    func call(_ route: String, data: [String: Any]? = nil, method: HTTPMethod, done: @escaping ((_ JSON: JSON?, _ error: Pr.error?) -> Void), showDebug: Bool = false) {
        let requestURL = "\(baseURL)\(route)"
        
        if showDebug {
            var dataStr = "nil"
            if let data = data {
                dataStr = "\n\(data)"
            }
            Pr.log.v("""
                
                    📬 URL : \(requestURL)
                    Data : \(dataStr)
                
                """)
        }
        
        var headers: HTTPHeaders? = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\"\(apiKey)\""
        ]
        if let token = App.pref.get(forKey: .token) as? String {
            headers?.add(name: "User-Token", value: token)
        }
        
        AF.request(requestURL,
                   method: method,
                   parameters: data,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseString { response in
                var statusCode = -1
                if let statusCodeResponse = response.response?.statusCode {
                    statusCode = statusCodeResponse
                }
                
                let debug = """
                                
                                Status : \(statusCode) - Request : \(requestURL)
                            
                            """
                Pr.log.v(debug)
                
                if showDebug {
                    let body = """
                            
                                Body response for request : \(requestURL)
                                \(response.value ?? "[NO BODY]")
                            
                            """
                    Pr.log.d(body)
                }
                
                
                switch statusCode {
                    case 200:
                        if let data = response.value, !data.isEmpty {
                            do {
                                let jsonData = data.data(using: .utf8)!
                                let json = try JSON(data: jsonData)
                                done(json, nil)
                            } catch(let error) {
                                Pr.log.e("Can't parse body request to JSON")
                                done(nil, Pr.error.handle(error))
                            }
                        } else {
                            done(nil, nil)
                        }
                    default:
                        Pr.log.e("Alamofire request failed")
                        done(nil, Pr.error())
                }
            }
    }
    
    
    // MARK: - Utils
    func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        /// Apple Date class will automatically format from device's Locale
        /// specify the locale to ensure a specific format to send
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    
    func getDateString(_ date: Date?) -> String? {
        if let date = date {
            return ServiceManager.shared.getDateFormatter().string(from: date)
        }
        return nil
    }
    
    func getDate(fromString: String) -> Date? {
        let serverFormatter = ServiceManager.shared.getDateFormatter()
        return serverFormatter.date(from: fromString)
    }
}

