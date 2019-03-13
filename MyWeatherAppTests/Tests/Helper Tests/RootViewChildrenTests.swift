//
//  RootViewChildrenTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 3/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class RootViewChildrenTests: XCTestCase {

    var testChildDelegate: RootViewChildren!
    var testBuddy: Buddy!
    var testWeather: [Weather] = []
    let testNames = ["child1", "child2", "child3", "child4"]
    
    override func setUp() {
        testChildDelegate = RootViewChildren()
        testChildDelegate.childCount = 0
        testBuddy = Buddy.init(location: defaultLocation.0)
        testMode = true
    }

    override func tearDown() {
        testChildDelegate = nil
        testBuddy = nil
        testMode = false
    }

    func test_initializeChildren() {
        testChildDelegate.initializeChildren(names: testNames, buddy: testBuddy)
        XCTAssertEqual(testNames.count, testChildDelegate.childCount, "Child Number Mismatch")
    }
    
    func test_addNewChild(){
        let mainName = "Main", weatherName = "CurrentWeather"
        var testName: String!
        for index in 0...1{
            if index == 0 {
                testName = mainName
            } else {
                testName = weatherName
            }
            testChildDelegate.addNewChild(name: testName, buddy: testBuddy)
            XCTAssertEqual(testChildDelegate.childViewControllers.count, index+1, "Not all controllers initalized")
        }
    }

    func test_updateChild(){
        //TODO: Create mock view controllers
        let testViews: [UIViewController] = []
        let expectedResult = ["updateChild_MainViewController", "updateChild_CurrentWeatherViewController"]
        for index in 0...1 {
        testChildDelegate.updateChild(child: testViews[index], buddy: testBuddy, weather: nil)
            XCTAssertEqual(testChildDelegate.functionCalled, expectedResult[index])
        }
    }
    
    func test_updateAllChildren(){
        //FIXME: Make this NOT reliant on addNewChild()
        
        testChildDelegate.addNewChild(name: "Main", buddy: testBuddy)
        testChildDelegate.addNewChild(name: "CurrentWeather", buddy: testBuddy)
        testChildDelegate.updateAllChildren(buddy: testBuddy, weather: testWeather)
        XCTAssertEqual(testChildDelegate.childCount, 2)
    }
}
