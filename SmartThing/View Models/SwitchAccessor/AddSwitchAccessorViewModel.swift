//
//  AddSwitchAccessorViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/24.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import SwiftUI

class AddSwitchAccessorViewModel {
    
    var uniqueID = UUID()
    var labelName: String = ""
    var topicName_getOn: String = ""
    var topicName_setOn: String = ""
    
    func saveSwitchAccessor(success: @escaping (Bool) -> ()) {
        if labelName.count != 0 && topicName_getOn.count != 0 && topicName_setOn.count != 0 {
            CoreDataManager.shared.saveAccessor(accessorVM: self)
            success(true)
        } else {
            success(false)
        }
    }
}
