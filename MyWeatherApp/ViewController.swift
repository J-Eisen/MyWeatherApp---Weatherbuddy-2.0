//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit

let defaultLocation = 11221

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempStyle: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var systemLabel: UILabel!
    
    @IBOutlet weak var preciptationTitleLabel: UILabel!
    @IBOutlet weak var zipcodeField: UITextField!
    
    var location = defaultLocation
    var testMode = false
    var weather: [Weather] = []
    var selectedTime = 0
    var lastTime = 0
    
    // infoSwitch:
    //      tempStyle      tempLabel/systemLabel/rain/snow
    //  0   feelslike      english      precip
    //  1   actual         metric       rain
    //  2                               snow
    var infoSwitch = [0, 0, 0]
    var updateSwitch = [true, true, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadViewAfterFetch()
    }
    
    @IBAction func handleTap(recognizer: UITapGestureRecognizer){
        guard recognizer.view != nil else { return }
        
        if recognizer.state == .ended {
            let tapPoint = recognizer.location(in: nil)
            
            if tapCheck(tap: tapPoint, target: systemLabel.frame) {         // SystemLabel Change
                updateSwitch[1] = true
                if infoSwitch[1] == 0 {
                    infoSwitch[1] = 1
                } else {
                    infoSwitch[1] = 0
                }
            } else if tapCheck(tap: tapPoint, targetY1: preciptationTitleLabel.frame, targetY2: precipLabel.frame) {
                updateSwitch[2] = true
                if infoSwitch[2] == 2 {
                    infoSwitch[2] = 0
                } else {
                    infoSwitch[2] += 1
                }
            } else if tapCheck(tap: tapPoint, targetY1: tempLabel.frame, targetY2: tempStyle.frame) {
                updateSwitch[0] = true
                if infoSwitch[0] == 0 {
                    infoSwitch[0] = 1
                } else {
                    infoSwitch[0] = 0
                }
            }
            guard weather.count > 0 else { return }
            updateLabels(weatherData: weather[selectedTime], infoSwitch: infoSwitch)
        }
    }
    
    @IBAction func panHandler(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else { return }
        
        if recognizer.state == .ended {
            if abs(recognizer.velocity(in: super.view).y) < 1 {
                if recognizer.velocity(in: super.view).x < 0 {          // Pan Left
                    if selectedTime == weather.count - 1 {
                        selectedTime = 0
                    } else {
                        selectedTime += 1
                    }
                } else if recognizer.velocity(in: super.view).x > 0 {   // Pan Right
                    if selectedTime == 0 {
                        selectedTime = weather.count - 1
                    } else {
                        selectedTime -= 1
                    }
                }
            }
            guard weather.count > 0 else { return }
            updateLabels(weatherData: weather[selectedTime], infoSwitch: infoSwitch)
        }
    }
}

extension ViewController {
    func tapCheck(tap: CGPoint, target: CGRect) -> Bool {
        var result = false
        if tap.x > target.minX && tap.x < target.maxX
        && tap.y > target.minY && tap.y < target.maxY { result = true}
        return result
    }
    
    func tapCheck(tap: CGPoint, targetX: CGRect, targetY: CGRect) -> Bool {
        var result = false
        if tap.x > targetX.minX && tap.x < targetX.maxX
        && tap.y > targetY.minY && tap.y < targetY.maxY { result = true}
        return result
    }
    func tapCheck(tap: CGPoint, targetY1: CGRect, targetY2: CGRect) -> Bool {
        var result = false
        var minPoint: CGPoint = CGPoint.init(x: targetY2.minX, y: targetY2.minY)
        var maxPoint: CGPoint = CGPoint.init(x: targetY2.maxX, y: targetY2.maxY)
        
        // Checking if X updated needed
        if targetY1.maxX > targetY2.maxX {
          maxPoint.x = targetY1.maxX
        }
        if targetY1.minX > targetY2.minX {
            minPoint.x = targetY1.minX
        }
        // Checking if Y updated needed
        if targetY1.maxY > targetY2.maxY {
            maxPoint.y = targetY1.maxY
        }
        if targetY1.minY > targetY2.minY {
            minPoint.y = targetY1.minY
        }
        
        // Checking tap vs target
        if tap.x > minPoint.x && tap.x < maxPoint.x
            && tap.y > minPoint.y && tap.y < maxPoint.y { result = true }
        return result
    }
}

