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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func starPressed(_ sender: Any) {
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
