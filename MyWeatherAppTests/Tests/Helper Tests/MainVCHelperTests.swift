//
//  MainVCTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 2/17/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class MainVCTests: XCTestCase {
    var testBuddy: Buddy!
    var expectedImage: UIImage!
    var expectedImageString: String!
    var buddyName: String!

    override func setUp() {
        buddyName = defaultBuddyName
        testBuddy = Buddy.init(latitude: defaultLocation.0, longitude: defaultLocation.1, highTemp: 70, lowTemp: 40, rain: 1, snow: 1, precip: 50, uvIndex: 2, settings: Settings.init())
        testBuddy.settings.buddyType = buddyName
        expectedImage = UIImage.init(named: "TestImage")
        testMode = true
    }

    override func tearDown() {
        buddyName = nil
        testBuddy = nil
        expectedImage = nil
        expectedImageString = nil
        testMode = false
    }

    func test_imageBuilder_background() {
        let resultImage = imageBuilder(buddyName: buddyName)
        XCTAssertEqual(expectedImage, resultImage, "Wrong background image loaded")
    }
    
    func test_imageBuilder_buddy(){
        let resultImage = imageBuilder(buddy: testBuddy)
        XCTAssertEqual(expectedImage, resultImage, "Wrong buddy image loaded")
    }
    
    func test_makeImage_background() {
        expectedImageString = "TestBuddy_Background"
        let resultImageString = makeImage(buddyName: buddyName)
        XCTAssertEqual(expectedImageString, resultImageString, "Wrong background image string created")
    }
    
    func test_makeImage_buddy(){
        let expectedImageStringArray = [["HotOutfit", "MediumOutfit", "LightCoat", "HeavyCoat"], ["", "_Rainboots", "_Snowboots", "_Snowboots"]]
        // WeatherData: highTemp: 70, lowTemp: 40, rain: 1, snow: 1, precip: 50
        let testSettingsTemp: [Float] = [25, 30, 45, 75, 80]
        let testSettingsRain: [Float] = [2, 0, 2, 0]
        let testSettingsSnow: [Float] = [2, 2, 0, 0]
        // _ | _R | _S | _(R)S
        var resultImageString = ""
        testBuddy.settings.buddyType = buddyName
        
        for i in 0...3 {
            testBuddy.settings.english.highTemp = testSettingsTemp[i+1]
            testBuddy.settings.english.lowTemp = testSettingsTemp[i]
            for j in 0...7 {
                expectedImageString = "TestBuddy_\(expectedImageStringArray[0][i])"
                if j > 3 {
                    testBuddy.settings.precip = 40
                    expectedImageString.append("_Umbrella")
                } else {
                    testBuddy.settings.precip = 60
                }
                testBuddy.settings.english.rain = testSettingsRain[j%4]
                testBuddy.settings.english.snow = testSettingsSnow[j%4]
                testBuddy.clothingUpdate()
                expectedImageString.append("\(expectedImageStringArray[1][j%4])")
                resultImageString = makeImage(buddy: testBuddy)
            
                XCTAssertEqual(expectedImageString, resultImageString, "Failed at outer loop: \(i) inner loop: \(j)")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
