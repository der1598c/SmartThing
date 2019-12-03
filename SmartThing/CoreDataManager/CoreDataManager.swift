//
//  CoreDataManager.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/24.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(moc: NSManagedObjectContext.current)
    
    var moc: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    private func fetchSwitchAccessor(uniqueID: UUID) -> SwitchAccessor? {
        
        var switchAccessories = [SwitchAccessor]()
        
        let request: NSFetchRequest<SwitchAccessor> = SwitchAccessor.fetchRequest()
        request.predicate = NSPredicate(format: "uniqueID == %@", uniqueID as CVarArg)
        
        do {
            switchAccessories = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return switchAccessories.first
        
    }
    
    private func fetchValueAccessor(uniqueID: UUID) -> ValueAccessor? {
        
        var valueAccessories = [ValueAccessor]()
        
        let request: NSFetchRequest<ValueAccessor> = ValueAccessor.fetchRequest()
        request.predicate = NSPredicate(format: "uniqueID == %@", uniqueID as CVarArg)
        
        do {
            valueAccessories = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return valueAccessories.first
        
    }
    
    func deleteAccessor(uniqueID: UUID, accessorType: AccessorType) {
        
        switch accessorType {
        case .SwitchAccessor:
            do {
                if let accessor = fetchSwitchAccessor(uniqueID: uniqueID) {
                    self.moc.delete(accessor)
                    try self.moc.save()
                }
            } catch let error as NSError {
                print(error)
            }
            break
        case .ValueAccessor:
            do {
                if let accessor = fetchValueAccessor(uniqueID: uniqueID) {
                    self.moc.delete(accessor)
                    try self.moc.save()
                }
            } catch let error as NSError {
                print(error)
            }
            break
        }
    }
    
    func getAllAccessories<T>(accessorType: AccessorType) -> [T]? {
        
        switch accessorType {
            
        case .SwitchAccessor:
            
            var switchAccessories = [SwitchAccessor]()
            
            let request: NSFetchRequest<SwitchAccessor> = SwitchAccessor.fetchRequest()
            
            do {
                switchAccessories = try self.moc.fetch(request)
            } catch let error as NSError {
                print(error)
            }
            
            return (switchAccessories as! [T])
            
        case .ValueAccessor:
            
            var valueAccessories = [ValueAccessor]()
            
            let request: NSFetchRequest<ValueAccessor> = ValueAccessor.fetchRequest()
            
            do {
                valueAccessories = try self.moc.fetch(request)
            } catch let error as NSError {
                print(error)
            }
            
            return (valueAccessories as! [T])
        }
    }
    
    func saveAccessor<T>(accessorVM: T) {
        
        if accessorVM is AddOrUpdateValueAccessorViewModel {
            let valueAccessorVM = accessorVM as! AddOrUpdateValueAccessorViewModel
            let valueAccessor = ValueAccessor(context: self.moc)
            valueAccessor.uniqueID = valueAccessorVM.uniqueID
            valueAccessor.labelName = valueAccessorVM.labelName
            valueAccessor.valueType = valueAccessorVM.valueType
            valueAccessor.topicName = valueAccessorVM.topicName
        }
        
        if accessorVM is AddOrUpdateSwitchAccessorViewModel {
            let switchAccessorVM = accessorVM as! AddOrUpdateSwitchAccessorViewModel
            let switchAccessor = SwitchAccessor(context: self.moc)
            switchAccessor.uniqueID = switchAccessorVM.uniqueID
            switchAccessor.labelName = switchAccessorVM.labelName
            switchAccessor.topicName_getOn = switchAccessorVM.topicName_getOn
            switchAccessor.topicName_setOn = switchAccessorVM.topicName_setOn
        }
        
        do {
            try self.moc.save()
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func updateAccessor<T>(accessorVM: T, updateSuccess: @escaping (Bool) -> ()) {
        
        if accessorVM is AddOrUpdateValueAccessorViewModel {
            do {
                let valueAccessorVM = accessorVM as! AddOrUpdateValueAccessorViewModel
                if let accessor = fetchValueAccessor(uniqueID: valueAccessorVM.uniqueID) {
                    
                    if valueAccessorVM.labelName.count <= 0 && valueAccessorVM.topicName.count <= 0 {
                        updateSuccess(false)
                        return
                    }
                    
                    if valueAccessorVM.labelName.count > 0 { accessor.setValue(valueAccessorVM.labelName, forKey: "labelName") }
                    if valueAccessorVM.topicName.count > 0 { accessor.setValue(valueAccessorVM.topicName, forKey: "topicName") }
                    try self.moc.save()
                    updateSuccess(true)
                }
            } catch let error as NSError {
                print(error)
                updateSuccess(false)
            }
        }
        
        if accessorVM is AddOrUpdateSwitchAccessorViewModel {
            do {
                let switchAccessorVM = accessorVM as! AddOrUpdateSwitchAccessorViewModel
                if let accessor = fetchSwitchAccessor(uniqueID: switchAccessorVM.uniqueID) {
                    
                    if switchAccessorVM.labelName.count <= 0 && switchAccessorVM.topicName_getOn.count <= 0 && switchAccessorVM.topicName_setOn.count <= 0 {
                        updateSuccess(false)
                        return
                    }
                    
                    if switchAccessorVM.labelName.count > 0 { accessor.setValue(switchAccessorVM.labelName, forKey: "labelName") }
                    if switchAccessorVM.topicName_getOn.count > 0 { accessor.setValue(switchAccessorVM.topicName_getOn, forKey: "topicName_getOn") }
                    if switchAccessorVM.topicName_setOn.count > 0 { accessor.setValue(switchAccessorVM.topicName_setOn, forKey: "topicName_setOn") }
                    try self.moc.save()
                    updateSuccess(true)
                } else {
                    
                }
            } catch let error as NSError {
                print(error)
                updateSuccess(false)
            }
        }
        
    }
    
}

enum AccessorType {
    case SwitchAccessor
    case ValueAccessor
}
