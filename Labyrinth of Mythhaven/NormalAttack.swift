//
//  NormalAttack.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/15/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import SpriteKit

class NormalAttack: AttackProtocol {
    enum AttackPositionState: Int {
        case left = 0, middle = 1, right = 2
        
        mutating func attack() {
            let rand = Int.random(in: 1...10)
            if rand < 4 {
                self = .left
                print("left")
            }
            else if rand < 7 {
                self = .middle
                print("middle")
            }
            else {
                self = .right
                print("right")
            }
        }
    }
    
    var monster: Monster
    var attackPositionState: AttackPositionState
    
    init (_ monster: Monster) {
        self.monster = monster
        attackPositionState = .middle
        attackPositionState.attack()
    }
    
    func run(_ player: Player, gameScene: GameScene) -> SKAction {
        let randWaitTime = SKAction.wait(forDuration: 3, withRange: 4)
        let checkPlayer = SKAction.run {
            if player.playerPosition.rawValue == self.attackPositionState.rawValue {
                print("Player has been hit")
                player.takeDamage(self.monster.attackStat)
            }
        }
        
        let animateMonster = SKAction.repeat(SKAction.animate(with: monster.textureArray, timePerFrame: 1), count: 1)
        
        let snowball = SKSpriteNode(texture: monster.normalAttackTextureArray[0])
        snowball.setScale(2)
        let xPos = player.playerPositionArray[attackPositionState.rawValue]
        let startPoint = CGPoint(x: xPos, y: gameScene.size.height * 1.2)
        let endpoint = gameScene.size.height/2
        snowball.position = startPoint
        snowball.zPosition = 3
        gameScene.addChild(snowball)
        
        let moveSnowBall = SKAction.moveTo(y: endpoint, duration: 1.5)
        let deleteSnowball = SKAction.removeFromParent()
        let snowballSequence = SKAction.sequence([moveSnowBall, checkPlayer, deleteSnowball])
        let runSnowballAction = SKAction.run {
            snowball.run(snowballSequence)
        }
        
        let monsterSequence = SKAction.sequence([randWaitTime, animateMonster, runSnowballAction])
        return monsterSequence
    }
    
    
}
