//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/7/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit
import CoreLocation

let defaultLocation: Double = 11221

class MainViewController: UIViewController {
    
    @IBOutlet weak var weatherBuddySaysLabel: UILabel!
    @IBOutlet weak var outfitLabel: UILabel!
    @IBOutlet weak var sunglassesLabel: UILabel!
    @IBOutlet weak var umbrellaLabel: UILabel!
    @IBOutlet weak var bootsLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var location = defaultLocation
    var testMode = false
    var weather: [Weather] = []
    var selectedTime = 0
    var lastTime = 0
    var buddy: Buddy!
    var tempSettings: Settings!
    var labelArray: [UILabel] = []
    let locationManager = CLLocationManager()
    var initalLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalLocation = super.view.center
        buddy = loadBuddy()
        sunglassesLabel.text = "Sunglasses"
        umbrellaLabel.text = "Umbrella"
        labelArray.append(contentsOf: [outfitLabel, sunglassesLabel, umbrellaLabel, bootsLabel])
        for label in labelArray {
            label.isHidden = true
        }
        loadingIndicator.isHidden = false
        print("Getting user location")
        if buddy.settings.locationPreferences[0] {
            getLocation()
        } else {
            buddy.location = (buddy.settings.zipcode, 0.0)
        }
        if buddy.location.1 == 0.0 {
            buddy.location = (buddy.settings.zipcode, 0.0)
        }
        print("Reloading View After Fetch Running...")
        reloadViewAfterFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tempSettings != nil {
            buddy.settings = tempSettings
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SettingsViewController {
            let vc = segue.destination as! SettingsViewController
            vc.settings = buddy.settings
            vc.initialSettings = buddy.settings
        }
    }
    
    @IBAction func panHandler(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else { return }
        
        if recognizer.state == .changed {
            if recognizer.location(in: super.view).y > initalLocation.y { // Down Drag
                let translateY = recognizer.translation(in: super.view).y
                super.view.center.y += translateY
                if super.view.center.y > initalLocation.y + 100 {
                    super.view.center.y = initalLocation.y + 100
                }
                reloadViewAfterFetch()
            }
        } else if recognizer.state == .ended {
            super.view.center = initalLocation
        }
    }
}

extension MainViewController {
    func reloadViewAfterFetch(){
        print("fetching...")
        loadingIndicator.isHidden = false
        fetch(location: buddy.location, testMode: testMode) {
            newWeather in
            self.weather.append(contentsOf: newWeather!)
            DispatchQueue.main.async {
                self.buddy.updateBuddy(newWeatherArray: self.weather)
                self.loadingIndicator.isHidden = true
                self.labelArray = updateBuddyLabels(buddy: self.buddy, labels: self.labelArray)
            }
        }
        print("fetch complete!")
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000.0
        locationManager.delegate = self
        guard checkAuthoriztion(locationManager: locationManager) else { return }
        locationManager.requestLocation()
    }
    
    func checkAuthoriztion(locationManager: CLLocationManager) -> Bool {
        var authorization: Bool = false
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                authorization = true
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            default:
                authorization = false
            }
        return authorization
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinates = locations.last!.coordinate
        buddy.location = (coordinates.latitude.binade, coordinates.longitude.binade)
        print(buddy.location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError {
            case CLError.locationUnknown:
                print("Location Unknown \(clError)")
            case CLError.denied:
                print("Denied \(clError)")
            default:
                print("Core Location Error \(clError)")
            }
        } else {
            print("Other Error:", error.localizedDescription)
        }
    }
}
