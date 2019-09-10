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
var functionCalled = false
var managedObjectChanged = false
var managedContextCount: Int = 0
var testEntity: NSEntityDescription!
var testManagedObject: NSManagedObject!

//MARK: - Save Functions

func saveBuddy(buddy: Buddy){
    print("Saving Buddy...")
    
    guard let managedContext = getManagedContext() else { return }
    
    if !testMode {
        let entity = NSEntityDescription.entity(forEntityName: buddyEntityString, in: managedContext)!
        let savedBuddy = NSManagedObject(entity: entity, insertInto: managedContext)
        savedBuddy.setValue(buddy.location.0, forKeyPath: "latitude")
        savedBuddy.setValue(buddy.location.1, forKeyPath: "longitude")
        savedBuddy.setValue(buddy.rawData.english.highTemp, forKeyPath: "eHighTemp")
        savedBuddy.setValue(buddy.rawData.english.lowTemp, forKeyPath: "eLowTemp")
        savedBuddy.setValue(buddy.rawData.english.rain, forKeyPath: "eRain")
        savedBuddy.setValue(buddy.rawData.english.snow, forKeyPath: "eSnow")
        savedBuddy.setValue(buddy.rawData.precip, forKeyPath: "precipitation")
        
        saveSettings(settings: buddy.settings)
        saveData(managedContext: managedContext)
    } else {
        functionCalled = true
        testEntity = NSEntityDescription.entity(forEntityName: buddyEntityString, in: managedContext)
        testManagedObject = NSManagedObject(entity: testEntity, insertInto: managedContext)
    }
}

func saveSettings(settings: Settings){
    print("Saving Settings...")
    
    guard let managedContext = getManagedContext() else { return }
    
    if !testMode {
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
        
        saveData(managedContext: managedContext)
    } else {
        functionCalled = true
        testEntity = NSEntityDescription.entity(forEntityName: settingsEntityString, in: managedContext)
        testManagedObject = NSManagedObject(entity: testEntity, insertInto: managedContext)
        managedContextCount = managedContext.insertedObjects.count
        managedObjectChanged = testManagedObject.hasChanges
    }
    print("Save Complete!")
}

//MARK: - Load Functions

func loadBuddy() -> Buddy {
    print("Loading Buddy...")
    var loadedBuddy = Buddy.init(location: defaultLocation.0)
    let loadedSettings = loadSettings()
    
    guard let fetchedBuddies = fetchData(entityString: buddyEntityString)
        else { return loadedBuddy  }
    
    guard fetchedBuddies.last != nil
        else { return loadedBuddy }
    
    let fetchedBuddy = fetchedBuddies.last!
    if !testMode {
        loadedBuddy = Buddy.init(
            latitude: fetchedBuddy.value(forKey: "latitude") as? Double ?? defaultLocation.0,
            longitude: fetchedBuddy.value(forKey: "longitude") as? Double ?? defaultLocation.1,
            highTemp: fetchedBuddy.value(forKey: "eHighTemp") as? Float ?? defaultValues[0],
            lowTemp: fetchedBuddy.value(forKey: "eLowTemp") as? Float ?? defaultValues[1],
            rain: fetchedBuddy.value(forKey: "eRain") as? Float ?? defaultValues[2],
            snow: fetchedBuddy.value(forKey: "eSnow") as? Float ?? defaultValues[3],
            precip: fetchedBuddy.value(forKey: "precipitation") as? Float ?? defaultValues[4],
            uvIndex: fetchedBuddy.value(forKey: "uvIndex") as? Float ?? defaultValues[5],
            settings: loadedSettings)
    }
    
    print("Load Complete!")
    return loadedBuddy
}

func loadSettings() -> Settings {
    print("Loading Settings...")
    let loadedSettings: Settings!
    
    guard let fetchedSettings = fetchData(entityString: settingsEntityString)?.last
        else {
            print("Fetch Error: Default Settings Used")
            return Settings.init()
        }
    
    loadedSettings = Settings.init(
        highTemp: fetchedSettings.value(forKey: "eHighTemp") as? Float ?? defaultSettingsFloats[0],
        lowTemp: fetchedSettings.value(forKey: "eLowTemp") as? Float ?? defaultSettingsFloats[1],
        rain: fetchedSettings.value(forKey: "eRain") as? Float ?? defaultSettingsFloats[2],
        snow: fetchedSettings.value(forKey: "eSnow") as? Float ?? defaultSettingsFloats[3],
        precipitation: fetchedSettings.value(forKey: "precipitation") as? Float ?? defaultSettingsFloats[4],
        uvIndex: fetchedSettings.value(forKey: "uvIndex") as? Float ?? defaultSettingsFloats[5],
        zipcode: fetchedSettings.value(forKey: "zipcode") as? Double ?? defaultLocation.0,
        locationAuth: fetchedSettings.value(forKey: "authorization") as? Int ?? defaultSettingsInts[0],
        gpsSwitch: fetchedSettings.value(forKey: "swGPS") as? Bool ?? defaultSettingsBools[0],
        zipcodeSwitch: fetchedSettings.value(forKey: "swZipcode") as? Bool ?? defaultSettingsBools[1],
        systemType: fetchedSettings.value(forKey: "system") as? Int ?? defaultSettingsInts[1],
        tempType: fetchedSettings.value(forKey: "temperature") as? Int ?? defaultSettingsInts[2],
        dayStart: fetchedSettings.value(forKey: "dEnd") as? Int ?? defaultSettingsInts[3],
        dayEnd: fetchedSettings.value(forKey: "dStart") as? Int ?? defaultSettingsInts[4],
        buddy: fetchedSettings.value(forKey: "buddyType") as? String ?? defaultBuddyType)
    
    print("Load Complete!")
    return loadedSettings
}

//MARK: - Helper Functions

// Fetching
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

// Getting Context
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

// Save Data
func saveData(managedContext: NSManagedObjectContext?){
    if testMode != true {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        appDelegate.saveContext()
    } else if managedContext != nil {
        print("ManagedContext: \(managedContext!.hasChanges)")
        if !testMode {
            if managedContext!.hasChanges {
                do {
                    try managedContext!.save()
                } catch {
                    let error = error as NSError
                    print("Saving error \(error)")
                }
            }
        } else {
            if managedContext!.hasChanges {
                managedObjectChanged = true
            } else {
                managedObjectChanged = false
            }
        }
        functionCalled = true
    }
}
