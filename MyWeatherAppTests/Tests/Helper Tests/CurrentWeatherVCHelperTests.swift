//
//  CurrentWeatherVCHelperTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 2/25/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class CurrentWeatherVCHelperTests: XCTestCase {

    var testBuddy: Buddy!
    let testWeather = targetWeather
    
    override func setUp() {
        testMode = true
        testBuddy = Buddy.init(location: defaultLocation.0)
        testBuddy.settings.buddyType = "TestBuddy"
    }

    override func tearDown() {
        testMode = false
        testBuddy = nil
    }

    func test_getHour(){
        let expectedHour = 10
        let resultHour = getCurrentHour()
        XCTAssertEqual(expectedHour, resultHour, "Error: Hour mismatch")
    }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
