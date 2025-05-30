// FileDestination.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

// Previously, no logs were written for Linux platform. Until that's fixed, it's better to not expose `FileDestination`
// for Linux at all.
#if !os(Linux)
    import Foundation

    // swiftlint:disable:next type_body_length
    open class FileDestination: BaseDestination {
        public var fileHandle: FileHandle?
        public var logFileURL: URL?
        public var syncAfterEachWrite: Bool = false
        public var colored: Bool = false {
            didSet {
                if colored {
                    // bash font color, first value is intensity, second is color
                    // see http://bit.ly/1Otu3Zr & for syntax http://bit.ly/1Tp6Fw9
                    // uses the 256-color table from http://bit.ly/1W1qJuH
                    reset = "\u{001b}[0m"
                    escape = "\u{001b}[38;5;"
                    levelColor.verbose = "251m" // silver
                    levelColor.debug = "35m" // green
                    levelColor.info = "38m" // blue
                    levelColor.warning = "178m" // yellow
                    levelColor.error = "197m" // red
                } else {
                    reset = ""
                    escape = ""
                    levelColor.verbose = ""
                    levelColor.debug = ""
                    levelColor.info = ""
                    levelColor.warning = ""
                    levelColor.error = ""
                }
            }
        }

        // LOGFILE ROTATION
        // ho many bytes should a logfile have until it is rotated?
        // default is 5 MB. Just is used if logFileAmount > 1
        public var logFileMaxSize: Int
        // Number of log files used in rotation, default is 1 which deactivates file rotation
        public var logFileAmount: Int

        public enum Constants {
            public static let defaultLogFileAmount = 1
            public static let defaultLogFileMaxSize = (5 * 1024 * 1024) // 5 MB
        }

        let fileManager: FileManager

        public init(
            logFileURL: URL? = nil,
            logFileMaxSize: Int = Constants.defaultLogFileMaxSize,
            logFileAmount: Int = Constants.defaultLogFileAmount,
            fileManager: FileManager = .default
        ) {
            self.logFileAmount = logFileAmount
            self.logFileMaxSize = logFileMaxSize
            self.fileManager = fileManager
            if let logFileURL {
                self.logFileURL = logFileURL
                super.init()
                return
            }

            // platform-dependent logfile directory default
            var baseURL: URL?
            #if os(OSX)
                if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                    baseURL = url
                    // try to use ~/Library/Caches/APP NAME instead of ~/Library/Caches
                    if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable")
                        as? String
                    {
                        do {
                            if let appURL = baseURL?.appendingPathComponent(appName, isDirectory: true) {
                                try fileManager.createDirectory(
                                    at: appURL,
                                    withIntermediateDirectories: true,
                                    attributes: nil
                                )
                                baseURL = appURL
                            }
                        } catch {
                            Self.fallbackLog(
                                // swiftlint:disable:next line_length
                                "Could not create folder /Library/Caches/\(appName). Error: \(String(describing: error))"
                            )
                        }
                    }
                }
            #else
                // iOS, watchOS, etc. are using the caches directory
                if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                    baseURL = url
                }
            #endif

            if let baseURL {
                self.logFileURL = baseURL.appendingPathComponent("swiftybeaver.log", isDirectory: false)
            }
            super.init()
        }

        // append to file. uses full base class functionality
        override open func send(
            _ level: SwiftyBeaver.Level,
            msg: String,
            thread: String,
            file: String,
            function: String,
            line: UInt,
            context: Any? = nil
        ) -> String? {
            let formattedString = super.send(
                level,
                msg: msg,
                thread: thread,
                file: file,
                function: function,
                line: line,
                context: context
            )

            guard let formattedString else {
                Self.fallbackLog("No formatted string was formed for message: \(msg)")
                return nil
            }
            guard validateSaveFile(str: formattedString) else {
                Self.fallbackLog("Could not validate or write to file with formatted string: \(formattedString)")
                return formattedString
            }
            return formattedString
        }

        // allows customization of initializing FileHandle
        open func fileHandle(forWritingTo url: URL) throws -> FileHandle {
            try FileHandle(forWritingTo: url)
        }

        // check if filesize is bigger than wanted and if yes then rotate them
        func validateSaveFile(str: String) -> Bool {
            if logFileAmount > 1 {
                guard let url = logFileURL else { return false }
                let filePath = url._path()
                if fileManager.fileExists(atPath: filePath) == true {
                    do {
                        // Get file size
                        let attr = try fileManager.attributesOfItem(atPath: filePath)
                        // swiftlint:disable:next force_cast
                        let fileSize = attr[FileAttributeKey.size] as! UInt64
                        // Do file rotation
                        if fileSize > logFileMaxSize {
                            rotateFile(url)
                        }
                    } catch {
                        Self.fallbackLog("Could not check file size. Error: \(String(describing: error))")
                    }
                }
            }
            return saveToFile(str: str)
        }

        private func rotateFile(_ fileUrl: URL) {
            let filePath = fileUrl._path()
            let lastIndex = (logFileAmount - 1)
            let firstIndex = 1
            do {
                for index in stride(from: lastIndex, through: firstIndex, by: -1) {
                    let oldFile = makeRotatedFileUrl(fileUrl, index: index)._path()

                    if fileManager.fileExists(atPath: oldFile) {
                        if index == lastIndex {
                            // Delete the last file
                            try fileManager.removeItem(atPath: oldFile)
                        } else {
                            // Move the current file to next index
                            let newFile = makeRotatedFileUrl(fileUrl, index: index + 1)._path()
                            try fileManager.moveItem(atPath: oldFile, toPath: newFile)
                        }
                    }
                }

                // Finally, move the current file
                let newFile = makeRotatedFileUrl(fileUrl, index: firstIndex)._path()
                try fileHandle?._close()
                fileHandle = nil
                try fileManager.moveItem(atPath: filePath, toPath: newFile)
            } catch {
                Self.fallbackLog("Could not rotate file. Error: \(String(describing: error))")
            }
        }

        /// Get all available log files limited to the current maximum ``logFileAmount``, sorted increasing by the
        /// integer postfix.
        public func allFileUrls(fileUrl: URL) -> [URL] {
            var urls = [URL]()
            if fileManager.fileExists(atPath: fileUrl._path()) {
                urls.append(fileUrl)
            }
            if logFileAmount > 1 {
                urls += (1 ... logFileAmount - 1).compactMap { index in
                    let url = makeRotatedFileUrl(fileUrl, index: index)
                    if fileManager.fileExists(atPath: url._path()) {
                        return url
                    } else {
                        return nil
                    }
                }
            }
            return urls
        }

        private func makeRotatedFileUrl(_ fileUrl: URL, index: Int) -> URL {
            // The index is appended to the file name, to preserve the original extension.
            fileUrl.deletingPathExtension()
                .appendingPathExtension("\(index).\(fileUrl.pathExtension)")
        }

        /// appends a string as line to a file.
        /// returns boolean about success
        @_spi(Testable)
        open func saveToFile(str: String) -> Bool {
            guard let url = logFileURL else {
                Self.fallbackLog("No file URL found to save to.")
                return false
            }

            let line = str + "\n"
            guard let data = line.data(using: String.Encoding.utf8) else { return false }

            return write(data: data, to: url)
        }

        private func write(data: Data, to url: URL) -> Bool {
            var success = false
            let coordinator = NSFileCoordinator(filePresenter: nil)
            var error: NSError?
            coordinator.coordinate(writingItemAt: url, error: &error) { url in
                do {
                    if fileManager.fileExists(atPath: url._path()) == false {
                        let directoryURL = url.deletingLastPathComponent()
                        if fileManager.fileExists(atPath: directoryURL._path()) == false {
                            try fileManager.createDirectory(
                                at: directoryURL,
                                withIntermediateDirectories: true
                            )
                        }
                        let urlPath = url._path()
                        guard !urlPath.isEmpty else {
                            Self.fallbackLog("Could not write to file because URL path is empty.")
                            return
                        }
                        if !fileManager.createFile(atPath: urlPath, contents: nil) {
                            Self.fallbackLog("Could not create file at path: \(urlPath)")
                            return
                        }

                        #if os(iOS) || os(watchOS)
                            if #available(iOS 10.0, watchOS 3.0, *) {
                                var attributes = try fileManager.attributesOfItem(atPath: urlPath)
                                attributes[FileAttributeKey.protectionKey] = FileProtectionType.none
                                try fileManager.setAttributes(attributes, ofItemAtPath: urlPath)
                            }
                        #endif
                    }

                    let fileHandle = try getOrCreateFileHandle(url: url)

                    try fileHandle._write(contentsOf: data)
                    if syncAfterEachWrite {
                        try fileHandle._synchronize()
                    }
                    success = true
                } catch {
                    Self.fallbackLog("Could not write to file \(url). Error: \(String(describing: error))")
                }
            }

            if let error {
                Self.fallbackLog("Failed writing file with error: \(String(describing: error))")
                return false
            }

            return success
        }

        private func getOrCreateFileHandle(url: URL) throws -> FileHandle {
            if let fileHandle {
                return fileHandle
            } else {
                let fileHandle = try fileHandle(forWritingTo: url)
                try fileHandle._seekToEnd()
                self.fileHandle = fileHandle
                return fileHandle
            }
        }

        /// deletes log file.
        /// returns true if file was removed or does not exist, false otherwise
        public func deleteLogFile() -> Bool {
            guard let url = logFileURL, fileManager.fileExists(atPath: url._path()) == true else {
                return true
            }
            do {
                try fileManager.removeItem(at: url)
                return true
            } catch {
                Self.fallbackLog("Could not remove file \(url). Error: \(String(describing: error))")
                return false
            }
        }

        deinit {
            do {
                try fileHandle?._close()
            } catch {
                Self.fallbackLog("Failed to close file handle in deinit. Error: \(String(describing: error))")
            }
        }
    }

    extension FileHandle {
        fileprivate func _close() throws {
            if #available(iOS 13, macCatalyst 13.1, macOS 10.15, tvOS 13, visionOS 1, watchOS 6, *) {
                try close()
            } else {
                closeFile()
            }
        }

        fileprivate func _seekToEnd() throws {
            if #available(iOS 13.4, macCatalyst 13.4, macOS 10.15.4, tvOS 13.4, visionOS 1, watchOS 6.2, *) {
                try seekToEnd()
            } else {
                seekToEndOfFile()
            }
        }

        fileprivate func _synchronize() throws {
            if #available(iOS 13, macCatalyst 13.1, macOS 10.15, tvOS 13, visionOS 1, watchOS 6, *) {
                try synchronize()
            } else {
                synchronizeFile()
            }
        }

        fileprivate func _write(contentsOf data: Data) throws {
            if #available(iOS 13.4, watchOS 6.2, tvOS 13.4, macOS 10.15.4, *) {
                try write(contentsOf: data)
            } else {
                write(data)
            }
        }
    }

    extension URL {
        fileprivate func _path() -> String {
            if #available(
                iOS 16,
                macCatalyst 16,
                macOS 13,
                tvOS 16,
                visionOS 1,
                watchOS 9,
                *
            ) {
                path(percentEncoded: false)
            } else {
                path
            }
        }
    }
#endif
