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
        
        if accessorVM is AddValueAccessorViewModel {
            let valueAccessorVM = accessorVM as! AddValueAccessorViewModel
            let valueAccessor = ValueAccessor(context: self.moc)
            valueAccessor.uniqueID = valueAccessorVM.uniqueID
            valueAccessor.labelName = valueAccessorVM.labelName
            valueAccessor.valueType = valueAccessorVM.valueType
            valueAccessor.topicName = valueAccessorVM.topicName
        }
        
        if accessorVM is AddSwitchAccessorViewModel {
            let switchAccessorVM = accessorVM as! AddSwitchAccessorViewModel
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
}

enum AccessorType {
    case SwitchAccessor
    case ValueAccessor
}
