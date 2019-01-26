//
//  MyWeatherAppTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class MainTests: XCTestCase {
    
    var preFetchedWeatherData: [Weather] = []
    var labelNames: [String] = []
    
    override func setUp() {
        super.setUp()
        testMode = true
        fetch(location: defaultLocation, testMode: true){
            returnedData in
            self.preFetchedWeatherData.append(contentsOf: returnedData!)
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_FetchJSON_AND_ParseJSON() {
        fetch(location: defaultLocation, testMode: testMode) {
        testWeather in
        XCTAssertNotNil(testWeather)
            XCTAssertEqual(testWeather!.count, targetWeather.count)
            for index in 0...testWeather!.count - 1 {
                let targetMirror = Mirror(reflecting: targetWeather[index])
                let testMirror = Mirror(reflecting: testWeather![index])
                for (testData, targetData) in zip(testMirror.children, targetMirror.children) {
                    XCTAssertEqual("\(testData.value)", "\(targetData.value)")
                }
            }
        }
    }

    func test_FetchJSON_AND_ParseJSON_WithDownload_Performance() {
        self.measure {
            testMode = false
            var weather: [Weather] = []
            fetch(location: defaultLocation, testMode: testMode){
                returnedWeather in
                weather.append(contentsOf: returnedWeather!)
            }
        }
    }
    
    /*func test_InfoSwitchStates() {
        let viewDelegate = UIViewController.init() as! ViewController
        for i in 0...2 {
            for j in 0...1 {
                for k in 0...1 {
                    let infoSwitch = [k,j,i]
                    viewDelegate.updateSwitch = [true,true,true]
                    viewDelegate.updateLabels(weatherData: preFetchedWeatherData[0], infoSwitch: infoSwitch)
                }
            }
        }
    }*/
}
