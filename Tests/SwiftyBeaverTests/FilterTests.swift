// FilterTests.swift
// SwiftyBeaver
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
@_spi(Testable) import SwiftyBeaver
import XCTest

class FilterTests: XCTestCase {
    //
    // Path filtering tests (identity)
    //
    func test_path_getTarget_isPathFilter() {
        let filter = Filters.path.startsWith("/some/path")
        let isCorrectTargetType: Bool = switch filter.getTarget() {
        case .path:
            true

        default:
            false
        }
        XCTAssertTrue(isCorrectTargetType)
    }

    //
    // Path filtering tests (isRequired)
    //
    func test_path_startsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.startsWith("/some/path", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_path_containsAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.contains("/some/path", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_path_excludesAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.excludes("/some/path", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_path_endsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.endsWith("/some/path", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_path_equalsAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.equals("/some/path", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_path_startsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.startsWith("/some/path", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_path_containsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.contains("/some/path", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_path_excludesAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.excludes("/some/path", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_path_endsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.endsWith("/some/path", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_path_equalsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.equals("/some/path", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    //
    // Path filtering tests (case sensitivity)
    //
    func test_path_startsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.startsWith("/some/path", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_path_containsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.contains("/some/path", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_path_excludesAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.excludes("/some/path", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_path_endsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.endsWith("/some/path", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_path_equalsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.equals("/some/path", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_path_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.startsWith("/some/path", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_path_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.contains("/some/path", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_path_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.excludes("/some/path", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_path_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.endsWith("/some/path", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_path_equalsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.equals("/some/path", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    //
    // Path filtering tests (comparison testing)
    //
    func test_pathStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/first", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/First", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.startsWith("/First", caseSensitive: true)
        XCTAssertFalse(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/first", "/second", caseSensitive: true)
        XCTAssertTrue(filter.apply("/second/path/to/anywhere"))
    }

    func test_pathStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/First", "/Second", caseSensitive: false)
        XCTAssertTrue(filter.apply("/second/path/to/anywhere"))
    }

    func test_pathStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.startsWith("/First", "/Second", caseSensitive: true)
        XCTAssertFalse(filter.apply("/second/path/to/anywhere"))
    }

    func test_pathContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/path", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/Path", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.contains("/Path", caseSensitive: true)
        XCTAssertFalse(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/pathway", "/path", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/Pathway", "/Path", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.contains("/Pathway", "/Path", caseSensitive: true)
        XCTAssertFalse(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/path", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/epath/to/anywhere"))
    }

    func test_pathExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/Path", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/epath/to/anywhere"))
    }

    func test_pathExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.excludes("/Path", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/pathway", "/path", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/Pathway", "/Path", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.excludes("/Pathway", "/Path", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/anywhere", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/Anywhere", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.endsWith("/Anywhere", caseSensitive: true)
        XCTAssertFalse(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/nowhere", "/anywhere", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/Nowhere", "/Anywhere", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.endsWith("/Nowhere", "/Anywhere", caseSensitive: true)
        XCTAssertFalse(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/first/path/to/anywhere", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/First/path/to/Anywhere", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.equals("/First/path/to/Anywhere", caseSensitive: true)
        XCTAssertFalse(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/second/path/to/anywhere", "/first/path/to/anywhere", caseSensitive: true)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/Second/path/to/nowhere", "/First/Path/To/Anywhere", caseSensitive: false)
        XCTAssertTrue(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.equals("/Second/path/to/anywhere", "/First/path/to/Anywhere", caseSensitive: true)
        XCTAssertFalse(filter.apply("/first/path/to/anywhere"))
    }

    func test_pathCustomSimple_answersTrue() {
        let filter = Filters.path.custom { string in
            string == "/Second/path/to/anywhere"
        }
        XCTAssertTrue(filter.apply("/Second/path/to/anywhere"))
    }

    func test_pathCustomComplexMatches_answersFalse() {
        let filter = Filters.path.custom { string in
            let disallowedValues = ["/Second/path/to/anywhere"]
            let allowedValues = ["/First/path/to/anywhere"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        XCTAssertFalse(filter.apply("/Second/path/to/anywhere"))
    }

    func test_pathCustomComplexMatches_answersTrue() {
        let filter = Filters.path.custom { string in
            let disallowedValues = ["/Second/path/to/anywhere"]
            let allowedValues = ["/First/path/to/anywhere"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        XCTAssertTrue(filter.apply("/First/path/to/anywhere"))
    }

    //
    // Function filtering tests (identity)
    //
    func test_function_getTarget_isFunctionFilter() {
        let filter = Filters.function.startsWith("myFunc")
        let isCorrectTargetType: Bool = switch filter.getTarget() {
        case .function:
            true

        default:
            false
        }
        XCTAssertTrue(isCorrectTargetType)
    }

    //
    // Function filtering tests (isRequired)
    //
    func test_function_startsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.startsWith("myFunc", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_function_containsAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.contains("myFunc", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_function_excludesAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.excludes("myFunc", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_function_endsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.endsWith("myFunc", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_function_equalsAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.equals("myFunc", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_function_startsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.startsWith("myFunc", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_function_containsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.contains("myFunc", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_function_excludesAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.excludes("myFunc", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_function_endsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.endsWith("myFunc", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_function_equalsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.equals("myFunc", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    //
    // Function filtering tests (case sensitivity)
    //
    func test_function_startsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.startsWith("myFunc", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_function_containsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.contains("myFunc", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_function_excludesAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.excludes("myFunc", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_function_endsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.endsWith("myFunc", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_function_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.startsWith("myFunc", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_function_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.contains("myFunc", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_function_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.excludes("myFunc", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_function_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.endsWith("myFunc", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    //
    // Function filtering tests (comparison testing)
    //
    func test_functionStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("myFunc", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunction"))
    }

    func test_functionStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("MyFunc", caseSensitive: false)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.startsWith("MyFunc", caseSensitive: true)
        XCTAssertFalse(filter.apply("myFunc"))
    }

    func test_functionStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("yourFunc", "myFunc", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("YourFunc", "MyFunc", caseSensitive: false)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.startsWith("YourFunc", "MyFunc", caseSensitive: true)
        XCTAssertFalse(filter.apply("myFunc"))
    }

    func test_functionContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("Func", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("Func", caseSensitive: false)
        XCTAssertTrue(filter.apply("myfunc"))
    }

    func test_functionContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.contains("Func", caseSensitive: true)
        XCTAssertFalse(filter.apply("myfunc"))
    }

    func test_functionContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("doSomething", "Func", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("DoSomething", "func", caseSensitive: false)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.contains("DoSomething", "Func", caseSensitive: true)
        XCTAssertFalse(filter.apply("myfunc"))
    }

    func test_functionExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("Func", caseSensitive: true)
        XCTAssertFalse(filter.apply("myFunc"))
    }

    func test_functionExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("Func", caseSensitive: false)
        XCTAssertFalse(filter.apply("myfunc"))
    }

    func test_functionExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.excludes("Func", caseSensitive: true)
        XCTAssertTrue(filter.apply("myfunc"))
    }

    func test_functionExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("doSomething", "Func", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("DoSomething", "func", caseSensitive: false)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.excludes("DoSomething", "Func", caseSensitive: true)
        XCTAssertTrue(filter.apply("myfunc"))
    }

    func test_functionEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("Func", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("Func", caseSensitive: false)
        XCTAssertTrue(filter.apply("myfunc"))
    }

    func test_functionEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.endsWith("Func", caseSensitive: true)
        XCTAssertFalse(filter.apply("myfunc"))
    }

    func test_functionEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("doSomething", "Func", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("DoSomething", "Func", caseSensitive: false)
        XCTAssertTrue(filter.apply("myfunc"))
    }

    func test_functionEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.endsWith("DoSomething", "Func", caseSensitive: true)
        XCTAssertFalse(filter.apply("myfunc"))
    }

    func test_functionEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("myFunc", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("myFunc", caseSensitive: false)
        XCTAssertTrue(filter.apply("myfunc"))
    }

    func test_functionEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.equals("myFunc", caseSensitive: true)
        XCTAssertFalse(filter.apply("myfunc"))
    }

    func test_functionEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: true)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: false)
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: true)
        XCTAssertFalse(filter.apply("myfunc"))
    }

    func test_functionCustomSimple_answersTrue() {
        let filter = Filters.function.custom { string in
            string == "myfunc"
        }
        XCTAssertTrue(filter.apply("myfunc"))
    }

    func test_functionCustomComplexMatches_answersTrue() {
        let filter = Filters.function.custom { string in
            let disallowedValues = ["yourFunc", "yourOtherFunc"]
            let allowedValues = ["myFunc"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        XCTAssertTrue(filter.apply("myFunc"))
    }

    func test_functionCustomComplexMatches_answersFalse() {
        let filter = Filters.function.custom { string in
            let disallowedValues = ["yourFunc", "yourOtherFunc"]
            let allowedValues = ["myFunc"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        XCTAssertFalse(filter.apply("yourFunc"))
    }

    //
    // Message filtering tests (identity)
    //
    func test_message_getTarget_isMessageFilter() {
        let filter = Filters.message.startsWith("Hello there, SwiftyBeaver!")
        let isCorrectTargetType: Bool = switch filter.getTarget() {
        case .message:
            true

        default:
            false
        }
        XCTAssertTrue(isCorrectTargetType)
    }

    //
    // Message filtering tests (isRequired)
    //
    func test_message_startsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.startsWith("Hello", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_message_containsAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.contains("there", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_message_excludesAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.excludes("there", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_message_endsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.endsWith("SwifyBeaver!", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_message_equalsAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.equals("SwifyBeaver!", required: true)
        XCTAssertTrue(filter.isRequired())
    }

    func test_message_startsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.startsWith("Hello", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_message_containsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.contains("there", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_message_excludesAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.excludes("there", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_message_endsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    func test_message_equalsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.equals("SwiftyBeaver!", required: false)
        XCTAssertFalse(filter.isRequired())
    }

    //
    // Message filtering tests (case sensitivity)
    //
    func test_message_startsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.startsWith("Hello", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_message_containsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.contains("there", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_message_excludesAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.excludes("there", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_message_endsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_message_equalsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.equals("SwiftyBeaver!", caseSensitive: true)
        XCTAssertTrue(isCaseSensitive(filter.getTarget()))
    }

    func test_message_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.startsWith("Hello", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_message_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.contains("there", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_message_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.excludes("there", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_message_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    func test_message_equalsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.equals("SwiftyBeaver!", caseSensitive: false)
        XCTAssertFalse(isCaseSensitive(filter.getTarget()))
    }

    //
    // Function filtering tests (comparison testing)
    //
    func test_messageStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("Hello", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("hello", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.startsWith("hello", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("Goodbye", "Hello", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("goodbye", "hello", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.startsWith("goodbye", "hello", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("there", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("There", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.contains("There", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("their", "there", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("Their", "There", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.contains("Their", "There", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("there", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("There", caseSensitive: false)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.excludes("There", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("their", "there", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("Their", "There", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.excludes("Their", "There", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("swiftybeaver!", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.endsWith("swiftybeaver!", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("SluggishMink!", "SwiftyBeaver!", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("sluggishmink!", "swiftybeaver!", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.endsWith("sluggishmink!!", "swiftybeaver!", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals("Hello there, SwiftyBeaver!", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals("hello there, swiftybeaver!", caseSensitive: false)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.equals("hello there, swiftybeaver!", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals("Goodbye, SluggishMink!", "Hello there, SwiftyBeaver!", caseSensitive: true)
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals(
            "goodbye, sluggishmink!",
            "hello there, swiftybeaver!",
            caseSensitive: false
        )
        XCTAssertTrue(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.equals("goodbye, sluggishmink!", "hello there, swiftybeaver!", caseSensitive: true)
        XCTAssertFalse(filter.apply("Hello there, SwiftyBeaver!"))
    }

    func test_messageCustomSimple_answersTrue() {
        let filter = Filters.message.custom { string in
            string == "hello"
        }
        XCTAssertTrue(filter.apply("hello"))
    }

    func test_messageCustomComplexMatches_answersTrue() {
        let filter = Filters.message.custom { string in
            let disallowedValues = ["goodbye", "see you later"]
            let allowedValues = ["hello"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        XCTAssertTrue(filter.apply("hello"))
    }

    func test_messageCustomComplexMatches_answersFalse() {
        let filter = Filters.function.custom { string in
            let disallowedValues = ["goodbye", "see you later"]
            let allowedValues = ["hello"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        XCTAssertFalse(filter.apply("goodbye"))
    }

    // Helper functions
    private func isCaseSensitive(_ targetType: Filter.TargetType) -> Bool {
        let comparisonType: Filter.ComparisonType? = switch targetType {
        case let .path(type):
            type

        case let .function(type):
            type

        case let .message(type):
            type
        }

        guard let compareType = comparisonType else {
            return false
        }

        let isCaseSensitive: Bool = switch compareType {
        case let .contains(_, caseSensitive):
            caseSensitive

        case let .excludes(_, caseSensitive):
            caseSensitive

        case let .startsWith(_, caseSensitive):
            caseSensitive

        case let .endsWith(_, caseSensitive):
            caseSensitive

        case let .equals(_, caseSensitive):
            caseSensitive

        case .custom:
            false
        }

        return isCaseSensitive
    }
}

#if canImport(Testing)
    import Testing

    @Suite
    struct _FilterTests {
        //
        // Path filtering tests (identity)
        //
        @Test
        func _path_getTarget_isPathFilter() {
            let filter = Filters.path.startsWith("/some/path")
            let isCorrectTargetType: Bool =
                switch filter.getTarget() {
                case .path:
                    true

                default:
                    false
                }
            #expect(isCorrectTargetType)
        }

        //
        // Path filtering tests (isRequired)
        //
        @Test
        func _path_startsWithAndIsRequired_isRequiredFilter() {
            let filter = Filters.path.startsWith("/some/path", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _path_containsAndIsRequired_isRequiredFilter() {
            let filter = Filters.path.contains("/some/path", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _path_excludesAndIsRequired_isRequiredFilter() {
            let filter = Filters.path.excludes("/some/path", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _path_endsWithAndIsRequired_isRequiredFilter() {
            let filter = Filters.path.endsWith("/some/path", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _path_equalsAndIsRequired_isRequiredFilter() {
            let filter = Filters.path.equals("/some/path", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _path_startsWithAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.path.startsWith("/some/path", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _path_containsAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.path.contains("/some/path", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _path_excludesAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.path.excludes("/some/path", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _path_endsWithAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.path.endsWith("/some/path", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _path_equalsAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.path.equals("/some/path", required: false)
            #expect(!filter.isRequired())
        }

        //
        // Path filtering tests (case sensitivity)
        //
        @Test
        func _path_startsWithAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.path.startsWith("/some/path", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_containsAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.path.contains("/some/path", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_excludesAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.path.excludes("/some/path", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_endsWithAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.path.endsWith("/some/path", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_equalsAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.path.equals("/some/path", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.path.startsWith("/some/path", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.path.contains("/some/path", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.path.excludes("/some/path", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.path.endsWith("/some/path", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _path_equalsAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.path.equals("/some/path", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        //
        // Path filtering tests (comparison testing)
        //
        @Test
        func _pathStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.startsWith("/first", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.startsWith("/First", caseSensitive: false)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.startsWith("/First", caseSensitive: true)
            #expect(!filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.startsWith("/first", "/second", caseSensitive: true)
            #expect(filter.apply("/second/path/to/anywhere"))
        }

        @Test
        func _pathStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.startsWith("/First", "/Second", caseSensitive: false)
            #expect(filter.apply("/second/path/to/anywhere"))
        }

        @Test
        func _pathStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.startsWith("/First", "/Second", caseSensitive: true)
            #expect(!filter.apply("/second/path/to/anywhere"))
        }

        @Test
        func _pathContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.contains("/path", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.contains("/Path", caseSensitive: false)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.contains("/Path", caseSensitive: true)
            #expect(!filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.contains("/pathway", "/path", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.contains("/Pathway", "/Path", caseSensitive: false)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.contains("/Pathway", "/Path", caseSensitive: true)
            #expect(!filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.excludes("/path", caseSensitive: true)
            #expect(filter.apply("/first/epath/to/anywhere"))
        }

        @Test
        func _pathExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.excludes("/Path", caseSensitive: false)
            #expect(filter.apply("/first/epath/to/anywhere"))
        }

        @Test
        func _pathExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.excludes("/Path", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.excludes("/pathway", "/path", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.excludes("/Pathway", "/Path", caseSensitive: false)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.excludes("/Pathway", "/Path", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.endsWith("/anywhere", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.endsWith("/Anywhere", caseSensitive: false)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.endsWith("/Anywhere", caseSensitive: true)
            #expect(!filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.endsWith("/nowhere", "/anywhere", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.endsWith("/Nowhere", "/Anywhere", caseSensitive: false)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.endsWith("/Nowhere", "/Anywhere", caseSensitive: true)
            #expect(!filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.equals("/first/path/to/anywhere", caseSensitive: true)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.equals("/First/path/to/Anywhere", caseSensitive: false)
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.equals("/First/path/to/Anywhere", caseSensitive: true)
            #expect(!filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.equals(
                "/second/path/to/anywhere", "/first/path/to/anywhere", caseSensitive: true
            )
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.path.equals(
                "/Second/path/to/nowhere", "/First/Path/To/Anywhere", caseSensitive: false
            )
            #expect(filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.path.equals(
                "/Second/path/to/anywhere", "/First/path/to/Anywhere", caseSensitive: true
            )
            #expect(!filter.apply("/first/path/to/anywhere"))
        }

        @Test
        func _pathCustomSimple_answersTrue() {
            let filter = Filters.path.custom { string in
                string == "/Second/path/to/anywhere"
            }
            #expect(filter.apply("/Second/path/to/anywhere"))
        }

        @Test
        func _pathCustomComplexMatches_answersFalse() {
            let filter = Filters.path.custom { string in
                let disallowedValues = ["/Second/path/to/anywhere"]
                let allowedValues = ["/First/path/to/anywhere"]
                return !disallowedValues.contains(string) && allowedValues.contains(string)
            }
            #expect(!filter.apply("/Second/path/to/anywhere"))
        }

        @Test
        func _pathCustomComplexMatches_answersTrue() {
            let filter = Filters.path.custom { string in
                let disallowedValues = ["/Second/path/to/anywhere"]
                let allowedValues = ["/First/path/to/anywhere"]
                return !disallowedValues.contains(string) && allowedValues.contains(string)
            }
            #expect(filter.apply("/First/path/to/anywhere"))
        }

        //
        // Function filtering tests (identity)
        //
        @Test
        func _function_getTarget_isFunctionFilter() {
            let filter = Filters.function.startsWith("myFunc")
            let isCorrectTargetType: Bool =
                switch filter.getTarget() {
                case .function:
                    true

                default:
                    false
                }
            #expect(isCorrectTargetType)
        }

        //
        // Function filtering tests (isRequired)
        //
        @Test
        func _function_startsWithAndIsRequired_isRequiredFilter() {
            let filter = Filters.function.startsWith("myFunc", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _function_containsAndIsRequired_isRequiredFilter() {
            let filter = Filters.function.contains("myFunc", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _function_excludesAndIsRequired_isRequiredFilter() {
            let filter = Filters.function.excludes("myFunc", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _function_endsWithAndIsRequired_isRequiredFilter() {
            let filter = Filters.function.endsWith("myFunc", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _function_equalsAndIsRequired_isRequiredFilter() {
            let filter = Filters.function.equals("myFunc", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _function_startsWithAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.function.startsWith("myFunc", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _function_containsAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.function.contains("myFunc", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _function_excludesAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.function.excludes("myFunc", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _function_endsWithAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.function.endsWith("myFunc", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _function_equalsAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.function.equals("myFunc", required: false)
            #expect(!filter.isRequired())
        }

        //
        // Function filtering tests (case sensitivity)
        //
        @Test
        func _function_startsWithAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.function.startsWith("myFunc", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _function_containsAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.function.contains("myFunc", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _function_excludesAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.function.excludes("myFunc", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _function_endsWithAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.function.endsWith("myFunc", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _function_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.function.startsWith("myFunc", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _function_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.function.contains("myFunc", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _function_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.function.excludes("myFunc", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _function_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.function.endsWith("myFunc", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        //
        // Function filtering tests (comparison testing)
        //
        @Test
        func _functionStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.startsWith("myFunc", caseSensitive: true)
            #expect(filter.apply("myFunction"))
        }

        @Test
        func _functionStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.startsWith("MyFunc", caseSensitive: false)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.startsWith("MyFunc", caseSensitive: true)
            #expect(!filter.apply("myFunc"))
        }

        @Test
        func _functionStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.startsWith("yourFunc", "myFunc", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.startsWith("YourFunc", "MyFunc", caseSensitive: false)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.startsWith("YourFunc", "MyFunc", caseSensitive: true)
            #expect(!filter.apply("myFunc"))
        }

        @Test
        func _functionContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.contains("Func", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.contains("Func", caseSensitive: false)
            #expect(filter.apply("myfunc"))
        }

        @Test
        func _functionContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.contains("Func", caseSensitive: true)
            #expect(!filter.apply("myfunc"))
        }

        @Test
        func _functionContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.contains("doSomething", "Func", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.contains("DoSomething", "func", caseSensitive: false)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.contains("DoSomething", "Func", caseSensitive: true)
            #expect(!filter.apply("myfunc"))
        }

        @Test
        func _functionExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.excludes("Func", caseSensitive: true)
            #expect(!filter.apply("myFunc"))
        }

        @Test
        func _functionExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.excludes("Func", caseSensitive: false)
            #expect(!filter.apply("myfunc"))
        }

        @Test
        func _functionExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.excludes("Func", caseSensitive: true)
            #expect(filter.apply("myfunc"))
        }

        @Test
        func _functionExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.excludes("doSomething", "Func", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.excludes("DoSomething", "func", caseSensitive: false)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.excludes("DoSomething", "Func", caseSensitive: true)
            #expect(filter.apply("myfunc"))
        }

        @Test
        func _functionEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.endsWith("Func", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.endsWith("Func", caseSensitive: false)
            #expect(filter.apply("myfunc"))
        }

        @Test
        func _functionEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.endsWith("Func", caseSensitive: true)
            #expect(!filter.apply("myfunc"))
        }

        @Test
        func _functionEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.endsWith("doSomething", "Func", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.endsWith("DoSomething", "Func", caseSensitive: false)
            #expect(filter.apply("myfunc"))
        }

        @Test
        func _functionEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.endsWith("DoSomething", "Func", caseSensitive: true)
            #expect(!filter.apply("myfunc"))
        }

        @Test
        func _functionEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.equals("myFunc", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.equals("myFunc", caseSensitive: false)
            #expect(filter.apply("myfunc"))
        }

        @Test
        func _functionEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.equals("myFunc", caseSensitive: true)
            #expect(!filter.apply("myfunc"))
        }

        @Test
        func _functionEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: true)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: false)
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: true)
            #expect(!filter.apply("myfunc"))
        }

        @Test
        func _functionCustomSimple_answersTrue() {
            let filter = Filters.function.custom { string in
                string == "myfunc"
            }
            #expect(filter.apply("myfunc"))
        }

        @Test
        func _functionCustomComplexMatches_answersTrue() {
            let filter = Filters.function.custom { string in
                let disallowedValues = ["yourFunc", "yourOtherFunc"]
                let allowedValues = ["myFunc"]
                return !disallowedValues.contains(string) && allowedValues.contains(string)
            }
            #expect(filter.apply("myFunc"))
        }

        @Test
        func _functionCustomComplexMatches_answersFalse() {
            let filter = Filters.function.custom { string in
                let disallowedValues = ["yourFunc", "yourOtherFunc"]
                let allowedValues = ["myFunc"]
                return !disallowedValues.contains(string) && allowedValues.contains(string)
            }
            #expect(!filter.apply("yourFunc"))
        }

        //
        // Message filtering tests (identity)
        //
        @Test
        func _message_getTarget_isMessageFilter() {
            let filter = Filters.message.startsWith("Hello there, SwiftyBeaver!")
            let isCorrectTargetType: Bool =
                switch filter.getTarget() {
                case .message:
                    true

                default:
                    false
                }
            #expect(isCorrectTargetType)
        }

        //
        // Message filtering tests (isRequired)
        //
        @Test
        func _message_startsWithAndIsRequired_isRequiredFilter() {
            let filter = Filters.message.startsWith("Hello", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _message_containsAndIsRequired_isRequiredFilter() {
            let filter = Filters.message.contains("there", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _message_excludesAndIsRequired_isRequiredFilter() {
            let filter = Filters.message.excludes("there", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _message_endsWithAndIsRequired_isRequiredFilter() {
            let filter = Filters.message.endsWith("SwifyBeaver!", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _message_equalsAndIsRequired_isRequiredFilter() {
            let filter = Filters.message.equals("SwifyBeaver!", required: true)
            #expect(filter.isRequired())
        }

        @Test
        func _message_startsWithAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.message.startsWith("Hello", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _message_containsAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.message.contains("there", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _message_excludesAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.message.excludes("there", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _message_endsWithAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.message.endsWith("SwiftyBeaver!", required: false)
            #expect(!filter.isRequired())
        }

        @Test
        func _message_equalsAndIsNotRequired_isNotRequiredFilter() {
            let filter = Filters.message.equals("SwiftyBeaver!", required: false)
            #expect(!filter.isRequired())
        }

        //
        // Message filtering tests (case sensitivity)
        //
        @Test
        func _message_startsWithAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.message.startsWith("Hello", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_containsAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.message.contains("there", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_excludesAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.message.excludes("there", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_endsWithAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_equalsAndIsCaseSensitive_isCaseSensitive() {
            let filter = Filters.message.equals("SwiftyBeaver!", caseSensitive: true)
            #expect(isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.message.startsWith("Hello", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.message.contains("there", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.message.excludes("there", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        @Test
        func _message_equalsAndIsNotCaseSensitive_isNotCaseSensitive() {
            let filter = Filters.message.equals("SwiftyBeaver!", caseSensitive: false)
            #expect(!isCaseSensitive(filter.getTarget()))
        }

        //
        // Function filtering tests (comparison testing)
        //
        @Test
        func _messageStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.startsWith("Hello", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.startsWith("hello", caseSensitive: false)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.startsWith("hello", caseSensitive: true)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.startsWith("Goodbye", "Hello", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.startsWith("goodbye", "hello", caseSensitive: false)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.startsWith("goodbye", "hello", caseSensitive: true)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.contains("there", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.contains("There", caseSensitive: false)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.contains("There", caseSensitive: true)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.contains("their", "there", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.contains("Their", "There", caseSensitive: false)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.contains("Their", "There", caseSensitive: true)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.excludes("there", caseSensitive: true)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.excludes("There", caseSensitive: false)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.excludes("There", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.excludes("their", "there", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.excludes("Their", "There", caseSensitive: false)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.excludes("Their", "There", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.endsWith("swiftybeaver!", caseSensitive: false)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.endsWith("swiftybeaver!", caseSensitive: true)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.endsWith("SluggishMink!", "SwiftyBeaver!", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.endsWith(
                "sluggishmink!", "swiftybeaver!", caseSensitive: false
            )
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.endsWith(
                "sluggishmink!!", "swiftybeaver!", caseSensitive: true
            )
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.equals("Hello there, SwiftyBeaver!", caseSensitive: true)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.equals("hello there, swiftybeaver!", caseSensitive: false)
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.equals("hello there, swiftybeaver!", caseSensitive: true)
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.equals(
                "Goodbye, SluggishMink!", "Hello there, SwiftyBeaver!", caseSensitive: true
            )
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
            let filter = Filters.message.equals(
                "goodbye, sluggishmink!",
                "hello there, swiftybeaver!",
                caseSensitive: false
            )
            #expect(filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
            let filter = Filters.message.equals(
                "goodbye, sluggishmink!", "hello there, swiftybeaver!", caseSensitive: true
            )
            #expect(!filter.apply("Hello there, SwiftyBeaver!"))
        }

        @Test
        func _messageCustomSimple_answersTrue() {
            let filter = Filters.message.custom { string in
                string == "hello"
            }
            #expect(filter.apply("hello"))
        }

        @Test
        func _messageCustomComplexMatches_answersTrue() {
            let filter = Filters.message.custom { string in
                let disallowedValues = ["goodbye", "see you later"]
                let allowedValues = ["hello"]
                return !disallowedValues.contains(string) && allowedValues.contains(string)
            }
            #expect(filter.apply("hello"))
        }

        @Test
        func _messageCustomComplexMatches_answersFalse() {
            let filter = Filters.function.custom { string in
                let disallowedValues = ["goodbye", "see you later"]
                let allowedValues = ["hello"]
                return !disallowedValues.contains(string) && allowedValues.contains(string)
            }
            #expect(!filter.apply("goodbye"))
        }

        // Helper functions
        private func isCaseSensitive(_ targetType: Filter.TargetType) -> Bool {
            let comparisonType: Filter.ComparisonType? =
                switch targetType {
                case let .path(type):
                    type

                case let .function(type):
                    type

                case let .message(type):
                    type
                }

            guard let compareType = comparisonType else {
                return false
            }

            let isCaseSensitive: Bool =
                switch compareType {
                case let .contains(_, caseSensitive):
                    caseSensitive

                case let .excludes(_, caseSensitive):
                    caseSensitive

                case let .startsWith(_, caseSensitive):
                    caseSensitive

                case let .endsWith(_, caseSensitive):
                    caseSensitive

                case let .equals(_, caseSensitive):
                    caseSensitive

                case .custom:
                    false
                }

            return isCaseSensitive
        }
    }

#endif
