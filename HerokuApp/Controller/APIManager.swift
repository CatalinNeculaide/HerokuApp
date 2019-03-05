//
//  APIManager.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 05/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation
import Alamofire

enum EndPoint: String {
    case user_get = "/api-user-get"
    case spot_get_all = "/api-spot-get-all"
    case spot_get_details = "/api-spot-get-details"
    case spot_get_country = "/api-spot-get-country"
    case spot_favorites_add = "/api-spot-favorites-add"
    case spot_favorites_remove = "/api-spot-favorites-remove"
}


class APIManager {
    
    let url = "https://internship-2019.herokuapp.com"
    
    func getEndPoint(endpoint: EndPoint) -> String {
        
        return url + endpoint.rawValue
        
    }
    
    
    
}
