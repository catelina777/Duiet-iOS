//
//  Logger.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/09.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import os.log

extension OSLogType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .info:
            return "ℹ️(info)"
        case .debug:
            return "⛏(debug)"
        case .error:
            return "🚨(error)"
        case .fault:
            return "💣(fault)"
        default:
            return "DEFAULT"
        }
    }
}

final class Logger {
    static let shared = Logger()
    private static let log = OSLog(subsystem: "com.sentinel", category: "default")

    private init() {}

    func info(_ message: Any?,
              functionName: StaticString = #function,
              fileName: StaticString = #file,
              lineNumber: Int = #line) {
        logging(message,
                logType: .info,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    func debug(_ message: Any?,
               functionName: StaticString = #function,
               fileName: StaticString = #file,
               lineNumber: Int = #line) {
        logging(message,
                logType: .debug,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    func error(_ message: Any?,
               functionName: StaticString = #function,
               fileName: StaticString = #file,
               lineNumber: Int = #line) {
        logging(message,
                logType: .error,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    func fault(_ message: Any?,
               functionName: StaticString = #function,
               fileName: StaticString = #file,
               lineNumber: Int = #line) {
        logging(message,
                logType: .fault,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    func `default`(_ message: Any?,
                   functionName: StaticString = #function,
                   fileName: StaticString = #file,
                   lineNumber: Int = #line) {
        logging(message,
                logType: .default,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    private func logging(_ message: Any?,
                         logType: OSLogType,
                         functionName: StaticString,
                         fileName: StaticString,
                         lineNumber: Int) {
        let staticSelf = type(of: self)
        let log = staticSelf.log
        guard log.isEnabled(type: logType) else { return }
        guard
            let output = staticSelf.buildOutput(message,
                                                logType: logType,
                                                functionName: functionName,
                                                fileName: fileName,
                                                lineNumber: lineNumber)
        else { return }
        os_log("%@", log: log, type: logType, output)
    }

    static func buildOutput(_ message: Any?,
                            logType: OSLogType,
                            functionName: StaticString,
                            fileName: StaticString,
                            lineNumber: Int) -> String? {
        guard let message = message else { return nil }
        let fileName = (String(describing: fileName) as NSString).lastPathComponent
        return "[\(logType)] [\(threadName)] [\(fileName):\(lineNumber)] \(functionName) > \(message)"
    }

    private static var threadName: String {
        if Thread.isMainThread {
            return "main"
        }
        if let threadName = Thread.current.name, !threadName.isEmpty {
            return threadName
        }
        if let queueName = DispatchQueue.currentQueueLabel, !queueName.isEmpty {
            return queueName
        }
        return String(format: "[%p] ", Thread.current)
    }
}

extension DispatchQueue {
    static var currentQueueLabel: String? {
        String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
