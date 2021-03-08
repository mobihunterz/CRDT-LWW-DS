//
//  DictNodeTests.swift
//  CRDT_LWWTests
//
//  Created by Paresh Thakor on 08/03/21.
//

import XCTest
@testable import CRDT_LWW

class DictNodeTests: XCTestCase {
    
    func testEmptyDictNoDescription() {
        XCTAssertEqual(DictNode().description, "")
    }
    
    func testEmptyDictNoKeysAndValues() {
        XCTAssertEqual(DictNode().result().count, 0)
    }
    
    func testDictWithKeyValueInit() {
        let node = DictNode("name", "ABC")
        let result = node.result()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.keys.count ?? 0, 1)
        XCTAssertEqual(result.first?.values.count ?? 0, 1)
        XCTAssertEqual(result.first?.keys.first ?? "", "name")
        XCTAssertEqual(result.first?.values.first ?? "", "ABC")
    }
    
    func testAddKeyValuePostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node["gender"]="Male"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Prapti")
        XCTAssertEqual(node["gender"], "Male")
        
        node["job"]="ios"
        XCTAssertEqual(node.result().count, 3)
        XCTAssertEqual(node["name"], "Prapti")
        XCTAssertEqual(node["gender"], "Male")
        XCTAssertEqual(node["job"], "ios")
    }
    
    func testRemoveKeyPostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node.remove("name")
        XCTAssertEqual(node.result().count, 0)
        XCTAssertNil(node["name"])
    }
    
    func testRemoveWrongKeyPostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node.remove("gender")
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        XCTAssertNil(node["gender"])
    }
    
    func testUpdateKeyPostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node["name"]="Jayesha"
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Jayesha")
    }
    
    func testAddUpdateKeyPostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node["gender"] = "Male"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Prapti")
        XCTAssertEqual(node["gender"], "Male")
        
        node["name"] = "Jayesha"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Jayesha")
        XCTAssertEqual(node["gender"], "Male")
    }
    
    func testMultiOpsPostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node["gender"] = "Male"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Prapti")
        XCTAssertEqual(node["gender"], "Male")
        
        node["name"] = "Jayesha"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Jayesha")
        XCTAssertEqual(node["gender"], "Male")
        
        node.remove("gender")
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Jayesha")
        XCTAssertNil(node["gender"])
        
        node["job"] = "ios"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Jayesha")
        XCTAssertEqual(node["job"], "ios")
        
        node["job"] = "android"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Jayesha")
        XCTAssertEqual(node["job"], "android")
    }
    
    func testMultiOpsRemovePostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node["gender"] = "Male"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Prapti")
        XCTAssertEqual(node["gender"], "Male")
        
        node.remove("name")
        XCTAssertEqual(node.result().count, 1)
        XCTAssertNil(node["name"])
        XCTAssertEqual(node["gender"], "Male")
    }
    
    func testReUpdatePostInit() {
        var node = DictNode("name", "Prapti")
        
        XCTAssertEqual(node.result().count, 1)
        XCTAssertEqual(node["name"], "Prapti")
        
        node["gender"] = "Male"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Prapti")
        XCTAssertEqual(node["gender"], "Male")
        
        node.remove("name")
        XCTAssertEqual(node.result().count, 1)
        XCTAssertNil(node["name"])
        XCTAssertEqual(node["gender"], "Male")
        
        node["name"] = "Kalki"
        node["gender"] = "Female"
        XCTAssertEqual(node.result().count, 2)
        XCTAssertEqual(node["name"], "Kalki")
        XCTAssertEqual(node["gender"], "Female")
        
        node.remove("name")
        XCTAssertEqual(node.result().count, 1)
        XCTAssertNil(node["name"])
        XCTAssertEqual(node["gender"], "Female")
        
        node.remove("gender")
        XCTAssertEqual(node.result().count, 0)
        XCTAssertNil(node["name"])
        XCTAssertNil(node["gender"])
    }
    
    func testMergePostInit() {
        let node1 = DictNode("name", "Prapti")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["name"], "Prapti")
        
        let node2 = DictNode("office", "Anand")
        XCTAssertEqual(node2.result().count, 1)
        XCTAssertEqual(node2["office"], "Anand")
        
        let node3 = node1 + node2
        XCTAssertEqual(node3.result().count, 2)
        XCTAssertEqual(node3["name"], "Prapti")
        XCTAssertEqual(node3["office"], "Anand")
    }
    
    func testAddAndMergePostInit() {
        var node1 = DictNode("name", "Prapti")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["name"], "Prapti")
        
        node1["gender"] = "female"
        XCTAssertEqual(node1.result().count, 2)
        XCTAssertEqual(node1["name"], "Prapti")
        XCTAssertEqual(node1["gender"], "female")
        
        var node2 = DictNode("office", "Anand")
        XCTAssertEqual(node2.result().count, 1)
        XCTAssertEqual(node2["office"], "Anand")
        
        node2["address"] = "Petlad"
        XCTAssertEqual(node2.result().count, 2)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["address"], "Petlad")
        
        let node3 = node1 + node2
        XCTAssertEqual(node3.result().count, 4)
        XCTAssertEqual(node3["name"], "Prapti")
        XCTAssertEqual(node3["gender"], "female")
        XCTAssertEqual(node3["office"], "Anand")
        XCTAssertEqual(node3["address"], "Petlad")
    }
    
    func testAddUpdateRemoveAndMergePostInit() {
        var node1 = DictNode("name", "Prapti")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["name"], "Prapti")
        
        node1["gender"] = "female"
        XCTAssertEqual(node1.result().count, 2)
        XCTAssertEqual(node1["name"], "Prapti")
        XCTAssertEqual(node1["gender"], "female")
        
        var node2 = DictNode("office", "Anand")
        XCTAssertEqual(node2.result().count, 1)
        XCTAssertEqual(node2["office"], "Anand")
        
        node2["address"] = "Petlad"
        XCTAssertEqual(node2.result().count, 2)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["address"], "Petlad")
        
        node1.remove("name")
        node1["title"] = "Mrs."
        XCTAssertEqual(node1.result().count, 2)
        XCTAssertNil(node1["name"])
        XCTAssertEqual(node1["title"], "Mrs.")
        XCTAssertEqual(node1["gender"], "female")
        
        node2["village"] = "Badhipura"
        node2["location"] = "county"
        XCTAssertEqual(node2.result().count, 4)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["address"], "Petlad")
        XCTAssertEqual(node2["village"], "Badhipura")
        XCTAssertEqual(node2["location"], "county")
        
        node2.remove("location")
        XCTAssertEqual(node2.result().count, 3)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["address"], "Petlad")
        XCTAssertEqual(node2["village"], "Badhipura")
        
        node2.remove("address")
        node2["residence"] = "metro"
        XCTAssertEqual(node2.result().count, 3)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["village"], "Badhipura")
        XCTAssertEqual(node2["residence"], "metro")
        
        
        let node3 = node1 + node2
        XCTAssertEqual(node3.result().count, 5)
        XCTAssertEqual(node3["title"], "Mrs.")
        XCTAssertEqual(node3["gender"], "female")
        XCTAssertEqual(node3["office"], "Anand")
        XCTAssertEqual(node3["village"], "Badhipura")
        XCTAssertEqual(node3["residence"], "metro")
    }
    
    func testMergeUpdatePostAdd() {
        var node1 = DictNode("name", "Prapti")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["name"], "Prapti")
        
        node1["gender"] = "female"
        XCTAssertEqual(node1.result().count, 2)
        XCTAssertEqual(node1["name"], "Prapti")
        XCTAssertEqual(node1["gender"], "female")
        
        var node2 = DictNode("office", "Anand")
        XCTAssertEqual(node2.result().count, 1)
        XCTAssertEqual(node2["office"], "Anand")
        
        node2["gender"] = "male"
        XCTAssertEqual(node2.result().count, 2)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["gender"], "male")
        
        let node3 = node1 + node2
        XCTAssertEqual(node3.result().count, 3)
        XCTAssertEqual(node3["name"], "Prapti")
        XCTAssertEqual(node3["gender"], "male")
        XCTAssertEqual(node3["office"], "Anand")
    }
    
    func testMergeUpdateRemovePostAdd() {
        var node1 = DictNode("name", "Prapti")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["name"], "Prapti")
        
        node1["gender"] = "female"
        node1["job"] = "ios"
        XCTAssertEqual(node1.result().count, 3)
        XCTAssertEqual(node1["name"], "Prapti")
        XCTAssertEqual(node1["gender"], "female")
        XCTAssertEqual(node1["job"], "ios")
        
        node1["name"] = "Sivana"
        XCTAssertEqual(node1.result().count, 3)
        XCTAssertEqual(node1["name"], "Sivana")
        XCTAssertEqual(node1["gender"], "female")
        XCTAssertEqual(node1["job"], "ios")
        
        var node2 = DictNode("office", "Anand")
        XCTAssertEqual(node2.result().count, 1)
        XCTAssertEqual(node2["office"], "Anand")
        
        node2["gender"] = "male"
        XCTAssertEqual(node2.result().count, 2)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["gender"], "male")
        
        node1.remove("job")
        XCTAssertEqual(node1.result().count, 2)
        XCTAssertEqual(node1["name"], "Sivana")
        XCTAssertEqual(node1["gender"], "female")
        
        let node3 = node1 + node2
        XCTAssertEqual(node3.result().count, 3)
        XCTAssertEqual(node3["name"], "Sivana")
        XCTAssertEqual(node3["gender"], "male")
        XCTAssertEqual(node3["office"], "Anand")
    }
    
    func testMergeMultiplePostAdd() {
        var node1 = DictNode("name", "Prapti")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["name"], "Prapti")
        
        node1["gender"] = "female"
        node1["job"] = "ios"
        XCTAssertEqual(node1.result().count, 3)
        XCTAssertEqual(node1["name"], "Prapti")
        XCTAssertEqual(node1["gender"], "female")
        XCTAssertEqual(node1["job"], "ios")
        
        node1["name"] = "Sivana"
        node1.remove("job")
        XCTAssertEqual(node1.result().count, 2)
        XCTAssertEqual(node1["name"], "Sivana")
        XCTAssertEqual(node1["gender"], "female")
        
        var node2 = DictNode("office", "Anand")
        XCTAssertEqual(node2.result().count, 1)
        XCTAssertEqual(node2["office"], "Anand")
        
        node2["gender"] = "male"
        XCTAssertEqual(node2.result().count, 2)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["gender"], "male")
        
        node2["job"] = "android"
        XCTAssertEqual(node2.result().count, 3)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["gender"], "male")
        XCTAssertEqual(node2["job"], "android")
        
        let node3 = DictNode("village", "Badhipura")
        XCTAssertEqual(node3.result().count, 1)
        XCTAssertEqual(node3["village"], "Badhipura")
        
        let node = node3 + node1 + node2
        XCTAssertEqual(node.result().count, 5)
        XCTAssertEqual(node["office"], "Anand")
        XCTAssertEqual(node["gender"], "male")
        XCTAssertEqual(node["job"], "android")
        XCTAssertEqual(node["village"], "Badhipura")
        XCTAssertEqual(node["name"], "Sivana")
    }
    
    func test2WayMergeRemovePostAdd() {
        var node1 = DictNode("name", "Prapti")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["name"], "Prapti")
        
        node1["job"] = "ios"
        node1.remove("name")
        node1.remove("blank")
        XCTAssertEqual(node1.result().count, 1)
        XCTAssertEqual(node1["job"], "ios")
        
        var node2 = DictNode("office", "Anand")
        XCTAssertEqual(node2.result().count, 1)
        XCTAssertEqual(node2["office"], "Anand")
        
        node2["job"] = "android"
        XCTAssertEqual(node2.result().count, 2)
        XCTAssertEqual(node2["office"], "Anand")
        XCTAssertEqual(node2["job"], "android")
        
        let resNode1 = node1 + node2
        let resNode2 = node2 + node1
        XCTAssertEqual(resNode1.result().count, 2)
        XCTAssertEqual(resNode1.result().count, resNode2.result().count)
        XCTAssertEqual(resNode1["job"], resNode2["job"])
        XCTAssertEqual(resNode1["office"], resNode2["office"])
    }
}
