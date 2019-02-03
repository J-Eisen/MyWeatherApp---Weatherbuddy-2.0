//
//  CoreLocationFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/31/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//
/*
import CoreLocation
import UIKit

let locationManager = CLLocationManager()
var location: CLLocation?

func getUserLocation(viewController: UIViewController) -> CLLocation? {
    let locManager = locationManagerSetup(viewController: viewController)
    guard locManager != nil else { return nil }
    locManager!.requestLocation()
    guard location != nil else { return nil }
    return location
}

func checkAuthoriztion(locationManager: CLLocationManager) -> Bool {
    var authorization: Bool = false
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
    guard !checkAuthoriztion(locationManager: locationManager) else { return nil }
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.distanceFilter = 1000.0
    locationManager.delegate = viewController as? CLLocationManagerDelegate
    return locationManager
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    location = locations.last
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
*/
