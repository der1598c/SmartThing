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
    
    func saveValueAccessor() {
        CoreDataManager.shared.saveValueAccessor(labelName: labelName, valueType: valueType, topicName: topicName)
    }
}
