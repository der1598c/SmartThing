//
//  AddValueAccessorViewModel.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/24.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import SwiftUI

class AddValueAccessorViewModel {
    
    var labelName: String = ""
    var valueType: String = ""
    var topicName: String = ""
    
    func saveValueAccessor(success: @escaping (Bool) -> ()) {
        if labelName.count != 0 && valueType.count != 0 && topicName.count != 0 {
            CoreDataManager.shared.saveAccessor(accessorVM: self)
            success(true)
        } else {
            success(false)
        }
    }
}
