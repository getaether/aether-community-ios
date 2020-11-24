
import Foundation
import CoreBluetooth
import UIKit

class BluetoothService: NSObject, CBCentralManagerDelegate {
    
    static let instance = BluetoothService()
    private var manager: CBCentralManager!
    
    private let BEAN_NAME = "Aether Lumni"
    
    private var peripherals: [CBPeripheral] = []
    private var peripheral: CBPeripheral!
    private var managedPeripherals: [AEBluetoothPeripheral] = []

    override private init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppClose), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppOpen), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.onAppOpen()
    }
    
    // MARK: - Central methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        if peripheral.name?.contains(BEAN_NAME) == true {
            
            self.peripherals.append(peripheral)
            manager.connect(peripheral, options: nil)
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let newPeripheral = AEBluetoothPeripheral(peripheral: peripheral)
        
        self.managedPeripherals.append(newPeripheral)
        
        peripheral.discoverServices(nil)
        
        self.peripherals.removeAll { $0 == peripheral }
        
        central.stopScan()
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.peripherals.removeAll(where: { $0 == peripheral } )
    }

    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        self.managedPeripherals.removeAll {
            peripheral == $0.peripheral
        }
    }
    
    // MARK: - Callbacks
    @objc func onAppClose() {
        self.manager.stopScan()
        self.peripherals.forEach { self.manager.cancelPeripheralConnection($0) }
        self.managedPeripherals.forEach { self.manager.cancelPeripheralConnection($0.peripheral) }
        
        self.managedPeripherals.removeAll()
        self.peripherals.removeAll()
        
        self.manager = nil
    }
    
    @objc func onAppOpen() {
        guard self.manager == nil else { return }
        self.manager = CBCentralManager.init(delegate: self, queue: nil)
    }
}
