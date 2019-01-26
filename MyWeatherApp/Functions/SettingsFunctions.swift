//
//  SettingsViewFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/24/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit
import Foundation

let pickerDataSource = [[0,1,2,3,4,5,6,7,8,9,10],[0,1,2,3,4,5,6,7,8,9]]

////////////////////////////////
///  Initialization Helpers  ///
////////////////////////////////

/////  Sliders  /////

func initSliderHelper(slider: UISlider, settings: Settings) -> UISlider {
    var initializedSlider: UISlider
    
    switch slider.restorationIdentifier {
    case "precipitationSlider":
        initializedSlider = setSlider(max: 100, min: 0, value: settings.precip, slider: slider)
        break
    case "highTempSlider":
        if settings.tempType == 0 {
            initializedSlider = setSlider(max: 95, min: 32, value: settings.english.highTemp, slider: slider)
        } else {
            initializedSlider = setSlider(max: 35.0, min: 0.0, value: settings.metric.highTemp, slider: slider)
        }
        break
    case "lowTempSlider":
        if settings.tempType == 0 {
            initializedSlider = setSlider(max: 95, min: 32, value: settings.english.lowTemp, slider: slider)
        } else {
            initializedSlider = setSlider(max: 35.0, min: 0.0, value: settings.metric.lowTemp, slider: slider)
        }
        break
    default:
        print("Error: No Slider Found")
        initializedSlider = slider
    }
    return initializedSlider
}

func setSlider(max: Float, min: Float, value: Float, slider: UISlider) -> UISlider {
    let slider = slider
    slider.maximumValue = max
    slider.minimumValue = min
    slider.value = value
    return slider
}

/////  Pickers  /////

func initPickerHelper(picker: UIPickerView, settings: Settings) -> UIPickerView {
    let row: (Int, Int)
    
    if settings.systemType == 0 {
        if picker.restorationIdentifier == "rainPicker" {
            row.0 = getInteger(fromFloat: settings.english.rain)
            row.1 = getDecimal(fromFloat: settings.english.rain)
        } else {
            row.0 = getInteger(fromFloat: settings.english.snow)
            row.1 = getDecimal(fromFloat: settings.english.snow)
        }
    } else {
        if picker.restorationIdentifier == "rainPicker" {
            row.0 = getInteger(fromFloat: settings.metric.rain)
            row.1 = getDecimal(fromFloat: settings.metric.rain)
        } else {
            row.0 = getInteger(fromFloat: settings.metric.snow)
            row.1 = getDecimal(fromFloat: settings.metric.snow)
        }
    }
    picker.selectRow(row.0, inComponent: 0, animated: false)
    picker.selectRow(row.1, inComponent: 1, animated: false)
    
    return picker
}

func initPickerLabelsHelper(labels: [UILabel], settings: Settings) -> [UILabel] {
    if settings.systemType == 0 {
        for label in labels { label.text = "in" }
    } else {
        for label in labels { label.text = "cm" }
    }
    return labels
}

/////  Segmented Controls  /////

func initSegmentedControlHelper(segControl: UISegmentedControl, settings: Settings) -> UISegmentedControl {
    if segControl.restorationIdentifier == "tempSegmentedControl" {
        segControl.selectedSegmentIndex = settings.tempType
    } else {
       segControl.selectedSegmentIndex = settings.systemType
    }
    return segControl
}

////////////////////////////////
///     Update Helpers       ///
////////////////////////////////

/////  Labels  /////

func updateLabelsHelper(label: UILabel, settings: Settings) {
    
}

/////  Sliders  /////

func updateSliderHelper(slider: UISlider, settings: Settings) -> (Settings, String) {
    let labelString: String
    var settings = settings
    
    if slider.restorationIdentifier == "precipitationSlider" {
        settings.precip = slider.value.rounded()
        labelString = "\(Int(slider.value.rounded())) %"
    } else {
        settings = updateTempSlider(slider: slider, settings: settings).0
        labelString = updateTempSlider(slider: slider, settings: settings).1
    }
    return (settings, labelString)
}

