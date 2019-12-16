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
    var monsterHpBar: ProgressBar?
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
        monsterHpBar?.progress = CGFloat(integerLiteral: health)
        if let progressBar = monsterHpBar {
            if progressBar.progress <= CGFloat(progressBar.total / 2) && progressBar.progress > CGFloat(progressBar.total / 4) {
                monsterHpBar?.bar?.color = .yellow
            } else if progressBar.progress <= CGFloat(progressBar.total / 4) {
                monsterHpBar?.bar?.color = .red
            }
        }
    }
    
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
