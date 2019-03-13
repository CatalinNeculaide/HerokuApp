//
//  FilterViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 04/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func getFilteredSpots(country: String?, windProbability: Double?)
    func cancelButtonTapped()
}

class FilterViewController: UIViewController, UITextFieldDelegate, PickerViewControllerDelegate {
    
    
    @IBOutlet weak var countriesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var changeWindProbTextField: UITextField!
    @IBOutlet weak var selectCountryButton: UIButton!
    
    
    var countries: [String] = []
    var selectedCountry: String?
    var selectedWindProbability : Double?
    weak var delegate: FilterViewControllerDelegate?
    
    
    static func instantiate() -> FilterViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        return controller
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountries()
        
        selectCountryButton.titleLabel?.textAlignment = .center
    }
    
    func getCountries() {
        selectCountryButton.setTitle("Loading countries....", for: .normal)
        selectCountryButton.isEnabled = false
        countriesActivityIndicator.hidesWhenStopped = true
        countriesActivityIndicator.startAnimating()
        self.selectCountryButton.setTitleColor(UIColor.defaultBlue, for: .normal)

        APIManager.shared.getCountries { (isSuccess, error, countriesGet) in
            self.countriesActivityIndicator.stopAnimating()
            
            if isSuccess {
                for country in countriesGet {
                    self.countries.append(country)
                }
                
                self.selectCountryButton.setTitle("Select Country", for: .normal)
                self.selectCountryButton.isEnabled = true
                
            } else {
                print(error!)
                
                self.selectCountryButton.setTitle("Couldn't load countries. Retry.", for: .normal)
                self.selectCountryButton.setTitleColor(UIColor.red, for: .normal)
                self.selectCountryButton.isEnabled = true
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "Changes will be unsaved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.delegate?.cancelButtonTapped()
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
        }
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        var windProbability: Double?
        
        if let textFieldValue = changeWindProbTextField.text {
            
             windProbability = Double(textFieldValue)
            
        }
        
        self.selectedWindProbability = windProbability
        delegate?.getFilteredSpots(country: selectedCountry, windProbability: windProbability)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func selectCountryPressed(_ sender: Any) {
        if countries.count == 0 {
            getCountries()
        } else {
            let pickerController = PickerViewController.instantiate(with: countries, delegate: self, preselectedElement: selectedCountry)
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - PickerViewControllerDelegate
    func didSelectOption(option: String) {
        guard option != "None" else {
            selectCountryButton.setTitle("Select Country", for: .normal)
            selectedCountry = nil
            return
        }
        
        selectCountryButton.setTitle(option, for: .normal)
        selectedCountry = option
        
    }
}
