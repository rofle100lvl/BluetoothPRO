//
//  BluetoothPROApp.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 15/11/22.
//

import SwiftUI

@main
struct BluetoothPROApp: App {

    var body: some Scene {
        WindowGroup {
            RegistrationView(appModel: AppModel())
        }
    }
}
