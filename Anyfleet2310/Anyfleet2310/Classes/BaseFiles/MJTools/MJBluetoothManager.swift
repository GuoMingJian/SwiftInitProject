//
//  MJBluetoothManager.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/3/16.
//

import UIKit
import CoreBluetooth

class MJBluetoothManager: NSObject {
    struct BluetoothData {
        var peripheral: CBPeripheral
        var advertisementData: NSDictionary
        var RSSI: String
    }
    
    // 单例模式
    static var shared: MJBluetoothManager {
        struct Static {
            static var instance: MJBluetoothManager?
        }
        if Static.instance == nil {
            Static.instance = MJBluetoothManager()
            //
            Static.instance?.handleBluetoothDelegate()
            //
            Static.instance?.bluetoothAuthorize(completed: { isAuthorize in
                if !isAuthorize {
                    let currentVC = UIView.topMostController()
                    MJAuthorize.goToSetting(appAuthorityKind: .BlueTooth, currentVC: currentVC)
                }
            })
        }
        //
        return Static.instance!
    }
    
    /// 蓝牙
    public var babyBluetooth: BabyBluetooth = BabyBluetooth.share()
    
    /// channel
    public var channelOnPeripheralView: String = "peripheralView"
    
    /// 以 bluetoothFilter 为开头进行过滤
    public var bluetoothFilter: String = "AT_"
    
    /// 扫描时间，超过时间停止扫描
    public var scanOverTime: Int32 = 30
    
    /// 已扫描的设备列表
    public var bluetoothScannedList: Array<BluetoothData> = []
    
    /// 当前连接的 Peripheral
    public var currentPeripheral: CBPeripheral?
    
    // ============================================ //
    public var writeCBCharacteristic: CBCharacteristic?
    public var notifyCBCharacteristic: CBCharacteristic?
    
    public let serviceUUID: String = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
    public let writeUUID: String = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
    public let notifyUUID: String = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
    
    private var isParse = false
    private var orderType: UInt8 = 0
    
    // =========== 自定义Block =============
    typealias BluetoothDidChanged = (( _ bluetoothList: Array<BluetoothData>,  _ indexPath: IndexPath) -> Void)
    /// 已扫描数据更了（配合动画）
    public var existDataChanged: BluetoothDidChanged?
    /// 新增扫描数据（配合动画）
    public var newDataChanged: BluetoothDidChanged?
    /// 数据改变，用于reloadData
    public var dataDidChanged: ((_ bluetoothList: Array<BluetoothData>) -> Void)?
    /// 超时已结束扫描
    public var endedBlock: (() -> Void)?
    // ---------------------------------------
    /// 指令回调
    typealias OrderResultBlock = (_ isSuccess: Bool) -> Void
    /// 连接回调
    typealias ConnectedBlock = (_ isSuccess: Bool, _ name: String) -> Void
    /// 蓝牙Tag连接状态
    public var bluetoothConnectedBlock: ConnectedBlock?
    /// 撤防指令是否成功回调
    private var bluetoothDisarmedBlock: OrderResultBlock?
    
    public func bluetoothAuthorize(completed: @escaping (_ isAuthorize: Bool) -> Void) {
        let granted = CBPeripheralManager.authorizationStatus()
        switch granted {
        case .denied:
            /// 未授权
            completed(false)
        case .notDetermined:
            /// 不确定
            completed(false)
        case .restricted :
            /// 受限的
            completed(false)
        case .authorized:
            /// 授权
            completed(true)
        @unknown default:
            completed(false)
        }
    }
    
