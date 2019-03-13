//
//  CoreDataManager.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 05/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static var mainViewContext : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    class public func saveMainContext() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        
    }
    
    class public func getKitingSpots() -> [KitingSpot]? {
        
        let spotsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KitingSpot")
        spotsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let fetchedSpots = try CoreDataManager.mainViewContext.fetch(spotsFetchRequest) as! [KitingSpot]
            if fetchedSpots.count > 0 {
                return fetchedSpots
            } else {
                return nil
            }
        } catch {
            fatalError("Failed to fetch KitingSpots: \(error)")
        }
    }
    
    class public func getKitingSpot(id: String) -> KitingSpot? {
       
        let spotFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KitingSpot")
        spotFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        spotFetchRequest.predicate = NSPredicate(format: "spotId = %@", id)
        do {
            let fetchedSpots = try CoreDataManager.mainViewContext.fetch(spotFetchRequest) as! [KitingSpot]
            return fetchedSpots.first
        } catch {
            fatalError("Failed to fetch KitingSpot with id: \(id). Error: \(error)")
        }
    }
    
    class public func getFilteredSpots(country: String? = nil, windProbability: Double? = nil) -> [KitingSpot] {
        
        var fetchedSpots: [KitingSpot] = []
        let spotFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KitingSpot")
        spotFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if (country != nil) && (windProbability != nil) {
            spotFetchRequest.predicate = NSPredicate(format: "country == %@ && windProbability == %@", country!, windProbability!)
        } else if country == nil && windProbability != nil {
            spotFetchRequest.predicate = NSPredicate(format: "windProbability == %@", windProbability!)
        } else if country != nil && windProbability == nil {
            spotFetchRequest.predicate = NSPredicate(format: "country == %@", country!)
        }
        
        do {
            fetchedSpots = try CoreDataManager.mainViewContext.fetch(spotFetchRequest) as! [KitingSpot]
        } catch {
            fatalError("Failed to fetch filtered kitingSpots. Error: \(error)")
        }
        
        return fetchedSpots
    }
}
