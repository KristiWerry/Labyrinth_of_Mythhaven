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
    // Represents the states the monster can be in
    enum MonsterState {
        case attackNormal, attackUltimate, idle
        
        // Used to pseudo randomly decide which attack pattern to use on the monsters next attack
        mutating func attack() {
            let rand = Int.random(in: 1...10)
            rand < 8 ? (self = .attackNormal) : (self = .attackUltimate)
        }
    }
    
    var monster: SKSpriteNode
    var monsterState: MonsterState
    var monsterHpBar: ProgressBar?
    var textureArray = [SKTexture]() // Holds the animations for the monsters attack indicator
    var normalAttackTextureArray = [SKTexture]() // Holds the animations for the normal attack
    var health: Int
    var attackStat: Int
    var isAlive: Bool

    init (_ monsterNode: SKSpriteNode) {
        monster = monsterNode
        monsterState = .idle
        
        attackStat = 20
        health = 100
        isAlive = true
        
        textureArray.append(SKTexture(imageNamed: "monster_1.png"))
        textureArray.append(SKTexture(imageNamed: "monster_2.png"))
        textureArray.append(SKTexture(imageNamed: "monster_1.png"))
        
        normalAttackTextureArray.append(SKTexture(imageNamed: "snowball"))
    }
    
    func attack() -> AttackProtocol {
        monsterState.attack() // choose the next attack pattern
        switch monsterState {
        case .attackNormal:
            return NormalAttack(self)
        case .attackUltimate:
            return NormalAttack(self) // Change to ultimate attack when available
        case .idle:
            print("idle")
        }
        return NormalAttack(self)
    }
    
    // Handle when the monster takes damage
    func takeDamage(_ amount: Int) {
        health -= amount
        
        // Check if the monster is still alive
        if health <= 0 {
            health = 0
            isAlive = false
        }
        
        // Change the monsters hp bar according to the new health amount
        monsterHpBar?.progress = CGFloat(integerLiteral: health)
        if let progressBar = monsterHpBar {
            // Change the hp bar color based on the monsters percent of remaining health
            if progressBar.progress <= CGFloat(progressBar.total / 2) && progressBar.progress > CGFloat(progressBar.total / 4) {
                monsterHpBar?.bar?.color = .yellow
            } else if progressBar.progress <= CGFloat(progressBar.total / 4) {
                monsterHpBar?.bar?.color = .red
            }
        }
    }
    
    
    // Constructs the monsters hp bar
    func createMonsterHpBar(gameScene: GameScene) {
        //monster hp bar
        let monsterHpBackground = SKShapeNode(rectOf: CGSize(width: 180, height: 11), cornerRadius: 5)
        monsterHpBackground.setScale(2)
        monsterHpBackground.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height * 0.85)
        monsterHpBackground.zPosition = 100
        monsterHpBackground.strokeColor = .black
        monsterHpBackground.fillColor = .black
        gameScene.addChild(monsterHpBackground)
        
        let monsterHpContainer = SKShapeNode(rectOf: CGSize(width: 150, height: 11), cornerRadius: 5)
        monsterHpContainer.setScale(2)
        monsterHpContainer.position = CGPoint(x: gameScene.size.width/2 + 30, y:gameScene.size.height * 0.85)
        monsterHpContainer.zPosition = 102
        monsterHpContainer.strokeColor = .lightGray
        monsterHpContainer.lineWidth = 2
        gameScene.addChild(monsterHpContainer)
        
        let monsterHpLabel = SKLabelNode(text: "HP")
        monsterHpLabel.horizontalAlignmentMode = .center
        monsterHpLabel.position = CGPoint(x: gameScene.size.width/2 - 151 , y: gameScene.size.height * 0.85 - 10)
        monsterHpLabel.fontName = "AmericanTypewriter"
        monsterHpLabel.fontColor = UIColor.orange
        monsterHpLabel.fontSize = 25
        monsterHpLabel.zPosition = 102
        gameScene.addChild(monsterHpLabel)
        
        monsterHpBar = {
            let progressBar = ProgressBar(color: .green, size: CGSize(width: 298, height: 20), totalProgress: CGFloat(integerLiteral: self.health))
            progressBar.position = CGPoint(x:gameScene.size.width/2 + 30, y:gameScene.size.height * 0.85 - 11)
            progressBar.progress = CGFloat(integerLiteral: self.health)
            return progressBar
        }()
        
        if let hpBar = monsterHpBar {
            gameScene.addChild(hpBar)
        }
    }
}
