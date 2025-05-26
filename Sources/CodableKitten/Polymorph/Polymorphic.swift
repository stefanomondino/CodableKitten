//
//  File.swift
//  
//
//  Created by Stefano Mondino on 16/09/24.
//

import Foundation

public protocol Polymorphic: Decodable, Sendable {
    associatedtype Extractor: TypeExtractor
    static var typeExtractor: Extractor { get }
}

//public extension Polymorphic {
//    var key: Extractor { Self.extractor }
//}
