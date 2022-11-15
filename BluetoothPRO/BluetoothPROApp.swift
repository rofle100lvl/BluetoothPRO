//
//  BluetoothPROApp.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 15/11/22.
//

import SwiftUI

@main
struct BluetoothPROApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
