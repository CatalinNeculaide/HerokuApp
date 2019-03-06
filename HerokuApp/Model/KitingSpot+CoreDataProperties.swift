//
//  KitingSpot+CoreDataProperties.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 06/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON


extension KitingSpot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KitingSpot> {
        return NSFetchRequest<KitingSpot>(entityName: "KitingSpot")
    }
    
    @nonobjc public func configureWithJson(json : JSON) {
        self.spotId = json["id"].string
        self.country = json["country"].string
        self.isFavorite = json["isFavorite"].bool ?? false
        self.name = json["name"].string
        self.whenToGo = json["whenToGo"].string ?? ""
        self.latitude = json["latitude"].int16 ?? 0
        self.longitude = json["longitude"].int16 ?? 0
        self.windProbability = json["windProbability"].int16 ?? 0
        
    }

    @NSManaged public var country: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var spotId: String?
    @NSManaged public var whenToGo: String?
    @NSManaged public var latitude: Int16
    @NSManaged public var longitude: Int16
    @NSManaged public var windProbability: Int16

}
