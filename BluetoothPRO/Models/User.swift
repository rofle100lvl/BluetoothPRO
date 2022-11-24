//
//  User.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 16/11/22.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: UUID
    let name: String
    var photo_data: Data
    var friends: [UUID]
    var dictionary: [String: Any] {
            return ["id": id,
                    "name": name,
                    "photo_data": photo_data.base64EncodedString(options: .endLineWithLineFeed) ,
                    "friends": friends]
    }
    
    init(id: UUID, name: String, photo_data: Data, friends: [UUID]) {
        self.id = id
        self.name = name
        self.photo_data = photo_data
        self.friends = friends
    }
    
    init(dto: UserDTO) {
        self.id = dto.id
        self.friends = dto.friends
        self.photo_data = Data(base64Encoded: dto.photo_data, options: .ignoreUnknownCharacters)!
        self.name = dto.name
    }
}
