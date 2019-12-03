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
    @State private var isNeedUpdatete: Bool = false
    
    let screenSize = UIScreen.main.bounds
    
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
    
    private func refetchVMAndreflashView() {
        if self.isNeedUpdatete {
            self.switchAccessorListVM.fetchAllSwitchAccessories()
            self.valueAccessorListVM.fetchAllValueAccessories()
        }
        self.isNeedUpdatete = false
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                List {
                    
                    ForEach(self.switchAccessorListVM.switchAccessories, id: \.uniqueID) { switchAccessor in
                        HStack {
                            
                            NavigationLink(destination:
                                
                                SwitchWidgetDetailsView(uniqueID: switchAccessor.uniqueID, labelName: switchAccessor.labelName, topicName_getOn: switchAccessor.topicName_getOn, topicName_setOn: switchAccessor.topicName_setOn, isNeedUpdatete: self.$isNeedUpdatete)
                                    .onDisappear(){
                                        self.refetchVMAndreflashView()
                                    }
                            ) {
                               
                                HStack {
                                    HStack {
                                        SwitchWidgetView(labelName: switchAccessor.labelName, topicName_getOn: switchAccessor.topicName_getOn, topicName_setOn: switchAccessor.topicName_setOn)
                                        .frame(minWidth: 0, maxWidth: self.screenSize.width / 2, minHeight: 0, maxHeight: self.screenSize.height / 5)
                                    }.padding()
                                    
                                    Text(switchAccessor.labelName)
                                        .font(.title)
                                        .padding([.leading, .trailing, .top, .bottom], 12)
                                        .foregroundColor(Color.init(UIColor(named: "switchLiteColor")!))
                                        
                                    Spacer()
                                }
                                .background(Color.init(UIColor(named: "switchColor")!))
                                .cornerRadius(12)
                            }
                            
                        }
                    }.onDelete(perform: deleteSwitchAccessor)
                    
                    ForEach(self.valueAccessorListVM.valueAccessories, id: \.uniqueID) { valueAccessor in
                        HStack {
                            
                            NavigationLink(destination:
                                
                                ValueWidgetDetailsView(uniqueID: valueAccessor.uniqueID, labelName: valueAccessor.labelName, topicName: valueAccessor.topicName, valueType: valueAccessor.valueType, isNeedUpdatete: self.$isNeedUpdatete)
                                    .onDisappear(){
                                        self.refetchVMAndreflashView()
                                    }
                                
                            ) {
                               
                                HStack {
                                    VStack {
                                        ValueWidgetView(labelName: valueAccessor.labelName,
                                                       valueType: valueAccessor.valueType == ValueType.Temperature.rawValue ? ValueType.Temperature : ValueType.Humidity,
                                                       topicName: valueAccessor.topicName)
                                        .frame(minWidth: 0, maxWidth: self.screenSize.width / 1.2, minHeight: 0, maxHeight: self.screenSize.height / 5)
                                    }.padding()
                                    
                                    Text(valueAccessor.labelName)
                                        .font(.title)
                                        .padding([.leading, .trailing, .top, .bottom], 12)
                                        .foregroundColor(Color.init(UIColor(named: valueAccessor.valueType == ValueType.Temperature.rawValue ? "temperatureLiteColor" : "humidityLiteColor")!))
                                    
                                    Spacer()
                                }
                                .background(Color.init(UIColor(named: valueAccessor.valueType == ValueType.Temperature.rawValue ? "temperatureColor" : "humidityColor")!))
                                .cornerRadius(12)
                                
                            }
                        }
                    }.onDelete(perform: deleteValueAccessor)
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    print("ONDISMISS")
                    self.refetchVMAndreflashView()
                }, content: {
                    AddAccessorView(isPresented: self.$isPresented, isNeedUpdatete: self.$isNeedUpdatete)
                })
                
            }
            .navigationViewStyle(DefaultNavigationViewStyle())
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
