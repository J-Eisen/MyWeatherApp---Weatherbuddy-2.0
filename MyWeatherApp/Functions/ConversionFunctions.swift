//
//  ConversionFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/16/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

func celsiusToFahrenheit(fromC: Float) -> (Float) {
    return ((fromC*9/5)+32)
}

func fahrenheitToCelsius(fromF: Float) -> (Float) {
    return ((fromF - 32.0)*(5/9))
}

func inchToCm(inch: Float) -> (Float) {
    return ((inch*2.54*1000).rounded())/1000
}

func cmToInch(cm: Float) -> (Float) {
    return ((cm/2.54*1000).rounded())/1000
}
