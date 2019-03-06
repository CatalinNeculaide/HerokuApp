//
//  FilterViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 04/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITextFieldDelegate, PickerViewControllerDelegate {
    
    
    var countries: [String] = ["Romania","Italia"]
    var selectedCountry = "None"
    
    
    @IBOutlet weak var selectCountryButton: UIButton!
    
    
    static func instantiate() -> FilterViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        return controller
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCountryButton.titleLabel?.textAlignment = .center

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Changes will be unsaved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getCountries() {
        //to do func to get countries from api
    }
    
    @IBAction func selectCountryPressed(_ sender: Any) {
        let pickerController = PickerViewController.instantiate(with: countries, delegate: self, preselectedElement: selectedCountry)
        present(pickerController, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //to do numpad keyboard apear
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // to do hide numpad heyboard
    }
    
    //MARK: - PickerViewControllerDelegate
    func didSelectOption(option: String) {
        selectCountryButton.titleLabel?.text = option
        selectedCountry = option
    }
}
