// FileDestinationTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

#if !os(Linux)
    import Foundation
    @_spi(Testable) import SwiftyBeaver
    import XCTest

    class FileDestinationTests: XCTestCase {
        func testFileIsWritten() {
            let log = SwiftyBeaver.Destinations()

            let path = "/tmp/testSBF.log"
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
                XCTAssertEqual(x, sqrt(Double(i)))
            }

            // was the file written and does it contain the lines?
            let fileLines = linesOfFile(path: path)
            XCTAssertNotNil(fileLines)
            guard let lines = fileLines else { return }
            XCTAssertEqual(lines.count, 5)
            XCTAssertEqual(lines[0], "VERBOSE: first line to log")
            XCTAssertEqual(lines[1], "DEBUG: second line to log")
            XCTAssertEqual(lines[2], "INFO: third line to log")
            XCTAssertEqual(lines[3], "WARNING: fourth line with context 123")
            XCTAssertEqual(lines[4], "")
        }

        func testFileIsWrittenToFolderWithSpaces() {
            let log = SwiftyBeaver.Destinations()

            let folder = "/tmp/folder with spaces"
            createFolder(path: folder)

            let path = folder + "/testSBF.log"
            deleteFile(path: path)

            // in conversion from path String to URL you need to replace " " with "%20"
            let pathReadyForURL = path.replacingOccurrences(of: " ", with: "%20")
            let fileURL = URL(string: "file://" + pathReadyForURL)
            XCTAssertNotNil(fileURL)
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
                XCTAssertEqual(x, sqrt(Double(i)))
            }

            // was the file written and does it contain the lines?
            let fileLines = linesOfFile(path: path)
            XCTAssertNotNil(fileLines)
            guard let lines = fileLines else { return }
            XCTAssertEqual(lines.count, 4)
            XCTAssertEqual(lines[0], "VERBOSE: first line to log")
            XCTAssertEqual(lines[1], "DEBUG: second line to log")
            XCTAssertEqual(lines[2], "INFO: third line to log")
            XCTAssertEqual(lines[3], "")
        }

        func testFileIsWrittenToDeletedFolder() {
            let log = SwiftyBeaver.Destinations()

            let path = "/tmp/\(UUID().uuidString)/testSBF.log"
            deleteFile(path: path)
            deleteFile(path: "/tmp/\(UUID().uuidString)/testSBF.log.1")

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
                XCTAssertEqual(x, sqrt(Double(i)))
            }

            // was the file written and does it contain the lines?
            let fileLines = linesOfFile(path: path)
            XCTAssertNotNil(fileLines)
            guard let lines = fileLines else { return }
            XCTAssertEqual(lines.count, 5)
            XCTAssertEqual(lines[0], "VERBOSE: first line to log") // is in first rotation file
            XCTAssertEqual(lines[1], "DEBUG: second line to log")
            XCTAssertEqual(lines[2], "INFO: third line to log")
            XCTAssertEqual(lines[3], "WARNING: fourth line with context 123")
            XCTAssertEqual(lines[4], "")
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
                let fileContent = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
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
    }

    #if canImport(Testing)
        import Testing

        @Suite
        struct _FileDestinationTests {
            @Test
            func fileIsWritten() {
                let log = SwiftyBeaver.Destinations()

                let path = "/tmp/testSBF.log"
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

                let path = "/tmp/\(UUID().uuidString)/testSBF.log"
                deleteFile(path: path)
                deleteFile(path: "/tmp/\(UUID().uuidString)/testSBF.log.1")

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
        }
    #endif
#endif
