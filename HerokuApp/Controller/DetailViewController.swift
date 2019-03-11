//
//  DetailViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 04/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var longitudeValue: UILabel!
    @IBOutlet weak var latitudeValue: UILabel!
    @IBOutlet weak var windProbabilityValue: UILabel!
    @IBOutlet weak var countryValue: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    var spotId: String = ""
    var isStarOn: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.getDetailsForSpot(spotID: spotId) { (isSuccess, error, kitingSpot) in
            
            self.longitudeValue.text = "\(kitingSpot.longitude)"
            self.latitudeValue.text = "\(kitingSpot.latitude)"
            self.windProbabilityValue.text = "\(kitingSpot.windProbability)"
            self.countryValue.text = kitingSpot.country
            
        }
        
        setImageToStarButton()

    }
    
    
    static func instantiate(with spotID: String, isFavorite: Bool) -> DetailViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        controller.spotId = spotID
        controller.isStarOn = isFavorite
        return controller
        
    }

    @IBAction func starPressed(_ sender: Any) {
        
        if isStarOn == false {
            
            APIManager.shared.addSpotToFavorites(spotID: spotId) { (isSuccess, error, spot) in
                
                if isSuccess == true && spot == self.spotId {
                    
                    self.setImageToStarButton()
                    
                }
                else {
                    print(error!)
                }
                
            }
            
        } else {
            
            APIManager.shared.removeSpotFromFavorites(spotID: spotId) { (isSuccess, error, spot) in
                
                if isSuccess == true && spot == self.spotId{
                    
                    self.setImageToStarButton()
                    
                }
                else {
                    print(error!)
                }
            }
        }
        
    }
    
    
    func setImageToStarButton() {
        
        starButton.image = isStarOn == true ? UIImage(named: "star-on") : UIImage(named: "star-off")
        
    }
  
    @IBAction func sportsButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
