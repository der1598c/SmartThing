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
    
    var labelName: String = ""
    var topicName_getOn: String = ""
    var topicName_setOn: String = ""
    
    func saveSwitchAccessor() {
        CoreDataManager.shared.saveAccessor(accessorVM: self)
    }
}
