//
//  MainViewController.swift
//  Labyrinth of Mythhaven
//
//  Created by William Ritchie on 12/17/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateStats()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GameViewSegue" {
            if let destination = segue.destination as? GameViewController {
                destination.modalPresentationStyle = .fullScreen
            }
        }
    }
    @IBAction func updateInfo(_ sender: Any) {
    }
    
    // Starts the game
    @IBAction func play(_ sender: Any) {
        self.performSegue(withIdentifier: "GameViewSegue", sender: self)
    }
    
    // Neeeded in order to unwind from the scene
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        updateStats()
    }
    
    func updateStats() {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "Name")
        let gender = defaults.string(forKey: "Gender")
        let hp = defaults.integer(forKey: "HP")
        let attack = defaults.integer(forKey: "Attack")
        let defense = defaults.integer(forKey: "Defense")
        
        nameLabel.text = name
        hpLabel.text = String(hp)
        attackLabel.text = String(attack)
        defenseLabel.text = String(defense)
        genderLabel.text = gender
    }
}
