//
//  FriendCell.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import SwiftUI

struct FriendCell: View {
    let user: User
    
    var body: some View {
        VStack {
            Text(user.name)
            CircleDataView(data: user.photo_data)
                .aspectRatio(contentMode: .fit)
                
        }
    }
}

struct FriendCell_Previews: PreviewProvider {
    static var previews: some View {
        FriendCell(user: User(id: UUID(), name: "Roma", photo_data: Data(), friends: []))
    }
}
