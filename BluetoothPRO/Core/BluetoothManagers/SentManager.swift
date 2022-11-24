import Foundation
import CoreBluetooth

enum Const {
    static let serviceUUID = CBUUID(string: "9ad583f9-433f-4fce-b402-3b6dd4dd4c95")
    static let userInfoCharacteristicUUID = CBUUID(string: "cc74a69c-6527-11ed-9022-0242ac120002")
    static let sendRequestCharacteristicUUID = CBUUID(string: "5bd59929-c735-4342-abd4-7f4b5336055f")
}

struct BluetoothSeviceViewModel {
    let service: CBMutableService
    let userInfoCharacteristic: CBMutableCharacteristic
    let sendRequestCharacteristic: CBMutableCharacteristic
    
    init(service: CBMutableService, userInfoCharacteristicUUID: CBMutableCharacteristic, sendRequestCharacteristic: CBMutableCharacteristic) {
        self.service = service
        self.userInfoCharacteristic = userInfoCharacteristicUUID
        self.sendRequestCharacteristic = sendRequestCharacteristic
    }
    
    static func initSendUserId(data: Data) -> BluetoothSeviceViewModel {
        let service = CBMutableService(type: Const.serviceUUID, primary: true)
        let userInfoCharacteristicUUID = CBMutableCharacteristic(type: Const.userInfoCharacteristicUUID, properties: .read, value: data, permissions: .readable)
        let sendRequestCharacteristic = CBMutableCharacteristic(type: Const.sendRequestCharacteristicUUID, properties: .write, value: nil, permissions: .writeable)
        service.characteristics = [userInfoCharacteristicUUID, sendRequestCharacteristic]
        return self.init(service: service, userInfoCharacteristicUUID: userInfoCharacteristicUUID, sendRequestCharacteristic: sendRequestCharacteristic)
    }
}

final class BroadCastManager: NSObject, ObservableObject {
    @Published var requests: [UUID] = []
    var peripheralManager: CBPeripheralManager? = nil
    var viewModel: BluetoothSeviceViewModel!
    
    init(data: Data) {
        super.init()
        self.viewModel = BluetoothSeviceViewModel.initSendUserId(data: data)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startSearch() {

    }
    
    func stopSeatch() {
        peripheralManager?.stopAdvertising()
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
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == viewModel.sendRequestCharacteristic.uuid {
                guard let data = request.value else { return }
                if let decoded = String(data: data, encoding: .utf8),
                   let uuid = UUID(uuidString: decoded) {
                    self.requests.append(uuid)
                    peripheralManager?.respond(to: request, withResult: .success)
                }
            }
        }
    }
    
    
}
