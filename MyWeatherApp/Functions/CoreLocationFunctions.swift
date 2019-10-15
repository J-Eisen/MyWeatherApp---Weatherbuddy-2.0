//
//  CoreLocationFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/31/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import CoreLocation
import UIKit

let locationManager = CLLocationManager()
var location: CLLocation?

func getUserLocation(viewController: UIViewController) -> CLLocation? {
    if !testMode {
        let locManager = locationManagerSetup(viewController: viewController)
        guard locManager != nil else { return nil }
        locManager!.requestLocation()
        guard location != nil else { return nil }
        return location
    } else {
        let locManager = locationManagerSetup(viewController: viewController)
        return nil
    }
}

func checkAuthoriztion(locationManager: CLLocationManager) -> Bool {
    var authorization: Bool = false
    if !testMode {
        repeat {
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
        }while(CLLocationManager.authorizationStatus() == .notDetermined)
        return authorization
    } else {
        functionCalled = true
        return true
    }
}

func checkAuthorization(settings: Settings) -> Settings {
    var settings = settings
    settings.locationAuthorization = Int(CLLocationManager.authorizationStatus().rawValue)
    return settings
}

func loadAuthorization(settings: Settings) {
    CLAuthorizationStatus.init(rawValue: Int32(settings.locationAuthorization))
}

func locationManagerSetup(viewController: UIViewController) -> CLLocationManager? {
    if !testMode {
        guard checkAuthoriztion(locationManager: locationManager) else { return nil }
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000.0
        locationManager.delegate = viewController as? CLLocationManagerDelegate
        return locationManager
    } else {
        functionCalled = true
        return nil
    }
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if !testMode {
        location = locations.last
    } else {
        functionCalled = true
    }
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

