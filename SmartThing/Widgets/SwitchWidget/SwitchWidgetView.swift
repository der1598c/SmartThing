//
//  SwitchWidgetView.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import SwiftUI

struct SwitchWidgetView: View {
    
    @ObservedObject var model: SwitchWidgetViewModel
    
    init(labelName: String, topicName_getOn: String, topicName_setOn: String) {
        self.model = SwitchWidgetViewModel(isOn: true, labelName: labelName, topicName_getOn: topicName_getOn, topicName_setOn: topicName_setOn)
    }
    
    var body: some View {
        
        HStack {
            Image(self.model.switchWidgetModel.isOn! ? "power-ON" : "power-OFF")
                .resizable()
                .frame(width: 60, height: 60)
            Button(self.model.switchWidgetModel.isOn! ? "ON" : "OFF") {
                self.model.setSwitchOn(isOn: !self.model.switchWidgetModel.isOn!)
            }.foregroundColor(self.model.switchWidgetModel.isOn! ? Color.white : Color.gray)
        }
        .onTapGesture {
            self.model.setSwitchOn(isOn: !self.model.switchWidgetModel.isOn!)
        }
        .padding()
        .background(Color(red: 119/255, green: 119/255, blue: 119/255, opacity: 0.6))
        .cornerRadius(16)
        .animation(.default)
        
    }
}

struct SwitchWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchWidgetView(labelName: "Switch", topicName_getOn: "Switch/getOn", topicName_setOn: "Switch/setOn")
    }
}
