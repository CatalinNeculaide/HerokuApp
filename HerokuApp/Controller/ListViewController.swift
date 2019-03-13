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
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        
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
        }

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
    
    func getAllSpots(){
        APIManager.shared.getAllSpots { (isSuccess, error, kitingSpotsGet) in
            if isSuccess == true {
                var apiKitingSpots = [KitingSpot]()
                for kitingSpot in kitingSpotsGet {
                    apiKitingSpots.append(kitingSpot)
                }
                self.kitingSpots = apiKitingSpots
                self.tableView.reloadData()
            } else {
                print(error!)
            }
        }
    }
    // MARK - Tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return kitingSpots.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        let item = kitingSpots[indexPath.row].name
        cell.textLabel?.text = item
        
        //to do information cell
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = DetailViewController.instantiate(with: kitingSpots[indexPath.row])
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - get Filter Options
    func getFilteredSpots(country: String?, windProbabilty: Int?) {
        
        APIManager.shared.getAllSpots(country: country, windProbability: windProbabilty) { (isSuccess, error, filteredKitingSpots) in
            //to do
        }
    }
    
    func cancelButtonTapped() {
        //Handle cancel
    }
}

