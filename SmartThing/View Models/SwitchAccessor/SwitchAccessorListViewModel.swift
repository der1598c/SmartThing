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
        CoreDataManager.shared.deleteAccessor(uniqueID: switchAccessorVM.uniqueID, accessorType: .SwitchAccessor)
        fetchAllSwitchAccessories()
    }
    
    func fetchAllSwitchAccessories() {
        let allSwitchAccessories: [SwitchAccessor] = CoreDataManager.shared.getAllAccessories(accessorType: .SwitchAccessor)!
        self.switchAccessories = allSwitchAccessories.map(SwitchAccessorViewModel.init)
        print(self.switchAccessories)
    }

    
}

class SwitchAccessorViewModel {
    
    var uniqueID:UUID
    var labelName: String
    var topicName_getOn: String
    var topicName_setOn: String
    
    init(switchAccessor: SwitchAccessor) {
        self.uniqueID = switchAccessor.uniqueID!
        self.labelName = switchAccessor.labelName!
        self.topicName_getOn = switchAccessor.topicName_getOn!
        self.topicName_setOn = switchAccessor.topicName_setOn!
    }
    
}
