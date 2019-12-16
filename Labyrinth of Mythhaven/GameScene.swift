//
//  GameScene.swift
//  Labyrinth of Mythhaven
//
//  Created by Macbook Air on 12/13/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var player: Player?
    var monster: Monster?
    enum GameState {
        case preGame, playGame, endGame, pauseGame
    }
    
    override func didMove(to view: SKView) {

        createBackground()
        createPlayer()
        createMonster()
        createSwipeGestureRecognizer()
    }
    
    func createMonster() {
        let monsterNode = SKSpriteNode(imageNamed: "monster_1.png")
        monsterNode.setScale(2)
        monsterNode.position = CGPoint(x:self.size.width/2, y: self.size.height/2 + monsterNode.size.height/2)
        monsterNode.zPosition = 2
        
        monster = Monster(monsterNode)

        if let node = monster?.monster {
            self.addChild(node)
        }

        animateMonster()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        monster?.takeDamage(player?.attack() ?? 0)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        player?.movePlayer(direction: sender.direction)
    }
    
    func createPlayer() {
        let playerPositionArray: [CGFloat] = [self.size.width/3, self.size.width / 2, self.size.width * 2/3]
        
        let playerNode = SKSpriteNode(imageNamed: "player_girl")
        playerNode.setScale(1)
        playerNode.position = CGPoint(x: playerPositionArray[1], y: self.size.height/2 + playerNode.size.height/2)
        playerNode.zPosition = 3
        
        player = Player(playerNode, playerPositionArray)
        
        if let node = player?.player {
            self.addChild(node)
        }
    }
    
    func createBackground() {
        let background0 = SKSpriteNode(imageNamed: "gameBackground0")
        //set the size of the background to the size of the scene
        background0.size = self.size
        //center the background in the scene
        background0.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background0.zPosition = 0
        self.addChild(background0)
        
        let background1 = SKSpriteNode(imageNamed: "gameBackground1")
        //set the size of the background to the size of the scene
        background1.size = self.size
        //center the background in the scene
        background1.position = CGPoint(x: self.size.width/2, y: 0)
        background1.zPosition = 1
        self.addChild(background1)
    }
    
    func createSwipeGestureRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        self.view?.addGestureRecognizer(swipeRight)
        self.view?.addGestureRecognizer(swipeLeft)
    }
    
    func animateMonster() {
        if let attackAction = monster?.animate(), let playerObj = player{
            let action = attackAction.run(playerObj)
            monster?.monster.run(action, completion: { self.animateMonster() })
        }
    }
}
