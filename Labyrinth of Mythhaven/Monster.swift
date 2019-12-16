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
    enum MonsterState {
        case attackNormal, attackUltimate, idle
        
        mutating func attack() {
            let rand = Int.random(in: 1...10)
            rand < 8 ? (self = .attackNormal) : (self = .attackUltimate)
        }
    }
    
    var monster: SKSpriteNode
    var monsterState: MonsterState
    var textureArray = [SKTexture]()
    var health: Int
    var attackStat: Int

    init (_ monsterNode: SKSpriteNode) {
        monster = monsterNode
        monsterState = .idle
        
        attackStat = 15
        health = 100
        
        textureArray.append(SKTexture(imageNamed: "monster_1.png"))
        textureArray.append(SKTexture(imageNamed: "monster_2.png"))
        textureArray.append(SKTexture(imageNamed: "monster_1.png"))
    }
    
    func animate() -> AttackProtocol{
        return attack()
    }
    
    func attack() -> AttackProtocol {
        monsterState.attack()
        switch monsterState {
        case .attackNormal:
            return NormalAttack(self)
        case .attackUltimate:
            return NormalAttack(self) // Change to ultimate when available
        case .idle:
            print("Default")
        }
        return NormalAttack(self)
    }
    
    func takeDamage(_ amount: Int) {
        health -= amount
        print(health)
    }
}
