//
//  ViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 04/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, FilterViewControllerDelegate {
    
   
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
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

