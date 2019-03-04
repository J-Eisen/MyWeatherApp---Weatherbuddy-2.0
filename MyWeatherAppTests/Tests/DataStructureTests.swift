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
        fetch(location: defaultLocation){
            returnedData in
            self.preFetchedWeatherData.append(contentsOf: returnedData!)
        }
    }

    override func tearDown() {
        testMode = false
    }

    func test_FetchJSON_AND_ParseJSON() {
        fetch(location: defaultLocation) {
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
            var weather: [Weather] = []
            fetch(location: defaultLocation){
                returnedWeather in
                weather.append(contentsOf: returnedWeather!)
            }
        }
    }
}
