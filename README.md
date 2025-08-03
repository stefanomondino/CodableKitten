![](CodableKitten.png)

[![Swift Package Tests](https://github.com/stefanomondino/CodableKitten/actions/workflows/test.yml/badge.svg)](https://github.com/stefanomondino/CodableKitten/actions/workflows/test.yml)

CodableKitten is a collection of tools to deal with Swift Codable objects, especially in advanced scenarios involving modularization.

## Key Features

- **Polymorph**: a property wrapper powered way to decode objects into a protocol type when the concrete type is not known in advance.
- **ExtensibleIdentifier**: a safe, non-failing alternative to classic enums that can be extended outside the original declaration (and declaring module)
- **DateValue**: a safe property wrapper to directly convert remote date values into `Date` objects, handling various date formats and time zones. Use `ISO8601DateFormat` for ISO 8601 dates or write your own custom formatter.


## Installation

### Swift Package Manager (SPM)

You can add CodableKitten to your project using [Swift Package Manager](https://swift.org/package-manager/).

#### Xcode
1. Open your project in Xcode.
2. Go to **File > Add Packages...**
3. Enter the package repository URL:
   ```
   https://github.com/stefanomondino/CodableKitten
   ```
4. Select the version you want to install and add the package to your target.

#### Package.swift
Add CodableKitten as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/stefanomondino/CodableKitten", from: "0.1.0")
]
```
Then add `CodableKitten` to your target dependencies:
```swift
targets: [
    .target(
        name: "YourTargetName",
        dependencies: [
            "CodableKitten"
        ]
    )
]
```

## Usage


### Polymorph

Sometimes remote values represent types not known in advance: arrays may contain heterogeneous elements, or properties might vary their contents according to some remote logic. In these cases, you can use the `Polymorph` property wrapper to decode objects into a protocol type.
Example:

```swift
protocol Animal: Polymorphic where Extractor == AnimalType {}

struct AnimalType: StringTypeExtractor, Encodable {
    typealias ObjectType = Animal
    let value: String
    init(_ value: String) { self.value = value }
    static var cat: Self { "cat" }
    static var dog: Self { "dog" }
}

struct Dog: Animal {
    static var typeExtractor: AnimalType { .dog }
    let name: String
    let goodBoy: Bool
}

struct Cat: Animal {
    static var typeExtractor: AnimalType { .cat }
    let name: String
    let isFluffy: Bool
}
```


Given a JSON array like this (see `animals.json`):

```json
[
  {
    "type": "dog",
    "name": "Bingo",
    "goodBoy": true
  },
  {
    "type": "cat",
    "name": "Whiskers",
    "isFluffy": true
  }
]
```

You can decode it as an array of protocol values:

```swift
import Foundation
import CodableKitten

let json = """
[
  { "type": "dog", "name": "Bingo", "goodBoy": true },
  { "type": "cat", "name": "Whiskers", "isFluffy": true }
]
""".data(using: .utf8)!

let decoder = JSONDecoder()
decoder.set(types: [Dog.self, Cat.self], for: AnimalType.self)
let animals = try decoder.decode(Polymorph<AnimalType, [any Animal]>.self, from: json).wrappedValue
for animal in animals {
    print(animal)
}
// Prints: Dog(name: "Bingo", goodBoy: true) and Cat(name: "Whiskers", ...)
```


### ExtensibleIdentifier

When mapping enumerated values from a remote JSON, using Swift enums can lead to decoding errors if client-side-unknown-values are added and sent.

Instead of using a enum, you can do something like

```swift
public struct AnimalType: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
    public let value: String
    public init(_ value: String) {
        self.value = value
    }
    public static var dog: Self { "dog" }
}

```
You'll still be able to switch over an `AnimalType` value, but you can also extend it outside the original declaration and - when needed - even outside the original declaring module.

```swift
extension AnimalType {
    static var cat: Self { "cat" }
}
```
You can also use the compact tagged version, where you associate an identifier to a very specific type (Animal in this example):
```swift
struct Animal {}

public typealias AnimalType = ExtensibleIdentifier<String, Animal>

extension AnimalType {
    static var dog: Self { "dog" }
}
extension AnimalType {
    static var cat: Self { "cat" }
}
```
Use the former if you have many different enumerations associated to the same object (example for animals: breed, country, etc...) and the latter for single enumerations (usually ids or types).

## Roadmap
- Write appropriate documentation
- Write some clear example other than the ones in unit tests
- Improve/add method documentation in code
- Add more tests

## About the name
Choosing the name of a public library is always complex because you need to find something that is easy to remember, possibly short, meaningful and on top of that you need to avoid collisions with internal framework names that might not be visible or known in advance.

I would have loved to call this "CodableKit", but "Kit" is overused by Apple and I wanted to stay away from their names.

[SourceKitten](https://github.com/jpsim/SourceKitten) already went down the cat road and I really liked their move; on top of that, I wanted to tribute something to my late ginger cat Micia (italian for "Kitty"). Felt like the right thing to do :) 
AI helped with a cartoon version of one of her pictures that became this library logo <3

## Contributing

Contributions are welcome! Please open issues or pull requests for bug fixes, improvements, or new features.

## License

MIT License. See [LICENSE](LICENSE) for details.
