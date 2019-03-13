//
//  APIManager.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 05/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum EndPoint: String {
    case getUser = "/api-user-get"
    case getAll = "/api-spot-get-all"
    case getDetails = "/api-spot-get-details"
    case getCountry = "/api-spot-get-countries"
    case addFavorites = "/api-spot-favorites-add"
    case removeFavorites = "/api-spot-favorites-remove"
}


class APIManager {
    
    let url = "https://internship-2019.herokuapp.com"
    static let shared = APIManager()
    
    private static var headers : HTTPHeaders {
        var headerDict = HTTPHeaders()
        headerDict["Content-Type"] = "application/json"
        if let token = UserDefaults.standard.string(forKey: "token") {
            headerDict["token"] = token
        }
        else {
            
        }
        return headerDict
    }
    
    func getEndPoint(endpoint: EndPoint) -> String {
        
        return url + endpoint.rawValue
        
    }
    
    static func handleApiError(from json: JSON) {
        
        //Show alert with error code and message
        if json["error"]["message"].string != nil {
            let error = Ab4Error(with: json["error"])
            //Show error
            let alert = UIAlertController(title: "Oops!", message: "\(error.code) : \(error.message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            print("Error code: \(error.code) with message: \(error.message)")
        }
        
    }
    
    
    func getUser(email: String, completionHandler: @escaping (Bool, Error?) -> Void ) {
        let parameters = ["email" : email]
        
        Alamofire.request(getEndPoint(endpoint: .getUser), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: APIManager.headers).responseJSON { (dataResponse) in
            
            if dataResponse.result.isSuccess {
                let json = JSON(dataResponse.result.value!)
                APIManager.handleApiError(from: json)
            
                if let token = json["result"]["token"].string {
                UserDefaults.standard.set(token, forKey: "token")
                }
            
                completionHandler(dataResponse.result.isSuccess, dataResponse.result.error)
            } else {
                print(dataResponse.result.error!)
                APIManager.handleApiError(from: JSON(dataResponse.result.value!))
            }

        }
    }

    
    func getAllSpots(country: String? = nil, windProbability: Double? = nil, completionHandler: @escaping (Bool, Error?, [KitingSpot]) -> Void) {
        var parameters: Parameters = [:]
        
        if let country = country {
            parameters["country"] = country
        }
        
        if let windProbability = windProbability {
            parameters["windProbability"] = windProbability
        }
        
        Alamofire.request(getEndPoint(endpoint: .getAll), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: APIManager.headers).responseJSON { (dataResponse) in
            
            var kitingSpots = [KitingSpot]()
            
            if dataResponse.result.isSuccess {
                let json = JSON(dataResponse.result.value!)
                APIManager.handleApiError(from: json)
                
                
                let localKitingSpots = CoreDataManager.getKitingSpots() ?? []
                for kitingSpot in localKitingSpots {
                    CoreDataManager.mainViewContext.delete(kitingSpot)
                }
                
                if let kitingSpotsJsons = json["result"].array {
                    for kitingSpotJson in kitingSpotsJsons {
                        let kitingSpot = KitingSpot(context: CoreDataManager.mainViewContext)
                        kitingSpot.configureWithJson(json: kitingSpotJson)
                        kitingSpots.append(kitingSpot)
                    }
                }
            } else {
                print(dataResponse.result.error!)
                kitingSpots = CoreDataManager.getFilteredSpots(country: country, windProbability: windProbability)
            }
            completionHandler(dataResponse.result.isSuccess, dataResponse.result.error,kitingSpots)
        }
    }
    
    
    func getDetailsForSpot(spotID: String, completionHandler: @escaping (Bool, Error?, KitingSpot) -> Void) {
        
        let parameters: [String:String] = ["spotId":spotID]
        
        Alamofire.request(getEndPoint(endpoint: .getDetails), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: APIManager.headers).responseJSON { (dataResponse) in
            
            if dataResponse.result.isSuccess {
                let json = JSON(dataResponse.result.value!)["result"]
                APIManager.handleApiError(from: json)
                guard let spotId = json["id"].string else {
                    print("No spot id received from API")
                    return
                }
                
                if let localKitingSpot = CoreDataManager.getKitingSpot(id: spotId) {
                    localKitingSpot.configureWithJson(json: json)
                    completionHandler(dataResponse.result.isSuccess, dataResponse.result.error, localKitingSpot)
                    
                } else {
                    let newKitingSpot = KitingSpot(context: CoreDataManager.mainViewContext)
                    newKitingSpot.configureWithJson(json: json)
                    completionHandler(dataResponse.result.isSuccess, dataResponse.result.error, newKitingSpot)
                }
                        
            } else {
                print(dataResponse.result.error!)
                if let localKitingSpot = CoreDataManager.getKitingSpot(id: spotID) {
                    completionHandler(dataResponse.result.isSuccess, dataResponse.result.error, localKitingSpot)
                }
            }
        }
    }
    
    
    func getCountries(completionHandler: @escaping (Bool, Error?, [String]) -> Void) {
        
        
        
        Alamofire.request(getEndPoint(endpoint: .getCountry), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: APIManager.headers).responseJSON { (dataResponse) in
             var countries = [String]()
            if dataResponse.result.isSuccess {
                let json = JSON(dataResponse.result.value!)
                APIManager.handleApiError(from: json)
    
            
                if let countriesJson = json["result"].array {
                    for countryJson in countriesJson {
                        let country = countryJson.string
                        countries.append(country!)
                    }
                }
            } else {
                print(dataResponse.result.error!)
            }
            completionHandler(dataResponse.result.isSuccess, dataResponse.result.error, countries)
        }
    }
    
    func addSpotToFavorites(spotID: String, completionHandler: @escaping (Bool, Error?, String) -> Void) {
        
        let parameters: [String: String] = ["spotId":spotID]
        
        Alamofire.request(getEndPoint(endpoint: .addFavorites), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: APIManager.headers).responseJSON { (dataResponse) in
            if dataResponse.result.isSuccess {
                let json = JSON(dataResponse.result.value!)
                APIManager.handleApiError(from: json)
            
                if let idSpot = json["result"].string {
                    if idSpot != spotID {
                        print("Error, wrong spot added to favorites")
                    }
                }
            } else {
                print(dataResponse.result.error!)
            }
            completionHandler(dataResponse.result.isSuccess, dataResponse.result.error, spotID)
        }
    }
    
    func removeSpotFromFavorites(spotID: String, completionHandler: @escaping (Bool, Error?, String) -> Void) {
        
        let parameters: [String:String] = ["spotId":spotID]
        
        Alamofire.request(getEndPoint(endpoint: .removeFavorites), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: APIManager.headers).responseJSON { (dataResponse) in
            if dataResponse.result.isSuccess {
                let json = JSON(dataResponse.result.value!)
                APIManager.handleApiError(from: json)
            
                if let idSpot = json["result"].string {
                    if idSpot != spotID {
                        print("Error, wrong spot removed from favorites")
                    }
                }
            } else {
                print(dataResponse.result.error!)
            }
            completionHandler(dataResponse.result.isSuccess, dataResponse.result.error, spotID)
        }
    }
    
    
    
}
    


