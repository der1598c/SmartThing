//
//  ValueWidgetDetailsView.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/12/2.
//  Copyright © 2019 Leyee. All rights reserved.
//

import SwiftUI

struct ValueWidgetDetailsView: View {
    
    let uniqueID: UUID
    let labelName: String
    let topicName: String
    let valueType: String
    
    @State private var isUpdateSucessed = false
    @State private var showAlert = false
    @State var updateValueAccessorVM = AddOrUpdateValueAccessorViewModel()
    
    @Binding var isNeedUpdatete: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func preUpdateValueAccessor() {
        updateValueAccessorVM.uniqueID = self.uniqueID
        updateValueAccessorVM.valueType = self.valueType
    }
    
    var body: some View {
        VStack {
            
            Text(labelName)
                    .padding([.leading, .trailing, .top], 12)
                    .font(.title)
            
            TextField("Override name", text: self.$updateValueAccessorVM.labelName)
                    .padding([.leading, .trailing, .bottom, .top], 12)
                .background(Color.init(UIColor(named: valueType == ValueType.Temperature.rawValue ? "temperatureColor" : "humidityColor")!))
                    .cornerRadius(8)
                    .fixedSize()
            
            Text(topicName)
                    .padding([.leading, .trailing, .top], 12)
                    .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
            
            TextField("Override topic", text: self.$updateValueAccessorVM.topicName)
                    .padding([.leading, .trailing, .bottom, .top], 12)
                    .background(Color.init(UIColor(named: valueType == ValueType.Temperature.rawValue ? "temperatureColor" : "humidityColor")!))
                    .cornerRadius(8)
                    .fixedSize()
            
            Text(valueType)
                    .padding([.leading, .trailing, .top], 12)
                    .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
            
            Button(action: {
                self.preUpdateValueAccessor()
                self.updateValueAccessorVM.updateValueAccessor() { success in
                    self.showAlert = !self.showAlert
                    self.isUpdateSucessed = success
                }
                
            }) {
               HStack {
                  Image(systemName: "arrow.uturn.down")
                  Text("Update Accessor")
               }
            }
                .padding(16)
                .foregroundColor(Color.white)
                .background(Color.init(UIColor(named: "buttonColor")!))
                .cornerRadius(10)
                .alert(isPresented: $showAlert) { () -> Alert in
                    var message: String  {
                        isUpdateSucessed ? "Update Completed." : "Update Failed."
                    }
                    return Alert(title: Text(""), message: Text(message), dismissButton: .destructive(Text("OK"), action: {
                        if self.isUpdateSucessed {
                            self.isNeedUpdatete = true
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }))
                }
            
            Spacer()
            Text("\(uniqueID)")
            .padding([.leading, .trailing, .bottom], 12)
            .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
            .fixedSize()
            
        }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.init(UIColor(named: valueType == ValueType.Temperature.rawValue ? "temperatureColor" : "humidityColor")!))
            .cornerRadius(16)
            .padding()
    }
}

struct ValueWidgetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ValueWidgetDetailsView(uniqueID: UUID(), labelName: "Label", topicName: "Topic", valueType: "Temperature", isNeedUpdatete: .constant(false))
    }
}
