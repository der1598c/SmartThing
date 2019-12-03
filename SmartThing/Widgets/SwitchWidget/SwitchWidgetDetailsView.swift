//
//  SwitchWidgetDetailsView.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/12/3.
//  Copyright © 2019 Leyee. All rights reserved.
//

import SwiftUI

struct SwitchWidgetDetailsView: View {
    
    let uniqueID: UUID
    let labelName: String
    let topicName_getOn: String
    let topicName_setOn: String
    
    @State private var isUpdateSucessed = false
    @State private var showAlert = false
    @State var updateSwitchAccessorVM = AddOrUpdateSwitchAccessorViewModel()
    
    @Binding var isNeedUpdatete: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func preUpdateSwitchAccessor() {
        updateSwitchAccessorVM.uniqueID = self.uniqueID
    }
    
    var body: some View {
        VStack {
                
                Text(labelName)
                        .padding([.leading, .trailing, .top], 12)
                        .font(.title)
                
                TextField("Override name", text: self.$updateSwitchAccessorVM.labelName)
                        .padding([.leading, .trailing, .bottom, .top], 12)
                        .background(Color.init(UIColor(named: "switchColor")!))
                        .cornerRadius(8)
                        .fixedSize()
                
                Text(topicName_getOn)
                        .padding([.leading, .trailing, .top], 12)
                        .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
                
                TextField("Override getOn topic", text: self.$updateSwitchAccessorVM.topicName_getOn)
                        .padding([.leading, .trailing, .bottom, .top], 12)
                        .background(Color.init(UIColor(named: "switchColor")!))
                        .cornerRadius(8)
                        .fixedSize()
                
                Text(topicName_setOn)
                        .padding([.leading, .trailing, .top], 12)
                        .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
            
                TextField("Override setOn topic", text: self.$updateSwitchAccessorVM.topicName_setOn)
                        .padding([.leading, .trailing, .bottom, .top], 12)
                        .background(Color.init(UIColor(named: "switchColor")!))
                        .cornerRadius(8)
                        .fixedSize()
                
                Button(action: {
                    self.preUpdateSwitchAccessor()
                    self.updateSwitchAccessorVM.updateSwitchAccessor() { success in
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
                .background(Color.init(UIColor(named: "switchColor")!))
                .cornerRadius(16)
                .padding()
        }
}

struct SwitchWidgetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchWidgetDetailsView(uniqueID: UUID(), labelName: "Label", topicName_getOn: "GetOnTopic", topicName_setOn: "SetOnTopic", isNeedUpdatete: .constant(false))
    }
}
