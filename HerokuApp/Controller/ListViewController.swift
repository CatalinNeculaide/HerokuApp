//
//  ViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 04/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var kitingSpots : [KitingSpot]?
    var filterViewController : FilterViewController?
    var detailViewController : DetailViewController?
    
    let test = ["aaa","bbb","ccc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kitingSpots = CoreDataManager.getKitingSpots()
        tableView.reloadData()
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        
        if let filterVc = filterViewController {
            self.present(filterVc, animated: true, completion: nil)
        } else {
            filterViewController = FilterViewController.instantiate()
            self.present(filterViewController!, animated: true, completion: nil)

        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return kitingSpots?.count ?? 0
        return test.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        
        let item = test[indexPath.row]
        cell.textLabel?.text = item
        
        //to do information cell
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        detailViewController = DetailViewController.instantiate()
        self.present(detailViewController!, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

