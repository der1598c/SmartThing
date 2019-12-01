//
//  ValueAccessorListViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/24.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class ValueAccessorListViewModel: ObservableObject {
    
    @Published
    var valueAccessories = [ValueAccessorViewModel]()
    
    init() {
        fetchAllValueAccessories()
    }
    
    func deleteValueAccessor(_ valueAccessorVM: ValueAccessorViewModel) {
        CoreDataManager.shared.deleteAccessor(uniqueID: valueAccessorVM.uniqueID, accessorType: .ValueAccessor)
        fetchAllValueAccessories()
    }
    
    func fetchAllValueAccessories() {
        let allValueAccessories: [ValueAccessor] = CoreDataManager.shared.getAllAccessories(accessorType: .ValueAccessor)!
        self.valueAccessories = allValueAccessories.map(ValueAccessorViewModel.init)
        print(self.valueAccessories)
    }

    
}

class ValueAccessorViewModel {
    
    var uniqueID:UUID
    var labelName: String
    var valueType: String
    var topicName: String
    
    init(valueAccessor: ValueAccessor) {
        self.uniqueID = valueAccessor.uniqueID!
        self.labelName = valueAccessor.labelName!
        self.valueType = valueAccessor.valueType!
        self.topicName = valueAccessor.topicName!
    }
    
}
