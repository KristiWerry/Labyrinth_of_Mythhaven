//
//  SIgnInViewController.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/17/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit

class SIgnInViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let genders = ["Female", "Male"]
    var genderPicked = "Female"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderPicked = genders[row]
        print(genderPicked)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: genders[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    //ui text field delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        
        return true
    }
    
    //creates a popup alert with a given title and message
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @IBAction func enterButton(_ sender: Any) {
        let name = nameTextField.text ?? ""
        if name == "" {
            createAlert(title: "Oh No", message: "Enter a name.")
        }
        else {
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: "Name")
            defaults.set(genderPicked, forKey: "Gender")
            defaults.set(4, forKey: "Attack")
            defaults.set(3, forKey: "Defense")
            defaults.set(100, forKey: "HP")
            defaults.set(1, forKey: "Level")
            self.performSegue(withIdentifier: "MainViewSegue", sender: self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MainViewSegue" {
            if let destination = segue.destination as? MainViewController {
                destination.modalPresentationStyle = .fullScreen
            }
        }
    }
    
    @IBAction func unwindToSignIn(sender: UIStoryboardSegue) {
        
    }
}