func updateTempSlider(slider: UISlider, settings: Settings) -> (Settings, String) {
    var settings = settings
    let labelString: String
    
    if settings.tempType == 0 {
        if slider.restorationIdentifier == "lowTempSlider" {
            settings.english.lowTemp = slider.value.rounded()
            settings.metric.lowTemp = fahrenheitToCelsius(fromF: slider.value).rounded()
        } else {
            settings.english.highTemp = slider.value.rounded()
            settings.metric.highTemp = fahrenheitToCelsius(fromF: slider.value).rounded()
        }
        labelString = "\(Int(slider.value.rounded())) ºF"
    } else {
        if slider.restorationIdentifier == "lowTempSlider" {
            settings.english.lowTemp = celsiusToFahrenheit(fromC: slider.value)
            settings.metric.lowTemp = (slider.value*10).rounded()/10
        } else {
            settings.english.highTemp = celsiusToFahrenheit(fromC: slider.value)
            settings.metric.highTemp = (slider.value*10).rounded()/10
        }
        labelString = celsiusDisplay(value: slider.value)
    }
    return (settings, labelString)
}

func tempCheck(senderSlider: UISlider, highSlider: UISlider, highLabel: UILabel, settings: Settings) -> (Settings?, UISlider?, UILabel?){
    var settings = settings
    
    if senderSlider.value >= highSlider.value {
        highSlider.value = senderSlider.value
        settings = updateTempSlider(slider: highSlider, settings: settings).0
        highLabel.text = updateTempSlider(slider: highSlider, settings: settings).1
    }
    
    return (settings, highSlider, highLabel)
}

func tempCheck(senderSlider: UISlider, lowSlider: UISlider, lowLabel: UILabel, settings: Settings) -> (Settings?, UISlider?, UILabel?){
    var settings = settings
    
    if senderSlider.value <= lowSlider.value {
        lowSlider.value = senderSlider.value
        settings = updateTempSlider(slider: lowSlider, settings: settings).0
        lowLabel.text = updateTempSlider(slider: lowSlider, settings: settings).1
    }
    return (settings, lowSlider, lowLabel)
}

/////  Pickers  /////

func updatePickerHelper(pickerView: UIPickerView, settings: Settings, row: Int, component: Int) -> Settings {
    var data: Float = 0.0
    var settings = settings
    
    if settings.systemType == 0 {
        if pickerView.restorationIdentifier == "rainPicker" {
            data = settings.english.rain
            settings.english.rain = updatePickerData(data: data, component: component, row: row)
            settings.metric.rain = inchToCm(inch: updatePickerData(data: data, component: component, row: row))
        } else {
            data = settings.english.snow
            settings.english.snow = updatePickerData(data: data, component: component, row: row)
            settings.metric.snow = inchToCm(inch: updatePickerData(data: data, component: component, row: row))
        }
    } else {
        if pickerView.restorationIdentifier == "rainPicker" {
            data = settings.metric.rain
            settings.english.rain = cmToInch(cm: updatePickerData(data: data, component: component, row: row))
            settings.metric.rain = updatePickerData(data: data, component: component, row: row)
        } else {
            data = settings.metric.snow
            settings.english.snow = cmToInch(cm: updatePickerData(data: data, component: component, row: row))
            settings.metric.snow = updatePickerData(data: data, component: component, row: row)
        }
    }
    return settings
}

////////////////////////////////
///     Other Functions      ///
////////////////////////////////

func getInteger(fromFloat: Float) -> Int {
    return Int(fromFloat.rounded(.towardZero))
}

func getDecimal(fromFloat: Float) -> Int {
    return Int((fromFloat - fromFloat.rounded(.towardZero))*10)
}

func updatePickerData(data: Float, component: Int, row: Int) -> Float {
    if component == 0 {
        return updateInteger(data: data, component: component, row: row)
    } else {
        return updateDecimal(data: data, component: component, row: row)
    }
}

func updateInteger(data: Float, component: Int, row: Int) -> Float {
    return data - data.rounded(.towardZero) + Float(pickerDataSource[component][row])
}

func updateDecimal(data: Float, component: Int, row: Int) -> Float {
    return data.rounded(.towardZero) + (Float(pickerDataSource[component][row])/10)
}

func celsiusDisplay(value: Float) -> String {
    return "\((value*10).rounded()/10) ºC"
}