extension ViewController {
    func reloadViewAfterFetch(){
        fetch(location: location, testMode: testMode) {
            newWeather in
            self.weather.append(contentsOf: newWeather!)
            DispatchQueue.main.async {
                self.updateLabels(weatherData: self.weather[self.selectedTime], infoSwitch: self.infoSwitch)
            }
        }
    }
    
    func updateLabels(weatherData: Weather, infoSwitch: [Int]){
        let timeInt: Int? = Int(weatherData.hour)
        let timeChange = Bool.init(timeInt != lastTime)
        lastTime = timeInt!
        
        if infoSwitch[2] == 0 && updateSwitch[2] {
            precipLabel.text = "\(weatherData.precipitation) %"
            preciptationTitleLabel.text = "Precipitation (%)"
        }
        if infoSwitch[1] == 0 {         // english based info
            if infoSwitch[0] == 0 && (updateSwitch[0] || updateSwitch[1]) {     // feelslike temp
                tempLabel.text = "\(weatherData.tempFeelslikeEnglish)° F"
                tempStyle.text = "Feelslike Temp"
            } else if updateSwitch[0] || updateSwitch[1] {                      // actual temp
                tempLabel.text = "\(weatherData.tempActualEnglish)° F"
                tempStyle.text = "Actual Temp"
            }
            if infoSwitch[2] == 1 && (updateSwitch[2] || updateSwitch[1]) {
                precipLabel.text = "\(weatherData.rainEnglish) \" "
                preciptationTitleLabel.text = "Rainfall (inches)"
            } else if infoSwitch[2] == 2 && (updateSwitch[2] || updateSwitch[1]) {
                precipLabel.text = "\(weatherData.snowEnglish) \" "
                preciptationTitleLabel.text = "Snowfall (inches)"
            }
                
            if timeChange || updateSwitch[1] {
                if timeInt! - 12 > 0 {
                    timeLabel.text = "\(timeInt!-12):00 PM"
                } else if timeInt! == 12 {
                    timeLabel.text = "12:00 PM"
                } else if timeInt! == 0 {
                    timeLabel.text = "12:00 AM"
                } else {
                    timeLabel.text = "\(timeInt!):00 AM"
                }
            }
                if updateSwitch[1] { systemLabel.text = "English" }
            } else {                        // metric based info
                if infoSwitch[0] == 0 && (updateSwitch[0] || updateSwitch[1]) {     // feelslike temp
                    tempLabel.text = "\(weatherData.tempFeelslikeMetric) C"
                    tempStyle.text = "Feelslike Temp"
                } else if updateSwitch[0] || updateSwitch[1] {                    // actual temp
                    tempLabel.text = "\(weatherData.tempActualMetric) C"
                    tempStyle.text = "Actual Temp"
                }
                if infoSwitch[2] == 1 && (updateSwitch[2] || updateSwitch[1]) {
                    precipLabel.text = "\(weatherData.rainMetric) cm "
                    preciptationTitleLabel.text = "Rainfall (cm)"
                } else if infoSwitch[2] == 2 && (updateSwitch[2] || updateSwitch[1]) {
                    precipLabel.text = "\(weatherData.snowMetric) cm "
                    preciptationTitleLabel.text = "Snowfall (cm)"
                }
                if timeChange || updateSwitch[1] {
                    if timeInt! < 10 {
                        timeLabel.text = "0\(timeInt!):00"
                    } else {
                        timeLabel.text = "\(timeInt!):00"
                    }
                }
                if updateSwitch[1] { systemLabel.text = "Metric" }
            }
        for index in 0...updateSwitch.count-1 {
            updateSwitch[index] = false
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.returnKeyType = .done
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        location = Int(textField.text!)!
        textField.text = ""
        weather = []
        reloadViewAfterFetch()
        return true
    }
}
