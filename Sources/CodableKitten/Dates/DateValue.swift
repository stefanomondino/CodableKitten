//
//  File.swift
//  CodableKitten
//
//  Created by Stefano Mondino on 27/07/25.
//

import Foundation

/// A property wrapper for decoding and encoding `Date` values using customizable raw representations and formats.
///
/// `DateValue` allows you to specify how a `Date` is encoded and decoded from a raw type representation (such as a `String` or `Int`)
/// using a provided `DateFormat` implementation. This is useful when working with JSON or other data formats where dates are represented
/// in various string or numeric formats.
///
/// - Generic Parameters:
///   - RawType: The type used to encode and decode the date value. Must conform to `Codable`.
///   - Format: A type conforming to `DateFormat` that provides the logic for converting between `RawType` and `Date`.
///
/// ## Usage
/// Use `DateValue` to wrap `Date` properties in your Codable types, specifying the desired raw format and formatter.
/// For example, to decode ISO8601 formatted strings, use `DateValue<String, ISO8601Format>`.
///
/// The wrapped value accesses the underlying `Date` value directly.
///
/// ## Initializers
/// - `init(_ interval: TimeInterval)`: Creates a `DateValue` from a time interval since 1970.
/// - `init(_ date: Date)`: Creates a `DateValue` from a `Date`.
/// - `init?(_ raw: RawType)`: Attempts to create a `DateValue` from a raw representation using the specified `Format`.
///
/// ## Properties
/// - `wrappedValue`: The underlying `Date` value.
/// - `date`: The stored `Date` value (read-only outside the wrapper).
@propertyWrapper
public struct DateValue<RawType: Codable, Format: DateFormat>: Codable, Sendable where Format.RawType == RawType {
    /// The stored `Date` value.
    public private(set) var date: Date
    
    /// The wrapped `Date` value accessed via the property wrapper.
    public var wrappedValue: Date {
        get { date }
        set { date = newValue }
    }
    
    /// Creates a `DateValue` from a time interval since 1970.
    /// - Parameter interval: Time interval since 1970.
    public init(_ interval: TimeInterval) {
        self.date = Date(timeIntervalSince1970: interval)
    }
    
    /// Creates a `DateValue` from a `Date`.
    /// - Parameter date: The `Date` value.
    public init(_ date: Date) {
        self.date = date
    }
    
    /// Attempts to create a `DateValue` from a raw representation using the specified `Format`.
    /// Returns `nil` if the raw value cannot be parsed into a `Date`.
    /// - Parameter raw: The raw encoded value.
    public init?(_ raw: RawType) {
        guard let date = Format.format(raw) else {
            return nil
        }
        self.date = date
    }
    
    /// Decodes the `DateValue` from the given decoder.
    /// Throws if the raw value cannot be decoded or parsed into a valid `Date`.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(RawType.self)
        if let value = DateValue.init(raw) {
            self = value
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Invalid date string format.")
        }
    }
}


/// A type alias for `DateValue` that uses a `String` as its raw representation.
///
/// `StringDateValue` is a convenience type for cases where you want to use a `DateValue`
/// property wrapper with date strings and a custom `DateFormat` implementation.
/// The associated `Format` must conform to `DateFormat` and accept `String` as its raw type.
///
/// ## Usage
/// Use `StringDateValue` to wrap date properties that are encoded and decoded from string representations,
/// such as ISO8601 strings or custom date formats, by specifying the appropriate `DateFormat` type.
///
/// ```swift
/// struct Event: Codable {
///     @StringDateValue<ISO8601Format>
///     var startDate: Date
/// }
/// ```
///
/// - Note: The `Format` type must have `RawType == String`.
///
/// - SeeAlso: `DateValue`
public typealias StringDateValue<Format: DateFormat> = DateValue<String, Format> where Format.RawType == String


/// A protocol that defines the requirements for formatting and parsing `Date` values using a raw type representation.
///
/// Types conforming to `DateFormat` provide the logic for converting between a raw representation (such as a `String` or `Int`)
/// and a `Date` instance. This is especially useful when working with dates in encoded formats (e.g., JSON) that require
/// custom parsing or formatting, such as ISO8601 strings or custom date patterns.
///
/// ## Associated Types
/// - `RawType`: The raw value type (such as `String` or `Int`) that will be converted to and from `Date`.
///
/// ## Requirements
/// - `static func format(_ raw: RawType) -> Date?`: A static method to parse a raw value into a `Date`.
///
/// ## Usage
/// Implement custom formats by creating types that conform to `DateFormat`, specifying the desired parsing logic. You can then use
/// these types as the `Format` parameter in property wrappers like `DateValue` or `StringDateValue` to control how dates are encoded and decoded.
///
/// ```swift
/// struct MyCustomFormat: DateFormat {
///     static func format(_ raw: String) -> Date? {
///         // Custom parsing logic here
///     }
/// }
/// ```
///
/// - Note: You can provide additional helper methods or properties (such as custom format strings) in your conforming types as needed.
///
/// - SeeAlso: `DateValue`, `StringDateValue`
public protocol DateFormat {
    associatedtype RawType
    static func format(_ raw: RawType) -> Date?
}


