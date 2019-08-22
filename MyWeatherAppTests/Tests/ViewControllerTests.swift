//
//  ViewControllerTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 2/18/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class ViewControllerTests: XCTestCase {

    var rootVC: RootViewController!
    var currentWeatherVC: CurrentWeatherViewController!
    var mainVC: MainViewController!
    var settingsVC: SettingsViewController!
    var testBuddy: Buddy!
    var testSettings: Settings!
    
    override func setUp() {
        testMode = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        rootVC = storyboard.instantiateViewController(withIdentifier: "RootViewController") as? RootViewController
        currentWeatherVC = storyboard.instantiateViewController(withIdentifier: "CurrentWeatherViewController") as? CurrentWeatherViewController
        mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        
        currentWeatherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentWeatherViewController") as? CurrentWeatherViewController
        
        mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        
        settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        
        testSettings = Settings.init()
        testBuddy = Buddy.init(latitude: defaultTestCoordinates.0, longitude: defaultTestCoordinates.1, highTemp: 80, lowTemp: 40, rain: 1, snow: 1, precip: 40, uvIndex: 2, settings: testSettings)
    }

    override func tearDown() {
        testMode = false
        segueString = nil
        rootVC = nil
        currentWeatherVC = nil
        mainVC = nil
        settingsVC = nil
        testSettings = nil
        testBuddy = nil
    }
    
    func test_pass_data_root_to_settings(){
        rootVC.buddy = testBuddy
        rootVC.performSegue(withIdentifier: rootToSettings, sender: rootVC)
        XCTAssertNotNil(settingsVC)
        XCTAssertEqual(segueString, "Root To Settings")
     }
     
     func test_pass_data_settings_to_root_saving(){
        rootVC.buddy = testBuddy
        testSettings.systemType = 1
        testSettings.tempType = 1
        testSettings.precip = 80
        settingsVC.settings = testSettings!
        XCTAssertNotNil(settingsVC.settings)
        settingsVC.performSegue(withIdentifier: settingsToRootSave, sender: nil)
        let resultsSettings = rootVC.buddy.settings
        checkSettings(expected: testSettings, results: resultsSettings, testName: "Data Pass: SettingsToRoot Saving")
        XCTAssertEqual(segueString, "Saving")
     }
    
    func test_pass_data_settings_to_root_cancel(){
        rootVC.buddy = testBuddy
        testSettings.systemType = 1
        testSettings.tempType = 1
        testSettings.precip = 80
        settingsVC.settings = testSettings!
        settingsVC.performSegue(withIdentifier: settingsToRootCancel, sender: nil)
        XCTAssertEqual(segueString, "Canceling")
        let resultsSettings = rootVC.buddy.settings
        testSettings = Settings.init()
        checkSettings(expected: testSettings, results: resultsSettings, testName: "Data Pass: SettingsToRoot Cancel")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension ViewControllerTests {
    func checkSettings(expected: Settings, results: Settings, testName: String){
        XCTAssertEqual(expected.buddyType, results.buddyType, "BuddyType Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.systemType, results.systemType, "SystemType Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.tempType, results.tempType, "TempType Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.precip, results.precip, "Precipitation Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.highTemp, results.english.highTemp, "HighTemp Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.lowTemp, results.english.lowTemp, "LowTemp Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.rain, results.english.rain, "English.Rain Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.snow, results.english.snow, "English.Snow Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.uvIndex, results.uvIndex, "UVIndex Mismatch. Failed in \(testName) test")
    }
}
