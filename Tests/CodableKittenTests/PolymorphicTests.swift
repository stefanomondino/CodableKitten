import XCTest
@testable import CodableKitten

final class PolymorphicTests: XCTestCase {
    var decoder: JSONDecoder = .init()
    var decoder2: JSONDecoder = .init()
    
    override func setUp() {
        super.setUp()
        decoder.set(types: [Bike.self, Car.self, Boat.self], for: VehicleType.self)
        decoder.set(types: [TVShow.self, MusicVideo.self, Movie.self], for: WatchableType.self)
        decoder.set(types: [Dog.self, Cat.self], for: AnimalType.self)
    }
    
    func test_mocks_are_properly_working() throws {
            struct Test: Decodable {
                let type: String
            }
            let mock: Mock = .vehicles
            let objects: [Test] = try mock.object()
            XCTAssertEqual(objects.first?.type, "car")
        }
    
    func test_polymorphic_root_object_gets_decoded() throws {
        let vehicle = try Mock.vehicle
            .object(of: Polymorph<VehicleType>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual((vehicle as? Car)?.brand, "TheBrand™")
    }
    
    func test_polymorphic2_root_object_gets_decoded() throws {
        let animal = try Mock.animal
            .object(of: Polymorph<AnimalType>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual((animal as? Dog)?.name, "Bingo")
    }
    
    func test_root_array_of_polymorphic_objects_gets_decoded() throws {
        let array = try Mock.vehicles
            .object(of: PolymorphArray<VehicleType>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual((array.first as? Car)?.brand, "TheBrand™")
    }
    
    func test_polymorphic_object_as_property_gets_decoded() throws {

        let response = try Mock.vehicleResponseWithProperties
            .object(of: SingleResponse.self, decoder: decoder)
        XCTAssertEqual((response.vehicle as? Car)?.brand, "TheBrand™")
    }
    
    func test_polymorphic_objects_with_nested_types_gets_decoded() throws {
        let array = try Mock.watchablesWithNestedTypes
            .object(of: PolymorphArray<WatchableType>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual(array.count, 3)
    }
    func test_polymorphic_objects_with_nested_types_gets_encoded() throws {
        let polymorph = try Mock.watchablesWithNestedTypes
            .object(of: PolymorphArray<WatchableType>.self, decoder: decoder)
        let data = try JSONEncoder().encode(polymorph)
        let reDecoded = try decoder.decode(PolymorphArray<WatchableType>.self,
                                           from: data)
        XCTAssertEqual(reDecoded.wrappedValue.count, 3)
    }
}
