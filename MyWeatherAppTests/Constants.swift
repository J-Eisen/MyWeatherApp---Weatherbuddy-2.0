//
//  Constants.swift
//  MyWeatherAppTests
//
//  Created by Jonah Eisenstock on 1/15/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import Foundation

// Segue Strings
let rootToSettings = "rootToSettings"
let settingsToRootSave = "settingsToRootSave"
let settingsToRootCancel = "settingsToRootCancel"

// Default Locations
var defaultTestLocation = (Double(defaultZipcode), 0.0)
var defaultTestZipcode = 90272
var defaultTestCoordinates = (-37.8, 175.8) // "Hobbiton" Matamata, NZ

let targetWeather: [MockWeather] = [MockWeather.init(hour: "18", uvIndex: "0", precipitation: "0", tempActualEnglish: "36.0", tempActualMetric: "2", tempFeelslikeEnglish: "36.0", tempFeelslikeMetric: "2", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "19", uvIndex: "0", precipitation: "1", tempActualEnglish: "35.2", tempActualMetric: "2", tempFeelslikeEnglish: "35.2", tempFeelslikeMetric: "2", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "20", uvIndex: "0", precipitation: "2", tempActualEnglish: "34.7", tempActualMetric: "2", tempFeelslikeEnglish: "34.7", tempFeelslikeMetric: "2", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "21", uvIndex: "0", precipitation: "3", tempActualEnglish: "34.5", tempActualMetric: "1", tempFeelslikeEnglish: "34.5", tempFeelslikeMetric: "1", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "22", uvIndex: "0", precipitation: "3", tempActualEnglish: "34.0", tempActualMetric: "1", tempFeelslikeEnglish: "34.0", tempFeelslikeMetric: "1", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "23", uvIndex: "0", precipitation: "3", tempActualEnglish: "33.4", tempActualMetric: "1", tempFeelslikeEnglish: "33.4", tempFeelslikeMetric: "1", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "0", uvIndex: "0", precipitation: "3", tempActualEnglish: "33.1", tempActualMetric: "1", tempFeelslikeEnglish: "33.1", tempFeelslikeMetric: "1", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "1", uvIndex: "0", precipitation: "3", tempActualEnglish: "32.4", tempActualMetric: "0", tempFeelslikeEnglish: "32.4", tempFeelslikeMetric: "0", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0"), MockWeather.init(hour: "2", uvIndex: "0", precipitation: "3", tempActualEnglish: "31.5", tempActualMetric: "-0", tempFeelslikeEnglish: "28", tempFeelslikeMetric: "-2", rainEnglish: "0.0", rainMetric: "0", snowEnglish: "0.0", snowMetric: "0")]

// Default Buddy and Settings Information

let defaultBuddyName = "TestBuddy"
let defaultBuddyData: [Float] = [70, 65, 1, 1, 20, 2]
let defaultPrecipitation: Float = 40
let defaultUVIndex: Float = 4
let defaultLocationAuthorization = 0
let defaultLocationPreferences = [true, true]
let defaultDay = (9, 17)
let defaultTypes: (Int, Int) = (0, 0)

// Default WeatherData
let defaultWeatherData: [[Float]] = [[77, 40, 1, 1.5], [25, 4.444, 2.54, 3.81]]
