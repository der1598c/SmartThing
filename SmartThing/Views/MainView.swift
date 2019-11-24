//
//  MainView.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var switchAccessorListVM: SwitchAccessorListViewModel
    @ObservedObject var valueAccessorListVM: ValueAccessorListViewModel
    @State private var isPresented: Bool = false
    
    init() {
        self.switchAccessorListVM = SwitchAccessorListViewModel()
        self.valueAccessorListVM = ValueAccessorListViewModel()
    }
    
    private func deleteSwitchAccessor(at offsets: IndexSet) {
        offsets.forEach { index in
            let switchAccessorVM = self.switchAccessorListVM.switchAccessories[index]
            self.switchAccessorListVM.deleteSwitchAccessor(switchAccessorVM)
        }
    }
    
    private func deleteValueAccessor(at offsets: IndexSet) {
        offsets.forEach { index in
            let valueAccessorVM = self.valueAccessorListVM.valueAccessories[index]
            self.valueAccessorListVM.deleteValueAccessor(valueAccessorVM)
        }
    }
    
    private func reflashVM() {
        self.switchAccessorListVM.fetchAllSwitchAccessories()
        self.valueAccessorListVM.fetchAllValueAccessories()
    }
    
    var body: some View {
        
        NavigationView {
//            VStack {
//
//                SwitchWidgetView(labelName: "Switch", topicName_getOn: "Switch/getOn", topicName_setOn: "Switch/setOn")
//                    .padding()
//
//                VStack {
//                    ValueWidgetView(labelName: "Temperature", valueType: .Temperature, topicName: "Value/Temperature")
//
//                    ValueWidgetView(labelName: "Humidity", valueType: .Humidity, topicName: "Value/Humidity")
//                }.padding()
//
//            }.background(Color.yellow)
//            .cornerRadius(16)
            
            VStack {
                List {
                    
                    ForEach(self.switchAccessorListVM.switchAccessories, id: \.labelName) { switchAccessor in
                        HStack {
                            
                            SwitchWidgetView(labelName: switchAccessor.labelName, topicName_getOn: switchAccessor.topicName_getOn, topicName_setOn: switchAccessor.topicName_setOn)
                            
                            VStack {
                                
                                Text(switchAccessor.labelName)
                                    .padding([.leading, .trailing], 8)
                                    .font(.title)
                                Spacer()
                                Text(switchAccessor.topicName_getOn)
                                    .padding([.leading, .trailing], 12)
                                    .foregroundColor(Color.gray)
                                Spacer()
                                Text(switchAccessor.topicName_setOn)
                                    .padding([.leading, .trailing], 12)
                                    .foregroundColor(Color.gray)
                                
                            }.background(Color.init(red: 245/255, green: 180/255, blue: 135/255))
                            .cornerRadius(16)
                            .padding()
                            
                            Spacer()
                        }
                    }.onDelete(perform: deleteSwitchAccessor)
                    
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    print("ONDISMISS")
//                    self.switchAccessorListVM.fetchAllSwitchAccessories()
                    self.reflashVM()
                }, content: {
                    AddAccessoriesView(isPresented: self.$isPresented)
                })
                
                List {
                    ForEach(self.valueAccessorListVM.valueAccessories, id: \.labelName) { valueAccessor in
                        HStack {
                            
                            ValueWidgetView(labelName: valueAccessor.labelName,
                                            valueType: valueAccessor.valueType == ValueType.Temperature.rawValue ? ValueType.Temperature : ValueType.Humidity,
                                            topicName: valueAccessor.topicName)
                            
                            VStack {
                                
                                Text(valueAccessor.labelName)
                                    .padding([.leading, .trailing], 8)
                                    .font(.title)
                                Spacer()
                                Text(valueAccessor.topicName)
                                    .padding([.leading, .trailing], 12)
                                    .foregroundColor(Color.gray)
                                
                            }.background(Color.init(red: 135/255, green: 245/255, blue: 240/255))
                            .cornerRadius(16)
                            .padding()
                        }
                    }.onDelete(perform: deleteValueAccessor)
                                
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    print("ONDISMISS")
//                    self.valueAccessorListVM.fetchAllValueAccessories()
                    self.reflashVM()
                }, content: {
                    AddAccessoriesView(isPresented: self.$isPresented)
                })
            }
            .navigationBarTitle("Smart Home")
            .navigationBarItems(trailing: Button("Add Accessor") {
                self.isPresented = true
            })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
