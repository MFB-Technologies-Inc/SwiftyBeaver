// FileDestinationTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

#if !os(Linux)
    import Foundation
    @_spi(Testable) import SwiftyBeaver
    import Testing

    @Suite
    struct FileDestinationTests {
        @Test
        func fileIsWritten() {
            let log = SwiftyBeaver.Destinations()

            let path = "/tmp/\(functionName())_testSBF.log"
            deleteFile(path: path)

            // add file
            let file = FileDestination()
            file.logFileURL = URL(string: "file://" + path)!
            file.format = "$L: $M $X"
            _ = log.addDestination(file)

            log.verbose("first line to log")
            log.debug("second line to log")
            log.info("third line to log")
            log.warning("fourth line with context", context: 123)
            _ = log.flush(secondTimeout: 3)

            // wait a bit until the logs are written to file
            for i in 1 ... 100_000 {
                let x = sqrt(Double(i))
                #expect(x == sqrt(Double(i)))
            }

            // was the file written and does it contain the lines?
            let fileLines = linesOfFile(path: path)
            #expect(fileLines != nil)
            guard let lines = fileLines else { return }
            #expect(lines.count == 5)
            #expect(lines[0] == "VERBOSE: first line to log")
            #expect(lines[1] == "DEBUG: second line to log")
            #expect(lines[2] == "INFO: third line to log")
            #expect(lines[3] == "WARNING: fourth line with context 123")
            #expect(lines[4] == "")
        }

        @Test
        func fileIsWrittenToFolderWithSpaces() {
            let log = SwiftyBeaver.Destinations()

            let folder = "/tmp/folder with spaces"
            createFolder(path: folder)

            let path = folder + "/testSBF.log"
            deleteFile(path: path)

            // in conversion from path String to URL you need to replace " " with "%20"
            let pathReadyForURL = path.replacingOccurrences(of: " ", with: "%20")
            let fileURL = URL(string: "file://" + pathReadyForURL)
            #expect(fileURL != nil)
            guard let url = fileURL else { return }

            // add file
            let file = FileDestination()
            file.logFileURL = url
            file.format = "$L: $M"
            _ = log.addDestination(file)

            log.verbose("first line to log")
            log.debug("second line to log")
            log.info("third line to log")
            _ = log.flush(secondTimeout: 3)

            // wait a bit until the logs are written to file
            for i in 1 ... 100_000 {
                let x = sqrt(Double(i))
                #expect(x == sqrt(Double(i)))
            }

            // was the file written and does it contain the lines?
            let fileLines = linesOfFile(path: path)
            #expect(fileLines != nil)
            guard let lines = fileLines else { return }
            #expect(lines.count == 4)
            #expect(lines[0] == "VERBOSE: first line to log")
            #expect(lines[1] == "DEBUG: second line to log")
            #expect(lines[2] == "INFO: third line to log")
            #expect(lines[3] == "")
        }

        @Test
        func fileIsWrittenToDeletedFolder() {
            let log = SwiftyBeaver.Destinations()

            let path = "/tmp/\(functionName())/testSBF.log"
            deleteFile(path: path)
            deleteFile(path: "/tmp/\(functionName())/testSBF.log.1")

            // add file
            let file = FileDestination()
            file.logFileURL = URL(string: "file://" + path)!
            file.format = "$L: $M $X"
            // active logfile rotation
            file.logFileAmount = 2
            file.logFileMaxSize = 1000
            _ = log.addDestination(file)

            log.verbose("first line to log")
            log.debug("second line to log")
            log.info("third line to log")
            log.warning("fourth line with context", context: 123)
            _ = log.flush(secondTimeout: 3)

            // wait a bit until the logs are written to file
            for i in 1 ... 100_000 {
                let x = sqrt(Double(i))
                #expect(x == sqrt(Double(i)))
            }

            // was the file written and does it contain the lines?
            let fileLines = linesOfFile(path: path)
            #expect(fileLines != nil)
            guard let lines = fileLines else { return }
            #expect(lines.count == 5)
            #expect(lines[0] == "VERBOSE: first line to log") // is in first rotation file
            #expect(lines[1] == "DEBUG: second line to log")
            #expect(lines[2] == "INFO: third line to log")
            #expect(lines[3] == "WARNING: fourth line with context 123")
            #expect(lines[4] == "")
        }

        @Test
        func allFileUrls() throws {
            let path = "/tmp/\(functionName())_testSBF.log"
            let path1 = "/tmp/\(functionName())_testSBF.1.log"
            let path2 = "/tmp/\(functionName())_testSBF.2.log"
            let path3 = "/tmp/\(functionName())_testSBF.3.log"
            let path4 = "/tmp/\(functionName())_testSBF.4.log"
            let path5 = "/tmp/\(functionName())_testSBF.5.log"

            deleteFile(path: path)
            deleteFile(path: path1)
            deleteFile(path: path2)
            deleteFile(path: path3)
            deleteFile(path: path4)
            deleteFile(path: path5)

            FileManager.default.createFile(atPath: path, contents: Data("0".utf8))
            FileManager.default.createFile(atPath: path1, contents: Data("1".utf8))
            FileManager.default.createFile(atPath: path2, contents: Data("2".utf8))
            FileManager.default.createFile(atPath: path3, contents: Data("3".utf8))
            FileManager.default.createFile(atPath: path4, contents: Data("4".utf8))
            FileManager.default.createFile(atPath: path5, contents: Data("5".utf8))

            let url = try #require(URL(string: path))

            // add file
            let file = FileDestination()
            file.logFileAmount = 5
            file.logFileURL = url

            let fileUrls = file.allFileUrls(fileUrl: url)
            #expect(fileUrls.map(\.absoluteString) == [
                path,
                path1,
                path2,
                path3,
                path4,
            ])
        }

        @Test
        func allFileUrls_OneFile() throws {
            let path = "/tmp/\(functionName())_testSBF.log"

            deleteFile(path: path)

            FileManager.default.createFile(atPath: path, contents: Data("0".utf8))

            let url = try #require(URL(string: path))

            // add file
            let file = FileDestination()
            file.logFileAmount = 1
            file.logFileURL = url

            let fileUrls = file.allFileUrls(fileUrl: url)
            #expect(fileUrls.map(\.absoluteString) == [path])
        }

        @Test
        func allFileUrls_ZeroFiles() throws {
            let path = "/tmp/\(functionName())_testSBF.log"

            deleteFile(path: path)

            let url = try #require(URL(string: path))

            // add file
            let file = FileDestination()
            file.logFileAmount = 1
            file.logFileURL = url

            let fileUrls = file.allFileUrls(fileUrl: url)
            #expect(fileUrls.isEmpty)
        }

        // MARK: Helper Functions

        // deletes a file if it is existing
        func deleteFile(path: String) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {}
        }

        // returns the lines of a file as optional array which is nil on error
        func linesOfFile(path: String) -> [String]? {
            do {
                // try to read file
                let fileContent = try NSString(
                    contentsOfFile: path, encoding: String.Encoding.utf8.rawValue
                )
                return fileContent.components(separatedBy: "\n")
            } catch {
                print(error)
                return nil
            }
        }

        // creates a folder if not already existing
        func createFolder(path: String) {
            do {
                try FileManager.default.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print("Unable to create directory")
            }
        }

        /// Removes the `()` from the function name for use in paths
        func functionName(function: String = #function) -> String {
            function.trimmingCharacters(in: ["(", ")"])
        }
    }
#endif
