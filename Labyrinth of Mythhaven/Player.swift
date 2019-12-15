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

    init(_ playerNode: SKSpriteNode, _ playerPositions: [CGFloat]) {
        player = playerNode
        playerPositionArray = playerPositions
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
        print(player.position.x)
    }
}
