//
//  AddAccessorView.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/12/3.
//  Copyright © 2019 Leyee. All rights reserved.
//

import SwiftUI

struct AddAccessorView: View {
    
    @Binding var isPresented: Bool
    @Binding var isNeedUpdatete: Bool
    @State var addSwitchAccessorVM = AddOrUpdateSwitchAccessorViewModel()
    @State var addValueAccessorVM = AddOrUpdateValueAccessorViewModel()
    @State private var accessorType: AccessorType = .SwitchAccessor
    @State private var showAlert = false
    
    var body: some View {
        
        NavigationView {
        
        Group {
        
        VStack {
            
            Picker(selection: self.$accessorType, label: Text("Select the accessor to be added.")) {
                Text("Switch Accessor").tag(AccessorType.SwitchAccessor)
                Text("Value Accessor").tag(AccessorType.ValueAccessor)
            }.pickerStyle(SegmentedPickerStyle())
                .padding(16)
            
            if self.accessorType == AccessorType.SwitchAccessor {
                TextField("Enter accessor name", text: self.$addSwitchAccessorVM.labelName)
                    .padding()
                TextField("Enter topic Name for getOn", text: self.$addSwitchAccessorVM.topicName_getOn)
                    .padding()
                TextField("Enter topic Name for setOn", text: self.$addSwitchAccessorVM.topicName_setOn)
                    .padding()
            } else if self.accessorType == AccessorType.ValueAccessor {
                TextField("Enter accessor name", text: self.$addValueAccessorVM.labelName)
                    .padding()
                Picker(selection: self.$addValueAccessorVM.valueType, label: Text("Accessor value type:")) {
                    Text("Temperature").tag(ValueType.Temperature.rawValue)
                    Text("Humidity").tag(ValueType.Humidity.rawValue)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(16)
                TextField("Enter topic Name", text: self.$addValueAccessorVM.topicName)
                    .padding()
            }
            
            Button(action: {
                if self.accessorType == AccessorType.SwitchAccessor {
                    self.addSwitchAccessorVM.saveSwitchAccessor() { success in
                        self.isPresented = !success
                        self.showAlert = !success
                        self.isNeedUpdatete = success
                    }
                } else {
                    self.addValueAccessorVM.saveValueAccessor() { success in
                        self.isPresented = !success
                        self.showAlert = !success
                        self.isNeedUpdatete = success
                    }
                }
                
            }) {
               HStack {
                  Image(systemName: "arrow.uturn.down")
                  Text(self.accessorType == AccessorType.SwitchAccessor ? "Place Switch Accessor" : "Place Value Accessor")
               }
            }.alert(isPresented: $showAlert) { () -> Alert in
               return Alert(title: Text("Please provide complete information"))
            }.padding(16)
            .foregroundColor(Color.white)
            .background(Color.green)
            .cornerRadius(10)
            
            Spacer()
            
        }
        }.padding()
        .navigationBarTitle(self.accessorType == AccessorType.SwitchAccessor ? "Add Switch Accessor" : "Add Value Accessor")
        }
        
    }
}

struct AddAccessorView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccessorView(isPresented: .constant(false), isNeedUpdatete: .constant(false))
    }
}
