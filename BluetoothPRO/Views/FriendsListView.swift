//
//  FriendsListView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import SwiftUI

struct FriendsListView: View {
    @ObservedObject var friendsListModel: FriendsListViewModel
    
    init(appModel: AppModel) {
        self.friendsListModel = FriendsListViewModel(appModel: appModel)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(friendsListModel.friends) { user in
                    FriendCell(user: user)
                }
            }
        }
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(appModel: AppModel())
    }
}