extension DateFormat where RawType == String {
    /// Parses a date string into a `Date` object using the specified date format string.
    ///
    /// This static helper method is intended for use by types conforming to `DateFormat` where the raw type is `String`.
    /// It utilizes a `DateFormatter` configured with the provided format string, a fixed `en_US_POSIX` locale, and the UTC time zone,
    /// ensuring consistent and locale-independent parsing results. This is particularly useful for handling dates in standardized
    /// formats (such as ISO8601 or custom patterns) when decoding from strings.
    ///
    /// - Parameters:
    ///   - raw: The raw string representing the date to be parsed.
    ///   - format: The format string to use for parsing the date (e.g., `"yyyy-MM-dd'T'HH:mm:ssZ"`).
    /// - Returns: A `Date` object if parsing is successful; otherwise, `nil`.
    ///
    /// - Note: For performance-sensitive scenarios, consider reusing a configured `DateFormatter` instance
    ///   rather than creating one on each call, as done here for simplicity.
    ///
    /// - SeeAlso: `DateValue`, `StringDateValue`, `DateFormat`
    public static func format(_ raw: RawType, format: String) -> Date? {
        let formatter = DateFormatter()
        // https://forums.swift.org/t/dateformatter-rounds-a-time-to-milliseconds/55024/4
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter.date(from: raw)
    }
}


/// A date format type that parses ISO8601 date strings with second precision.
///
/// `ISO8601Format` conforms to the `DateFormat` protocol and provides a static method
/// for parsing date strings in the following ISO8601 format: `"yyyy-MM-dd'T'HH:mm:ssZ"`.
///
/// This is commonly used for representing date and time values in JSON and other text-based
/// formats, and corresponds to a date string such as `"2025-07-27T15:30:45+0000"`.
///
/// ## Usage
/// Use `ISO8601Format` as the `Format` parameter for `DateValue<String, Format>` or the
/// `StringDateValue<Format>` type alias to decode and encode `Date` values using this format.
///
/// ```swift
/// struct Event: Codable {
///     @StringDateValue<ISO8601Format>
///     var timestamp: Date
/// }
/// ```
///
/// ## Format Details
/// - Format string: `"yyyy-MM-dd'T'HH:mm:ssZ"`
/// - Example: `"2025-07-27T15:30:45+0000"`
///
/// - Note: This format does **not** include milliseconds. For ISO8601 dates with millisecond
///   precision, see `ISO8601FormatWithMilliseconds`.
///
/// - SeeAlso: `DateFormat`, `StringDateValue`, `ISO8601FormatWithMilliseconds`
public struct ISO8601Format: DateFormat {
    public static func format(_ raw: String) -> Date? {
        format(raw, format: dateFormat)
    }
    public static var dateFormat: String { "yyyy-MM-dd'T'HH:mm:ssZ" }
}

/// A date format type that safely parses ISO8601 date strings with optional and variable precision for fractional seconds.
///
/// `ISO8601SafeFormat` conforms to `DateFormat` and is designed to handle not only the standard ISO8601 date-time strings
/// without fractional seconds (e.g., `"2025-07-27T15:30:45Z"`), but also those with up to six digits of fractional seconds
/// (e.g., `"2025-07-27T15:30:45.123456Z"`).
///
/// This is useful for decoding date strings from a variety of sources that may or may not include subsecond precision,
/// such as APIs or databases that emit ISO8601 timestamps with or without milliseconds or microseconds.
///
/// ## Usage
/// Use `ISO8601SafeFormat` as the `Format` parameter for `DateValue<String, Format>` or with the `StringDateValue<Format>`
/// type alias to robustly parse date strings with the greatest compatibility.
///
/// ```swift
/// struct Event: Codable {
///     @StringDateValue<ISO8601SafeFormat>
///     var timestamp: Date
/// }
/// ```
///
/// ## Format Details
/// - Recognizes and parses the following patterns:
///   - `"yyyy-MM-dd'T'HH:mm:ssZ"`
///   - `"yyyy-MM-dd'T'HH:mm:ss.SZ"` (tenths)
///   - `"yyyy-MM-dd'T'HH:mm:ss.SSZ"` (hundredths)
///   - `"yyyy-MM-dd'T'HH:mm:ss.SSSZ"` (milliseconds)
///   - `"yyyy-MM-dd'T'HH:mm:ss.SSSSZ"`
///   - `"yyyy-MM-dd'T'HH:mm:ss.SSSSSZ"`
///   - `"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"` (up to microseconds)
/// - All formats require a trailing `"Z"` to indicate UTC time zone.
/// - Example accepted values:
///     - `"2025-07-27T15:30:45Z"`
///     - `"2025-07-27T15:30:45.1Z"`
///     - `"2025-07-27T15:30:45.123Z"`
///     - `"2025-07-27T15:30:45.123456Z"`
///
/// ## Implementation Details
/// The parsing logic first attempts the standard ISO8601 format. If unsuccessful, it iteratively tries
/// more precise fractional second formats, from six digits down to one, for compatibility with different sources.
///
/// - SeeAlso: `DateFormat`, `StringDateValue`, `ISO8601Format`
public struct ISO8601SafeFormat: DateFormat {
    public static func format(_ raw: String) -> Date? {
        let baseFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let base = format(raw, format: baseFormat + "Z") {
            return base
        } else {
            for customFormat in (1...6).reversed().map({ "\(baseFormat).\(String(repeating: "S", count: $0))Z"}) {
                if let value = format(raw, format: customFormat) {
                    return value
                }
            }
        }
        return nil
    }
}

