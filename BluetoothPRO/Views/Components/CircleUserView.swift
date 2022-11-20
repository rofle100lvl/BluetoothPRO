//
//  CircleUserView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 20/11/22.
//

import SwiftUI

struct CircleDataView: View {
    let data: Data
    
    var body: some View {
        if let image = UIImage(data: data) {
            Image(uiImage: image)
        } else {
            Image(systemName: "heart.fill")
        }
    }
}

struct CircleUserView_Previews: PreviewProvider {
    static var previews: some View {
        CircleDataView(data: Data())
    }
}
