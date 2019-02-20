//
//  SettingsTests.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 1/24/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//


import UIKit
import XCTest
@testable import MyWeatherApp

class SettingsTests: XCTestCase {
    var testSettings: Settings!
    var testSlider: UISlider!
    var testSegmentedControl: UISegmentedControl!
    let testNumArray: [Float] = [1.73498751, 1.091579, 5.34549415, 9.999999]
    
    override func setUp() {
        testSettings = Settings.init()
        testSlider = UISlider.init()
        testSegmentedControl = UISegmentedControl.init(items: ["One","Two"])
    }

    override func tearDown() {
        testSettings = nil
        testSlider = nil
        testSegmentedControl = nil
    }
    
    func test_setSlider_helper_function(){
        let expectedSlider = UISlider.init()
        let sliderMax: Float = 10
        let sliderMin: Float = 0
        let sliderValue: Float = 5
        expectedSlider.maximumValue = sliderMax
        expectedSlider.minimumValue = sliderMin
        expectedSlider.value = sliderValue
        expectedSlider.restorationIdentifier = "name"
        testSlider.restorationIdentifier = "name"
        testSlider = setSlider(max: sliderMax, min: sliderMin, value: sliderValue, slider: testSlider)
        XCTAssertEqual(expectedSlider.restorationIdentifier, testSlider.restorationIdentifier)
        XCTAssertEqual(expectedSlider.maximumValue, testSlider.maximumValue)
        XCTAssertEqual(expectedSlider.minimumValue, testSlider.minimumValue)
        XCTAssertEqual(expectedSlider.value, testSlider.value)
    }
    
    // Update to also test for celsius
    func test_function_initSliders(){
        let expectedSlider = UISlider.init()
        let sliderNameArray = ["precipitationSlider","highTempSlider","lowTempSlider"]
        let sliderMaxArray: [[Float]] = [[100,95,95],[100,35.0,35.0]]
        let sliderMinArray: [[Float]] = [[0,32,32],[0,0.0,0.0]]
        let sliderValueArray: [[Float]] = [[testSettings.precip, testSettings.english.highTemp, testSettings.english.lowTemp], [testSettings.precip, testSettings.metric.highTemp, testSettings.metric.lowTemp]]
        
        for i in 0...1 {
            testSettings.tempType = i
            for j in 0...2 {
                expectedSlider.restorationIdentifier = sliderNameArray[j]
                expectedSlider.maximumValue = sliderMaxArray[i][j]
                expectedSlider.minimumValue = sliderMinArray[i][j]
                expectedSlider.value = sliderValueArray[i][j]
                testSlider.restorationIdentifier = sliderNameArray[j]
                print(expectedSlider.maximumValue)
                print(expectedSlider.minimumValue)
                print(expectedSlider.value)
                testSlider = initSliderHelper(slider: testSlider, settings: testSettings)
                XCTAssertEqual(expectedSlider.restorationIdentifier, testSlider.restorationIdentifier)
                XCTAssertEqual(expectedSlider.maximumValue, testSlider.maximumValue, "Failed for \(expectedSlider.restorationIdentifier ?? "error")")
                XCTAssertEqual(expectedSlider.minimumValue, testSlider.minimumValue, "Failed for \(expectedSlider.restorationIdentifier ?? "error")")
                XCTAssertEqual(expectedSlider.value, testSlider.value, "Failed for \(expectedSlider.restorationIdentifier ?? "error")")
            }
        }
    }
    /*
    // update to also test for metric
    func test_function_initPickers(){
        var testSettings = Settings.init()
        let testPicker = UIPickerView.init()
        let pickerNameArray = ["rainPicker", "snowPicker"]
        
        let resultsPicker = initPickerHelper(picker: testPicker, settings: testSettings)
    }
    */
    func test_initPickerLabelsHelper(){
        let testLabels: [UILabel] = [UILabel.init(), UILabel.init()]
        var expectedString: String
        for index in 0...1 {
            testSettings.systemType = index
            if index == 0 { expectedString = "in" }
            else { expectedString = "cm" }
            let resultsLabels = initPickerLabelsHelper(labels: testLabels, settings: testSettings)
            for result in resultsLabels {
                XCTAssertEqual(result.text, expectedString)
            }
        }
    }
    
