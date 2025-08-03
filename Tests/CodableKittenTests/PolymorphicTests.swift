import Testing
@testable import CodableKitten
import Foundation

@Suite("Polymorphic Tests")
struct PolymorphicTests {
    var decoder: JSONDecoder = .init()
    var decoder2: JSONDecoder = .init()
    
    init() {
        decoder.set(types: [Bike.self, Car.self, Boat.self], for: VehicleType.self)
        decoder.set(types: [TVShow.self, MusicVideo.self, Movie.self], for: WatchableType.self)
//        decoder.set(types: [Dog.self, Cat.self], for: AnimalType.self)
        AnimalType.set(types: [Dog.self, Cat.self], in: decoder)
    }
    @Test("Mocks are properly working")
    func test_mocks_are_properly_working() throws {
            struct Test: Decodable {
                let type: String
            }
            let mock: Mock = .vehicles
            let objects: [Test] = try mock.object()
        #expect(objects.first?.type == "car")
        }
    
    @Test("Polymorphic root object gets decoded")
    func test_polymorphic_root_object_gets_decoded() throws {
        let vehicle = try Mock.vehicle
            .object(of: Polymorph<VehicleType, any Vehicle>.self, decoder: decoder)
            .wrappedValue
        let car = try #require(vehicle as? Car)
        #expect(car.brand == "TheBrand™")
    }

    @Test("Polymorphic2 root object gets decoded")
    func test_polymorphic2_root_object_gets_decoded() throws {
        let animal = try Mock.animal
            .object(of: Polymorph<AnimalType, any Animal>.self, decoder: decoder)
            .wrappedValue
        let dog = try #require(animal as? Dog)
        #expect(dog.name == "Bingo")
    }

    @Test("Root array of polymorphic objects gets decoded")
    func test_root_array_of_polymorphic_objects_gets_decoded() throws {
        let array = try Mock.vehicles
            .object(of: Polymorph<VehicleType, [any Vehicle]>.self, decoder: decoder)
            .wrappedValue
        #expect((array.first as? Car)?.brand == "TheBrand™")
        #expect(array.map { $0.name } == ["The Name®", "Floater 3000", "Bye Cycle"])
    }

    @Test("Polymorphic object as property gets decoded")
    func test_polymorphic_object_as_property_gets_decoded() throws {
        do {
            let response = try Mock.vehicleResponseWithProperties
                .object(of: SingleResponse.self, decoder: decoder)
            #expect((response.vehicle as? Car)?.brand == "TheBrand™")
            #expect(response.vehicle.name == "The Name®")
            #expect(response.otherVehicles.count == 2)
        }
    }

    @Test("Polymorphic objects with nested types gets decoded")
    func test_polymorphic_objects_with_nested_types_gets_decoded() throws {
        let array = try Mock.watchablesWithNestedTypes
            .object(of: Polymorph<WatchableType, [any Watchable]>.self, decoder: decoder)
            .wrappedValue
        #expect(array.count == 3)
    }

    @Test("Polymorphic objects with nested types gets encoded")
    func test_polymorphic_objects_with_nested_types_gets_encoded() throws {
        let polymorph = try Mock.watchablesWithNestedTypes
            .object(of: Polymorph<WatchableType, [any Watchable]>.self, decoder: decoder)
        let data = try JSONEncoder().encode(polymorph)
        let reDecoded = try decoder.decode(Polymorph<WatchableType, [any Watchable]>.self,
                                           from: data)
        #expect(reDecoded.wrappedValue.count == 3)
    }
    @Test("Single polymorphic animal gets encoded and decoded")
    func test_single_polymorphic_animal_gets_encoded_and_decoded() throws {
        let polymorph = try Mock.animal
            .object(of: Polymorph<AnimalType, any Animal>.self, decoder: decoder)
        let data = try JSONEncoder().encode(polymorph)
        let reDecoded = try decoder.decode(Polymorph<AnimalType, any Animal>.self, from: data)
        let dog = try #require(reDecoded.wrappedValue as? Dog)
        #expect(dog.name == "Bingo")
    }
}
