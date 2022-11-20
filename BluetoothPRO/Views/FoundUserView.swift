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
        appModel.recieveManager.$nearbyUsersIds.sink { usersId in
            appModel.networkManager.fetchUser(user: UUID()) {
                self.users.append($0)
            }
        }
        .store(in: &store)
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
            HStack {
                ForEach(vm.users) { user in
                    VStack {
                        CircleDataView(data: user.photo_url)
                        Text(user.name)
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
