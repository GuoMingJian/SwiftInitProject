//
//  MJMQTTManager.swift
//  AnyTrekForklift
//
//  Created by 郭明健 on 2023/3/14.
//

import UIKit
import CocoaMQTT

class MJMQTTManager: NSObject {
    /// MQTT配置文件
    struct MQTTModel: Codable {
        var host: String = ""
        var port: String = ""
        var userName: String = ""
        var password: String = ""
        var sendTopic: String = ""
        var receiveTopic: String = ""
        var joinTopic: String = ""
    }
    
    /// MQTT发送消息格式
    struct MQTTSendMessage: Codable {
        /// 叉车名
        var forkliftName: String = ""
        /// 上报时间使用时间戳 13位
        var lastDriving: String = ""
        /// 1为行驶中0为静止
        var status: String = ""
        /// 叉车工作时长（累计xxx秒）
        var onlineTime: Int = 0
    }
    
    /// MQTT接收消息格式
    struct MQTTReceiveMessage: Codable {
        /// 叉车名
        var forkliftName: String = ""
        /// 累计工作时长，单位秒
        var onlineTime: Int = 0
    }
    
    static let shared: MJMQTTManager = MJMQTTManager()
    
    // MQTT
    private var mqtt: CocoaMQTT? {
        didSet {
            if mqtt?.connState == CocoaMQTTConnState.connected {
            }
        }
    }
    
    private var mqttConfiguration: MQTTModel = MQTTModel()
    private var mqttIsConnected: Bool = false
    
    public var didReceiveMessageBlock: ((_ messageModel: MQTTReceiveMessage) -> Void)?
    public var askOnlineTimeBlock: (() -> Void)?
    
    // MARK: - Public
    /// 初始化 MQTT，并连接
    public func setupMQTT() {
        if let mqttModel = getMqttConfiguration() {
            mqttConfiguration = mqttModel
            let clientID = String.randomString(length: 8).md5.uppercased()
            //
            let port: UInt16 = UInt16(mqttModel.port) ?? 0
            mqtt = CocoaMQTT(clientID: clientID, host: mqttModel.host, port: port)
            mqtt?.username = mqttModel.userName
            mqtt?.password = mqttModel.password
            mqtt?.keepAlive = 90
            mqtt?.delegate = self
            //
            mqttIsConnected = mqtt?.connect() ?? false
            if mqttIsConnected {
                print("mqtt======>已连接！")
            }
        }
    }
    
    public func disconnect() {
        mqtt?.disconnect()
    }
    
    /// 发送 MQTT 消息
    public func sendMqttMessage(forkliftName: String,
                                lastDriving: String,
                                status: String,
                                onlineTime: Int = 0) {
        let mqttTopic: String = mqttConfiguration.sendTopic
        let sendModel: MQTTSendMessage = MQTTSendMessage(forkliftName: forkliftName, lastDriving: lastDriving, status: status, onlineTime: onlineTime)
        let mqttContent: String = sendModel.json
        let message = CocoaMQTTMessage(topic: mqttTopic, string: mqttContent, qos: .qos0, retained: false)
        mqtt?.publish(message)
    }
    
    // MARK: - Private
    
    /// 通过配置文件获取 MQTTModel
    private func getMqttConfiguration() -> MQTTModel? {
        if let dict = BaseTools.getDictionaryFormFile(fileName: "mqttConfiguration") {
            if let model: MQTTModel = try? String.performTransToModelObject(type: MQTTModel.self, dictionary: dict) {
                return model
            }
        }
        return nil
    }
}

// MARK: - MQTT
extension MJMQTTManager: CocoaMQTTDelegate {
    ///
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        // 注意一定要连接成功了之后，才能发布主题和订阅主题。
        if ack.description == "accept" {
            // 订阅主题
            mqtt.subscribe(mqttConfiguration.receiveTopic)
            mqtt.subscribe(mqttConfiguration.joinTopic)
        }
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {}
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        if let json = message.string {
            // 询问当前工作时长
            // https://forklift.anytrek.app/#/forklift
            if json.elementsEqual("h5 joined the connection") {
                print("mqtt======> ask online time")
                if askOnlineTimeBlock != nil {
                    askOnlineTimeBlock!()
                }
            } else {
                // 接收累计工作时长
                if let dict: Dictionary<String, Any> = json.toDictionary() as? Dictionary<String, Any> {
                    if let model: MQTTReceiveMessage = try! String.performTransToModelObject(type: MQTTReceiveMessage.self, dictionary: dict) {
                        print("mqtt======>接收到消息：\n\(model)")
                        if didReceiveMessageBlock != nil {
                            didReceiveMessageBlock!(model)
                        }
                    }
                }
            }
        }
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {}
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {}
    
    ///
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    
    ///
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
    
    ///
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {}
}

