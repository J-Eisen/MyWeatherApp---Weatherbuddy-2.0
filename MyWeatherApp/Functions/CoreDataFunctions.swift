//
//  CoreDataFunctions.swift
//  MyWeatherApp
//
//  Created by Jonah Eisenstock on 1/31/19.
//  Copyright © 2019 JonahEisenstock. All rights reserved.
//

import UIKit
import CoreData

let buddyEntityString = "BuddySave"
let settingsEntityString = "SettingsSave"

func saveBuddy(buddy: Buddy){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: buddyEntityString, in: managedContext)!
    let buddySave = NSManagedObject(entity: entity, insertInto: managedContext)
    buddySave.setValue(buddy.location.0 , forKeyPath: "latitude")
    buddySave.setValue(buddy.location.1 , forKeyPath: "longitude")
    buddySave.setValue(buddy.rawData.english.highTemp, forKeyPath: "eHighTemp")
    buddySave.setValue(buddy.rawData.english.lowTemp, forKeyPath: "eLowTemp")
    buddySave.setValue(buddy.rawData.english.rain, forKeyPath: "eRain")
    buddySave.setValue(buddy.rawData.english.snow, forKeyPath: "eSnow")
    buddySave.setValue(buddy.rawData.precip, forKeyPath: "precipitation")
    buddySave.setValue(buddy.rawData.uvIndex, forKeyPath: "uvIndex")
    buddySave.setValue(buddy.lastHour, forKeyPath: "lastHour")
    
    saveSettings(settings: buddy.settings)
    
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

func saveSettings(settings: Settings){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: settingsEntityString, in: managedContext)!
    let settingsSave = NSManagedObject(entity: entity, insertInto: managedContext)
    
    settingsSave.setValue(settings.locationAuthorization, forKeyPath: "authorization")
    settingsSave.setValue(settings.systemType, forKeyPath: "system")
    settingsSave.setValue(settings.tempType, forKeyPath: "temperature")
    settingsSave.setValue(settings.english.highTemp, forKeyPath: "eHighTemp")
    settingsSave.setValue(settings.english.lowTemp, forKeyPath: "eLowTemp")
    settingsSave.setValue(settings.english.rain, forKeyPath: "eRain")
    settingsSave.setValue(settings.english.snow, forKeyPath: "eSnow")
    settingsSave.setValue(settings.precip, forKeyPath: "precipitation")
    settingsSave.setValue(settings.uvIndex, forKeyPath: "uvIndex")
    
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Saving Error. \(error), \(error.userInfo)")
    }
}

func loadBuddy() -> Buddy? {
    let loadedBuddy: Buddy!
    let loadedSettings: Settings!
    
    guard let fetchedData = fetchData(entityString: buddyEntityString)?.first
        else { return nil }
    if loadSettings() != nil {
       loadedSettings = loadSettings()
    } else {
        loadedSettings = Settings.init()
    }
    loadedBuddy = Buddy.init(
        latitude: fetchedData.value(forKeyPath: "latitude") as? Double ?? 10017,
        longitude: fetchedData.value(forKeyPath: "longitude") as? Double ?? 0,
        highTemp: fetchedData.value(forKeyPath: "eHighTemp") as? Float ?? 0,
        lowTemp: fetchedData.value(forKeyPath: "eLowTemp") as? Float ?? 100,
        rain: fetchedData.value(forKeyPath: "eRain") as? Float ?? 0,
        snow: fetchedData.value(forKeyPath: "eSnow") as? Float ?? 0,
        precip: fetchedData.value(forKeyPath: "precip") as? Float ?? 0,
        uvIndex: fetchedData.value(forKeyPath: "uvIndex") as? Float ?? 0,
        settings: loadedSettings,
        lastHour: fetchedData.value(forKeyPath: "lastHour") as? String ?? "0")
    
    return loadedBuddy
}

func loadSettings() -> Settings? {
    let loadedSettings: Settings!
    guard let fetchedData = fetchData(entityString: settingsEntityString)?.first
        else { return nil }
    
    loadedSettings = Settings.init(
        highTemp: fetchedData.value(forKeyPath: "eHighTemp") as? Float ?? 80,
        lowTemp: fetchedData.value(forKeyPath: "eLowTemp") as? Float ?? 60,
        rain: fetchedData.value(forKeyPath: "eRain") as? Float ?? 1.0,
        snow: fetchedData.value(forKeyPath: "eSnow") as? Float ?? 1.0,
        precipitation: fetchedData.value(forKeyPath: "precipitation") as? Float ?? 40,
        uvIndex: fetchedData.value(forKeyPath: "uvIndex") as? Float ?? 2,
        locationAuth: fetchedData.value(forKeyPath: "authorization") as? Int ?? 0,
        systemType: fetchedData.value(forKeyPath: "system") as? Int ?? 0,
        tempType: fetchedData.value(forKeyPath: "temperature") as? Int ?? 0)
    
    return loadedSettings
}

func fetchData(entityString: String) -> [NSManagedObject]? {
    var fetchedData: [NSManagedObject] = []
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return nil }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityString)
    do {
        fetchedData = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Fetching Error. \(error), \(error.userInfo)")
    }
    return fetchedData
}
