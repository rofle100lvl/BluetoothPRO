//
//  RegistrationViewModel.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 22/11/22.
//

import Foundation
import Combine

final class RegistrationViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    let appModel: AppModel
    var store: Set<AnyCancellable> = Set()

    
    init(appModel: AppModel) {
        self.appModel = appModel
        $currentUser.sink { [weak self] user in
            self?.appModel.currentUser = user
        }
        .store(in: &store)
        let storedUserId = UserDefaultsManager.shared.get(objectForkey: .user, type: UUID.self)
        
        if let storedUserId = storedUserId {
            appModel.networkManager.fetchUser(id: storedUserId) { [weak self] userDTO in
                self?.currentUser = User(dto: userDTO)
            }
        }
        $currentUser
            .sink { [weak self] in
                guard let self = self else { return }
                UserDefaultsManager.shared.set($0?.id, forKey: .user)
                guard let currentUser = $0,
                let userId = currentUser.id.uuidString.data(using: .utf8) else { return }
                self.appModel.broadcastManager = BroadCastManager(data: userId)
                self.appModel.broadcastManager?.startSearch()
            }
            .store(in: &store)
    }
}
