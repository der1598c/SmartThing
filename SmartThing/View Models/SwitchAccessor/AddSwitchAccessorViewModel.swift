//
//  AddOrUpdateSwitchAccessorViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/12/3.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import SwiftUI

class AddOrUpdateSwitchAccessorViewModel {
    
    var uniqueID = UUID()
    var labelName = ""
    var topicName_getOn = ""
    var topicName_setOn = ""
    
    func saveSwitchAccessor(success: @escaping (Bool) -> ()) {
        if labelName.count != 0 && topicName_getOn.count != 0 && topicName_setOn.count != 0 {
            CoreDataManager.shared.saveAccessor(accessorVM: self)
            success(true)
        } else {
            success(false)
        }
    }
    
    func updateSwitchAccessor(success: @escaping (Bool) -> ()) {
        CoreDataManager.shared.updateAccessor(accessorVM: self) { updateSuccess in
            success(updateSuccess)
        }
    }
}
