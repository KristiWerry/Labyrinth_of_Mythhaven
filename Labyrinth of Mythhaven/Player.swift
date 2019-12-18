//
//  Player.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/15/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Player {
    enum PlayerPositionState: Int {
        case left = 0, middle = 1, right = 2
        mutating func moveLeft() {
            switch self {
            case .middle:
                self = .left
            case .right:
                self = .middle
            default:
                self = .left
            }
        }
        
        mutating func moveRight() {
            switch self {
            case .middle:
                self = .right
            case .left:
                self = .middle
            default:
                self = .right
            }
        }
    }
    var playerHpBar: ProgressBar?
    var playerPositionArray: [CGFloat] = []
    var playerPosition = PlayerPositionState.middle
    let player: SKSpriteNode
    var idleArray = [SKTexture]()
    var attackArray = [SKTexture]()
    var attackStat: Int
    var defenseStat: Int
    var health: Int
    var isAlive: Bool

    init(_ playerNode: SKSpriteNode, _ playerPositions: [CGFloat]) {
        player = playerNode
        playerPositionArray = playerPositions
        
        attackStat = 4
        defenseStat = 3
        health = 100
        isAlive = true
        
        idleArray.append(SKTexture(imageNamed: "player_girl.png"))
        idleArray.append(SKTexture(imageNamed: "player_girl1.png"))
        idleArray.append(SKTexture(imageNamed: "player_girl2.png"))
        
        attackArray.append(SKTexture(imageNamed: "player_girl_attack1.png"))
        attackArray.append(SKTexture(imageNamed: "player_girl_attack2.png"))
        attackArray.append(SKTexture(imageNamed: "player_girl1.png"))

        animate()
    }
        
    func movePlayer(direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .left:
            playerPosition.moveLeft()
        case .right:
            playerPosition.moveRight()
        default:
            print("default")
        }
        let movePlayer = SKAction.moveTo(x: playerPositionArray[playerPosition.rawValue], duration: 0.1)
        player.run(movePlayer)
    }
    
    func attack() -> Int {
        player.run(SKAction.animate(with: attackArray, timePerFrame: 0.1))
        return attackStat
    }
    
    func animate() {
        let animatePlayer = SKAction.repeatForever(SKAction.animate(with: idleArray, timePerFrame: 0.3))
        player.run(animatePlayer)
    }
    
    @objc func lowAlpha() {
        self.player.alpha = 0.5
    }
    
    @objc func highAlpha() {
        self.player.alpha = 1.0
    }
    
    func takeDamage(_ amount: Int) {
        let damage = amount - defenseStat
        
        if damage > 0 {
            health -= damage
            let fadeOutAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
            let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
            let damageSequence = SKAction.sequence([fadeOutAction, fadeInAction])
            let flickerAction = SKAction.repeat(damageSequence, count: 2)
            player.run(flickerAction)
        }
        
        if health <= 0 {
            health = 0
            isAlive = false
        }
        
        playerHpBar?.progress = CGFloat(integerLiteral: health)
        if let progressBar = playerHpBar {
            if progressBar.progress <= CGFloat(progressBar.total / 2) && progressBar.progress > CGFloat(progressBar.total / 4) {
                playerHpBar?.bar?.color = .yellow
            } else if progressBar.progress <= CGFloat(progressBar.total / 4) {
                playerHpBar?.bar?.color = .red
            }
        }
    }
    
    func createPlayerHpBar(gameScene: GameScene) {
        //player hp bar
        let playerHpBackground = SKShapeNode(rectOf: CGSize(width: 180, height: 11), cornerRadius: 5)
        playerHpBackground.setScale(4)
        playerHpBackground.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height * 0.40)
        playerHpBackground.zPosition = 100
        playerHpBackground.strokeColor = .black
        playerHpBackground.fillColor = .black
        gameScene.addChild(playerHpBackground)
        
        let playerHpContainer = SKShapeNode(rectOf: CGSize(width: 150, height: 10), cornerRadius: 5)
        playerHpContainer.setScale(4)
        playerHpContainer.position = CGPoint(x: gameScene.size.width/2 + 56, y:gameScene.size.height * 0.40)
        playerHpContainer.zPosition = 102
        playerHpContainer.strokeColor = .lightGray
        playerHpContainer.lineWidth = 2
        gameScene.addChild(playerHpContainer)
        
        let playerHpLabel = SKLabelNode(text: "HP")
        playerHpLabel.horizontalAlignmentMode = .center
        playerHpLabel.position = CGPoint(x: gameScene.size.width/2 - 296 , y: gameScene.size.height * 0.40 - 15)
        playerHpLabel.fontName = "AmericanTypewriter-Bold"
        playerHpLabel.fontColor = UIColor.orange
        playerHpLabel.fontSize = 42
        playerHpLabel.zPosition = 102
        gameScene.addChild(playerHpLabel)
        
        playerHpBar = {
            let progressBar = ProgressBar(color: .green, size: CGSize(width: 596, height: 34), totalProgress: CGFloat(integerLiteral: self.health))
            progressBar.position = CGPoint(x:gameScene.size.width/2 + 56, y:gameScene.size.height * 0.40 - 17)
            progressBar.progress = CGFloat(integerLiteral: self.health)
            return progressBar
        }()
        
        if let hpBar = playerHpBar {
            gameScene.addChild(hpBar)
        }
    }
    
    func defend() {
        defenseStat += 5
        print("Player Defense Boosted: \(defenseStat)")
    }
    
    func defenseFinished() {
        defenseStat -= 5
        print("Player Defense Boost Ended: \(defenseStat)")
    }
}
