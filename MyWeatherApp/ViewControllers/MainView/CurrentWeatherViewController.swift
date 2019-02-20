//
//  CurrentWeatherViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/10/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var waterfallLabel: UILabel!
    @IBOutlet weak var waterfallTitleLabel: UILabel!
    
    var buddy: Buddy!
    var weatherArray: [Weather]!
    var currentWeatherViewIntialLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeatherViewIntialLocation = self.currentWeatherView.center
        backgroundImage.image = imageBuilder(buddyName: buddy.settings.buddyType)
        updateWeatherLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImage.image = imageBuilder(buddyName: buddy.settings.buddyType)
        updateWeatherLabels()
    }
}

extension CurrentWeatherViewController {
    func getCurrentHour() -> Int {
        let currentDate = Date.init()
        let calendar = NSCalendar.autoupdatingCurrent
        return calendar.component(Calendar.Component.hour, from: currentDate)
    }
    
    func updateWeatherLabels(){
        var currentWeather: Weather!
        guard weatherArray.first != nil else { return }
        let currentHour = getCurrentHour()
        print("currentHour: \(currentHour)")
            for weather in weatherArray {
                if weather.hour == String(describing: currentHour) {
                    currentWeather = weather
                }
            }
        if (Int(currentWeather.rainEnglish) ?? 0) > 0 {
            waterfallTitleLabel.text = "Rain"
            waterfallTitleLabel.isHidden = false
            waterfallLabel.isHidden = false
            if buddy.settings.systemType == 0 {
                waterfallLabel.text = "\(currentWeather.rainEnglish) in"
            } else if buddy.settings.systemType == 1 {
                waterfallLabel.text = "\(currentWeather.rainMetric) cm"
            } else {
                waterfallLabel.isHidden = true
            }
        } else if (Int(currentWeather.snowEnglish) ?? 0) > 0 {
            waterfallTitleLabel.text = "Snow"
            waterfallTitleLabel.isHidden = false
            if buddy.settings.systemType == 0 {
                waterfallLabel.text = "\(currentWeather.snowEnglish) in"
            } else if buddy.settings.systemType == 1 {
                waterfallLabel.text = "\(currentWeather.snowMetric) cm"
            } else {
                waterfallLabel.isHidden = true
            }
        } else {
            waterfallTitleLabel.isHidden = true
            waterfallLabel.isHidden = true
        }
        precipitationLabel.text = "\(currentWeather.precipitation) %"
        if buddy.settings.tempType == 0 {
            tempLabel.text = "\(currentWeather.tempFeelslikeEnglish) ºF"
        } else {
            tempLabel.text = "\(currentWeather.tempFeelslikeMetric) ºC"
        }
    }
}