    func test_function_initSegmentedControls(){
        let segmentNames = ["systemSegmentedControl", "tempSegmentedControl"]
        
        for name in segmentNames {
            testSegmentedControl.restorationIdentifier = name
            for i in 0...1 {
            if testSegmentedControl.restorationIdentifier == "systemSegmentedControl" {
                testSettings.systemType = i
                testSegmentedControl = initSegmentedControlHelper(segControl: testSegmentedControl, settings: testSettings)
                XCTAssertEqual(testSegmentedControl.selectedSegmentIndex, testSettings.systemType)
            } else {
                testSettings.tempType = i
                testSegmentedControl = initSegmentedControlHelper(segControl: testSegmentedControl, settings: testSettings)
                XCTAssertEqual(testSegmentedControl.selectedSegmentIndex, testSettings.tempType)
            }
            XCTAssertEqual(testSegmentedControl.restorationIdentifier, name)
            }
        }
    }

    func test_getInteger_and_getDecimal_helper_functions(){
        var intResult: Int
        var decResult: Int
        let intExpected = [1, 1, 5, 9]
        let decExpected = [7, 0, 3, 9]
        for index in 0...testNumArray.count-1 {
            intResult = getInteger(fromFloat: testNumArray[index])
            decResult = getDecimal(fromFloat: testNumArray[index])
            XCTAssertEqual(intResult, intExpected[index], "getInt failure at \(testNumArray[index])")
            XCTAssertEqual(decResult, decExpected[index], "getDec failure at \(testNumArray[index])")
        }
    }
    
    func test_updatePickerData_helper_function(){
        var result: Float
        let data: Float = 0.0
        for component in 0...1{
            result = updatePickerData(data: data, component: component, row: 1)
            XCTAssertNotNil(result)
        }
    }
    
    func test_updateInteger_helper_function(){
        let component = 0
        let expectedData: [Float] = [4.73498751, 0.091579, 5.34549415]
        var resultData: Float
        let rowArray = [4, 0, 5]
        for index in 0...2 {
            resultData = updateInteger(data: testNumArray[index], component: component, row: rowArray[index])
            XCTAssertEqual(expectedData[index], resultData, accuracy: 0.0001)
        }
    }
    
    func test_updateDecimal_helper_function(){
        let component = 1
        let expectedData: [Float] = [1.1, 1.8, 5.3]
        var resultData: Float
        let rowArray = [1, 8, 3]
        for index in 0...2 {
            resultData = updateDecimal(data: testNumArray[index], component: component, row: rowArray[index])
            XCTAssertEqual(expectedData[index], resultData)
        }
    }
    
    func test_celsiusDisplay(){
        let testData: [Float] = [10.0000000, 1.89145175, 23.99999999, 11.43999999]
        let celsiusExpected: [String] = ["10.0 ºC", "1.9 ºC", "24.0 ºC", "11.4 ºC"]
        var celsiusResult: String
        
        for index in 0...testData.count-1 {
            celsiusResult = celsiusDisplay(value: testData[index])
            XCTAssertEqual(celsiusResult, celsiusExpected[index], "Failure at \(testData[index])")
        }
    }
    
    func test_slider_updateSliderHelper(){
        let expectedLabelArray = ["20 %", "40 %"]
        let expectedValueArray: [Float] = [20, 40]
        let testValueArray: [Float] = [20.2, 39.9]
        let testSlider = UISlider.init()
        testSlider.maximumValue = 100
        testSlider.minimumValue = 0
        let sliderNameArray = ["precipitationSlider", "lowTempSlider", "highTempSlider"]
        for name in sliderNameArray {
            testSlider.restorationIdentifier = name
            testSlider.value = 50
            if name == "precipitationSlider" {
                for index in 0...1 {
                    testSlider.value = testValueArray[index]
                    let results = updateSliderHelper(slider: testSlider, settings: testSettings)
                    XCTAssertEqual(results.0.precip, expectedValueArray[index])
                    XCTAssertEqual(results.1, expectedLabelArray[index])
                }
            } else {
                let results = updateSliderHelper(slider: testSlider, settings: testSettings)
                XCTAssertNotNil(results.0)
                XCTAssertNotNil(results.1)
            }
        }
    }
    
