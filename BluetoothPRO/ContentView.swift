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
    @State var userName: String = ""
    let appModel: AppModel
    
    init(appModel: AppModel) {
        self.appModel = appModel
    }
    
    var body: some View {
        if appModel.currentUser != nil {
            MainView(appModel: appModel)
        } else {
            VStack {
                Text("Choose your photo:")
                Text("Enter your name")
                TextField("Enter your username", text: $userName)
                Button(action: {
                    let user = User(userToken: UUID(), name: userName, photo_url: Data())
                    appModel.networkManager.sendUser(user: user) {
                        self.appModel.currentUser = user
                    }
                }) {
                    Text("Continue")
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appModel: AppModel())
            .preferredColorScheme(.light)
    }
}
