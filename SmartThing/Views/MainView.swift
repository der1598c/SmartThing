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
    
    private func reflashVM() {
        self.switchAccessorListVM.fetchAllSwitchAccessories()
        self.valueAccessorListVM.fetchAllValueAccessories()
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                List {
                    
                    ForEach(self.switchAccessorListVM.switchAccessories, id: \.uniqueID) { switchAccessor in
                        HStack {
                            
                            SwitchWidgetView(labelName: switchAccessor.labelName, topicName_getOn: switchAccessor.topicName_getOn, topicName_setOn: switchAccessor.topicName_setOn)
                                .frame(minWidth: 0, maxWidth: self.screenSize.height / 5, minHeight: 0, maxHeight: self.screenSize.height / 5)
                            
                            VStack {
//                                Text("\(switchAccessor.uniqueID)")
                                Text(switchAccessor.labelName)
                                    .padding([.leading, .trailing, .top], 8)
                                    .font(.title)
                                Spacer()
                                Text(switchAccessor.topicName_getOn)
                                    .padding([.leading, .trailing], 12)
                                    .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
                                Spacer()
                                Text(switchAccessor.topicName_setOn)
                                    .padding([.leading, .trailing, .bottom], 12)
                                    .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
                                
                            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .background(Color.init(UIColor(named: "switchColor")!))
                            .cornerRadius(16)
                            .padding()
                            
                            Spacer()
                        }
                    }.onDelete(perform: deleteSwitchAccessor)
                    
                    ForEach(self.valueAccessorListVM.valueAccessories, id: \.uniqueID) { valueAccessor in
                        HStack {
                            
                            ValueWidgetView(labelName: valueAccessor.labelName,
                                            valueType: valueAccessor.valueType == ValueType.Temperature.rawValue ? ValueType.Temperature : ValueType.Humidity,
                                            topicName: valueAccessor.topicName)
                            .frame(minWidth: 0, maxWidth: self.screenSize.height / 5, minHeight: 0, maxHeight: self.screenSize.height / 5)
                            
                            VStack {
//                                Text("\(valueAccessor.uniqueID)")
                                Text(valueAccessor.labelName)
                                    .padding([.leading, .trailing, .top], 8)
                                    .font(.title)
                                Spacer()
                                Text(valueAccessor.topicName)
                                    .padding([.leading, .trailing, .bottom], 12)
                                    .foregroundColor(Color.init(UIColor(named: "darkGrayColor")!))
                                
                            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .background(Color.init(UIColor(named: valueAccessor.valueType == ValueType.Temperature.rawValue ? "temperatureColor" : "humidityColor")!))
                            .cornerRadius(16)
                            .padding()
                        }
                    }.onDelete(perform: deleteValueAccessor)
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    print("ONDISMISS")
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
