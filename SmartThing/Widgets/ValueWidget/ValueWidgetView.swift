//
//  ValueWidgetView.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import SwiftUI

struct ValueWidgetView: View {
    
    @ObservedObject var model: ValueWidgetViewModel
    
    init(labelName: String, valueType: ValueType, topicName: String) {
        self.model = ValueWidgetViewModel(value: 0.0, valueType: valueType, labelName: labelName, topicName: topicName)
        self.model.currentMqttStatus = .OnDisconnected
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text(String("\(self.model.valueWidgetModel.valueType!)"))
                .foregroundColor(Color.white)
                
                if self.model.currentMqttStatus == .OnConnected {
                    Image("onConnected")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                if self.model.currentMqttStatus == .OnDisconnected {
                    Image("onDisconnected")
                    .resizable()
                    .frame(width: 15, height: 15)
                }
                if self.model.currentMqttStatus == .OnReceived {
                    Image("onReceived")
                    .resizable()
                    .frame(width: 15, height: 15)
                }
            }
            HStack {
                Image(getIconName(valueType: self.model.valueWidgetModel.valueType!, unit: self.model.valueWidgetModel.unit))
                .resizable()
                .frame(width: 60, height: 60)
                Text(String(format: "%.0f", self.model.valueWidgetModel.value!))
                    .foregroundColor(Color.white)
            }
            
        }
        .onTapGesture {
            self.model.toggleUnit()
        }
        .padding()
        .background(Color(red: 119/255, green: 119/255, blue: 119/255, opacity: 0.6))
        .cornerRadius(16)
        .animation(.default)
        
    }
    
    private func getIconName(valueType: ValueType, unit: UnitType) -> String {
        if valueType == .Temperature {
            if unit == .Fahrenheit {
                return "temperature-F"
            } else {
                return "temperature-C"
            }
        } else {
            return "humidity"
        }
    }
    
}

struct ValueWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ValueWidgetView(labelName: "Temperature", valueType: .Temperature, topicName: "Value")
    }
}
