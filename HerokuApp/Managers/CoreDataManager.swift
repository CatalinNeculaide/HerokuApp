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
}
