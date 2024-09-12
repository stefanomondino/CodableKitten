import XCTest
@testable import CodableKitten

final class ExtensibleIdentifierTests: XCTestCase {
    func test_identifier_string_retains_proper_value() {
        let identifier = StringIdentifier<Self>("testMe")
        let sameIdentifier = StringIdentifier<Self>("testMe")
        let otherIdentifier = StringIdentifier<XCTestCase>("testMe")
        XCTAssertEqual(identifier, "testMe")
        XCTAssertNotEqual(identifier, StringIdentifier<Self>("2"))
        let dictionary: [AnyHashable: String] = [
            identifier: "Test",
            otherIdentifier: "otherIdentifier"
        ]
        XCTAssertNotEqual(identifier.hashValue, otherIdentifier.hashValue)
        XCTAssertEqual(identifier.hashValue, sameIdentifier.hashValue)
        
        XCTAssertEqual(dictionary[identifier], "Test")
        XCTAssertEqual(dictionary[otherIdentifier], "otherIdentifier")
        XCTAssertNil(dictionary["testMe"])
        
        let array: [AnyHashable] = [identifier, otherIdentifier]
        XCTAssertEqual(Set(array).count, 2)
    }
}
