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
var saveDataCalled = false
var managedContextChanged = false

func saveBuddy(buddy: Buddy){
    print("Saving Buddy...")
    
    guard let managedContext = getManagedContext() else { return }
    
    let entity = NSEntityDescription.entity(forEntityName: buddyEntityString, in: managedContext)!
    let savedBuddy = NSManagedObject(entity: entity, insertInto: managedContext)
    savedBuddy.setValue(buddy.location.0, forKeyPath: "latitude")
    savedBuddy.setValue(buddy.location.1, forKeyPath: "longitude")
    savedBuddy.setValue(buddy.rawData.english.highTemp, forKeyPath: "eHighTemp")
    savedBuddy.setValue(buddy.rawData.english.lowTemp, forKeyPath: "eLowTemp")
    savedBuddy.setValue(buddy.rawData.english.rain, forKeyPath: "eRain")
    savedBuddy.setValue(buddy.rawData.english.snow, forKeyPath: "eSnow")
    savedBuddy.setValue(buddy.rawData.precip, forKeyPath: "precipitation")
    
    if !testMode {
        saveSettings(settings: buddy.settings)
    }
    
    saveData()
}

func saveSettings(settings: Settings){
    print("Saving Settings...")
    
    guard let managedContext = getManagedContext() else { return }
    
    let entity = NSEntityDescription.entity(forEntityName: settingsEntityString, in: managedContext)!
    let settingsSave = NSManagedObject(entity: entity, insertInto: managedContext)
    
    settingsSave.setValue(settings.locationAuthorization, forKeyPath: "authorization")
    settingsSave.setValue(settings.locationPreferences[0], forKeyPath: "swGPS")
    settingsSave.setValue(settings.locationPreferences[1], forKeyPath: "swZipcode")
    settingsSave.setValue(settings.zipcode, forKeyPath: "zipcode")
    settingsSave.setValue(settings.systemType, forKeyPath: "system")
    settingsSave.setValue(settings.tempType, forKeyPath: "temperature")
    settingsSave.setValue(settings.english.highTemp, forKeyPath: "eHighTemp")
    settingsSave.setValue(settings.english.lowTemp, forKeyPath: "eLowTemp")
    settingsSave.setValue(settings.english.rain, forKeyPath: "eRain")
    settingsSave.setValue(settings.english.snow, forKeyPath: "eSnow")
    settingsSave.setValue(settings.precip, forKeyPath: "precipitation")
    settingsSave.setValue(settings.uvIndex, forKeyPath: "uvIndex")
    settingsSave.setValue(settings.dayStart, forKeyPath: "dStart")
    settingsSave.setValue(settings.dayEnd, forKeyPath: "dEnd")
    settingsSave.setValue(settings.buddyType, forKeyPath: "buddyType")
    
    saveData()
    
    print("Save Complete!")
}

func loadBuddy() -> Buddy {
    print("Loading Buddy...")
    var loadedBuddy = Buddy.init(location: defaultLocation)
    let loadedSettings = loadSettings()
    
    guard let fetchedBuddies = fetchData(entityString: buddyEntityString)
        else { return loadedBuddy  }
    
    guard fetchedBuddies.last != nil
        else { return loadedBuddy }
    
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
        zipcode: fetchedSettings.value(forKey: "zipcode") as? Double ?? 10007,
        locationAuth: fetchedSettings.value(forKey: "authorization") as? Int ?? 0,
        gpsSwitch: fetchedSettings.value(forKey: "swGPS") as? Bool ?? true,
        zipcodeSwitch: fetchedSettings.value(forKey: "swZipcode") as? Bool ?? true,
        systemType: fetchedSettings.value(forKey: "system") as? Int ?? 0,
        tempType: fetchedSettings.value(forKey: "temperature") as? Int ?? 0,
        dayStart: fetchedSettings.value(forKey: "dEnd") as? Int ?? 8,
        dayEnd: fetchedSettings.value(forKey: "dStart") as? Int ?? 19,
        buddy: fetchedSettings.value(forKey: "buddyType") as? String ?? "CircleBuddy")
    
    print("Load Complete!")
    return loadedSettings
}

func fetchData(entityString: String) -> [NSManagedObject]? {
    print("Fetching CoreData...")
    var fetchedData: [NSManagedObject] = []
    
    let managedContext = getManagedContext()
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityString)
    do {
        fetchedData = try managedContext!.fetch(fetchRequest)
    } catch let error as NSError {
        print("Fetching Error. \(error), \(error.userInfo)")
    }
    print("CoreData Fetch Complete!")
    return fetchedData
}

func getManagedContext() -> NSManagedObjectContext! {
    guard testMode == true else {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        else { return nil }
    let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
//    let store = storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = storeCoordinator
    return managedObjectContext
}

func saveData(){
    if testMode != true {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        appDelegate.saveContext()
    } else {
        guard let managedContext = getManagedContext()
            else { print("Error creating mock context")
                return }
        managedContextChanged = managedContext.hasChanges
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let error = error as NSError
                print("Saving error \(error)")
            }
        }
        saveDataCalled = true
    }
}
