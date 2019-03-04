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
        
        /*currentWeatherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentWeatherViewController") as? CurrentWeatherViewController
        
        mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        
        settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController*/
        
        testSettings = Settings.init()
        testBuddy = Buddy.init(latitude: defaultCoordinates.0, longitude: defaultCoordinates.1, highTemp: 80, lowTemp: 40, rain: 1, snow: 1, precip: 40, uvIndex: 2, settings: testSettings)
    }

    override func tearDown() {
        testMode = false
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
        let resultsSettings = settingsVC.settings
        XCTAssertNotNil(resultsSettings)
//        checkSettings(expected: testSettings, results: resultsSettings!)
     }
     
     func test_pass_data_settings_to_root_saving(){
        rootVC.buddy = testBuddy
        testSettings.systemType = 1
        testSettings.tempType = 1
        testSettings.precip = 80
        settingsVC.settings = testSettings!
        settingsVC.performSegue(withIdentifier: settingsToRootSave, sender: nil)
        let resultsSettings = rootVC.buddy.settings
        checkSettings(expected: testSettings, results: resultsSettings)
     }
    
    func test_pass_data_settings_to_root_cancel(){
        rootVC.buddy = testBuddy
        testSettings.systemType = 1
        testSettings.tempType = 1
        testSettings.precip = 80
        settingsVC.settings = testSettings!
        settingsVC.performSegue(withIdentifier: settingsToRootCancel, sender: nil)
        let resultsSettings = rootVC.buddy.settings
        testSettings = Settings.init()
        checkSettings(expected: testSettings, results: resultsSettings)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension ViewControllerTests {
    func checkSettings(expected: Settings, results: Settings){
        XCTAssertEqual(expected.buddyType, results.buddyType)
        XCTAssertEqual(expected.systemType, results.systemType)
        XCTAssertEqual(expected.tempType, results.tempType)
        XCTAssertEqual(expected.precip, results.precip)
        XCTAssertEqual(expected.english.highTemp, results.english.highTemp)
        XCTAssertEqual(expected.english.lowTemp, results.english.lowTemp)
        XCTAssertEqual(expected.english.rain, results.english.rain)
        XCTAssertEqual(expected.english.snow, results.english.snow)
        XCTAssertEqual(expected.uvIndex, results.uvIndex)
    }
}
