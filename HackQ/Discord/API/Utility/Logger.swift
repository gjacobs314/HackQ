//
// Created by David Hedbor on 2/12/16.
// Copyright (c) 2016 NeoTron. All rights reserved.
//

import Foundation


open class Logger {
    open static var instance = Logger()

    public init() {}

    open func log(_ message: String, args: CVaListPointer = getVaList([])) {
        NSLogv(message, args)
    }

    fileprivate class func _shouldLogLevel(_ level: LoggingLevel) -> Bool {
        if !Registry.instance.debugEnabled && level == .Debug {
            return false
        }
        return true
    }

    fileprivate class func _logMessage(_ message: String, withLevel level: LoggingLevel, file: String, function: String, line: Int32) {
        if (!_shouldLogLevel(level)) {
            return
        }
        let nsfile = NSString(string: file)
        instance.log("| \(level.rawValue) \(nsfile.lastPathComponent):\(line) | \(message) (\(function))")
    }
}

public enum LoggingLevel : String{
    case Info = " INFO", Error = "ERROR", Debug = "DEBUG"
}

public func LOG_INFO(_ message: String, file: String = #file, function: String = #function, line: Int32 = #line ) {
    Logger._logMessage(message, withLevel: .Info, file: file, function: function, line: line)
}

public func LOG_ERROR(_ message: String, file: String = #file, function: String = #function, line: Int32 = #line) {
    Logger._logMessage(message, withLevel: .Error, file: file, function: function, line: line)
}

public func LOG_DEBUG(_ message: String, file: String = #file, function: String = #function, line: Int32 = #line ) {
    Logger._logMessage(message, withLevel: .Debug, file: file, function: function, line: line)
}
