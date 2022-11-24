//
//  FriendListViewModel.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import Foundation

final class FriendsListViewModel: ObservableObject {
    @Published var userFriends: [User] = []
    let appModel: AppModel
    
    init(appModel: AppModel) {
        self.appModel = appModel
        fetchFriends()
    }
    
    func fetchFriends() {
        appModel.networkManager.fetchFriends(user: appModel.currentUser!.id) { friends in
            friends.forEach {
                self.appModel.networkManager.fetchUser(id: $0) { [self] user in
                    userFriends.append(User(dto: user))
                }
            }
        }
    }
}
