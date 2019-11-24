//
//  AddAccessoriesView.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import SwiftUI

struct AddAccessoriesView: View {
    
    @Binding var isPresented: Bool
    @State var addSwitchAccessorVM = AddSwitchAccessorViewModel()
    @State var addValueAccessorVM = AddValueAccessorViewModel()
    @State private var accessorType: AccessorType = .SwitchAccessor
    
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
            
            Button("Place SwitchAccessor") {
                // place order
                if self.accessorType == AccessorType.SwitchAccessor {
                    self.addSwitchAccessorVM.saveSwitchAccessor()
                } else {
                    self.addValueAccessorVM.saveValueAccessor()
                }
                self.isPresented = false
                
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

struct AddAccessoriesView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccessoriesView(isPresented: .constant(false))
    }
}
