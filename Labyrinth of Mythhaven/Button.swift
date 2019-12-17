//
//  Button.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/16/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKNode {
    var button: SKSpriteNode
    private var mask: SKSpriteNode
    private var cropNode: SKCropNode
    private var initAction: () -> Void
    private var endAction: () -> Void
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
        
        isUserInteractionEnabled = true
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            mask.alpha = 0.5
            let scale = SKAction.scale(by: 1.05, duration: 0.02)
            let reverseScale = scale.reversed()
            run(SKAction.sequence([scale, reverseScale]))
            initAction()
        }
    }
    
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            for touch in touches {
                let location = touch.location(in: self)
                
                if button.contains(location) {
                    disable()
                    endAction()
                    run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run {
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
