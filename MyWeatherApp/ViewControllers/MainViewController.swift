//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit

let defaultLocation: Double = 11221

class MainViewController: UIViewController {
    
    @IBOutlet weak var outfitLabel: UILabel!
    @IBOutlet weak var sunglassesLabel: UILabel!
    @IBOutlet weak var umbrellaLabel: UILabel!
    @IBOutlet weak var bootsLabel: UILabel!
    
    @IBOutlet weak var systemLabel: UILabel!
    
    var location = defaultLocation
    var testMode = false
    var weather: [Weather] = []
    var selectedTime = 0
    var lastTime = 0
    var buddy: Buddy!
    var labelArray: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buddy = loadBuddy()
        sunglassesLabel.text = "Sunglasses"
        umbrellaLabel.text = "Umbrella"
        labelArray.append(contentsOf: [outfitLabel, sunglassesLabel, umbrellaLabel, bootsLabel])
        print("Reloading View After Fetch Running...")
        reloadViewAfterFetch()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SettingsViewController {
            let vc = segue.destination as! SettingsViewController
            vc.settings = buddy.settings
        }
    }
    /*
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
            labelArray = updateBuddyLabels(buddy: self.buddy, labels: labelArray)
        }
    }*/
}

extension MainViewController {
    func reloadViewAfterFetch(){
        print("fetching...")
        fetch(location: (location, 0), testMode: testMode) {
            newWeather in
            self.weather.append(contentsOf: newWeather!)
            DispatchQueue.main.async {
                self.labelArray = updateBuddyLabels(buddy: self.buddy, labels: self.labelArray)
            }
        }
        print("fetch complete!")
    }
    
}
/*
extension MainViewController: UITextFieldDelegate {
    
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
}*/
