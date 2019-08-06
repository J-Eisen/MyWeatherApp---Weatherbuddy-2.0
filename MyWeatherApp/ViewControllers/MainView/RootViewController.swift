//
//  RootViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/10/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIPageViewController {
    var buddy: Buddy!
    var tempSettings: Settings!
    var weather: [Weather] = []
    var pageControl = UIPageControl()
    var navBarDelegate = NavBar()
    let locationManager = CLLocationManager()
    let childrenDelegate = RootViewChildren()
    let newChildNameArray = ["Main", "CurrentWeather"]

    override func viewDidLoad() {
        super.viewDidLoad()
        buddy = loadBuddy()
        childrenDelegate.initializeChildren(names: newChildNameArray, buddy: buddy)
        reloadViewAfterFetch()
        if let firstViewController = childrenDelegate.childViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        self.dataSource = self
        self.delegate = self
        configurePageControl()
        navBarDelegate.setUp(buddy: buddy, parentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tempSettings != nil {
            buddy.settings = tempSettings
        }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.destination is SettingsViewController {
                if !testMode {
                    let vc = segue.destination as! SettingsViewController
                    vc.settings = buddy.settings
                    vc.initialSettings = buddy.settings
                } else {
                    segueString = "Root To Settings"
                }
            }
    }
}

//MARK:- UIPageViewControllerDataSource

extension RootViewController: UIPageViewControllerDataSource {
    // ToViewBefore
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = childrenDelegate.childViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard childrenDelegate.childViewControllers.count > previousIndex else {
            return nil
        }
        
        guard previousIndex >= 0 else {
            let childToUpdate = childrenDelegate.childViewControllers.last
            if childToUpdate is CurrentWeatherViewController {
            childrenDelegate.updateChild(child: childToUpdate!, buddy: buddy, weather: weather)
            } else {
             childrenDelegate.updateChild(child: childToUpdate!, buddy: buddy, weather: nil)
            }
            return childrenDelegate.childViewControllers.last
        }
        
        let childToUpdate = childrenDelegate.childViewControllers[previousIndex]
        if childToUpdate is CurrentWeatherViewController {
            childrenDelegate.updateChild(child: childToUpdate, buddy: buddy, weather: weather)
        } else {
            childrenDelegate.updateChild(child: childToUpdate, buddy: buddy, weather: nil)
        }
        return childrenDelegate.childViewControllers[previousIndex]
    }
    
    // ToViewAfter
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = childrenDelegate.childViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard childrenDelegate.childViewControllers.count > nextIndex else {
            return nil
        }
        
        guard childrenDelegate.childViewControllers.count != nextIndex else {
            let childToUpdate = childrenDelegate.childViewControllers.first!
            if childToUpdate is CurrentWeatherViewController {
                childrenDelegate.updateChild(child: childToUpdate, buddy: buddy, weather: weather)
            } else {
                childrenDelegate.updateChild(child: childrenDelegate.childViewControllers[nextIndex], buddy: buddy, weather: nil)
            }
            
            return childrenDelegate.childViewControllers.first!
        }
        
        let childToUpdate = childrenDelegate.childViewControllers[nextIndex]
        if childToUpdate is CurrentWeatherViewController {
            childrenDelegate.updateChild(child: childrenDelegate.childViewControllers[nextIndex], buddy: buddy, weather: weather)
        } else {
            childrenDelegate.updateChild(child: childrenDelegate.childViewControllers[nextIndex], buddy: buddy, weather: nil)
        }
        return childrenDelegate.childViewControllers[nextIndex]
    }
}

extension RootViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.children[0]
        self.pageControl.currentPage = childrenDelegate.childViewControllers.firstIndex(of: pageContentViewController)!
    }
}

//MARK:- Functions
extension RootViewController {
    
    //MARK: Config Element Functions
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 25, y: UIScreen.main.bounds.maxY - 75, width: 50, height: 50))
        self.pageControl.numberOfPages = childrenDelegate.childViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }

    //MARK: Reload after fetch
    func reloadViewAfterFetch(){
        print("fetching...")
        weather = []
        fetch(location: buddy.location) {
            newWeather in
            self.weather.append(contentsOf: newWeather!)
            DispatchQueue.main.async {
                self.buddy.updateBuddy(newWeatherArray: self.weather)
                self.childrenDelegate.updateAllChildren(buddy: self.buddy, weather: self.weather)
            }
        }
        print("fetch complete!")
    }
    
    func getUserLocation() {
        if buddy.settings.locationPreferences[0] {
            getLocation()
        } else {
            buddy.location = (buddy.settings.zipcode, 0.0)
        }
        if buddy.location.1 == 0.0 {
            buddy.location = (buddy.settings.zipcode, 0.0)
        }
    }
}

//MARK:- CLocationManagerDelegate
extension RootViewController: CLLocationManagerDelegate {
    
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
