//
//  FoundUserView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 20/11/22.
//

import Combine
import Foundation
import SwiftUI

final class FoundUserViewModel: ObservableObject {
    let appModel: AppModel
    @Published var users: [User] = []
    var store: Set<AnyCancellable> = Set()
    
    init(appModel: AppModel) {
        self.appModel = appModel
        appModel.recieveManager.$nearbyUsersIds.sink { usersIds in
            for userId in usersIds.keys {
                guard let userId = UUID(uuidString: userId) else { continue }
                if self.users.map({ $0.id }).contains(userId) { continue }
                
                appModel.networkManager.fetchUser(id: userId) { user in
                    self.users.append(User(dto: user))
                }
            }
            
        }
        .store(in: &store)
    }
    
    func sendRequest(for index: Int) {
        guard let data = appModel.currentUser?.id.uuidString.data(using: .utf8) else { return }
        appModel.recieveManager.sendRequest(for: users[index].id.uuidString, data: data)
    }
}

struct FoundUserView: View {
    @ObservedObject var vm: FoundUserViewModel
    
    init(appModel: AppModel) {
        self.vm = FoundUserViewModel(appModel: appModel)
    }
    
    var body: some View {
        if vm.users.count == 0 {
            Text("Discovering...")
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(vm.users.indices) { index in
                        FriendCell(user: vm.users[index])
                            .onTapGesture {
                                vm.sendRequest(for: index)
                            }
                    }
                }
            }
        }
    }
}

struct FoundUserView_Previews: PreviewProvider {
    static var previews: some View {
        FoundUserView(appModel: AppModel())
    }
}
