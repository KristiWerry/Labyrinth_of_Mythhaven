//
//  AttackInteface.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/15/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import SpriteKit

// This protocol will allow for multiple different attack types
protocol AttackProtocol {
    var monster: Monster { get set }
    func run(_ player: Player, gameScene: GameScene) -> SKAction
}
