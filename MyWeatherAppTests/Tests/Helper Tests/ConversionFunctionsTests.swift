//
//  ConversionFunctionsTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 3/3/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class ConversionFunctionsTests: XCTestCase {
    let expectedCelsius: [Float] = [0, -20, 10]
    let expectedFahrenheit: [Float] = [32, -4, 50]
    let expectedInch: [Float] = [1.75, 0, 3.93701]
    let expectedCm: [Float] = [4.445, 0, 10]

    func test_celsiusToFahrenheit() {
        var resultFahrenheit: Float?
        for index in 0...2{
            resultFahrenheit = celsiusToFahrenheit(fromC: expectedCelsius[index])
            XCTAssertEqual(expectedFahrenheit[index], resultFahrenheit)
        }
    }
    
    func test_fahrenheitToCelsius() {
        var resultCelsius: Float?
        for index in 0...2 {
            resultCelsius = fahrenheitToCelsius(fromF: expectedFahrenheit[index])
            XCTAssertEqual(expectedCelsius[index], resultCelsius)
        }
    }
    
    func test_inchToCm() {
        var resultCm: Float?
        for index in 0...2 {
            resultCm = inchToCm(inch: expectedInch[index])
            XCTAssertEqual(expectedCm[index], resultCm!, accuracy: 0.001)
        }
    }
    
    func test_cmToInch() {
        var resultInch: Float?
        for index in 0...2 {
            resultInch = cmToInch(cm: expectedCm[index])
            XCTAssertEqual(expectedInch[index], resultInch!, accuracy: 0.001)
        }
    }
}
