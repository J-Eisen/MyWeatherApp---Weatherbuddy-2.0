//
//  RootViewChildren.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/20/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit

class RootViewChildren: PageViewChildrenDelegate {
    var childViewControllers: [UIViewController] = []
    lazy var testChildViewControllers: [String] = []
    lazy var childCount: Int = 0
    lazy var functionCalled: String = ""
    
    func initializeChildren(names: [String], buddy: Buddy) {
        for name in names {
            if !testMode {
                addNewChild(name: name, buddy: buddy)
            } else {
                childCount += 1
            }
        }
    }
    
    func addNewChild(name: String, buddy: Buddy) {
        if !testMode {
            var newVC = UIStoryboard.init(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "\(name)ViewController")
            if newVC is MainViewController {
                let mainVC = newVC as! MainViewController
                mainVC.buddy = buddy
                newVC = mainVC
            } else if newVC is CurrentWeatherViewController {
                let weatherVC = newVC as! CurrentWeatherViewController
                weatherVC.buddy = buddy
                newVC = weatherVC
            }
            childViewControllers.append(newVC)
        } else {
            testChildViewControllers.append("\(name)ViewController")
        }
    }
    
    func updateChild(child: UIViewController, buddy: Buddy, weather: [Weather]?) {
        if !testMode {
            if child is CurrentWeatherViewController {
                let weatherVC = child as! CurrentWeatherViewController
                weatherVC.weatherArray = weather
                weatherVC.buddy = buddy
            } else {
                // Default Case
                let mainVC = child as! MainViewController
                mainVC.buddy = buddy
                mainVC.buddyImage.image = imageBuilder(buddy: buddy)
            }
        } else {
            if child is MainViewController {
                functionCalled = "updateChild_MainViewController"
            } else if child is CurrentWeatherViewController {
                functionCalled = "updateChild_CurrentWeatherViewController"
            } else {
                functionCalled = "out of bounds"
            }
        }
    }
    
    func updateAllChildren(buddy: Buddy, weather: [Weather]) {
        if !testMode {
            for child in childViewControllers {
                updateChild(child: child, buddy: buddy, weather: weather)
            }
        }
        else {
            testChildViewControllers.append("View1")
            testChildViewControllers.append("View2")
            childCount = testChildViewControllers.count
        }
    }
}
