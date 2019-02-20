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

        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        app.navigationBars["WeatherBuddy"].buttons["Settings Default"].tap()
    }

    override func tearDown() {
        
    }
    
    func test_scrollview(){
        app.swipeDown()
        app.swipeUp()
        app.swipeDown()
    }

    func test_highTempSlider() {
        let highTempSlider = app.sliders["HighTemp Slider"]
        
        highTempSlider.adjust(toNormalizedSliderPosition: 0.9)
        highTempSlider.adjust(toNormalizedSliderPosition: 0.0)
        
    }
    
    func test_minTempSlider() {
        let lowTempSlider = app.sliders["LowTemp Slider"]
        
        lowTempSlider.adjust(toNormalizedSliderPosition: 0.9)
        lowTempSlider.adjust(toNormalizedSliderPosition: 0.1)
    }
    
    func test_precipitationSlider(){
        let precipSlider = app.sliders["Precipitation Slider"]
        
        precipSlider.adjust(toNormalizedSliderPosition: 0.9)
        precipSlider.adjust(toNormalizedSliderPosition: 0.2)
    }
    
    func test_rainPicker(){
        let rainPicker = app.pickers["Rain Picker"]
        
        rainPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "8")
        rainPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "0")
        rainPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "9")
        rainPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "8")
        rainPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "0")
        rainPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "9")
    }
    
    func test_snowPicker(){
        let snowPicker = app.pickers["Snow Picker"]
        
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
    
    func test_gpsSwitch(){
        let gpsSwitch = app.switches["GPS Switch"]
        
        gpsSwitch.tap()
        gpsSwitch.tap()
    }
    
    func test_zipcodeSwitch(){
        let zipcodeSwitch = app.switches["Zipcode Switch"]
        let zipcodeTF = app.textFields["Zipcode Text Field"]
        
        zipcodeSwitch.tap()
        zipcodeTF.tap()
        zipcodeSwitch.tap()
    }
    
    func test_zipcodeTextField(){
        let zipcodeTextField = app.textFields["Zipcode Text Field"]
        
        zipcodeTextField.tap()
        
    }
}
