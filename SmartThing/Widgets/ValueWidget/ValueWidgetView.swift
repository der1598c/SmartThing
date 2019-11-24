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
    }
    
    var body: some View {
        
        HStack {
            
            Image(getIconName(valueType: self.model.valueWidgetModel.valueType!, unit: self.model.valueWidgetModel.unit))
                .resizable()
                .frame(width: 60, height: 60)
            VStack {
                Text(String("\(self.model.valueWidgetModel.labelName!)"))
                .foregroundColor(Color.white)
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
