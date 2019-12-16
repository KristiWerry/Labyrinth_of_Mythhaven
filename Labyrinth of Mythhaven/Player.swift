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
    var playerPositionArray: [CGFloat] = []
    var playerPosition = PlayerPositionState.middle
    let player: SKSpriteNode
    var idleArray = [SKTexture]()
    var attackArray = [SKTexture]()
    var attackStat: Int

    init(_ playerNode: SKSpriteNode, _ playerPositions: [CGFloat]) {
        player = playerNode
        playerPositionArray = playerPositions
        
        attackStat = 4
        
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
    
    
}
