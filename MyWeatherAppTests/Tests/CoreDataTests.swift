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
    var mockManagedContext: NSManagedObjectContext!
//    var resultMC: NS
    
    override func setUp() {
        testMode = true
        mockEnglishWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[0][0], lowTemp: defaultWeatherData[0][1], rain: defaultWeatherData[0][2], snow: defaultWeatherData[0][3])
        mockMetricWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[1][0], lowTemp: defaultWeatherData[1][1], rain: defaultWeatherData[1][2], snow: defaultWeatherData[1][3])
        mockSettings = Settings.init(english: mockEnglishWeatherData, metric: mockMetricWeatherData, precip: defaultPrecipitation, uvIndex: defaultUVIndex, dayStart: defaultDay.0, dayEnd: defaultDay.1, zipcode: Double(defaultTestZipcode), locationAuthorization: defaultLocationAuthorization, locationPreferences: defaultLocationPreferences, systemType: defaultTypes.0, tempType: defaultTypes.1, buddyType: defaultBuddyName)
        mockBuddy = Buddy.init(latitude: defaultTestCoordinates.0, longitude: defaultTestCoordinates.1, highTemp: defaultBuddyData[0], lowTemp: defaultBuddyData[1], rain: defaultBuddyData[2], snow: defaultBuddyData[3], precip: defaultBuddyData[4], uvIndex: defaultBuddyData[5], settings: mockSettings)
    }

    override func tearDown() {
        testMode = false
        mockSettings = nil
        mockBuddy = nil
        functionCalled = false
        managedObjectChanged = false
        mockEnglishWeatherData = nil
        mockMetricWeatherData = nil
        mockManagedContext = nil
    }

    func test_getManagedContext(){
        mockManagedContext = getManagedContext()
        XCTAssertNotNil(mockManagedContext)
        XCTAssertNotNil(mockManagedContext.persistentStoreCoordinator)
    }
    
    func test_saveData(){
        var hasChanges = false
        for index in 0...2 {
            mockManagedContext = getManagedContext()
            if index > 0 {
                testEntity = NSEntityDescription.init()
                hasChanges = true
                if index == 1 {
                    testEntity.name = "BuddySave"
                } else if index == 2 {
                    testEntity.name = "SettingsSave"
                }
                testManagedObject = NSManagedObject.init(entity: testEntity, insertInto: mockManagedContext)
                mockManagedContext.insert(testManagedObject)
            }
            saveData(managedContext: mockManagedContext)
            XCTAssertNotNil(mockManagedContext, "Mock Managed Context returned nil")
            XCTAssertEqual(hasChanges, managedObjectChanged, "Managed Object hasChanges fail. Expected \(hasChanges)")
            mockManagedContext.delete(testManagedObject)
        }
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
        XCTAssertTrue(functionCalled, "funciton did not finish")
        XCTAssertNotNil(testEntity, "saveBuddy entity never created")
        XCTAssertEqual(testEntity.name, buddyEntityString, "saveBuddy entity incorrectly created")
        XCTAssertNotNil(testManagedObject, "saveBuddy managedObject never created")
        XCTAssertEqual(buddyEntityString, testManagedObject.entity.name, "saveBuddy entity incorrectly created")
    }
    
    func test_saveSettings(){
        saveSettings(settings: mockSettings)
        XCTAssertTrue(functionCalled, "function did not finish")
        XCTAssertNotNil(testEntity, "saveSettings entity never created")
        XCTAssertEqual(testEntity.name, settingsEntityString, "saveSettings entity incorrectly created")
        XCTAssertNotNil(testManagedObject, "saveSettings managedObject never created")
    }
    
    func test_loadBuddy() {
        mockManagedContext = getManagedContext()
        mockBuddy.location = defaultLocation
        mockBuddy.rawData.english.highTemp = defaultValues[0]
        mockBuddy.rawData.english.lowTemp = defaultValues[1]
        mockBuddy.rawData.english.rain = defaultValues[2]
        mockBuddy.rawData.english.snow = defaultValues[3]
        mockBuddy.rawData.precip = defaultValues[4]
        mockBuddy.rawData.uvIndex = defaultValues[5]
        let resultBuddy = loadBuddy()
        checkBuddy(expected: mockBuddy, results: resultBuddy, testName: "loadBuddy")
    }
    
    func test_loadSettings(){
        mockSettings.english.highTemp = defaultSettingsFloats[0]
        mockSettings.english.lowTemp = defaultSettingsFloats[1]
        mockSettings.english.rain = defaultSettingsFloats[2]
        mockSettings.english.snow = defaultSettingsFloats[3]
        mockSettings.precip = defaultSettingsFloats[4]
        mockSettings.uvIndex = defaultSettingsFloats[5]
        mockSettings.zipcode = defaultLocation.0
        mockSettings.locationAuthorization = defaultSettingsInts[0]
        mockSettings.systemType = defaultSettingsInts[1]
        mockSettings.tempType = defaultSettingsInts[2]
        mockSettings.dayStart = defaultSettingsInts[3]
        mockSettings.dayEnd = defaultSettingsInts[4]
        mockSettings.locationPreferences = defaultSettingsBools
        mockSettings.buddyType = defaultBuddyType
        mockManagedContext = getManagedContext()
        let resultSettings = loadSettings()
        checkSettings(expected: mockSettings, results: resultSettings, testName: "loadSettings")
    }
}

extension CoreDataTests {
    func checkSettings(expected: Settings, results: Settings, testName: String){
        XCTAssertEqual(expected.buddyType, results.buddyType, "BuddyType Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.systemType, results.systemType, "SystemType Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.tempType, results.tempType, "TempType Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.precip, results.precip, "Precipitation Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.highTemp, results.english.highTemp, "HighTemp Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.lowTemp, results.english.lowTemp, "english.lowTemp Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.rain, results.english.rain, "English.Rain Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.english.snow, results.english.snow, "English.Snow Mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.uvIndex, results.uvIndex, "UVIndex Mismatch. Failed in \(testName) test")
    }
    
    func checkBuddy(expected: Buddy, results: Buddy, testName: String){
        XCTAssertEqual(expected.location.0, results.location.0, "location.0 (latitude) mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.location.1, results.location.1, "location.1 (longitude) mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.rawData.english.highTemp, results.rawData.english.highTemp, "rawData.english.hightemp mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.rawData.english.lowTemp, results.rawData.english.lowTemp, "rawData.english.lowTemp mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.rawData.english.lowTemp, results.rawData.english.lowTemp, "rawData.english.lowTemp mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.rawData.english.rain, results.rawData.english.rain, "rawData.english.rain mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.rawData.english.snow, results.rawData.english.snow, "rawData.english.snow mismatch. Failed in \(testName) test")
        XCTAssertEqual(expected.rawData.precip, results.rawData.precip, "rawData.precip mismatch. Failed in \(testName) test")
    }
}
