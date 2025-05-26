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
            .object(of: Polymorph<VehicleType, any Vehicle>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual((vehicle as? Car)?.brand, "TheBrand™")
    }
    
    func test_polymorphic2_root_object_gets_decoded() throws {
        let animal = try Mock.animal
            .object(of: Polymorph<AnimalType, any Animal>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual((animal as? Dog)?.name, "Bingo")
    }
    
    func test_root_array_of_polymorphic_objects_gets_decoded() throws {
        let array = try Mock.vehicles
            .object(of: Polymorph<VehicleType, [any Vehicle]>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual((array.first as? Car)?.brand, "TheBrand™")
        XCTAssertEqual(array.map { $0.name }, ["The Name®", "Floater 3000", "Bye Cycle"])
    }
    
    func test_polymorphic_object_as_property_gets_decoded() throws {
        do {
            let response = try Mock.vehicleResponseWithProperties
                .object(of: SingleResponse.self, decoder: decoder)
            XCTAssertEqual((response.vehicle as? Car)?.brand, "TheBrand™")
            XCTAssertEqual(response.vehicle.name, "The Name®")
            XCTAssertEqual(response.otherVehicles.count, 2)
        } catch {
            XCTFail("Failed to decode: \(error)")
        }
    }
    
    func test_polymorphic_objects_with_nested_types_gets_decoded() throws {
        let array = try Mock.watchablesWithNestedTypes
            .object(of: Polymorph<WatchableType, [any Watchable]>.self, decoder: decoder)
            .wrappedValue
        XCTAssertEqual(array.count, 3)
    }
    func test_polymorphic_objects_with_nested_types_gets_encoded() throws {
        
        let polymorph = try Mock.watchablesWithNestedTypes
            .object(of: Polymorph<WatchableType, [any Watchable]>.self, decoder: decoder)
        let data = try JSONEncoder().encode(polymorph)
        let reDecoded = try decoder.decode(Polymorph<WatchableType, [any Watchable]>.self,
                                           from: data)
        XCTAssertEqual(reDecoded.wrappedValue.count, 3)
    }
}


struct Response: Decodable {
  private enum CodingKeys: String, CodingKey {
    case items
  }
  let items: [any Animal]
  init(from decoder: any Decoder) throws {
      struct Extractor: Codable {
          let type: AnimalType
      }
      let container = try decoder.container(keyedBy: CodingKeys.self)
      var subContainer = try container.nestedUnkeyedContainer(forKey: .items)
      var items: [any Animal] = []
      while subContainer.isAtEnd == false {
          var subcontainerCopy = subContainer
          let extractor = try subContainer.decode(Extractor.self)
          switch extractor.type {
          case .cat: items.append(try subcontainerCopy.decode(Cat.self))
          case .dog: items.append(try subcontainerCopy.decode(Dog.self))
          default: break
          }
      }
      self.items = items
  }
}
