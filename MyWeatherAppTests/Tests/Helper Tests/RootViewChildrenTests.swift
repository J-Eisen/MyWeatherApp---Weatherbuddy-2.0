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
        testBuddy = Buddy.init(location: defaultTestLocation.0)
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
        let testNames = ["Main", "CurrentWeather"]
        let resultNames = ["MainViewController", "CurrentWeatherViewController"]
        for testName in testNames {
            testChildDelegate.addNewChild(name: testName, buddy: testBuddy)
        }
        XCTAssertEqual(testChildDelegate.testChildViewControllers.count, testNames.count, "Not all controllers initalized")
        for index in 0...testNames.count-1 {
            XCTAssertEqual(testChildDelegate.testChildViewControllers[index], resultNames[index], "View Controllers incorrectly set up")
        }
    }

    func test_updateChild(){
        let mockViews: [UIViewController] = [MainViewController(), CurrentWeatherViewController(), UIViewController()]
        let expectedResult = ["updateChild_MainViewController", "updateChild_CurrentWeatherViewController", "out of bounds"]
        let failText = ["Main", "CurrentWeather", "Exception"]
        for index in 0...2 {
            testChildDelegate.updateChild(child: mockViews[index], buddy: testBuddy, weather: testWeather)
            XCTAssertEqual(testChildDelegate.functionCalled, expectedResult[index], "Test Failed - \(failText[index])")
        }
    }
    
    func test_updateAllChildren(){
        testChildDelegate.updateAllChildren(buddy: testBuddy, weather: testWeather)
        XCTAssertEqual(testChildDelegate.childCount, 2)
    }
}
