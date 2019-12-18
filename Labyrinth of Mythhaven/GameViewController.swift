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
            let sceneContext = SceneContext(defaults: UserDefaults.standard)
            
            //Scale the scene so it fits on all devices
            scene = GameScene(size: CGSize(width:1536, height: 2048))
            // Set the scale mode to scale to fit the window
            scene?.scaleMode = .aspectFill
            scene?.setContext(sceneContext)
            scene?.gameManager = self
                
            // Present the scene
            view.presentScene(scene)
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
    
    // This is implemented as part of the GameManager protocol, it allows the scene to tell the controller that the scene is finished
    func quitGame() {
        scene?.removeAllActions()
        scene?.removeAllChildren()
        scene?.removeFromParent()
        scene = nil
        self.performSegue(withIdentifier: "ReturnToMainMenu", sender: self)
    }
    
    // Pauses the entire scene and all of its actions
    @IBAction func pauseGame(_ sender: Any) {
        scene?.isPaused = !(scene?.isPaused)!
        pauseModal.isHidden = !pauseModal.isHidden
    }
    
    @IBAction func resumeGame(_ sender: Any) {
        scene?.isPaused = !(scene?.isPaused)!
        pauseModal.isHidden = !pauseModal.isHidden
    }
}
