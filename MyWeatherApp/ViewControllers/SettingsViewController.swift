//
//  SettingsViewController.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/17/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController {
    var settings: Settings!
    var initialSettings: Settings!
    
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var precipLabel: UILabel!
    
    @IBOutlet weak var highTempSlider: UISlider!
    @IBOutlet weak var lowTempSlider: UISlider!
    @IBOutlet weak var precipitationSlider: UISlider!
    
    @IBOutlet weak var rainPicker: UIPickerView!
    @IBOutlet weak var snowPicker: UIPickerView!
    @IBOutlet var unitLabels: [UILabel]!
    
    @IBOutlet weak var systemSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tempSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var gpsSwitch: UISwitch!
    @IBOutlet weak var zipcodeSwitch: UISwitch!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    let pickerDataSource = [[0,1,2,3,4,5,6,7,8,9,10],[0,1,2,3,4,5,6,7,8,9]]
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        if settings == nil {
            settings = loadSettings()
        }
    }
    
    @IBAction func segmentedControlUpdate(_ sender: UISegmentedControl) {
        if sender.restorationIdentifier == "systemSegmentedControl" {
            settings.systemType = sender.selectedSegmentIndex
            initPickers()
        } else {
            settings.tempType = sender.selectedSegmentIndex
            initSliders()
        }
        updateLables()
    }
    
    @IBAction func sliderUpdate(_ sender: UISlider) {
        
        let updateResult = updateSliderHelper(slider: sender, settings: settings)
        settings = updateResult.0
        
        if sender.restorationIdentifier == "lowTempSlider" {
            minTempLabel.text = updateResult.1
            let tempCheckResult = tempCheck(senderSlider: sender, highSlider: highTempSlider, highLabel: maxTempLabel, settings: settings)
            if tempCheckResult.0 != nil { settings = tempCheckResult.0! }
            if tempCheckResult.1 != nil { highTempSlider = tempCheckResult.1 }
            if tempCheckResult.2 != nil { maxTempLabel = tempCheckResult.2 }
        } else if sender.restorationIdentifier == "highTempSlider" {
            maxTempLabel.text = updateResult.1
            let tempCheckResult = tempCheck(senderSlider: sender, lowSlider: lowTempSlider, lowLabel: minTempLabel, settings: settings)
            if tempCheckResult.0 != nil { settings = tempCheckResult.0! }
            if tempCheckResult.1 != nil { lowTempSlider = tempCheckResult.1 }
            if tempCheckResult.2 != nil { minTempLabel = tempCheckResult.2 }
        } else {
            precipLabel.text = updateResult.1
        }
    }

    @IBAction func locationSwitchUpdate(_ sender: UISwitch) {
        if sender.accessibilityIdentifier == "zipcodeSwitch" {
                zipcodeTextField.isEnabled = sender.isOn
                zipcodeTextField.isOpaque = sender.isOn
                settings.locationPreferences[1] = sender.isOn
        } else {
            if settings.locationAuthorization != 1 ||
                settings.locationAuthorization != 2 {
                locationManager.requestWhenInUseAuthorization()
            }
            settings.locationPreferences[0] = sender.isOn
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RootViewController {
            let vc = segue.destination as! RootViewController
            if segue.identifier == "settingsToRootSave" {
                saveSettings(settings: settings)
                vc.tempSettings = settings
            } else {
                vc.tempSettings = initialSettings
            }
        }
    }

}

extension SettingsViewController {
    func initView(){
        initSliders()
        initPickers()
        initSegmentedControls()
        initSwitches()
        updateLables()
    }
    
    func initPickers(){
        rainPicker.dataSource = self
        rainPicker.delegate = self
        snowPicker.dataSource = self
        snowPicker.delegate = self
        rainPicker = initPickerHelper(picker: rainPicker, settings: settings)
        snowPicker = initPickerHelper(picker: snowPicker, settings: settings)
        unitLabels = initPickerLabelsHelper(labels: unitLabels, settings: settings)
    }
    
    func initSliders(){
        highTempSlider = initSliderHelper(slider: highTempSlider!, settings: settings)
        lowTempSlider = initSliderHelper(slider: lowTempSlider!, settings: settings)
        precipitationSlider = initSliderHelper(slider: precipitationSlider!, settings: settings)
    }
    
    func initSegmentedControls() {
        systemSegmentedControl.selectedSegmentIndex = settings.systemType
        tempSegmentedControl.selectedSegmentIndex = settings.tempType
    }
    
    func initSwitches(){
        gpsSwitch.isOn = settings.locationPreferences[0]
        zipcodeSwitch.isOn = settings.locationPreferences[1]
    }
}

extension SettingsViewController {
    func updateLables(){
        if settings.tempType == 0 {
            maxTempLabel.text = "\(Int(settings.english.highTemp)) ºF"
            minTempLabel.text = "\(Int(settings.english.lowTemp)) ºF"
        } else {
            maxTempLabel.text = celsiusDisplay(value: settings.metric.highTemp)
            minTempLabel.text = celsiusDisplay(value: settings.metric.lowTemp)
        }
        precipLabel.text = "\(Int(settings.precip)) %"
    }
    
    func resetSettings() -> Settings{
        return Settings.init()
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settings = updatePickerHelper(pickerView: pickerView, settings: settings, row: row, component: component)
        print("Rain: \(settings.english.rain) in")
        print("Snow: \(settings.english.snow) in")
        print("Rain: \(settings.metric.rain) cm")
        print("Snow: \(settings.metric.snow) cm")
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerDataSource[component][row])"
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.returnKeyType = .done
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        settings.zipcode = Double(textField.text!)!
        textField.text = ""
        return true
    }
}