    // MARK: - 开始扫描蓝牙
    /// 开始扫描蓝牙
    /// - Parameter isRemoveOldData: 是否移除之前已扫描的设备，默认移除。
    public func startScanBluetooth(scanFilter: String = "",
                                   isRemoveOldData: Bool = true) {
        if scanFilter.count > 0 {
            bluetoothFilter = scanFilter
        }
        if isRemoveOldData {
            bluetoothScannedList.removeAll()
        }
        
        // 停止扫描
        stopScanBluetooth()
        // 查找Peripherals
        babyBluetooth.scanForPeripherals()
        // 开始执行
        babyBluetooth.begin()
        // 多少秒后停止扫描
        babyBluetooth.stop(scanOverTime)
        
        print("Bluetooth ===> \(localizedString("bl_start_scan"))")
    }
    
    // MARK: - 停止扫描蓝牙
    /// 停止扫描
    public func stopScanBluetooth() {
        // 停止扫描
        babyBluetooth.cancelScan()
        // 断开所有连接
        babyBluetooth.cancelAllPeripheralsConnection()
    }
    
    // MARK: - 连接蓝牙
    /// 连接蓝牙
    public func connectBluetooth(peripheral: CBPeripheral) {
        currentPeripheral = peripheral
        //
        if currentPeripheral != nil {
            print("Bluetooth ===> \(currentPeripheral?.name ?? "") - 开始连接")
            //
            babyBluetooth.having(currentPeripheral)
            babyBluetooth.channel(channelOnPeripheralView)
            babyBluetooth.connectToPeripherals()
            babyBluetooth.discoverServices()
            babyBluetooth.discoverCharacteristics()
            babyBluetooth.readValueForCharacteristic()
            babyBluetooth.begin()
        }
    }
    
    // MARK: - 断开蓝牙
    /// 断开连接
    public func stopConnectedBluetooth() {
        babyBluetooth.cancelPeripheralConnection(currentPeripheral)
    }
    
    // MARK: - 处理蓝牙委托
    /// 处理蓝牙委托
    private func handleBluetoothDelegate() {
        // 开始扫描
        babyBluetooth.setBlockOnCentralManagerDidUpdateState { [weak self] central in
            guard let _ = self else { return }
        }
        
        // 扫描到设备
        babyBluetooth.setBlockOnDiscoverToPeripherals { [weak self] central, peripheral, advertisementData, RSSI in
            guard let self = self else { return }
            
            // 处理搜索到的蓝牙设备
            guard let dict: NSDictionary = advertisementData as NSDictionary?,
                  let localName: String = dict.object(forKey: "kCBAdvDataLocalName") as? String,
                  let peripheralName: String = peripheral?.name else { return }
            
            if localName.hasPrefix(self.bluetoothFilter) || peripheralName.hasPrefix(self.bluetoothFilter) {
                // 更新已扫描设备数据
                self.insertBlueDataSource(peripheral: peripheral!, advertisementData: dict, RSSI: RSSI!, existDataBlock: self.existDataChanged, newDataBlock: self.newDataChanged)
            }
        }
        
        // 停止扫描
        babyBluetooth.setBlockStop { [weak self] isOverTime in
            guard let self = self else { return }
            
            if isOverTime {
                if let endedBlock = self.endedBlock {
                    endedBlock()
                }
                print("Bluetooth ===> \(localizedString("bl_end_scan"))")
            }
        }
        
        // 设备连接成功，同一个baby对象，使用不同的channel切换委托回调
        babyBluetooth.setBlockOnConnectedAtChannel(channelOnPeripheralView) { [weak self] central, peripheral in
            guard let self = self else { return }
            
            let text = String(format: "%@ %@", peripheral?.name ?? "", localizedString("bl_connect_succeeded"))
            print("Bluetooth ===> \(text)")
            self.currentPeripheral = peripheral
            //
            if let block = self.bluetoothConnectedBlock {
                block(true, peripheral?.name ?? "")
            }
        }
        
        // 设备连接失败
        babyBluetooth.setBlockOnFailToConnectAtChannel(channelOnPeripheralView) { [weak self] central, peripheral, error in
            guard let self = self else { return }
            
            let text = String(format: "%@ %@", peripheral?.name ?? "", localizedString("bl_connect_failed"))
            print("Bluetooth ===> \(text)")
            //
            if let block = self.bluetoothConnectedBlock {
                block(false, peripheral?.name ?? "")
            }
        }
        
        // 设备断开连接
        babyBluetooth.setBlockOnDisconnectAtChannel(channelOnPeripheralView) { [weak self] central, peripheral, error in
            guard let _ = self else { return }
            
            let text = String(format: "%@ %@", peripheral?.name ?? "", localizedString("bl_disconnected"))
            print("Bluetooth ===> \(text)")
        }
        
        babyBluetooth.setBlockOnReadValueForCharacteristicAtChannel(channelOnPeripheralView) { [weak self] peripheral, characteristics, error in
            guard let self = self else { return }
            
            if (characteristics?.uuid.uuidString == self.notifyUUID) && (characteristics?.isNotifying == false) {
                self.currentPeripheral?.setNotifyValue(true, for: characteristics!)
                self.notifyCBCharacteristic = characteristics
            }
            if (characteristics?.uuid.uuidString == self.writeUUID) && (characteristics?.isNotifying == false) {
                self.writeCBCharacteristic = characteristics
            }
            
            if (characteristics?.uuid.uuidString == self.notifyUUID) && (characteristics?.value?.count ?? 0 > 0) {
                self.parseData(data: characteristics?.value ?? Data())
            }
        }
    }
    
