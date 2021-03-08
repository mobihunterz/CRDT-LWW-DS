//
//  DictNode.swift
//  CRDT_LWW
//
//  Created by Paresh Thakor on 07/03/21.
//

import Foundation


/**
 DictNode is basically a LWW-CRDT data structure which stores each key/value pair with associated timestamp.
 Timestamp will be the time interval when add/remove element to/from set happened.
 */
public struct DictNode {
    // Add set with keys and associated timestamp
    public var keys: [String: TimeInterval]
    // Removed set with keys and associated timestamp
    public var removedKeys: [String: TimeInterval]
    
    // Values set which holds dictionary key/value pairs
    public var values: [String: String]
    
    init() {
        keys = [:]
        values = [:]
        
        removedKeys = [:]
    }
    
    /**
     Constructor with custom parameters.
     
     e.g. let theNode = DictNode("title", "Mr.") => Stores 'title' into keys and 'Mr.' into values with timestamp.
     */
    init(_ key: String, _ value: String) {
        self.init()
        
        // First element added into the node with initialisation
        self.add(key, value)
    }
    
    /**
     Add function will allow user to add/update a key/value pair into the node only when timestamp for new pair is latest than existing one.
     
     First, keys are being checked from add-set and if add-set has latest value for that key then update will not be required.
     Then, removed set is being checked and if removed-set has latest value for that key then also update wll not be required as it indicated the key is already remove from the dictionary.
     
     New element will be added/updated into add-set only when timestamp for new element is latest.
     */
    private mutating func add(_ key: String, _ value: String, _ timestamp: TimeInterval = Date().timeIntervalSince1970) {
        
        if let exist = keys[key], exist > timestamp {
            // Already updated with latest TS
            return
        } else if let removed = removedKeys[key], removed > timestamp {
            // Already removed with latest TS
            return
        }
        
        keys[key] = timestamp
        values[key] = value
    }
    
    /**
     Remove function will allow user to delete key/value pair from the node only when timestamp for new pair is latest than existing one.
     
     First, keys are being checked from add-set and if add-set has latest value for that key then remove will not be required.
     Then, removed set is being checked and if removed-set has latest value for that key then also remove wll not be required as it indicated the key is already removed from the dictionary.
     
     New element will be removed from dictionary only when timestamp for removed element is latest.
     When we are removing element from the dictionary, we just store key/timestamp pair into removed-set and not actually removing the original key from add-set.
     
     e.g. theNode.remove("name") => Removes the 'name' key from theNode.
     */
    public mutating func remove(_ key: String, _ timestamp: TimeInterval = Date().timeIntervalSince1970) {
        if let exist = keys[key], exist > timestamp {
            return
        } else if let removed = removedKeys[key], removed > timestamp {
            return
        }
        removedKeys[key] = timestamp
    }
    
    /**
     DictNode is using subscripts ([]) to store and get value for particular key.
     
     e.g. theNode["name"] = "Abc" => Then 'name' key will be set with 'Abc' value. If "name" already exists, it will be updated.
     e.g. let val = theNode["name"] => Stores 'Abc' into val.
     */
    public subscript(key: String) -> String? {
        get {
            if let removed = removedKeys[key] {
                if let exist = keys[key], exist > removed {
                    // Removed but added later so right now existing in keys
                    return values[key]
                } else {
                    return nil
                }
            }
            
            return values[key]
        }
        set(newValue) {
            self.add(key, newValue ?? "")
        }
    }
    
    /**
     Listing all key/value pairs which are from add-set and either not in remove-set or in remove-set with respective key timestamp earlier than the timestamp in add-set for that particular key.
     */
    public func result() -> [[String:String]] {
        var results = [[String:String]]()
        keys.forEach { (key, timestamp) in
            if let removed = removedKeys[key], removed >= timestamp {
                // this value is removed
            } else {
                if let theValue = values[key] {
                    results.append([key: theValue])
                }
            }
        }
        
        return results
    }
    
    /**
     Debug description variable.
     */
    public var description: String {
        var itemList = [String]()
        
        for item in self.result() {
            itemList.append("\(item.keys.first ?? "") : \(item.values.first ?? "")")
        }
        
        return itemList.joined(separator: ", ")
    }
    
    /**
     Merge function merges all key/value paris from parameter dictionary into current dictionary.
     i.e. NodeA.merge(NodeB) => {   Union of Add-set from NodeA and NodeB, Union of Remove-set from NodeA and NodeB   }
     
     Merging would not change timestamps so original state would be intact and order of operations will have same effect. (i.e. A + B = B + A)
     */
    public mutating func merge(_ node: DictNode) {
        node.result().forEach { (item) in
            if let exist = node.keys[item.keys.first ?? ""] {
                self.add(item.keys.first ?? "", item.values.first ?? "", exist)
            } else {
                self.add(item.keys.first ?? "", item.values.first ?? "")
            }
        }
        
        node.removedKeys.forEach { (item, timestamp) in
            self.remove(item, timestamp)
        }
    }
    
    /**
     Merge function with operators.
     i.e. A + B => {result.merge(A)}.merge(B)
     */
    public static func +(left: DictNode, right: DictNode) -> DictNode {
        var node = DictNode()
        node.merge(left)
        node.merge(right)
        return node
    }
}


