//
//  SettingsViewUITests.swift
//  MyWeatherAppUITests
//
//  Created by Jonah Eisenstock on 1/26/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import XCTest

class SettingsViewUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        app.navigationBars["Title"].buttons["Settings"].tap()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_highTempSlider() {
        let highTempSlider = app.sliders["highTempSlider"]
        
        highTempSlider.adjust(toNormalizedSliderPosition: 0.9)
        highTempSlider.adjust(toNormalizedSliderPosition: 0.0)
        
    }
    
    func test_minTempSlider() {
        let lowTempSlider = app.sliders["lowTempSlider"]
        
        lowTempSlider.adjust(toNormalizedSliderPosition: 0.9)
        lowTempSlider.adjust(toNormalizedSliderPosition: 0.1)
    }
    
    func test_precipitationSlider(){
        let precipSlider = app.sliders["precipitationSlider"]
        
        precipSlider.adjust(toNormalizedSliderPosition: 0.9)
        precipSlider.adjust(toNormalizedSliderPosition: 0.2)
    }
    
    func test_rainPicker(){
        let rainPicker = app.pickers["rainPicker"]
        
        rainPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "8")
        rainPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "0")
        rainPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "9")
        rainPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "8")
        rainPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "0")
        rainPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "9")
    }
    
    func test_snowPicker(){
        let snowPicker = app.pickers["snowPicker"]
        
        snowPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "8")
        snowPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "0")
        snowPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "9")
        snowPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "8")
        snowPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "0")
        snowPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "9")
    }
    
    func test_systemSegmentedControl(){
        app.buttons["Imperial"].tap()
        app.buttons["Metric"].tap()
        app.buttons["Metric"].tap()
        app.buttons["Imperial"].tap()
    }
    
    func test_tempSegmentedControl(){
        app.buttons["ºF"].tap()
        app.buttons["ºC"].tap()
        app.buttons["ºC"].tap()
        app.buttons["ºF"].tap()
    }
}
