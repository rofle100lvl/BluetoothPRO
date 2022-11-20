//
//  User.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 16/11/22.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID {
        userToken
    }
    let userToken: UUID
    let name: String
    let photo_url: Data
}
