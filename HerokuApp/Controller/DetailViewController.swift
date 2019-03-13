//
//  DetailViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 04/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailViewController: UIViewController {
    
    @IBOutlet weak var longitudeValue: UILabel!
    @IBOutlet weak var latitudeValue: UILabel!
    @IBOutlet weak var windProbabilityValue: UILabel!
    @IBOutlet weak var countryValue: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var titleName: UINavigationItem!
    @IBOutlet weak var detailsActivityIndicator: UIActivityIndicatorView!
    
    var localKitingSpot : KitingSpot = KitingSpot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        
        detailsActivityIndicator.startAnimating()
        APIManager.shared.getDetailsForSpot(spotID: localKitingSpot.spotId) { (isSuccess, error, kitingSpot) in
            
            if isSuccess {
                self.detailsActivityIndicator.stopAnimating()
                self.localKitingSpot = kitingSpot
                CoreDataManager.saveMainContext()
                self.configure()
            }
            
        }
    }
    
    func configure(){
        title = localKitingSpot.name
        countryValue.text = localKitingSpot.country
        latitudeValue.text = "\(localKitingSpot.latitude)"
        longitudeValue.text = "\(localKitingSpot.longitude)"
        windProbabilityValue.text = "\(localKitingSpot.windProbability)%"
        setImageToStarButton()
    }
    
    static func instantiate(with kitingSpot: KitingSpot) -> DetailViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        controller.localKitingSpot = kitingSpot
        return controller
        
    }

    @IBAction func starPressed(_ sender: Any) {
        
        
        if localKitingSpot.isFavorite == false {
            
            self.localKitingSpot.setValue(true, forKey: "isFavorite")
            self.setImageToStarButton()
            APIManager.shared.addSpotToFavorites(spotID: localKitingSpot.spotId) { (isSuccess, error, spot) in
                if isSuccess == true  {
                }
                else {
                    
                    self.localKitingSpot.setValue(false, forKey: "isFavorite")
                    print(error!)
                }
                
            }
            
        } else {
            self.localKitingSpot.setValue(false, forKey: "isFavorite")
            self.setImageToStarButton()

            APIManager.shared.removeSpotFromFavorites(spotID: localKitingSpot.spotId) { (isSuccess, error, spot) in
                
                if isSuccess == true{
                    
                }
                else {
                    print(error!)
                }
            }
        }
        
        CoreDataManager.saveMainContext()
        
    }
    
    
    func setImageToStarButton() {
        
        starButton.image = localKitingSpot.isFavorite == true ? UIImage(named: "star-on") : UIImage(named: "star-off")
        
    }
  
    @IBAction func sportsButtonTapped(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    deinit {
        NSLog("DetailViewController deinit")
    }
    
}
