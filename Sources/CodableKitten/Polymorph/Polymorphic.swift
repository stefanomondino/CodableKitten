//
//  File.swift
//  
//
//  Created by Stefano Mondino on 16/09/24.
//

import Foundation
/// This protocol defines a polymorphic type that can be decoded from a encoded object like JSON or Plist.
public protocol Polymorphic: Decodable, Sendable {
    /// The type of the extractor used to determine the concrete type from the encoded data.
    associatedtype Extractor: TypeExtractor
    /// An extractor that can be used to determine the concrete type from the encoded data.
    static var typeExtractor: Extractor { get }
}
