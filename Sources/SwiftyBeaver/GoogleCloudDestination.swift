// GoogleCloudDestination.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation

public final class GoogleCloudDestination: BaseDestination {
    private let serviceName: String

    public init(serviceName: String) {
        self.serviceName = serviceName
        super.init()
    }

    override public var asynchronously: Bool {
        get {
            false
        }
        set {}
    }

    override public func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread _: String,
        file: String,
        function: String,
        line: UInt,
        context: Any? = nil
    ) -> String? {
        let reportLocation: [String: Any] = ["filePath": file, "lineNumber": line, "functionName": function]
        var gcpContext: [String: Any] = ["reportLocation": reportLocation]
        if let context = context as? [String: Any] {
            if let httpRequestContext = context["httpRequest"] as? [String: Any] {
                gcpContext["httpRequest"] = httpRequestContext
            }

            if let user = context["user"] as? String {
                gcpContext["user"] = user
            }
        }

        let gcpJSON: [String: Any] = [
            "serviceContext": [
                "service": serviceName,
            ],
            "message": msg,
            "severity": level.severity,
            "context": gcpContext,
        ]

        let finalLogString: String

        do {
            finalLogString = try jsonString(obj: gcpJSON)
        } catch {
            let uncrashableLogString = "{\"context\":{\"reportLocation\":{\"filePath\": \"\(file)\"" +
                ",\"functionName\":\"\(function)\"" +
                ",\"lineNumber\":\(line)},\"severity\"" +
                ":\"CRITICAL\",\"message\":\"Error encoding " +
                "JSON log entry. You may be losing log messages!\"}"
            finalLogString = uncrashableLogString.description
        }
        print(finalLogString)
        return finalLogString
    }

    private func jsonString(obj: [String: Any]) throws -> String {
        let json = try JSONSerialization.data(withJSONObject: obj, options: [])
        guard let string = String(data: json, encoding: .utf8) else {
            throw GCPError.serialization
        }
        return string
    }
}

///
/// https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry#LogSeverity
extension SwiftyBeaver.Level {
    /// Verbose is reported as Debug to GCP.
    /// Recommend you don't bother using it.
    var severity: String {
        switch self {
        // There is only one level below "Debug": "Default", which becomes "Any" and is considered as a potential error
        // as well
        case .verbose: "DEBUG"
        case .debug: "DEBUG"
        case .info: "INFO"
        case .warning: "WARNING"
        case .error: "ERROR"
        case .critical: "CRITICAL"
        case .fault: "FAULT"
        }
    }
}

private enum GCPError: Error {
    case serialization
}
