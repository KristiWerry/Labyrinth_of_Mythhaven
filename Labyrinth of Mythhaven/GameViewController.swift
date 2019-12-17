//
//  GameViewController.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/13/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameManager {
    var scene: GameScene?
    @IBOutlet weak var pauseModal: UIView!
    @IBOutlet weak var pauseModalForeground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseModal.layer.cornerRadius = 5
        pauseModalForeground.layer.cornerRadius = 5
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            //if let scene = SKScene(fileNamed: "GameScene") {
            //Scale the scene so it fits on all devices
            scene = GameScene(size: CGSize(width:1536, height: 2048))
            // Set the scale mode to scale to fit the window
            scene?.scaleMode = .aspectFill
            scene?.gameManager = self
                
            // Present the scene
            view.presentScene(scene)
            //}
            
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func creatGameOverModal() {
        print("creating game over modal") // get rid of this
    }
    @IBAction func pauseGame(_ sender: Any) {
        scene?.isPaused = !(scene?.isPaused)!
        pauseModal.isHidden = !pauseModal.isHidden
    }
}
