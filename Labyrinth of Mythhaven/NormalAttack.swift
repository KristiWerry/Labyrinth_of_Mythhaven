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
    // Represents the positions where the player can exist and subsequently where the monster is
    // allowed to attack
    enum AttackPositionState: Int {
        case left = 0, middle = 1, right = 2
        
        // This function will self change an enum to pseudo randomly decide which position will be attacked
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
    
    var monster: Monster // Need reference to the monster in order to animate its attack
    var attackPositionState: AttackPositionState // Current position being attacked
    
    init (_ monster: Monster) {
        self.monster = monster
        attackPositionState = .middle
        attackPositionState.attack()
    }
    
    func run(_ player: Player, gameScene: GameScene) -> SKAction {
        let randWaitTime = SKAction.wait(forDuration: 3, withRange: 4) // This will cause the monster to wait some pseudo random amount of time before attacking again
        
        // This checks if the player has been hit
        let checkPlayer = SKAction.run {
            if player.playerPosition.rawValue == self.attackPositionState.rawValue {
                player.takeDamage(self.monster.attackStat) // Deals damage to the player
            }
        }
        
        // Animates the monster itself, indicating that it is attacking
        let animateMonster = SKAction.repeat(SKAction.animate(with: monster.textureArray, timePerFrame: 1), count: 1)
        
        // Set up the monsters attack
        let normalAttack = SKSpriteNode(texture: monster.normalAttackTextureArray[0])
        normalAttack.name = "attack" // This name is used to remove an attack nodes actions when the game ends
        normalAttack.setScale(2)
        
        // Setup for the attack positioning
        let xPos = player.playerPositionArray[attackPositionState.rawValue]
        let startPoint = CGPoint(x: xPos, y: gameScene.size.height * 1.2)
        let endpoint = gameScene.size.height/2
        normalAttack.position = startPoint
        normalAttack.zPosition = 3
        gameScene.addChild(normalAttack)
        
        let moveNormalAttack = SKAction.moveTo(y: endpoint, duration: 1.5)
        let deleteNormalAttack = SKAction.removeFromParent() // Remove the attack from the scene
        
        // Move attack, when it finishes check if the player has been hit, then delete the sprite
        let normalAttackSequence = SKAction.sequence([moveNormalAttack, checkPlayer, deleteNormalAttack])
        let runNormalAttackAction = SKAction.run {
            normalAttack.run(normalAttackSequence)
        }
        
        let monsterSequence = SKAction.sequence([randWaitTime, animateMonster, runNormalAttackAction])
        return monsterSequence
    }
    
    
}
