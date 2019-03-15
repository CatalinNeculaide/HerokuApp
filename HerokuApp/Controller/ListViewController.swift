//
//  ViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 04/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit
import SwipeCellKit

class ListViewController: UITableViewController, FilterViewControllerDelegate, SwipeTableViewCellDelegate {
   
    
    var kitingSpots : [KitingSpot] = []
    var filterViewController : FilterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.defaultBlue
        
        tableView.refreshControl = refreshControl
        
        kitingSpots = CoreDataManager.getKitingSpots() ?? []
        tableView.reloadData()
        
        if UserDefaults.standard.string(forKey: "token") == nil{
            APIManager.shared.getUser(email: "catalin.neculaide@gmail.com") { (isSuccess, error) in
                if isSuccess {
                   self.getAllSpots()
                } else {
                    print(error!)
                }
            }
        } else {
            getAllSpots()
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        
        if let filterVc = filterViewController {
            self.present(filterVc, animated: true, completion: nil)
        } else {
            filterViewController = FilterViewController.instantiate()
            filterViewController?.delegate = self
            self.present(filterViewController!, animated: true, completion: nil)
        }
        
    }
    
    func getAllSpots(country: String? = nil, windProbability: Double? = nil) {
        
        var apiKitingSpots = [KitingSpot]()
        
        APIManager.shared.getAllSpots(country: country, windProbability: windProbability) { (isSuccess, error, kitingSpotsGet) in
            if isSuccess == true {
                for kitingSpot in kitingSpotsGet {
                    apiKitingSpots.append(kitingSpot)
                }
                self.kitingSpots = apiKitingSpots
                CoreDataManager.saveMainContext()
                self.tableView.reloadData()
            } else {
                print(error!)
                apiKitingSpots = CoreDataManager.getFilteredSpots(country: country, windProbability: windProbability)
                self.kitingSpots = apiKitingSpots
                CoreDataManager.saveMainContext()
                self.tableView.reloadData()
            }
        }
        
    }
    // MARK - Tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return kitingSpots.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.delegate = self
        
        cell.accessoryType = .disclosureIndicator
        
        let item: KitingSpot = kitingSpots[indexPath.row]
        
        cell.cityName.text = item.name
        cell.countryName.text = item.country
        
        if item.isFavorite {
            cell.isFavoriteImage.isHidden = false
            cell.isFavoriteImage.image = UIImage(named: "star-on")
        } else {
            cell.isFavoriteImage.isHidden = true
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = DetailViewController.instantiate(with: kitingSpots[indexPath.row])
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var favorites: SwipeAction
        
        guard orientation == .right else { return nil }
        
        if kitingSpots[indexPath.row].isFavorite == false {
            favorites = SwipeAction(style: .default, title: "Add") { (action, indexPath) in
                action.transitionDelegate = ScaleTransition.default
                self.kitingSpots[indexPath.row].setValue(true, forKey: "isFavorite")
                
                APIManager.shared.addSpotToFavorites(spotID: self.kitingSpots[indexPath.row].spotId, completionHandler: { (isSuccess, error, spotID) in
                    if isSuccess == false {
                        print(error!)
                    }
                })
                self.tableView.reloadData()
                CoreDataManager.saveMainContext()
                
            }
            favorites.backgroundColor = UIColor.defaultBlue
        } else {
            favorites = SwipeAction(style: .default, title: "Remove") { (action, indexPath) in
                action.transitionDelegate = ScaleTransition.default
                self.kitingSpots[indexPath.row].setValue(false, forKey: "isFavorite")
                
                APIManager.shared.removeSpotFromFavorites(spotID: self.kitingSpots[indexPath.row].spotId, completionHandler: { (isSuccess, error, spotId) in
                    if isSuccess == false {
                        print(error!)
                    }
                })
                
                self.tableView.reloadData()
                CoreDataManager.saveMainContext()
            }
            favorites.backgroundColor = UIColor.red
        }
        
        return [favorites]
    }
    
    
    
    //MARK - get Filter Options
    
    func getFilteredSpots(country: String?, windProbability: Double?) {
        
        getAllSpots(country: country, windProbability: windProbability)
        tableView.reloadData()
        
    }
    
    
    func cancelButtonTapped() {
        //Handle cancel
    }
    
    @objc func handleRefresh (_ refreshControl: UIRefreshControl) {
    
        getAllSpots(country: filterViewController?.selectedCountry, windProbability: filterViewController?.selectedWindProbability)
        tableView.reloadData()
        refreshControl.endRefreshing()
    
    }
    
}

