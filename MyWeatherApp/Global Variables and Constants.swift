//
//  Global Variables and Constants.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/16/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

let staticClothing = ["Sunscreen": false,
                 "Umbrella": false,
                 "HeavyCoat": false,
                 "LightCoat": false,
                 "MediumOutfit": false,
                 "HotOutfit": false,
                 "Rainboots": false,
                 "Snowboots":false]

let orderedClothing = ["HeavyCoat",
                       "LightCoat",
                       "MediumOutfit",
                       "HotOutfit", "Umbrella", "Sunscreen",
                       "Rainboots", "Snowboots"]

// Set timeInterval to 10:32:45 7/31/87 EST/GMT-4:00 (2:32:45 GMT)
let timeInterval = 554740365

// Variables for testing
var testMode = false
var segueString: String!

// Defaults for Loading/Setting
let defaultZipcode: Double = 11221
let defaultLocation: (Double, Double) = (defaultZipcode, 0)

let defaultSettingsFloats: [Float] = [80, 40, 2.0, 1.0, 40, 2]
// [highTemp, lowTemp, rain, snow, precipitation, uvIndex]

let defaultSettingsInts: [Int] = [0, 0, 0, 8, 19]
// [locationAuth, systemType, tempType, dayStart, dayEnd]

// defaultSettingsInts[1] 0: Imperial/English | 1: Metric
// defaultSettingsInts[2] 0: ºF | 1: ºC

let defaultSettingsBools: [Bool] = [true, true]
let defaultBuddyType = "CircleBuddy"
let defaultValues: [Float] = [0, 100, 0, 0, 0, 0]
// [highTemp, lowTemp, rain, snow, precip, uvIndex]
