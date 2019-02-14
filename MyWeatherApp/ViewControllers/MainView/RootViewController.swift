//
//  RootViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 2/10/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit
import CoreLocation

let defaultLocation: Double = 11221

class RootViewController: UIPageViewController {
    var buddy: Buddy!
    var tempSettings: Settings!
    var weather: [Weather] = []
    var pageControl = UIPageControl()
    var navigationBar = UINavigationBar()
    let locationManager = CLLocationManager()
    var mainVC: MainViewController!
    var weatherVC: CurrentWeatherViewController!
    
    private func newViewController(name: String, buddy: Buddy) -> UIViewController {
        var newVC = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(name)ViewController")
        if newVC is MainViewController {
            mainVC = newVC as? MainViewController
            mainVC.buddy = buddy
            newVC = mainVC
        } else if newVC is CurrentWeatherViewController {
            weatherVC = newVC as? CurrentWeatherViewController
            weatherVC.buddy = buddy
            newVC = weatherVC
        }
        return newVC
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [newViewController(name: "Main", buddy: buddy), newViewController(name: "CurrentWeather", buddy: buddy)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Getting user location")
        buddy = loadBuddy()
        reloadViewAfterFetch()
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        dataSource = self
        self.delegate = delegate
        configurePageControl() //FIXME: dots don't work
        configureNavBar()   //FIXME: nav bar is too low
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tempSettings != nil {
            buddy.settings = tempSettings
        }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SettingsViewController {
            let vc = segue.destination as! SettingsViewController
            vc.settings = buddy.settings
            vc.initialSettings = buddy.settings
        }
    }
    @IBAction func longpressGesture(_ sender: UILongPressGestureRecognizer) {
    }
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
    }
}

//MARK:- UIPageViewControllerDataSource

extension RootViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            updateChildViewController(viewController: orderedViewControllers.last!)
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        updateChildViewController(viewController: orderedViewControllers[previousIndex])
        return orderedViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1

        guard orderedViewControllers.count != nextIndex else {
            updateChildViewController(viewController: orderedViewControllers.first!)
            return orderedViewControllers.first
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        updateChildViewController(viewController: orderedViewControllers[nextIndex])
        return orderedViewControllers[nextIndex]
    }
}

extension RootViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
}

//MARK:- Functions
extension RootViewController {
    //MARK: Config Functions
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 25, y: UIScreen.main.bounds.maxY - 50, width: 50, height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func configureNavBar(){
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 50))
        self.view.addSubview(navigationBar)
        
        var titleString: String
        titleString = "WeatherBuddy"
        let navItem = UINavigationItem(title: titleString)
        let settingsButton = UIBarButtonItem(image: UIImage(named: "Settings_Default"), style: .plain, target: nil, action: #selector(self.settingsButtonTapped(_:)))
        
        navItem.rightBarButtonItem = settingsButton
        navigationBar.setItems([navItem], animated: false)
    }
    
    @objc func settingsButtonTapped(_ sender: UIBarButtonItem!){
        self.performSegue(withIdentifier: "rootToSettings", sender: nil)
    }
    
    //MARK: Update Child Functions
    func updateChildViewController(viewController: UIViewController){
        if viewController is MainViewController {
            mainVC.buddy = buddy
            mainVC.buddyImage.image = imageBuilder(buddy: buddy)
        } else if viewController is CurrentWeatherViewController {
            weatherVC.weatherArray = weather
        }
    }
    
    func updateAllChildren(viewControllers: [UIViewController]){
        for vc in viewControllers {
            updateChildViewController(viewController: vc)
        }
    }

    //MARK: Reload after fetch
    func reloadViewAfterFetch(){
        print("fetching...")
        weather = []
        fetch(location: buddy.location, testMode: testMode) {
            newWeather in
            self.weather.append(contentsOf: newWeather!)
            DispatchQueue.main.async {
                self.buddy.updateBuddy(newWeatherArray: self.weather)
                self.updateAllChildren(viewControllers: self.viewControllers!)
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
