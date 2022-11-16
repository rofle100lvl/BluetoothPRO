//
//  ContentView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 15/11/22.
//

import SwiftUI
import CoreData

struct SomeOtherView: View {
    let manager = BroadCastManager()
    var body: some View {
        Text("SendView")
    }
}

struct ContentView: View {
    @ObservedObject var recieveManager = RecieveManager()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LazyView(SomeOtherView())) {
                    Text("To send View")
                }
                Text("RecieveView")
                if let user = recieveManager.user {
                    Text(user.name)
                    Text(user.userToken)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
