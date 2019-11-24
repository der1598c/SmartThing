//
//  MqttManager.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import CocoaMQTT

class MqttManager {
    
    enum ConnectionStatus {
        case connecting
        case connected
        case disconnecting
        case disconnected
        case error
        case none
    }
    
    //**************************************
    // MARK: - Init / Data
    
    // Init
    private init() { }
    static let shared = MqttManager()
    
    // Data
    var delegate = MulticastDelegate<MqttManagerDelegate>()
    
    let queue = DispatchQueue(label: "SSDataManager", attributes: [])
    var status = ConnectionStatus.none
    var qosNumber: Int = 0
    var subscribedTopics: [String] = []
    private var mqttClient: CocoaMQTT?
    
    //**************************************
    // MARK: - Methods
    
    func connect(host: String, port: Int, username: String?, password: String?, cleanSession: Bool) {
        
        guard !host.isEmpty else {
            delegate.invoke { (delegate) in
                delegate.onMqttDisconnected()
            }
            return
        }
        
        status = .connecting
        let clientId = "AMakarov-" + String(ProcessInfo().processIdentifier)
        
        mqttClient = CocoaMQTT(clientID: clientId, host: host, port: UInt16(port))
        if let mqttClient = mqttClient {
            
            mqttClient.username = username
            mqttClient.password = password
            mqttClient.keepAlive = UInt16(60)
            mqttClient.cleanSession = cleanSession
            mqttClient.delegate = self
            mqttClient.backgroundOnSocket = true
            mqttClient.connect()
        } else {
            delegate.invoke { (delegate) in
                delegate.onMqttError(message: "Mqtt initialization error")
            }
            status = .error
        }
    }
    
    func subscribe(topic: String) {
        let qos = CocoaMQTTQOS(rawValue: UInt8(qosNumber))!
        mqttClient?.subscribe(topic, qos: qos)
        subscribedTopics.append(topic)
    }
    
    func unsubscribe(topic: String) {
        mqttClient?.unsubscribe(topic)
        subscribedTopics = subscribedTopics.filter { $0 != topic }
    }
    
    func publish(message: String, topic: String) {
        let qos = CocoaMQTTQOS(rawValue: UInt8(qosNumber))!
        mqttClient?.publish(topic, withString: message, qos: qos)
    }
    
    func isConnected() -> Bool {
        return (status == .connected)
    }
    
    func disconnect() {
        if let client = mqttClient {
            status = .disconnecting
            client.disconnect()
        } else {
            status = .disconnected
        }
        
        subscribedTopics.removeAll()
    }
    
    func tryAutoConnect() {
        self.queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { [unowned self] in
            if self.mqttClient?.connState == .disconnected {
                _ = self.mqttClient?.connect()
            }
        }
    }
}

extension MqttManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print("SubscribeTopic")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("Connect: \(host):\(port)")
        status = .connected
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("ConnectAck: \(ack)")
        
        if ack == .accept {
            delegate.invoke { (delegate) in
                delegate.onMqttConnected()
            }
        } else {
            // Connection error
            var errorDescription = "Unknown Error"
            switch ack {
            case .accept:
                errorDescription = "No Error"
            case .unacceptableProtocolVersion:
                errorDescription = "Proto ver"
            case .identifierRejected:
                errorDescription = "Invalid Id"
            case .serverUnavailable:
                errorDescription = "Invalid Server"
            case .badUsernameOrPassword:
                errorDescription = "Invalid Credentials"
            case .notAuthorized:
                errorDescription = "Authorization Error"
            default:
                errorDescription = "Unknown Error"
            }
            
            delegate.invoke { (delegate) in
                delegate.onMqttError(message: errorDescription)
            }
            
            self.disconnect()
        }
        self.status = ack == .accept ? ConnectionStatus.connected : ConnectionStatus.error
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("Disconnect: \(err?.localizedDescription ?? "success")")
        
        if let error = err, status == .connecting {
            delegate.invoke { (delegate) in
                delegate.onMqttError(message: error.localizedDescription)
            }
        }
        
        status = err == nil ? .disconnected : .error
        delegate.invoke { (delegate) in
            delegate.onMqttDisconnected()
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("PublishMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("PublishAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        
        if let string = message.string {
            print("ReceiveMessage: \(string) from topic: \(message.topic)")
            delegate.invoke { (delegate) in
                delegate.onMqttMessageReceived(message: string, topic: message.topic)
            }
        } else {
            print("ReceiveMessage but message is not defined")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("SubscribeTopic")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("UnsubscribeTopic")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) { }
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) { }
}
