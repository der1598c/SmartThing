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
    
    private func fetchSwitchAccessor(labelName: String) -> SwitchAccessor? {
        
        var switchAccessories = [SwitchAccessor]()
        
        let request: NSFetchRequest<SwitchAccessor> = SwitchAccessor.fetchRequest()
        request.predicate = NSPredicate(format: "labelName == %@", labelName)
        
        do {
            switchAccessories = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return switchAccessories.first
        
    }
    
    private func fetchValueAccessor(labelName: String) -> ValueAccessor? {
        
        var valueAccessories = [ValueAccessor]()
        
        let request: NSFetchRequest<ValueAccessor> = ValueAccessor.fetchRequest()
        request.predicate = NSPredicate(format: "labelName == %@", labelName)
        
        do {
            valueAccessories = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return valueAccessories.first
        
    }
    
//    func deleteSwitchAccessor(labelName: String) {
//
//        do {
//            if let switchAccessor = fetchSwitchAccessor(labelName: labelName) {
//                self.moc.delete(switchAccessor)
//                try self.moc.save()
//            }
//        } catch let error as NSError {
//            print(error)
//        }
//
//    }
    
    func deleteAccessor(labelName: String, accessorType: AccessorType) {
        
        switch accessorType {
        case .SwitchAccessor:
            do {
                if let accessor = fetchSwitchAccessor(labelName: labelName) {
                    self.moc.delete(accessor)
                    try self.moc.save()
                }
            } catch let error as NSError {
                print(error)
            }
            break
        case .ValueAccessor:
            do {
                if let accessor = fetchValueAccessor(labelName: labelName) {
                    self.moc.delete(accessor)
                    try self.moc.save()
                }
            } catch let error as NSError {
                print(error)
            }
            break
        }
    }
    
    
    func getAllSwitchAccessories() -> [SwitchAccessor] {
        
        var switchAccessories = [SwitchAccessor]()
        
        let request: NSFetchRequest<SwitchAccessor> = SwitchAccessor.fetchRequest()
        
        do {
            switchAccessories = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return switchAccessories
        
    }
        
    func getAllValueAccessories() -> [ValueAccessor] {
        
        var valueAccessories = [ValueAccessor]()
        
        let request: NSFetchRequest<ValueAccessor> = ValueAccessor.fetchRequest()
        
        do {
            valueAccessories = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return valueAccessories
        
    }
    
    func saveSwitchAccessor(labelName: String, topicName_getOn: String, topicName_setOn: String) {
        
        let switchAccessor = SwitchAccessor(context: self.moc)
        switchAccessor.labelName = labelName
        switchAccessor.topicName_getOn = topicName_getOn
        switchAccessor.topicName_setOn = topicName_setOn
        
        do {
            try self.moc.save()
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func saveValueAccessor(labelName: String, valueType: String, topicName: String) {
        
        let valueAccessor = ValueAccessor(context: self.moc)
        valueAccessor.labelName = labelName
        valueAccessor.valueType = valueType
        valueAccessor.topicName = topicName
        
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