    // MARK: - ======================== 业务类代码 ↓↓↓ ========================
    /// 是否已连接蓝牙
    public func isConnectionStatus(deviceId: String,
                                   block: @escaping ((_ isConnected: Bool) -> Void)) {
        MJBluetoothManager.shared.startScanBluetooth(scanFilter: deviceId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let isConnected = self.isConnected(deviceId)
            block(isConnected)
        })
    }
    
    private func isConnected(_ deviceId: String) -> Bool {
        var isConnected: Bool = false
        //
        let peripherals = babyBluetooth.centralManager().retrieveConnectedPeripherals(withServices: [CBUUID(string: serviceUUID)])
        for (_, peripheral) in peripherals.enumerated() {
            if peripheral.name == deviceId {
                print("Bluetooth ===> 已连接设备名称 = \(peripheral.name ?? "")")
                stopScanBluetooth()
                currentPeripheral = peripheral
                connectBluetooth(peripheral: peripheral)
                //
                bluetoothScannedList.append(BluetoothData(peripheral: peripheral, advertisementData: [:], RSSI: "-66"))
                isConnected = true
                break
            }
        }
        //
        return isConnected
    }
    
    // MARK: - 发送指令
    //    /// 布防
    //    public func sendOrderWithArmed() {
    //        let byte: [UInt8] = [0xB5, 0x01]
    //        let data = Data(byte)
    //        sendData(data: data)
    //    }
    
    /// 撤防
    public func sendOrderWithDisarmed(orderResultBlock: OrderResultBlock?,
                                      failure: ((_ message: String) -> Void)) {
        if writeCBCharacteristic == nil || self.currentPeripheral?.state != .connected {
            print("Bluetooth ===> 请重新连接蓝牙设备")
            //
            failure("Reconnect your Bluetooth device.")
        } else {
            let byte: [UInt8] = [0xB5, 0x02]
            let data = Data(byte)
            sendData(data: data)
            //
            self.bluetoothDisarmedBlock = orderResultBlock
        }
    }
    
    private func sendData(data: Data) {
        /* 0: 包头
         1-3: 数据长度，高位在前，低位在后。
         4-N: 标识位+数据。
         N+1: 包尾，CRC8(包尾前的所有数据)
         */
        let bytes = [UInt8](data)
        let type: UInt8 = bytes[0]
        orderType = type
        isParse = true
        let length = UInt32(data.count)
        var header: [UInt8] = [0, 0, 0, 0]
        header[0] = 0x55 // APP -> 设备
        header[1] = UInt8(length >> 16)
        header[2] = UInt8(length >> 8)
        header[3] = UInt8(length)
        var sendData = Data(header)
        sendData.append(data)
        
        let CRC8Data = sendData.CRC8()
        sendData.append(CRC8Data)
        //
        if writeCBCharacteristic != nil {
            self.currentPeripheral?.writeValue(sendData, for: writeCBCharacteristic!, type: .withoutResponse)
        } else {
            print("Bluetooth ===> 请重新连接设备")
        }
    }
    
    // MARK: - Private
    /// 指令解析
    private func parseData(data: Data) {
        if !isParse {
            return
        }
        
        let bytes = [UInt8](data)
        // 包头（第0位）
        if bytes[0] != 0x56 {
            print("Bluetooth ===> 头部指令错误")
            return
        }
        // 标识符（第4位）
        let type: UInt8 = bytes[4]
        if type != orderType {
            print("Bluetooth ===> 指令类型不匹配 type = \(type), orderType = \(orderType)")
            return
        }
        
        switch type {
        case 0xB5: // 布防/撤防
            let result: UInt8 = bytes[5]
            if result == 0x01 {
                // 撤防成功
                if let block = bluetoothDisarmedBlock {
                    block(true)
                    print("Bluetooth ===> 手动撤防成功")
                }
            } else if result == 0x02 {
                // 撤防失败
                if let block = bluetoothDisarmedBlock {
                    block(false)
                    print("Bluetooth ===> 手动撤防失败")
                }
            }
            break
        default:
            // 其它指令暂不处理
            break
        }
        isParse = false
    }
    
    /// 更新已扫描的蓝牙列表数据
    private func insertBlueDataSource(peripheral: CBPeripheral,
                                      advertisementData: NSDictionary,
                                      RSSI: NSNumber,
                                      existDataBlock: BluetoothDidChanged?,
                                      newDataBlock: BluetoothDidChanged?) {
        let name: String = peripheral.name ?? ""
        let adName: String = advertisementData["kCBAdvDataLocalName"] as! String
        let rssi: String = RSSI.stringValue
        if name.elementsEqual(adName) {
            print("Bluetooth ===> 搜索到了设备: [\(name)]-RSSI[\(rssi)]")
        } else {
            print("Bluetooth ===> 搜索到了设备: [\(name)]-[\(adName)]-RSSI[\(rssi)]")
        }
        //
        var isExist: Bool = false
        var indexPath: IndexPath!
        let newData = BluetoothData(peripheral: peripheral, advertisementData: advertisementData, RSSI: rssi)
        for (index, item) in bluetoothScannedList.enumerated() {
            if item.peripheral.name == name || item.peripheral.name == adName {
                isExist = true
                bluetoothScannedList.remove(at: index)
                bluetoothScannedList.insert(newData, at: index)
                //
                if let existDataBlock = existDataBlock {
                    indexPath = IndexPath(row: index, section: 0)
                    existDataBlock(bluetoothScannedList, indexPath)
                    // tableView.reloadRows(at: [indexPath], with: .fade)
                }
                if let dataDidChanged = dataDidChanged {
                    dataDidChanged(bluetoothScannedList)
                }
                break
            }
        }
        
        if !isExist {
            bluetoothScannedList.append(newData)
            //
            if let newDataBlock = newDataBlock {
                indexPath = IndexPath(row: bluetoothScannedList.count - 1, section: 0)
                newDataBlock(bluetoothScannedList, indexPath)
                // tableView.insertRows(at: [indexPath], with: .fade)
            }
            if let dataDidChanged = dataDidChanged {
                dataDidChanged(bluetoothScannedList)
            }
        }
    }
}

