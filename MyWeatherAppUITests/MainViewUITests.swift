//
//  MainViewUITests.swift
//  MyWeatherAppUITests
//
//  Created by Jonah Eisenstock on 1/26/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest

class MainViewUITests: XCTestCase {
    var app: XCUIApplication!
    var center: XCUICoordinate!
    var left: XCUICoordinate!
    var right: XCUICoordinate!
    var bottom: XCUICoordinate!
    
    override func setUp() {

        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()

        center = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        left = app.coordinate(withNormalizedOffset: CGVector(dx: -5, dy: 0))
        right = app.coordinate(withNormalizedOffset: CGVector(dx: 5, dy: 0))
        bottom = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 5))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_scrollThroughPageViews(){
        app.swipeLeft()
        app.swipeLeft()
        app.swipeRight()
        app.swipeRight()
    }

    func test_reload_buddy() {
        app.swipeDown()
    }
    
    func test_reload_currentWeather(){
        app.swipeLeft()
        app.swipeDown()
    }

}
