//
//  MulticastDelegate.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation

class Weak: Equatable {
    
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
    
    static func ==(lhs: Weak, rhs: Weak) -> Bool {
        return lhs.value === rhs.value
    }
}

/**
 *  `MulticastDelegate` Easily create a multi-proxy for a given protocol or class。
 */
open class MulticastDelegate<T>: NSObject {
    
    /**
     *  An array used to store the delegate
     */
    fileprivate var delegates = [Weak]()
    
    /**
     *  Use this property to determine if delegates are empty
     *  If delegates array is empty, return true
     */
    public var isEmpty: Bool {
        
        return delegates.count == 0
    }
    
    /**
     *  Add new delegate to delegates array
     */
    public func add(_ delegate: T) {
        
        guard !self.contains(delegate) else {
            return
        }
        
        delegates.append(Weak(value: delegate as AnyObject))
    }
    
    /**
     *  Delete delegate from delegates array
     */
    public func remove(_ delegate: T) {
        
        let weak = Weak(value: delegate as AnyObject)
        if let index = delegates.index(of: weak) {
            delegates.remove(at: index)
        }
    }
    
    /**
     *  This method is used to trigger the proxy method
     */
    public func invoke(_ invocation: @escaping (T) -> ()) {
        
        clearNil()
        delegates.forEach({
            if let delegate = $0.value as? T {
                invocation(delegate)
            }
        })
    }
    
    /**
     *  This method is used to determine if a delegate already exists in the delegates array.
     */
    private func contains(_ delegate: T) -> Bool {
        
        return delegates.contains(Weak(value: delegate as AnyObject))
    }
    
    /**
     *  This method is used to remove invalid delegate in delegates array.
     */
    private func clearNil() {
        
        delegates = delegates.filter{ $0.value != nil }
    }
    
}

/**
 *  The custom operator implements the addition of the delegate, same with the add
 *
 *  - parameter left:   The multicast delegate
 *  - parameter right:  The delegate to be added
 */
public func +=<T>(left: MulticastDelegate<T>, right: T) {
    
    left.add(right)
}

/**
 *  Custom operators implement delete of the delegate, same as remove
 *
 *  - parameter left:   The multicast delegate
 *  - parameter right:  The delegate to be removed
 */
public func -=<T>(left: MulticastDelegate<T>, right: T) {
    
    left.remove(right)
}


/**
 *  Adding a sequence to a custom type requires adding a method that returns an iterator -> makeIterator() to implement the for loop function.
 */
extension MulticastDelegate: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        clearNil()
        
        var iterator = delegates.makeIterator()
        
        return AnyIterator {
            while let next = iterator.next() {
                if let delegate = next.value {
                    return delegate as? T
                }
            }
            return nil
        }
    }
}