    func test_slider_updateTempSliderHelper(){
        let expectedLabelArray = [["42 ºF", "68 ºF", "-5 ºF", "-7 ºF"],["12.2 ºC", "23.5 ºC", "19.0 ºC"]]
        let expectedValueArray: [[Float]] = [[42, 68, -5, -7], [12.2, 23.5, 19.0]]
        let testValueArray: [[Float]] = [[42.2, 67.9, -5.4, -6.8], [12.24, 23.49, 18.98]]
        let testSlider = UISlider.init()
        testSlider.maximumValue = 100
        testSlider.minimumValue = -10
        let sliderNameArray = ["lowTempSlider", "highTempSlider"]
        for tempType in 0...1 {
            testSettings.tempType = tempType
            for index in 0...expectedValueArray[tempType].count - 1 {
                testSlider.value = testValueArray[tempType][index]
                for name in sliderNameArray {
                    testSlider.restorationIdentifier = name
                    let results = updateTempSlider(slider: testSlider, settings: testSettings)
                    if tempType == 0 {
                        if name == "lowTempSlider" {
                            XCTAssertEqual(results.0.english.lowTemp, expectedValueArray[tempType][index])
                        } else { XCTAssertEqual(results.0.english.highTemp, expectedValueArray[tempType][index]) }
                    } else {
                        if name == "lowTempSlider" {
                            XCTAssertEqual(results.0.metric.lowTemp, expectedValueArray[tempType][index])
                        } else { XCTAssertEqual(results.0.metric.highTemp, expectedValueArray[tempType][index]) }
                    }
                    XCTAssertEqual(results.1, expectedLabelArray[tempType][index])
                }
            }
        }
    }
    
    func test_slider_tempCheck_highTempSender(){
        let senderSlider = UISlider.init()
        let lowTempSlider = UISlider.init()
        let lowTempLabel = UILabel.init()
        let testValues: [Float] = [0.8, 0.1]
        let lowTempValue: Float = 0.2
        
        for value in testValues {
            lowTempSlider.value = lowTempValue
            senderSlider.value = value
            let results = tempCheck(senderSlider: senderSlider, lowSlider: lowTempSlider, lowLabel: lowTempLabel, settings: testSettings)
            if lowTempValue > value {
                XCTAssertEqual(results.1?.value, value)
            } else {
                XCTAssertEqual(results.1?.value, lowTempValue)
            }
            XCTAssertNotNil(results.0)
            XCTAssertNotNil(results.2)
        }
    }
    
    func test_slider_tempCheck_lowTempSender(){
        let senderSlider = UISlider.init()
        let highTempSlider = UISlider.init()
        let highTempLabel = UILabel.init()
        let testValues: [Float] = [0.8, 0.1]
        let highTempValue: Float = 0.2
        
        for value in testValues {
            highTempSlider.value = highTempValue
            senderSlider.value = value
            let results = tempCheck(senderSlider: senderSlider, highSlider: highTempSlider, highLabel: highTempLabel, settings: testSettings)
            if highTempValue < value {
                XCTAssertEqual(results.1?.value, value)
            } else {
                XCTAssertEqual(results.1?.value, highTempValue)
            }
            XCTAssertNotNil(results.0)
            XCTAssertNotNil(results.2)
        }
    }
    
    func test_picker_updates(){
//        let picker = UIPickerView.init()
    }
    
    func test_measure_system_change(){
        let imperialSystem = 0
        let metricSystem = 1
        let expectedResults: [Float] =
            [1.1, 2.8,
             0.4, 1.0,
             0.0, 0.0]
        let testArray: [Float] = [1.1, 1.0, 0.0]
        for testNumber in testArray {
            
        }
        
        testSettings.systemType = imperialSystem
//        XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
    }
    
    func test_temperature_system_change(){
        
    }
    
    /* CoreData has not been implemented yet
    
    func test_save_settings_to_coreData(){
        
    }*/

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
