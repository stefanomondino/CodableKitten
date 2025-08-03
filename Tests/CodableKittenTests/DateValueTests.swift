//
//  File.swift
//  CodableKitten
//
//  Created by Stefano Mondino on 27/07/25.
//

import Foundation
import Testing
@testable import CodableKitten

@Suite("DateValue Tests")
struct DateValueTests {
    var iso8601Mock: DateRepresentation<ISO8601Format> {
        .init(
            string: "2023-10-01T12:34:56Z",
            date: DateComponents(
                calendar: .current,
                timeZone: .init(secondsFromGMT: 0),
                year: 2023,
                month: 10,
                day: 1,
                hour: 12,
                minute: 34,
                second: 56,
                nanosecond: 0
            ).date.unsafelyUnwrapped)
    }

    var iso8601WithMillisecondsMock: DateRepresentation<ISO8601FormatWithMilliseconds> {
        .init(
            string: "2023-10-01T12:34:56.001Z",
            date: DateComponents(
                calendar: .current,
                timeZone: .init(secondsFromGMT: 0),
                year: 2023,
                month: 10,
                day: 1,
                hour: 12,
                minute: 34,
                second: 56,
                nanosecond: 1 * 1_000_000
            ).date.unsafelyUnwrapped)
    }

    struct DateRepresentation<Format: DateFormat> {
        let string: String
        let date: Date
        
    }
    
    @Test("ISO8601DateFormatter gets converted in Date")
    func testISO8601DateFormatter() throws {
        let mock = iso8601Mock
        let date = try #require(DateValue<String, ISO8601SafeFormat>(mock.string)).date
        let expected = mock.date
        #expect(date == expected)
    }
    
    @Test("ISO8601DateFormatter with milliseconds gets converted in Date")
    func testISO8601WithMillisecondsDateFormatter() throws {
        let mock = iso8601WithMillisecondsMock
        let date = try #require(DateValue<String, ISO8601SafeFormat>(mock.string)).date
        let expected = mock.date
        #expect(abs(date.timeIntervalSince(expected)) < 0.001)
    }
    
    @Test("Date Formatter works as Codable")
    func testDateFormatterCodable() throws {
        struct Mock: Codable {
            @DateValue<String, ISO8601Format> var date: Date
        }
        let mock = iso8601Mock
        let json = Data("""
        {
            "date": "\(mock.string)"
        }
        """.utf8)
        let result = try JSONDecoder().decode(Mock.self, from: json)
        #expect(result.date == mock.date)
    }
}

