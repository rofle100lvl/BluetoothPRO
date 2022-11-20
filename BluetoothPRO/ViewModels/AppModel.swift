//
//  AppModel.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import Foundation
import Combine

final class SomeRealisation: NetworkManagerProtocol {
    func sendUser(user: User, completion: (() -> Void)?) {
        guard let completion = completion else { return }
        completion()
    }
    
    func fetchFriends(user: UUID, completion: (([User]) -> Void)?) {
        guard let completion = completion else { return }
        completion([])
    }
    
    func fetchUser(user: UUID, completion: ((User) -> Void)?) {
        guard let completion = completion else { return }
        completion(User(userToken: UUID(), name: "ns", photo_url: Data()))
    }
}

protocol NetworkManagerProtocol {
    func sendUser(user: User, completion: (() -> Void)?) -> Void
    func fetchFriends(user: UUID, completion: (([User]) -> Void)?) -> Void
    func fetchUser(user: UUID, completion: ((User) -> Void)?)
}

final class AppModel {
    @Published var currentUser: User?
    var recieveManager = RecieveManager()

    let networkManager: NetworkManagerProtocol
    var store: Set<AnyCancellable> = Set()
    
    init() {
        self.currentUser = UserDefaultsManager.shared.get(objectForkey: .user, type: User.self)
        networkManager = SomeRealisation()
        $currentUser
            .sink { UserDefaultsManager.shared.set($0, forKey: .user)}
            .store(in: &store)
    }
}
