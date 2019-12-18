//
//  MainViewController.swift
//  Labyrinth of Mythhaven
//
//  Created by William Ritchie on 12/17/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // Starts the game
    @IBAction func play(_ sender: Any) {
        self.performSegue(withIdentifier: "GameViewSegue", sender: self)
    }
    
    // Neeeded in order to unwind from the scene
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        
    }
}
