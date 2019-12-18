//
//  Button.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/16/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import SpriteKit

// Creates generic buttons as an SKNode and using an image, provides button click indication by changing alpha values on a mask and the button itself
class Button: SKNode {
    var button: SKSpriteNode
    private var mask: SKSpriteNode // A dark mask to used to help indicate when a user has pressed the button
    private var cropNode: SKCropNode // Helps overlay the mask on the button node
    private var initAction: () -> Void // Function that gets called on button down press
    private var endAction: () -> Void // Function that gets called on button release
    var isEnabled = true
    
    init(imageNamed: String, initialAction: @escaping () -> Void, endingAction: @escaping () -> Void ) {
        button = SKSpriteNode(imageNamed: imageNamed)
        mask = SKSpriteNode(color: SKColor.black, size: button.size)
        mask.alpha = 0.0
        
        cropNode = SKCropNode()
        cropNode.maskNode = button
        cropNode.zPosition = 3
        cropNode.addChild(mask)
        
        initAction = initialAction
        endAction = endingAction
        
        super.init()
        
        isUserInteractionEnabled = true // Allows the user to interact with the SKNode
        
        setupNodes()
        addNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNodes() {
        button.zPosition = 0
    }
    
    func addNodes() {
        addChild(button)
        addChild(cropNode)
    }
    
    // Button press down
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            mask.alpha = 0.5
            // The animation scales then descales the button to help indicate button press
            let scale = SKAction.scale(by: 1.05, duration: 0.01)
            let reverseScale = scale.reversed()
            run(SKAction.sequence([scale, reverseScale]))
            initAction() // Calls the method that is associated with the initial press of the button
        }
    }
    
    // Called when the button is being held
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location = touch.location(in: self)
                if button.contains(location) {
                    mask.alpha = 0.5
                } else {
                    mask.alpha = 0.0
                }
            }
        }
    }
    
    // Button is released
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location = touch.location(in: self)
                
                // Animate button click behavior
                if button.contains(location) {
                    disable()
                    endAction()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.05), SKAction.run {
                        self.enable()
                    }]))
                }
            }
        }
    }
    
    func disable() {
        isEnabled = false
        mask.alpha = 0.0
        button.alpha = 0.5
    }
    
    func enable() {
        isEnabled = true
        mask.alpha = 0.0
        button.alpha = 1.0
    }
}
