//
//  GameScene.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/13/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background0 = SKSpriteNode(imageNamed: "gameBackground0")
        //set the size of the background to the size of the scene
        background0.size = self.size
        //center the background in the scene
        background0.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background0.zPosition = 0
        self.addChild(background0)
        
        let background1 = SKSpriteNode(imageNamed: "gameBackground1")
        //set the size of the background to the size of the scene
        background1.size = self.size
        //center the background in the scene
        background1.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background1.zPosition = 1
        self.addChild(background1)
        
        let monster = SKSpriteNode(imageNamed: "monster1")
        monster.setScale(2)
        monster.position = CGPoint(x:self.size.width/2, y: self.size.height/2 + monster.size.height/2.5)
        monster.zPosition = 2
        self.addChild(monster)
        
        
    }
    
    
    
}
