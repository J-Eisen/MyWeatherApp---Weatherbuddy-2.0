//
//  CoreDataTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 2/4/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
import CoreData
@testable import MyWeatherApp

class CoreDataTests: XCTestCase {
    var mockSettings: Settings!
    var mockBuddy: Buddy!
    var mockEnglishWeatherData: Settings.WeatherData!
    var mockMetricWeatherData: Settings.WeatherData!
    
    override func setUp() {
        testMode = true
        mockEnglishWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[0][0], lowTemp: defaultWeatherData[0][1], rain: defaultWeatherData[0][2], snow: defaultWeatherData[0][3])
        mockMetricWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[1][0], lowTemp: defaultWeatherData[1][1], rain: defaultWeatherData[1][2], snow: defaultWeatherData[1][3])
        mockSettings = Settings.init(english: mockEnglishWeatherData, metric: mockMetricWeatherData, precip: defaultPrecipitation, uvIndex: defaultUVIndex, dayStart: defaultDay.0, dayEnd: defaultDay.1, zipcode: Double(defaultZipcode), locationAuthorization: defaultLocationAuthorization, locationPreferences: defaultLocationPreferences, systemType: defaultTypes.0, tempType: defaultTypes.1, buddyType: defaultBuddyName)
        mockBuddy = Buddy.init(latitude: defaultCoordinates.0, longitude: defaultCoordinates.1, highTemp: defaultBuddyData[0], lowTemp: defaultBuddyData[1], rain: defaultBuddyData[2], snow: defaultBuddyData[3], precip: defaultBuddyData[4], uvIndex: defaultBuddyData[5], settings: mockSettings)
    }

    override func tearDown() {
        testMode = false
        mockSettings = nil
        mockBuddy = nil
        saveDataCalled = false
        managedContextChanged = false
    }

    func test_getManagedContext(){
        let resultMC = getManagedContext()
        XCTAssertNotNil(resultMC)
    }
    
    func test_saveData(){
        let resultMC = getManagedContext()
        saveData()
        XCTAssertNotNil(resultMC)
    }
    
    func test_fetchData() {
        var fetchResults: [NSManagedObject]!
        let entityStrings = [settingsEntityString, buddyEntityString]
        for entityString in entityStrings {
            fetchResults = fetchData(entityString: entityString)
            XCTAssertNotNil(fetchResults)
        }
    }
    
    func test_saveBuddy(){
        saveBuddy(buddy: mockBuddy)
        let managedContext = getManagedContext()
        XCTAssertTrue(saveDataCalled, "saveBuddy() never called saveData()")
        XCTAssertTrue(managedContextChanged, "managedContext never changed")
//        managedContext?.fetch(<#T##request: NSFetchRequest<NSFetchRequestResult>##NSFetchRequest<NSFetchRequestResult>#>)
    }
    
    func test_saveSettings(){
        saveSettings(settings: mockSettings)
        XCTAssertTrue(saveDataCalled, "saveSettings() never called saveData()")
        XCTAssertTrue(managedContextChanged, "managedContext never changed")
    }
    
    func test_loadBuddy() {
        let managedContext = getManagedContext()
//        managedContext?.insert(<#T##object: NSManagedObject##NSManagedObject#>)
    }
    
    func test_loadSettings(){
        
    }
}
