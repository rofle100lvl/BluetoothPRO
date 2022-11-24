//
//  MainView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import Foundation
import Combine
import PopupView
import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var requests: [User] = []
    let appModel: AppModel
    var store: Set<AnyCancellable> = Set()
    
    init(appModel: AppModel) {
        self.appModel = appModel
        appModel.broadcastManager?.$requests.sink { usersIds in
            for userId in usersIds {
                if self.requests.map({ $0.id }).contains(userId) { continue }
                
                appModel.networkManager.fetchUser(id: userId) { user in
                    self.requests.append(User(dto: user))
                }
            }
        }
        .store(in: &store)
    }
    
    func addToFriend() {
        guard let currentId = self.appModel.currentUser?.id else { return }
        appModel.networkManager.addToFriend(query: AddToFriendQuery(first_id: currentId, second_id: requests[0].id)) {
            
        }
    }
}

struct MainView: View {
    @State var isShowing: Bool = false
    @ObservedObject var vm: MainViewModel
    
    init(appModel: AppModel) {
        vm = MainViewModel(appModel: appModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(vm.appModel.currentUser!.name)
                Image(uiImage: UIImage(data: vm.appModel.currentUser!.photo_data)!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(25)
                NavigationLink(destination: LazyView(FindUserView(appModel: self.vm.appModel))) {
                    Text("To Find user View")
                }
                NavigationLink(destination: LazyView(FriendsListView(appModel: vm.appModel))) {
                    Text("To Friends List user View")
                }
            }
            .popup(isPresented: $isShowing) {
                VStack {
                    Text("Добавить в друзья?")
                    FriendCell(user: self.vm.requests[0])
                        .frame(width: 400, height: 400)
                        .background(Color(red: 0.85, green: 0.8, blue: 0.95))
                        .cornerRadius(30.0)
                    HStack {
                        Button(action: {
                            vm.addToFriend()
                        }) {
                            Image(systemName: "checkmark")
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.black)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        Button(action: {}) {
                            Image(systemName: "xmark")
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.black)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        
                    }
                }
            }
        }
        .onChange(of: vm.requests) { newValue in
            isShowing = true
        }
        .navigationTitle("Main View")
    }
}
