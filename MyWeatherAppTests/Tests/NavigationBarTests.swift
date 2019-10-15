//
//  NavigationBarTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 10/1/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class NavigationBarTests: XCTestCase {
    var mockSettings: Settings!
    var mockBuddy: Buddy!
    var mockButton: UIButton!
    var mockNavBar: NavigationBar!
    var mockViewController: UIViewController!
    
    override func setUp() {
        testMode = true
        let mockEnglishWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[0][0], lowTemp: defaultWeatherData[0][1], rain: defaultWeatherData[0][2], snow: defaultWeatherData[0][3])
        let mockMetricWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[1][0], lowTemp: defaultWeatherData[1][1], rain: defaultWeatherData[1][2], snow: defaultWeatherData[1][3])
        mockSettings = Settings.init(english: mockEnglishWeatherData, metric: mockMetricWeatherData, precip: defaultPrecipitation, uvIndex: defaultUVIndex, dayStart: defaultDay.0, dayEnd: defaultDay.1, zipcode: Double(defaultTestZipcode), locationAuthorization: defaultLocationAuthorization, locationPreferences: defaultLocationPreferences, systemType: defaultTypes.0, tempType: defaultTypes.1, buddyType: defaultBuddyName)
        mockBuddy = Buddy.init(latitude: defaultTestCoordinates.0, longitude: defaultTestCoordinates.1, highTemp: defaultBuddyData[0], lowTemp: defaultBuddyData[1], rain: defaultBuddyData[2], snow: defaultBuddyData[3], precip: defaultBuddyData[4], uvIndex: defaultBuddyData[5], settings: mockSettings)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mockViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController") as? RootViewController
        
        mockButton = UIButton.init()
        
        mockNavBar = NavigationBar()
    }

    override func tearDown() {
        testMode = false
        functionCalled = false
        mockSettings = nil
        mockBuddy = nil
        mockButton = nil
        mockNavBar = nil
        mockViewController = nil
    }

    func testSetUp() {
        mockNavBar.setUp(buddy: mockBuddy, parentViewController: mockViewController)
        XCTAssertTrue(functionCalled, "buttonCalled() never called")
        XCTAssertNotNil(mockButton, "Mock Button not passed back")
        XCTAssertNotNil(mockButton.image(for: .normal), "Normal Image not Assigned")
        XCTAssertNotNil(mockButton.image(for: .disabled), "Disabled Image not Assigned")
    }
    
    func testButtonConstructor(){
        for index in 0...1 {
            mockButton = mockNavBar.buttonConstructor(buddy: mockBuddy, parentViewController: mockViewController, buttonType: index)
            
            XCTAssertTrue(functionCalled, "buttonCalled() never called for buttonType \(index)")
            XCTAssertNotNil(mockButton, "Mock Button not passed back for buttonType \(index)")
            XCTAssertNotNil(mockButton.image(for: .normal), "Normal Image not Assigned for buttonType \(index)")
            XCTAssertNotNil(mockButton.image(for: .disabled), "Disabled Image not Assigned for buttonType \(index)")
            
            functionCalled = false
            mockButton.setImage(nil, for: .normal)
            mockButton.setImage(nil, for: .disabled)
        }
    }
    /*
    func testButtonConstructorConstraints(){
        for index in 0...1 {
            mockButton = mockNavBar.buttonConstructorConstraints(newButton: mockButton, buttonType: index, parentViewController: mockViewController)
            XCTAssertNotNil(mockButton, "mockButton made nil")
            XCTAssertNotNil(mockButton.constraints, "No constraints assigned to button")
            XCTAssertFalse(mockButton.hasAmbiguousLayout, "mockButton has ambiguous constraints")
        }
    }*/
}
