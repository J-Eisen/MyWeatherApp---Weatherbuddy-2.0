//
//  MyWeatherAppUITests.swift
//  MyWeatherAppUITests
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest

class GeneralUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_viewSwitching_toSettings() {
        app.navigationBars["WeatherBuddy"].buttons["Settings Default"].tap()
        app.navigationBars["Settings"].buttons["Save"].tap()
        app.navigationBars["WeatherBuddy"].buttons["Settings Default"].tap()
        app.navigationBars["Settings"].buttons["Cancel"].tap()
    }
    
    func test_viewSwitching_toNewBuddy() {
        app.navigationBars["WeatherBuddy"].buttons["NewBuddy CircleBuddy"].tap()
    }
}
