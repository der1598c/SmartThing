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
        CoreDataManager.shared.deleteAccessor(labelName: valueAccessorVM.labelName, accessorType: .ValueAccessor)
        fetchAllValueAccessories()
    }
    
    func fetchAllValueAccessories() {
        let allValueAccessories: [ValueAccessor] = CoreDataManager.shared.getAllAccessories(accessorType: .ValueAccessor)!
        self.valueAccessories = allValueAccessories.map(ValueAccessorViewModel.init)
        print(self.valueAccessories)
    }

    
}

class ValueAccessorViewModel {
    
    var labelName = ""
    var valueType = ""
    var topicName = ""
    
    init(valueAccessor: ValueAccessor) {
        self.labelName = valueAccessor.labelName!
        self.valueType = valueAccessor.valueType!
        self.topicName = valueAccessor.topicName!
    }
    
}
