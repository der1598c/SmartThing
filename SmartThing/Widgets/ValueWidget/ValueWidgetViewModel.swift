//
//  ValueWidgetViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation

class ValueWidgetViewModel: ObservableObject {
    
    @Published var valueWidgetModel = ValueWidgetModel()
    @Published var currentMqttStatus: MqttStatus = .OnDisconnected
    private var keyOfIsCelsius = "IS-CELSIUS"
    
    init(value: Double, valueType: ValueType, labelName: String, topicName: String) {
        self.valueWidgetModel.value = value
        self.valueWidgetModel.valueType = valueType
        self.valueWidgetModel.labelName = labelName
        self.valueWidgetModel.topicName = topicName
        self.keyOfIsCelsius.append(self.valueWidgetModel.labelName!)
        self.keyOfIsCelsius.append(self.valueWidgetModel.topicName!)
        
        let userDefaults = UserDefaults.standard
        if let isCelsius: Bool = userDefaults.bool(forKey: keyOfIsCelsius) {
            if isCelsius {
                self.valueWidgetModel.unit = .Celsius
            } else {
                self.valueWidgetModel.unit = .Fahrenheit
            }
        }
        
        MqttManager.shared.delegate.add(self)
        
    }
    
    private func subscribeTopic() {
        MqttManager.shared.subscribe(topic: self.valueWidgetModel.topicName!)
    }
    
    private func setValue(value: Double) {
        
        if self.valueWidgetModel.valueType == .Temperature {
            switch self.valueWidgetModel.unit {
            case .Celsius :
                self.valueWidgetModel.value = value
                break
            case .Fahrenheit :
                //My default unit is Celsius.
                self.valueWidgetModel.value = value.convertToFahrenheit()
                break
            }
        } else {
            self.valueWidgetModel.value = value
        }
        
    }
    
    func toggleUnit() {
        
        if self.currentMqttStatus == .OnReceived {
            return
        }
        
        if self.valueWidgetModel.unit == .Fahrenheit {
            setUnit(unit: .Celsius)
        } else {
            setUnit(unit: .Fahrenheit)
        }
        
    }
    
    private func setUnit(unit: UnitType) {
        
        self.valueWidgetModel.unit = unit
        let isCelsius: Bool = unit == .Celsius
        let userDefaults = UserDefaults.standard
        userDefaults.set(isCelsius, forKey: keyOfIsCelsius)
    }
    
}

extension ValueWidgetViewModel: MqttManagerDelegate {
    
    func onMqttConnected() {
        print("ValueWidgetViewModel\nMqtt connected")
        self.currentMqttStatus = .OnConnected
        subscribeTopic()
    }
    
    func onMqttDisconnected() {
        print("ValueWidgetViewModel\nMqtt disconnected")
        self.currentMqttStatus = .OnDisconnected
    }
    
    func onMqttMessageReceived(message: String, topic: String) {
        print("ValueWidgetViewModel\nMqtt message received\nTopic: \(topic) \nMes: \(message)")
        
        if(topic == self.valueWidgetModel.topicName) {
            let value = Double(message)!
            self.currentMqttStatus = .OnReceived
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.setValue(value: value)
                self.currentMqttStatus = .OnConnected
            }
            
        }
        
    }
    
    func onMqttError(message: String) {
        print("ValueWidgetViewModel\nMqtt error\nMes: \(message)")
    }
}

struct ValueWidgetModel {
    var value: Double?
    var valueType: ValueType?
    var unit: UnitType = .Celsius
    var labelName: String?
    var topicName: String?
}

enum ValueType: String {
    case Temperature = "Temperature"
    case Humidity = "Humidity"
}

enum UnitType {
    case Celsius
    case Fahrenheit
}

extension Double {
    func convertToCelsius() -> Double {
        return (self - 32) * 5/9
    }
    
    func convertToFahrenheit() -> Double {
        return self * 9/5 + 32
    }
}
