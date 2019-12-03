//
//  AddOrUpdateValueAccessorViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/12/2.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import SwiftUI

class AddOrUpdateValueAccessorViewModel {
    
    var uniqueID = UUID()
    var labelName = ""
    var valueType = ""
    var topicName = ""
    
    func saveValueAccessor(success: @escaping (Bool) -> ()) {
        if labelName.count != 0 && valueType.count != 0 && topicName.count != 0 {
            CoreDataManager.shared.saveAccessor(accessorVM: self)
            success(true)
        } else {
            success(false)
        }
    }
    
    func updateValueAccessor(success: @escaping (Bool) -> ()) {
        CoreDataManager.shared.updateAccessor(accessorVM: self) { updateSuccess in
            success(updateSuccess)
        }
    }
    
}
