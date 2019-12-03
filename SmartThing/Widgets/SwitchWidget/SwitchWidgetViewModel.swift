//
//  SwitchWidgetViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import CocoaMQTT

class SwitchWidgetViewModel: ObservableObject {
    
    @Published var switchWidgetModel = SwitchWidgetModel()
    @Published var currentMqttStatus: MqttStatus = .OnDisconnected
    
    init(isOn: Bool, labelName: String, topicName_getOn: String, topicName_setOn: String) {
        self.switchWidgetModel.isOn = isOn
        self.switchWidgetModel.labelName = labelName
        self.switchWidgetModel.topicName_getOn = topicName_getOn
        self.switchWidgetModel.topicName_setOn = topicName_setOn
        
        MqttManager.shared.delegate.add(self)
    }
    
    private func subscribeTopic() {
        MqttManager.shared.subscribe(topic: self.switchWidgetModel.topicName_getOn!)
    }
    
    func setSwitchOn(isOn: Bool) {
        
        if self.currentMqttStatus == .OnReceived {
            return
        }
        
        if self.switchWidgetModel.isOn != isOn {
            self.switchWidgetModel.isOn = isOn
        }
        
        let message = isOn == true ? Status.ON.rawValue : Status.OFF.rawValue
        MqttManager.shared.publish(message: message, topic: self.switchWidgetModel.topicName_setOn!)
    }
}

extension SwitchWidgetViewModel: MqttManagerDelegate {
    
    func onMqttConnected() {
        print("SwitchWidgetViewModel\nMqtt connected")
        self.currentMqttStatus = .OnConnected
        subscribeTopic()
    }
    
    func onMqttDisconnected() {
        print("SwitchWidgetViewModel\nMqtt disconnected")
        self.currentMqttStatus = .OnDisconnected
    }
    
    func onMqttMessageReceived(message: String, topic: String) {
        print("SwitchWidgetViewModel\nMqtt message received\nTopic: \(topic) \nMes: \(message)")
        
        if topic == self.switchWidgetModel.topicName_getOn {
            let status = message == Status.ON.rawValue ? true : false
            self.currentMqttStatus = .OnReceived
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.setSwitchOn(isOn: status)
                self.currentMqttStatus = .OnConnected
            }
        }
        
    }
    
    func onMqttError(message: String) {
        print("SwitchWidgetViewModel\nMqtt error\nMes: \(message)")
    }
    
}

struct SwitchWidgetModel {
    var isOn: Bool?
    var labelName: String?
    var isAvaliable: Bool = false
    var topicName_getOn: String?
    var topicName_setOn: String?
}

enum Status: String {
    case ON = "1"
    case OFF = "0"
}