// MARK: - CRC8
extension Data {
    func CRC8() -> Data {
        let tableCRC8: [UInt8] = [
            0x00, 0x07, 0x0E, 0x09, 0x1C, 0x1B, 0x12, 0x15,0x38, 0x3F, 0x36, 0x31, 0x24, 0x23, 0x2A, 0x2D,
            0x70, 0x77, 0x7E, 0x79, 0x6C, 0x6B, 0x62, 0x65,0x48, 0x4F, 0x46, 0x41, 0x54, 0x53, 0x5A, 0x5D,
            0xE0, 0xE7, 0xEE, 0xE9, 0xFC, 0xFB, 0xF2, 0xF5, 0xD8, 0xDF, 0xD6, 0xD1, 0xC4, 0xC3, 0xCA, 0xCD,
            0x90, 0x97, 0x9E, 0x99, 0x8C, 0x8B, 0x82, 0x85,0xA8, 0xAF, 0xA6, 0xA1, 0xB4, 0xB3, 0xBA, 0xBD,
            0xC7, 0xC0, 0xC9, 0xCE, 0xDB, 0xDC, 0xD5, 0xD2, 0xFF, 0xF8, 0xF1, 0xF6, 0xE3, 0xE4, 0xED, 0xEA,
            0xB7, 0xB0, 0xB9, 0xBE, 0xAB, 0xAC, 0xA5, 0xA2,0x8F, 0x88, 0x81, 0x86, 0x93, 0x94, 0x9D, 0x9A,
            0x27, 0x20, 0x29, 0x2E, 0x3B, 0x3C, 0x35, 0x32,0x1F, 0x18, 0x11, 0x16, 0x03, 0x04, 0x0D, 0x0A,
            0x57, 0x50, 0x59, 0x5E, 0x4B, 0x4C, 0x45, 0x42,0x6F, 0x68, 0x61, 0x66, 0x73, 0x74, 0x7D, 0x7A,
            0x89, 0x8E, 0x87, 0x80, 0x95, 0x92, 0x9B, 0x9C,0xB1, 0xB6, 0xBF, 0xB8, 0xAD, 0xAA, 0xA3, 0xA4,
            0xF9, 0xFE, 0xF7, 0xF0, 0xE5, 0xE2, 0xEB, 0xEC, 0xC1, 0xC6, 0xCF, 0xC8, 0xDD, 0xDA, 0xD3, 0xD4,
            0x69, 0x6E, 0x67, 0x60, 0x75, 0x72, 0x7B, 0x7C,0x51, 0x56, 0x5F, 0x58, 0x4D, 0x4A, 0x43, 0x44,
            0x19, 0x1E, 0x17, 0x10, 0x05, 0x02, 0x0B, 0x0C,0x21, 0x26, 0x2F, 0x28, 0x3D, 0x3A, 0x33, 0x34,
            0x4E, 0x49, 0x40, 0x47, 0x52, 0x55, 0x5C, 0x5B,0x76, 0x71, 0x78, 0x7F, 0x6A, 0x6D, 0x64, 0x63,
            0x3E, 0x39, 0x30, 0x37, 0x22, 0x25, 0x2C, 0x2B,0x06, 0x01, 0x08, 0x0F, 0x1A, 0x1D, 0x14, 0x13,
            0xAE, 0xA9, 0xA0, 0xA7, 0xB2, 0xB5, 0xBC, 0xBB,0x96, 0x91, 0x98, 0x9F, 0x8A, 0x8D, 0x84, 0x83,
            0xDE, 0xD9, 0xD0, 0xD7, 0xC2, 0xC5, 0xCC, 0xCB, 0xE6, 0xE1, 0xE8, 0xEF, 0xFA, 0xFD, 0xF4, 0xF3]
        var crc = UInt8.min
        let buf: [UInt8] = [UInt8](self)
        for byte in buf {
            let x = crc ^ byte
            crc = tableCRC8[Int(x)]
        }
        return Data(bytes: [crc], count: 1)
    }
}
