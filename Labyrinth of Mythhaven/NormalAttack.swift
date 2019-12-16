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
    
    func run(_ player: Player) -> SKAction {
        let randWaitTime = SKAction.wait(forDuration: 3, withRange: 4)
        let checkPlayer = SKAction.run {
            if player.playerPosition.rawValue == self.attackPositionState.rawValue {
                print("Player has been hit")
                player.health -= self.monster.attackStat
                print(String(player.health) + " player health ~~~~~~~")
            }
        }
        let animateMonster = SKAction.repeat(SKAction.animate(with: monster.textureArray, timePerFrame: 1), count: 1)
        let monsterSequence = SKAction.sequence([randWaitTime, animateMonster, checkPlayer])
        return monsterSequence
    }
}
