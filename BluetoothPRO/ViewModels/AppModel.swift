//
//  AppModel.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 19/11/22.
//

import Foundation
import Combine
import Alamofire

final class AppModel {
    @Published var currentUser: User?
    var recieveManager = RecieveManager()
    var broadcastManager: BroadCastManager? = nil

    let networkManager: ToNetworkManagerProtocol
    var store: Set<AnyCancellable> = Set()
    
    init() {
        networkManager = SomeRealisation()
    }
}
