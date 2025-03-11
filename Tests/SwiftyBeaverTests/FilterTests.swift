// FilterTests.swift
// SwiftyBeaver
//
// Copyright (c) 2015 Sebastian Kreutzberger
// All rights reserved.
//
// Copyright 2025 MFB Technologies, Inc.
//
// This source code is licensed under the MIT License (MIT) found in the
// LICENSE file in the root directory of this source tree.

import Foundation
@testable import SwiftyBeaver
import Testing

@Suite
struct FilterTests {
    //
    // Path filtering tests (identity)
    //
    @Test
    func path_getTarget_isPathFilter() {
        let filter = Filters.path.startsWith("/some/path")
        let isCorrectTargetType: Bool = switch filter.getTarget() {
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
    func path_startsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.startsWith("/some/path", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func path_containsAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.contains("/some/path", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func path_excludesAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.excludes("/some/path", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func path_endsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.endsWith("/some/path", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func path_equalsAndIsRequired_isRequiredFilter() {
        let filter = Filters.path.equals("/some/path", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func path_startsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.startsWith("/some/path", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func path_containsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.contains("/some/path", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func path_excludesAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.excludes("/some/path", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func path_endsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.endsWith("/some/path", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func path_equalsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.path.equals("/some/path", required: false)
        #expect(!filter.isRequired())
    }

    //
    // Path filtering tests (case sensitivity)
    //
    @Test
    func path_startsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.startsWith("/some/path", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_containsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.contains("/some/path", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_excludesAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.excludes("/some/path", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_endsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.endsWith("/some/path", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_equalsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.path.equals("/some/path", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.startsWith("/some/path", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.contains("/some/path", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.excludes("/some/path", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.endsWith("/some/path", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func path_equalsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.path.equals("/some/path", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    //
    // Path filtering tests (comparison testing)
    //
    @Test
    func pathStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/first", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/First", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.startsWith("/First", caseSensitive: true)
        #expect(!filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/first", "/second", caseSensitive: true)
        #expect(filter.apply("/second/path/to/anywhere"))
    }

    @Test
    func pathStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.startsWith("/First", "/Second", caseSensitive: false)
        #expect(filter.apply("/second/path/to/anywhere"))
    }

    @Test
    func pathStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.startsWith("/First", "/Second", caseSensitive: true)
        #expect(!filter.apply("/second/path/to/anywhere"))
    }

    @Test
    func pathContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/path", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/Path", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.contains("/Path", caseSensitive: true)
        #expect(!filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/pathway", "/path", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.contains("/Pathway", "/Path", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.contains("/Pathway", "/Path", caseSensitive: true)
        #expect(!filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/path", caseSensitive: true)
        #expect(filter.apply("/first/epath/to/anywhere"))
    }

    @Test
    func pathExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/Path", caseSensitive: false)
        #expect(filter.apply("/first/epath/to/anywhere"))
    }

    @Test
    func pathExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.excludes("/Path", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/pathway", "/path", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.excludes("/Pathway", "/Path", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.excludes("/Pathway", "/Path", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/anywhere", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/Anywhere", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.endsWith("/Anywhere", caseSensitive: true)
        #expect(!filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/nowhere", "/anywhere", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.endsWith("/Nowhere", "/Anywhere", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.endsWith("/Nowhere", "/Anywhere", caseSensitive: true)
        #expect(!filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/first/path/to/anywhere", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/First/path/to/Anywhere", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.equals("/First/path/to/Anywhere", caseSensitive: true)
        #expect(!filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/second/path/to/anywhere", "/first/path/to/anywhere", caseSensitive: true)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.path.equals("/Second/path/to/nowhere", "/First/Path/To/Anywhere", caseSensitive: false)
        #expect(filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.path.equals("/Second/path/to/anywhere", "/First/path/to/Anywhere", caseSensitive: true)
        #expect(!filter.apply("/first/path/to/anywhere"))
    }

    @Test
    func pathCustomSimple_answersTrue() {
        let filter = Filters.path.custom { string in
            string == "/Second/path/to/anywhere"
        }
        #expect(filter.apply("/Second/path/to/anywhere"))
    }

    @Test
    func pathCustomComplexMatches_answersFalse() {
        let filter = Filters.path.custom { string in
            let disallowedValues = ["/Second/path/to/anywhere"]
            let allowedValues = ["/First/path/to/anywhere"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        #expect(!filter.apply("/Second/path/to/anywhere"))
    }

    @Test
    func pathCustomComplexMatches_answersTrue() {
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
    func function_getTarget_isFunctionFilter() {
        let filter = Filters.function.startsWith("myFunc")
        let isCorrectTargetType: Bool = switch filter.getTarget() {
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
    func function_startsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.startsWith("myFunc", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func function_containsAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.contains("myFunc", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func function_excludesAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.excludes("myFunc", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func function_endsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.endsWith("myFunc", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func function_equalsAndIsRequired_isRequiredFilter() {
        let filter = Filters.function.equals("myFunc", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func function_startsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.startsWith("myFunc", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func function_containsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.contains("myFunc", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func function_excludesAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.excludes("myFunc", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func function_endsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.endsWith("myFunc", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func function_equalsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.function.equals("myFunc", required: false)
        #expect(!filter.isRequired())
    }

    //
    // Function filtering tests (case sensitivity)
    //
    @Test
    func function_startsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.startsWith("myFunc", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func function_containsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.contains("myFunc", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func function_excludesAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.excludes("myFunc", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func function_endsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.function.endsWith("myFunc", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func function_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.startsWith("myFunc", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func function_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.contains("myFunc", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func function_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.excludes("myFunc", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func function_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.function.endsWith("myFunc", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    //
    // Function filtering tests (comparison testing)
    //
    @Test
    func functionStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("myFunc", caseSensitive: true)
        #expect(filter.apply("myFunction"))
    }

    @Test
    func functionStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("MyFunc", caseSensitive: false)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.startsWith("MyFunc", caseSensitive: true)
        #expect(!filter.apply("myFunc"))
    }

    @Test
    func functionStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("yourFunc", "myFunc", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.startsWith("YourFunc", "MyFunc", caseSensitive: false)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.startsWith("YourFunc", "MyFunc", caseSensitive: true)
        #expect(!filter.apply("myFunc"))
    }

    @Test
    func functionContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("Func", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("Func", caseSensitive: false)
        #expect(filter.apply("myfunc"))
    }

    @Test
    func functionContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.contains("Func", caseSensitive: true)
        #expect(!filter.apply("myfunc"))
    }

    @Test
    func functionContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("doSomething", "Func", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.contains("DoSomething", "func", caseSensitive: false)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.contains("DoSomething", "Func", caseSensitive: true)
        #expect(!filter.apply("myfunc"))
    }

    @Test
    func functionExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("Func", caseSensitive: true)
        #expect(!filter.apply("myFunc"))
    }

    @Test
    func functionExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("Func", caseSensitive: false)
        #expect(!filter.apply("myfunc"))
    }

    @Test
    func functionExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.excludes("Func", caseSensitive: true)
        #expect(filter.apply("myfunc"))
    }

    @Test
    func functionExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("doSomething", "Func", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.excludes("DoSomething", "func", caseSensitive: false)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.excludes("DoSomething", "Func", caseSensitive: true)
        #expect(filter.apply("myfunc"))
    }

    @Test
    func functionEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("Func", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("Func", caseSensitive: false)
        #expect(filter.apply("myfunc"))
    }

    @Test
    func functionEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.endsWith("Func", caseSensitive: true)
        #expect(!filter.apply("myfunc"))
    }

    @Test
    func functionEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("doSomething", "Func", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.endsWith("DoSomething", "Func", caseSensitive: false)
        #expect(filter.apply("myfunc"))
    }

    @Test
    func functionEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.endsWith("DoSomething", "Func", caseSensitive: true)
        #expect(!filter.apply("myfunc"))
    }

    @Test
    func functionEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("myFunc", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("myFunc", caseSensitive: false)
        #expect(filter.apply("myfunc"))
    }

    @Test
    func functionEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.equals("myFunc", caseSensitive: true)
        #expect(!filter.apply("myfunc"))
    }

    @Test
    func functionEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: true)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: false)
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.function.equals("yourFunc", "myFunc", caseSensitive: true)
        #expect(!filter.apply("myfunc"))
    }

    @Test
    func functionCustomSimple_answersTrue() {
        let filter = Filters.function.custom { string in
            string == "myfunc"
        }
        #expect(filter.apply("myfunc"))
    }

    @Test
    func functionCustomComplexMatches_answersTrue() {
        let filter = Filters.function.custom { string in
            let disallowedValues = ["yourFunc", "yourOtherFunc"]
            let allowedValues = ["myFunc"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        #expect(filter.apply("myFunc"))
    }

    @Test
    func functionCustomComplexMatches_answersFalse() {
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
    func message_getTarget_isMessageFilter() {
        let filter = Filters.message.startsWith("Hello there, SwiftyBeaver!")
        let isCorrectTargetType: Bool = switch filter.getTarget() {
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
    func message_startsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.startsWith("Hello", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func message_containsAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.contains("there", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func message_excludesAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.excludes("there", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func message_endsWithAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.endsWith("SwifyBeaver!", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func message_equalsAndIsRequired_isRequiredFilter() {
        let filter = Filters.message.equals("SwifyBeaver!", required: true)
        #expect(filter.isRequired())
    }

    @Test
    func message_startsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.startsWith("Hello", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func message_containsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.contains("there", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func message_excludesAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.excludes("there", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func message_endsWithAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", required: false)
        #expect(!filter.isRequired())
    }

    @Test
    func message_equalsAndIsNotRequired_isNotRequiredFilter() {
        let filter = Filters.message.equals("SwiftyBeaver!", required: false)
        #expect(!filter.isRequired())
    }

    //
    // Message filtering tests (case sensitivity)
    //
    @Test
    func message_startsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.startsWith("Hello", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_containsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.contains("there", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_excludesAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.excludes("there", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_endsWithAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_equalsAndIsCaseSensitive_isCaseSensitive() {
        let filter = Filters.message.equals("SwiftyBeaver!", caseSensitive: true)
        #expect(isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_startsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.startsWith("Hello", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_containsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.contains("there", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_excludesAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.excludes("there", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_endsWithAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    @Test
    func message_equalsAndIsNotCaseSensitive_isNotCaseSensitive() {
        let filter = Filters.message.equals("SwiftyBeaver!", caseSensitive: false)
        #expect(!isCaseSensitive(filter.getTarget()))
    }

    //
    // Function filtering tests (comparison testing)
    //
    @Test
    func messageStartsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("Hello", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageStartsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("hello", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageStartsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.startsWith("hello", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageStartsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("Goodbye", "Hello", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageStartsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.startsWith("goodbye", "hello", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageStartsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.startsWith("goodbye", "hello", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageContains_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("there", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageContains_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("There", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageContains_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.contains("There", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageContains_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("their", "there", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageContains_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.contains("Their", "There", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageContains_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.contains("Their", "There", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageExcludes_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("there", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageExcludes_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("There", caseSensitive: false)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageExcludes_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.excludes("There", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageExcludes_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("their", "there", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageExcludes_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.excludes("Their", "There", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageExcludes_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.excludes("Their", "There", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEndsWith_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("SwiftyBeaver!", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEndsWith_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("swiftybeaver!", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEndsWith_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.endsWith("swiftybeaver!", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEndsWith_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("SluggishMink!", "SwiftyBeaver!", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEndsWith_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.endsWith("sluggishmink!", "swiftybeaver!", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEndsWith_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.endsWith("sluggishmink!!", "swiftybeaver!", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEquals_hasOneValueAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals("Hello there, SwiftyBeaver!", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEquals_hasOneValueAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals("hello there, swiftybeaver!", caseSensitive: false)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEquals_hasOneValueAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.equals("hello there, swiftybeaver!", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEquals_hasMultipleValuesAndIsCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals("Goodbye, SluggishMink!", "Hello there, SwiftyBeaver!", caseSensitive: true)
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEquals_hasMultipleValuesAndIsNotCaseSensitiveAndMatches_answersTrue() {
        let filter = Filters.message.equals(
            "goodbye, sluggishmink!",
            "hello there, swiftybeaver!",
            caseSensitive: false
        )
        #expect(filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageEquals_hasMultipleValuesAndIsCaseSensitiveAndDoesNotMatch_answersFalse() {
        let filter = Filters.message.equals("goodbye, sluggishmink!", "hello there, swiftybeaver!", caseSensitive: true)
        #expect(!filter.apply("Hello there, SwiftyBeaver!"))
    }

    @Test
    func messageCustomSimple_answersTrue() {
        let filter = Filters.message.custom { string in
            string == "hello"
        }
        #expect(filter.apply("hello"))
    }

    @Test
    func messageCustomComplexMatches_answersTrue() {
        let filter = Filters.message.custom { string in
            let disallowedValues = ["goodbye", "see you later"]
            let allowedValues = ["hello"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        #expect(filter.apply("hello"))
    }

    @Test
    func messageCustomComplexMatches_answersFalse() {
        let filter = Filters.function.custom { string in
            let disallowedValues = ["goodbye", "see you later"]
            let allowedValues = ["hello"]
            return !disallowedValues.contains(string) && allowedValues.contains(string)
        }
        #expect(!filter.apply("goodbye"))
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
