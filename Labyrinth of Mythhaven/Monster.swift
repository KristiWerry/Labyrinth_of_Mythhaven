//
//  Monster.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/15/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Monster {
    enum MonsterAttackState {
        
    }
    
    var monster: SKSpriteNode
    var textureArray = [SKTexture]()

    init (_ monsterNode: SKSpriteNode) {
        monster = monsterNode
    }
    
    func animate() {
        textureArray.append(SKTexture(imageNamed: "monster_1.png"))
        textureArray.append(SKTexture(imageNamed: "monster_2.png"))
        textureArray.append(SKTexture(imageNamed: "monster_1.png"))
        
        let randWaitTime = SKAction.wait(forDuration: 3, withRange: 4)
        
        //let idleMonster = SKAction.wait(forDuration: 3)
        let animateMonster = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 1), count: 1)
        let monsterSequence = SKAction.sequence([randWaitTime,animateMonster])
        monster.run(SKAction.repeatForever(monsterSequence))
    }
}
