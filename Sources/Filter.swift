// Filter.swift
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

/// FilterType is a protocol that describes something that determines
/// whether or not a message gets logged. A filter answers a Bool when it
/// is applied to a value. If the filter passes, it shall return true,
/// false otherwise.
///
/// A filter must contain a target, which identifies what it filters against
/// A filter can be required meaning that all required filters against a specific
/// target must pass in order for the message to be logged.
public protocol FilterType: AnyObject {
    func apply(_ value: String?) -> Bool
    func getTarget() -> Filter.TargetType
    func isRequired() -> Bool
    func isExcluded() -> Bool
    func reachedMinLevel(_ level: SwiftyBeaver.Level) -> Bool
}

/// Filters is syntactic sugar used to easily construct filters
public class Filters {
    public static let path = PathFilterFactory.self
    public static let function = FunctionFilterFactory.self
    public static let message = MessageFilterFactory.self
}

/// Filter is an abstract base class for other filters
public class Filter {
    public enum TargetType {
        case path(Filter.ComparisonType)
        case function(Filter.ComparisonType)
        case message(Filter.ComparisonType)
    }

    public enum ComparisonType {
        case startsWith([String], Bool)
        case contains([String], Bool)
        case excludes([String], Bool)
        case endsWith([String], Bool)
        case equals([String], Bool)
        case custom((String) -> Bool)
    }

    let targetType: Filter.TargetType
    let required: Bool
    let minLevel: SwiftyBeaver.Level

    public init(_ target: Filter.TargetType, required: Bool, minLevel: SwiftyBeaver.Level) {
        targetType = target
        self.required = required
        self.minLevel = minLevel
    }

    public func getTarget() -> Filter.TargetType {
        targetType
    }

    public func isRequired() -> Bool {
        required
    }

    public func isExcluded() -> Bool {
        false
    }

    /// returns true of set minLevel is >= as given level
    public func reachedMinLevel(_ level: SwiftyBeaver.Level) -> Bool {
        // print("checking if given level \(level) >= \(minLevel)")
        level.rawValue >= minLevel.rawValue
    }
}

/// CompareFilter is a FilterType that can filter based upon whether a target
/// starts with, contains or ends with a specific string. CompareFilters can be
/// case sensitive.
public class CompareFilter: Filter, FilterType {
    private var filterComparisonType: Filter.ComparisonType?

    override public init(_ target: Filter.TargetType, required: Bool, minLevel: SwiftyBeaver.Level) {
        super.init(target, required: required, minLevel: minLevel)

        let comparisonType: Filter.ComparisonType? = switch getTarget() {
        case let .function(comparison):
            comparison

        case let .path(comparison):
            comparison

        case let .message(comparison):
            comparison
            /* default:
             comparisonType = nil */
        }
        filterComparisonType = comparisonType
    }

    public func apply(_ value: String?) -> Bool {
        guard let value else {
            return false
        }

        guard let filterComparisonType else {
            return false
        }

        let matches: Bool = switch filterComparisonType {
        case let .contains(strings, caseSensitive):
            !strings.filter { string in
                caseSensitive ? value.contains(string) :
                    value.lowercased().contains(string.lowercased())
            }.isEmpty

        case let .excludes(strings, caseSensitive):
            !strings.filter { string in
                caseSensitive ? !value.contains(string) :
                    !value.lowercased().contains(string.lowercased())
            }.isEmpty

        case let .startsWith(strings, caseSensitive):
            !strings.filter { string in
                caseSensitive ? value.hasPrefix(string) :
                    value.lowercased().hasPrefix(string.lowercased())
            }.isEmpty

        case let .endsWith(strings, caseSensitive):
            !strings.filter { string in
                caseSensitive ? value.hasSuffix(string) :
                    value.lowercased().hasSuffix(string.lowercased())
            }.isEmpty

        case let .equals(strings, caseSensitive):
            !strings.filter { string in
                caseSensitive ? value == string :
                    value.lowercased() == string.lowercased()
            }.isEmpty

        case let .custom(predicate):
            predicate(value)
        }

        return matches
    }

    override public func isExcluded() -> Bool {
        guard let filterComparisonType else { return false }

        switch filterComparisonType {
        case .excludes:
            return true
        default:
            return false
        }
    }
}

// Syntactic sugar for creating a function comparison filter
public class FunctionFilterFactory {
    public static func startsWith(
        _ prefixes: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.function(.startsWith(prefixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func contains(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.function(.contains(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func excludes(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.function(.excludes(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func endsWith(
        _ suffixes: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.function(.endsWith(suffixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func equals(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.function(.equals(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func custom(
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose,
        filterPredicate: @escaping (String) -> Bool
    ) -> FilterType {
        CompareFilter(.function(.custom(filterPredicate)), required: required, minLevel: minLevel)
    }
}

// Syntactic sugar for creating a message comparison filter
public class MessageFilterFactory {
    public static func startsWith(
        _ prefixes: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.message(.startsWith(prefixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func contains(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.message(.contains(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func excludes(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.message(.excludes(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func endsWith(
        _ suffixes: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.message(.endsWith(suffixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func equals(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.message(.equals(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func custom(
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose,
        filterPredicate: @escaping (String) -> Bool
    ) -> FilterType {
        CompareFilter(.message(.custom(filterPredicate)), required: required, minLevel: minLevel)
    }
}

// Syntactic sugar for creating a path comparison filter
public class PathFilterFactory {
    public static func startsWith(
        _ prefixes: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.path(.startsWith(prefixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func contains(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.path(.contains(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func excludes(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.path(.excludes(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func endsWith(
        _ suffixes: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.path(.endsWith(suffixes, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func equals(
        _ strings: String...,
        caseSensitive: Bool = false,
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose
    ) -> FilterType {
        CompareFilter(.path(.equals(strings, caseSensitive)), required: required, minLevel: minLevel)
    }

    public static func custom(
        required: Bool = false,
        minLevel: SwiftyBeaver.Level = .verbose,
        filterPredicate: @escaping (String) -> Bool
    ) -> FilterType {
        CompareFilter(.path(.custom(filterPredicate)), required: required, minLevel: minLevel)
    }
}

extension Filter.TargetType: Equatable {}

// The == does not compare associated values for each enum. Instead == evaluates to true
// if both enums are the same "types", ignoring the associated values of each enum
public func == (lhs: Filter.TargetType, rhs: Filter.TargetType) -> Bool {
    switch (lhs, rhs) {
    case (.path, .path):
        true

    case (.function, .function):
        true

    case (.message, .message):
        true

    default:
        false
    }
}
