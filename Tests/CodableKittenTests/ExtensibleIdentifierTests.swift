@testable import CodableKitten
import Testing
import Foundation
@Suite("ExtensibleIdentifier Tests")
struct ExtensibleIdentifierTests {
    
    @Test("Extensible Identifier should store the underlying value")
    func extensibleIdentifierShouldStoreUnderlyingValue() {
        let identifier = StringIdentifier<Self>("testMe")
        #expect(identifier.value == "testMe")
    }

    @Test("Extensible Identifier should encode the underlying value")
    func extensibleIdentifierShouldEncodeUnderlyingValue() throws {
        struct Object: Encodable {
            let id: StringIdentifier<Self>
        }
        let data = try JSONEncoder().encode(Object(id: "testMe"))
        let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
        #expect(dictionary as? [String: String] == ["id": "testMe"])
    }
    
    @Test("Using a @Case property wrapper should create a valid ExtensibleIdentifier")
    func casePropertyWrapperShouldCreateValidIdentifier() {
        #expect(ExtensibleIdentifier<String, Self>.Case("talk").wrappedValue == .init("talk"))
        #expect(ExtensibleIdentifier<Int, Self>.Case(5).wrappedValue == .init(5))
    }
    
    @Test("Mapping a String ExtensibleIdentifier from a known JSON Object should return a valid value")
    func mappingFromJSONReturnsValidObject() throws {
        let events: [Event] = try Mock.events.object()
        let event = try #require(events.first)
        #expect(event.title == "The most amazing talk you'll ever see")
        #expect(event.category == .talk)
        #expect(event.category == "talk")
    }
        
    @Test("Different ExtensibleIdentifiers with the same underlying value should have different hashes")
    func differentIdentifiersWithSameValueShouldHaveDifferentHashes() {
        struct DummyObject {}
        let identifier = StringIdentifier<Self>("testMe")
        let otherIdentifier = StringIdentifier<DummyObject>("testMe")
        let dictionary: [AnyHashable: String] = [
            identifier: "Test",
            otherIdentifier: "otherIdentifier"
        ]
        #expect(identifier.hashValue != otherIdentifier.hashValue)
        #expect(dictionary[identifier] == "Test")
        #expect(dictionary[otherIdentifier] == "otherIdentifier")
        #expect(dictionary["testMe"] == nil)
        let array: [AnyHashable] = [identifier, otherIdentifier]
        #expect(Set(array).count == 2)
    }
    
    @Test("Common identifiers should be expressible by literals and RawValue")
    func commonIdentifiersShouldBeExpressibleByLiteralsAndRawValue() {
        let stringIdentifier: StringIdentifier<Self> = "testMe"
        #expect(stringIdentifier.value == "testMe")
        #expect(stringIdentifier.description == "testMe")
        #expect(stringIdentifier.debugDescription == "testMe".debugDescription)
        let intIdentifier: IntIdentifier<Self> = 5
        #expect(intIdentifier.value == 5)
        let floatIdentifier: ExtensibleIdentifier<Float, Self> = 5.3
        #expect(floatIdentifier.value == 5.3)
        let boolIdentifier: BoolIdentifier<Self> = true
        #expect(boolIdentifier.value == true)
        
        let stringIdentifier2: StringIdentifier<Self>? = .init(rawValue: "testMe")
        #expect(stringIdentifier2 == "testMe")
        #expect(stringIdentifier2?.rawValue == "testMe")
    }
}
