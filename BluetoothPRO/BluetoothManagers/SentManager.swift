import Foundation
import CoreBluetooth

enum Const {
    static let serviceUUID = CBUUID(string: "9ad583f9-433f-4fce-b402-3b6dd4dd4c95")
    static let userInfoCharacteristicUUID = CBUUID(string: "cc74a69c-6527-11ed-9022-0242ac120002")
}

struct BluetoothSeviceViewModel {
    let service: CBMutableService
    let userInfoCharacteristicUUID: CBMutableCharacteristic
    
    init(service: CBMutableService, userInfoCharacteristicUUID: CBMutableCharacteristic) {
        self.service = service
        self.userInfoCharacteristicUUID = userInfoCharacteristicUUID
    }
    
    static func initReadable() -> BluetoothSeviceViewModel {
        let service = CBMutableService(type: Const.serviceUUID, primary: true)
        let userInfoCharacteristicUUID = CBMutableCharacteristic(type: Const.userInfoCharacteristicUUID, properties: .read, value: BluetoothSeviceViewModel.fakeUserData(), permissions: .readable)
        service.characteristics = [userInfoCharacteristicUUID]
        return self.init(service: service, userInfoCharacteristicUUID: userInfoCharacteristicUUID)
    }
    
    static func initWritable() -> BluetoothSeviceViewModel {
        let service = CBMutableService(type: Const.serviceUUID, primary: true)
        let userInfoCharacteristicUUID = CBMutableCharacteristic(type: Const.userInfoCharacteristicUUID, properties: .write, value: nil, permissions: .writeable)
        service.characteristics = [userInfoCharacteristicUUID]
        return self.init(service: service, userInfoCharacteristicUUID: userInfoCharacteristicUUID)
    }
    
    static func fakeUserData() -> Data {
        let userData = User(userToken: "fff-553", name: "Roman Gorbenko")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userData) {
            return encoded
        } else {
            return Data()
        }
    }
}

final class BroadCastManager: NSObject {
    var peripheralManager: CBPeripheralManager? = nil
    let viewModel = BluetoothSeviceViewModel.initReadable()
    
    override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
}

extension BroadCastManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            peripheralManager?.add(viewModel.service)
            peripheralManager!.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [Const.serviceUUID]])
        @unknown default:
            fatalError("ooooohhhh nooooo somethinggg bad happeeens")
        }
    }
}
