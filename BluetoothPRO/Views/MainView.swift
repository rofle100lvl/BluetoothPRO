//
//  MainView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import Foundation
import SwiftUI

struct MainView: View {
    let appModel: AppModel
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LazyView(FindUserView(appModel: self.appModel))) {
                    Text("To Find user View")
                }
                NavigationLink(destination: LazyView(FriendsListView(appModel: appModel))) {
                    Text("To Friends List user View")
                }
            }
        }
        .navigationTitle("Main View")
    }
}
