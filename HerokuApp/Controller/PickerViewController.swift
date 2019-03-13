//
//  CountryPickerViewController.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 05/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

protocol PickerViewControllerDelegate : AnyObject {
    func didSelectOption(option: String)
}

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var options : [String] = ["None"]
    weak var delegate: PickerViewControllerDelegate?
    var selectedChoice: String = "None"
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    static func instantiate(with options: [String], delegate: PickerViewControllerDelegate?, preselectedElement: String? = "None") -> PickerViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.options = controller.options + options
        controller.delegate = delegate
        controller.selectedChoice = preselectedElement ?? "None"
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.reloadAllComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(options.firstIndex(of: selectedChoice) ?? 0, inComponent: 0, animated: false)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedChoice = options[row]
        
    }
    

    @IBAction func selectButtonPressed(_ sender: Any) {
        
        delegate?.didSelectOption(option: selectedChoice)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
    }
}
