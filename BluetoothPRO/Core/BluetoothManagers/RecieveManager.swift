//
//  RecieveManager.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 15/11/22.
//

import Foundation
import CoreBluetooth
import Combine

class RecieveManager: NSObject, ObservableObject {
    @Published var nearbyUsersIds: [String: CBPeripheral] = [:]
    var centralManager: CBCentralManager? = nil
    var pherials: [CBPeripheral] = []
    var viewModel: BluetoothSeviceViewModel = .initSendUserId(data: Data())

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startSearch() {
        self.centralManager?.scanForPeripherals(withServices: [Const.serviceUUID])
    }
    
    func stopSearch() {
        self.centralManager?.stopScan()
    }
    
    func sendRequest(for userId: String, data: Data) {
        guard let peripheral =  nearbyUsersIds[userId] else { return }
        guard let services = peripheral.services else { return }
        guard let service = services.first(where: { $0.uuid == Const.serviceUUID }),
              let characteristic = service.characteristics?.first(where: { $0.uuid == Const.sendRequestCharacteristicUUID }) else { return }
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
}


extension RecieveManager: CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.pherials.append(peripheral)
        peripheral.delegate = self
        central.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([Const.serviceUUID])
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
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
        @unknown default:
            fatalError("ooooohhhh nooooo somethinggg bad happeeens")
        }
    }
}

extension RecieveManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            if service.uuid == Const.serviceUUID {
                 peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            if characteristic.uuid == Const.userInfoCharacteristicUUID {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let userData = characteristic.value else { return }
        if let decoded = String(data: userData, encoding: .utf8) {
            self.nearbyUsersIds[decoded] = peripheral
        }
    }
    
}
