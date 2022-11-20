//
//  FriendListViewModel.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import Foundation

final class FriendsListViewModel: ObservableObject {
    @Published var friends: [User] = []
    let user: User = User(userToken: UUID(), name: "Roma", photo_url: Data())
    let appModel: AppModel
    
    init(appModel: AppModel) {
        self.appModel = appModel
    }
    
    func fetchFriends() {
        appModel.networkManager.fetchFriends(user: user.userToken) { friends in
            self.friends = friends
        }
    }
}
