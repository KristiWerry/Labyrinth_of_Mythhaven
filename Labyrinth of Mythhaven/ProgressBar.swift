//
//  ProgressBar.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/15/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import SpriteKit

// This class is used to create the HP bars
class ProgressBar:SKNode {
    var bar:SKSpriteNode?
    var _progress:CGFloat = 0
    var total: CGFloat = 0.0
    var progress:CGFloat {
        get {
            return _progress
        }
        set {
            let value = newValue
            if let bar = bar {
                // This will keep the progress bar in terms of 100% and not the raw input value
                bar.xScale = 1 - (total - value) / total
                _progress = value
            }
        }
    }
    
    convenience init(color: SKColor, size: CGSize, totalProgress: CGFloat) {
        self.init()
        total = totalProgress
        bar = SKSpriteNode(color: color, size: size)
        if let bar = bar {
            bar.xScale = 0.0
            bar.zPosition = 101
            bar.position = CGPoint(x: -size.width / 2, y: 0)
            bar.anchorPoint = CGPoint(x: 0.0, y:0.0)
            addChild(bar)
        }
    }
}
