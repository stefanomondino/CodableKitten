//
//  File.swift
//  
//
//  Created by Stefano Mondino on 13/09/24.
//

import Foundation
import CodableKitten

struct WatchableType: TypeExtractor, Encodable {
    typealias ObjectType = Watchable
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case subType
    }
    let type: String
    let subType: String?
    private init(type: String, subType: String?) {
        self.type = type
        self.subType = subType
    }

    static func standard(_ value: String) -> Self {
        .init(type: value, subType: nil)
    }
    
    static func custom(_ value: String) -> Self {
        .init(type: "other", subType: value)
    }
}

protocol Watchable: Encodable, Polymorphic where Extractor == WatchableType {
    var name: String { get }
    var type: String { get }
    var subType: String? { get }
}

struct TVShow: Watchable {
    
    static var keyType:WatchableType { .tvShow }
    let name: String
    let isEnded: Bool
    var type: String
    var subType: String?
}

struct Movie: Watchable {
    static var keyType: WatchableType { .movie }
    let name: String
    let year: Int
    var type: String
    var subType: String?
}

struct MusicVideo: Watchable {
    static var keyType: WatchableType { .musicVideo }
    let name: String
    let artist: String
    var type: String
    var subType: String?
}

extension WatchableType {
    static var tvShow: Self { .standard("tvShow") }
    static var movie: Self { .standard("movie") }
    static var musicVideo: Self { .custom("musicVideo") }
}
