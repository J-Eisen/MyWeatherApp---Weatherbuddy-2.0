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
    print("Saving Buddy...")
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: buddyEntityString, in: managedContext)!
    let savedBuddy = NSManagedObject(entity: entity, insertInto: managedContext)
    savedBuddy.setValue(buddy.location.0, forKeyPath: "latitude")
    savedBuddy.setValue(buddy.location.1, forKeyPath: "longitude")
    savedBuddy.setValue(buddy.rawData.english.highTemp, forKeyPath: "eHighTemp")
    savedBuddy.setValue(buddy.rawData.english.lowTemp, forKeyPath: "eLowTemp")
    savedBuddy.setValue(buddy.rawData.english.rain, forKeyPath: "eRain")
    savedBuddy.setValue(buddy.rawData.english.snow, forKeyPath: "eSnow")
    savedBuddy.setValue(buddy.rawData.precip, forKeyPath: "precipitation")
    savedBuddy.setValue(buddy.rawData.uvIndex, forKeyPath: "uvIndex")
    savedBuddy.setValue(buddy.lastHour, forKeyPath: "lastHour")
    
    saveSettings(settings: buddy.settings)
    
    appDelegate.saveContext()
}

func saveSettings(settings: Settings){
    print("Saving Settings...")
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
    
    appDelegate.saveContext()
    print("Save Complete!")
}

func loadBuddy() -> Buddy {
    print("Loading Buddy...")
    var loadedBuddy = Buddy.init(location: defaultLocation, lastHour: "0")
    let loadedSettings = loadSettings()
    
    guard let fetchedBuddies = fetchData(entityString: buddyEntityString)
        else { return loadedBuddy  }
    
    let fetchedBuddy = fetchedBuddies.last!
    
    loadedBuddy = Buddy.init(
        latitude: fetchedBuddy.value(forKey: "latitude") as? Double ?? 10017,
        longitude: fetchedBuddy.value(forKey: "longitude") as? Double ?? 0,
        highTemp: fetchedBuddy.value(forKey: "eHighTemp") as? Float ?? 0,
        lowTemp: fetchedBuddy.value(forKey: "eLowTemp") as? Float ?? 100,
        rain: fetchedBuddy.value(forKey: "eRain") as? Float ?? 0,
        snow: fetchedBuddy.value(forKey: "eSnow") as? Float ?? 0,
        precip: fetchedBuddy.value(forKey: "precipitation") as? Float ?? 0,
        uvIndex: fetchedBuddy.value(forKey: "uvIndex") as? Float ?? 0,
        lastHour: fetchedBuddy.value(forKey: "lastHour") as? String ?? "0",
        settings: loadedSettings)
    
    print("Load Complete!")
    return loadedBuddy
}

func loadSettings() -> Settings {
    print("Loading Settings...")
    let loadedSettings: Settings!
    guard let fetchedSettings = fetchData(entityString: settingsEntityString)?.last
        else { return Settings.init() }
    
    loadedSettings = Settings.init(
        highTemp: fetchedSettings.value(forKey: "eHighTemp") as? Float ?? 80,
        lowTemp: fetchedSettings.value(forKey: "eLowTemp") as? Float ?? 60,
        rain: fetchedSettings.value(forKey: "eRain") as? Float ?? 1.0,
        snow: fetchedSettings.value(forKey: "eSnow") as? Float ?? 1.0,
        precipitation: fetchedSettings.value(forKey: "precipitation") as? Float ?? 40,
        uvIndex: fetchedSettings.value(forKey: "uvIndex") as? Float ?? 2,
        locationAuth: fetchedSettings.value(forKey: "authorization") as? Int ?? 0,
        systemType: fetchedSettings.value(forKey: "system") as? Int ?? 0,
        tempType: fetchedSettings.value(forKey: "temperature") as? Int ?? 0)
    
    print("Load Complete!")
    return loadedSettings
}

func fetchData(entityString: String) -> [NSManagedObject]? {
    print("Fetching CoreData...")
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
    print("CoreData Fetch Complete!")
    return fetchedData
}
