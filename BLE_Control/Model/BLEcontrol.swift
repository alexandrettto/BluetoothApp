//
//  BLEcontrol.swift
//  BLE_Control
//
//  Created by iMac 5K on 15.02.2022.
//

import Foundation
import CoreBluetooth

class BLEcontrol: NSObject {
    
    static let sharedInstance = BLEcontrol()
    
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    private var char_write: CBCharacteristic?
    let vvvv = CBUUID(string: "FFE0")
    let charcterstric_BLE = CBUUID(string: "FFE1")
    var read_value: String!
    
    
    private override init() { }
}



extension BLEcontrol: CBCentralManagerDelegate{
        
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on") // This line starts program to work with BLE
        }
        else {
            print("Все плохо")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let pname = peripheral.name {
            // Discovered peripherals represented by name, in this case only by BT05
            if pname == "BT05" {
                
                    self.centralManager.stopScan() // Stop scanning
                    self.myPeripheral = peripheral // Assigning peripherial
                    self.myPeripheral.delegate = self // delegation peripherial
                    self.centralManager.connect(peripheral, options: nil) // connect
                }
        }
        
    }
    public func startSCAN(){
        centralManager.scanForPeripherals(withServices: nil, options: nil) // Scanning
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        myPeripheral.discoverServices([vvvv])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        //self.createErrorAlert()
    }
}






//
extension BLEcontrol: CBPeripheralDelegate{
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            myPeripheral?.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
      guard let characteristics = service.characteristics else { return }

      for characteristic in characteristics {
          if characteristic.properties.contains(.read){
              peripheral.readValue(for: characteristic)
          }
          if characteristic.properties.contains(.writeWithoutResponse){
             char_write = characteristic
          }
      }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        peripheral.readValue(for: characteristic)
        switch characteristic.uuid{
        case charcterstric_BLE:
            guard let data = characteristic.value else { return }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            read_value = dataString
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
}

extension BLEcontrol {
    func startCentralManager() {
        let centralManagerQueue = DispatchQueue(label: "BLE queue", attributes: .concurrent)
        centralManager = CBCentralManager(delegate: self, queue: centralManagerQueue)
    }
    
    
    func writeOutgoingValue(data: String){
          
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        if let bluefruitPeripheral = myPeripheral {
              
          if let txCharacteristic = char_write {
                  
            bluefruitPeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
              }
          }
      }
    
}


