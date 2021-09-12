import Foundation
// - Based on https://github.com/sauvikdolui/swiftlogger


/// Wrapping Swift.print() within DEBUG flag
///
/// - Note: *print()* might cause [security vulnerabilities](https://codifiedsecurity.com/mobile-app-security-testing-checklist-ios/)
///
/// - Parameter object: The object which is to be logged
///
func print(_ object: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.print(object)
    #endif
}

public extension Pr {
    class log {
        enum Level: Int {
            case verbose     = 0
            case debug         = 1
            case info         = 2
            case warning     = 3
            case error         = 4
            case severe     = 5
            
            var prefix: String {
                switch self {
                    case .verbose:
                        return "[💬]"
                    case .debug:
                        return "[➡️]"
                    case .info:
                        return "[ℹ️]"
                    case .warning:
                        return "[⚠️]"
                    case .error:
                        return "[❌]"
                    case .severe:
                        return "[💥]"
                }
            }
        }
        private static var isLoggingEnabled: Bool {
            #if DEBUG
            return true
            #else
            return false
            #endif
        }
        // - Attributs
        static var showLevel: Level = .verbose
        static var showFilename = true
        static var showLine = false
        static var showColumn = false
        static var showFuncName = true
        static var showDate = true
        static var dateFormat = "YY-MM-dd"
        static var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            return formatter
        }
        static var showTime = true
        static var timeFormat = "hh:mm:ss.SSS"
        static var timeFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = timeFormat
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            return formatter
        }
        
        
        // MARK: - Loging methods
        /// Print for logger if level is higher than attributs showLevel
        ///
        /// - Parameters:
        ///     - object: Object or message to be logged
        ///     - level: Level to be logged
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        private class func printHandler(_ object: Any, level: Level, filename: String, line: Int, column: Int, funcName: String) {
            if isLoggingEnabled && level.rawValue >= showLevel.rawValue {
                let date         = showDate ? "\(dateFormatter.string(from: Date())) " : ""
                let time         = showTime ? "\(timeFormatter.string(from: Date())) " : ""
                let levelPrefix = "\(level.prefix) "
                let filename     = showFilename ? "[\(sourceFileName(filePath: filename))] " : ""
                let line        = showLine ? "l:\(line) " : ""
                let column         = showColumn ? "c:\(column) " : ""
                let funcName     = showFuncName ? "\(funcName) " : ""
                
                print("\(date)\(time)\(levelPrefix)\(filename)\(line)\(column)\(funcName)>> \(object)")
            }
        }
        
        /// Simple debug log message for entering a function
        ///
        /// - Parameters:
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func entry(filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) -> Void {
            printHandler("ENTRY", level: .debug, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        /// Simple debug log message for exiting a function
        ///
        /// - Parameters:
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func exit(filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) -> Void {
            printHandler("EXIT", level: .debug, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        /// Logs messages verbosely on console with prefix [💬]
        ///
        /// - Parameters:
        ///     - object: Object or message to be logged
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            printHandler(object, level:.verbose, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        /// Logs debug messages on console with prefix [➡️]
        ///
        /// - Parameters:
        ///     - object: Object or message to be logged
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func d(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            printHandler(object, level:.debug, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        /// Logs info messages on console with prefix [🔍]
        ///
        /// - Parameters:
        ///     - object: Object or message to be logged
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func i(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            printHandler(object, level:.info, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        /// Logs warnings verbosely on console with prefix [⚠️]
        ///
        /// - Parameters:
        ///     - object: Object or message to be logged
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func w(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            printHandler(object, level:.warning, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        
        /// Logs error messages on console with prefix [❌]
        ///
        /// - Parameters:
        ///     - object: Object or message to be logged
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func e(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            printHandler(object, level:.error, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        /// Logs severe events on console with prefix [💥]
        ///
        /// - Parameters:
        ///     - object: Object or message to be logged
        ///     - filename: File name from where loggin to be done
        ///     - line: Line number in file from where the logging is done
        ///     - column: Column number of the log message
        ///     - funcName: Name of the function from where the logging is done
        class func s(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
            printHandler(object, level:.severe, filename: filename, line: line, column: column, funcName: funcName)
        }
        
        
        /// Extract the file name from the file path
        ///
        /// - Parameter filePath: Full file path in bundle
        /// - Returns: File Name with extension
        private class func sourceFileName(filePath: String) -> String {
            let components = filePath.components(separatedBy: "/")
            return components.isEmpty ? "" : components.last!
        }
    }
}
