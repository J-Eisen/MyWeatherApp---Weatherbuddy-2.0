//
//  CoreLocationTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 2/4/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
import CoreLocation
@testable import MyWeatherApp

class CoreLocationTests: XCTestCase {
    var mockSettings: Settings!
    var mockViewController: UIViewController!
    var mockEnglishWeatherData: Settings.WeatherData!
    var mockMetricWeatherData: Settings.WeatherData!
    
//    let mockRootVC: UIViewController.init()
    override func setUp() {
        testMode = true
        functionCalled = false
        mockViewController = UIViewController.init()
        mockEnglishWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[0][0], lowTemp: defaultWeatherData[0][1], rain: defaultWeatherData[0][2], snow: defaultWeatherData[0][3])
        mockMetricWeatherData = Settings.WeatherData(highTemp: defaultWeatherData[1][0], lowTemp: defaultWeatherData[1][1], rain: defaultWeatherData[1][2], snow: defaultWeatherData[1][3])
        mockSettings = Settings.init(english: mockEnglishWeatherData, metric: mockMetricWeatherData, precip: defaultPrecipitation, uvIndex: defaultUVIndex, dayStart: defaultDay.0, dayEnd: defaultDay.1, zipcode: Double(defaultTestZipcode), locationAuthorization: defaultLocationAuthorization, locationPreferences: defaultLocationPreferences, systemType: defaultTypes.0, tempType: defaultTypes.1, buddyType: defaultBuddyName)
    }

    override func tearDown() {
        functionCalled = false
        
        testMode = false
        mockSettings = nil
        mockEnglishWeatherData = nil
        mockMetricWeatherData = nil
        mockViewController = nil
    }
    
    func test_getUserLocation(){
        let mockLocation = getUserLocation(viewController: mockViewController)
        XCTAssertTrue(functionCalled, "getUserLocation not called")
    }
    
    /*func test_checkAuthorization_locationManager(){
        let mockLocationManager = CLLocationManager.init()
        let authorizations: [CLAuthorizationStatus] = [.notDetermined, .denied, .authorizedWhenInUse, .authorizedAlways]
        for authorization in authorizations {
            mockLocationManager.set
            let returnedAuthorization = checkAuthoriztion(locationManager: <#T##CLLocationManager#>)
            
        }
    }*/
    
    //FIXME: Broken Test
    func test_checkAuthorization_settings(){
        let authorizations: [CLAuthorizationStatus] = [.notDetermined, .denied, .authorizedWhenInUse, .authorizedAlways]
        for authorization in authorizations {
            CLAuthorizationStatus.init(rawValue: authorization.rawValue)
            checkAuthorization(settings: mockSettings)
            XCTAssertEqual(mockSettings.locationAuthorization, Int(authorization.rawValue))
        }
    }
    
    /* Not called
    func test_loadAuthorization(){
        let settingsAuthorizations: [Int] = [0, 1, 2, 3]
        let authorizations: [CLAuthorizationStatus] = [.notDetermined, .denied, .authorizedWhenInUse, .authorizedAlways]
        for authorization in authorizations {
            CLAuthorizationStatus.init(rawValue: authorization.rawValue)
            
        }
    }*/
    
    func test_locationManagerSetup(){
        let mockLocationManager = locationManagerSetup(viewController: mockViewController)
        XCTAssert(functionCalled, "locationManagerSetup not called")
    }
}
