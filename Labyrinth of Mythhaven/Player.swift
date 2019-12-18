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
    // Represents the positions the player can exist in after having swiped right or left
    enum PlayerPositionState: Int {
        case left = 0, middle = 1, right = 2
        
        // Handles if the user attempts to move left
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
        
        // Handles if the user attempts to move right
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
    var idleArray = [SKTexture]() // Texture array holding the animation for the players idle state
    var attackArray = [SKTexture]() // Texture array holding the animation for the players attack
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

        // Begins animating the characters idle animations
        animate()
    }
    
    // Based on the provided direction, attempt to move left or right
    func movePlayer(direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .left:
            playerPosition.moveLeft()
        case .right:
            playerPosition.moveRight()
        default:
            print("Non left or right direction")
        }
        
        // Use the players position raw value as an indice to the position array that holds the correspsonding pixel location on the screen
        let movePlayer = SKAction.moveTo(x: playerPositionArray[playerPosition.rawValue], duration: 0.1)
        player.run(movePlayer)
    }
    
    // Runs the players attack animation and returns the players attack stat
    func attack() -> Int {
        player.run(SKAction.animate(with: attackArray, timePerFrame: 0.1))
        return attackStat
    }
    
    // Animates the players idle animation
    func animate() {
        let animatePlayer = SKAction.repeatForever(SKAction.animate(with: idleArray, timePerFrame: 0.3))
        player.run(animatePlayer)
    }
    
    // Handles when the player has been hit and is about to take damage
    func takeDamage(_ amount: Int) {
        let damage = amount - defenseStat
        
        if damage > 0 {
            health -= damage // Calculate the new health
            
            // Run a flicker animation indicating that the player has been hit
            let fadeOutAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
            let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
            let damageSequence = SKAction.sequence([fadeOutAction, fadeInAction])
            let flickerAction = SKAction.repeat(damageSequence, count: 2)
            player.run(flickerAction)
        }
        
        // Check if the player is still alive
        if health <= 0 {
            health = 0
            isAlive = false
        }
        
        // The following changes the players hp bar based on the new health amount
        playerHpBar?.progress = CGFloat(integerLiteral: health)
        if let progressBar = playerHpBar {
            // Changes the color of the hp bar depending on the percentage of health remaining
            if progressBar.progress <= CGFloat(progressBar.total / 2) && progressBar.progress > CGFloat(progressBar.total / 4) {
                playerHpBar?.bar?.color = .yellow
            } else if progressBar.progress <= CGFloat(progressBar.total / 4) {
                playerHpBar?.bar?.color = .red
            }
        }
    }
    
    // Cosntructs the players hp bar
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
        
        // The actual progress bar is just the green part of the hp bar, the rest is just styling
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
    
    // This is tied to the block button, increases the users defense, which decreases the amount of damage dealt if theuy were to be hit by a monster attack
    func defend() {
        defenseStat += 5
        print("Player Defense Boosted: \(defenseStat)")
    }
    
    // When the user releases the block button this function will get called and reset the users defense to its original amount
    func defenseFinished() {
        defenseStat -= 5
        print("Player Defense Boost Ended: \(defenseStat)")
    }
}
