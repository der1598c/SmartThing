//
//  SwitchAccessorListViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/24.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class SwitchAccessorListViewModel: ObservableObject {
    
    @Published
    var switchAccessories = [SwitchAccessorViewModel]()
    
    init() {
        fetchAllSwitchAccessories()
    }
    
    func deleteSwitchAccessor(_ switchAccessorVM: SwitchAccessorViewModel) {
//        CoreDataManager.shared.deleteSwitchAccessor(labelName: switchAccessorVM.labelName)
        CoreDataManager.shared.deleteAccessor(labelName: switchAccessorVM.labelName, accessorType: .SwitchAccessor)
        fetchAllSwitchAccessories()
    }
    
    func fetchAllSwitchAccessories() {
        self.switchAccessories = CoreDataManager.shared.getAllSwitchAccessories().map(SwitchAccessorViewModel.init)
        print(self.switchAccessories)
    }

    
}

class SwitchAccessorViewModel {
    
    var labelName = ""
    var topicName_getOn = ""
    var topicName_setOn = ""
    
    init(switchAccessor: SwitchAccessor) {
        self.labelName = switchAccessor.labelName!
        self.topicName_getOn = switchAccessor.topicName_getOn!
        self.topicName_setOn = switchAccessor.topicName_setOn!
    }
    
}
