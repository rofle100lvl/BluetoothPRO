//
//  UserDTO.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 21/11/22.
//

import Foundation

struct UserDTO: Codable {
    var id: UUID
    let name: String
    var photo_data: String
    var friends: [UUID]
}
