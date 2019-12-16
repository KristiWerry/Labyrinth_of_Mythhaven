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
    var monsterHpBar: ProgressBar?
    var playerHpBar: ProgressBar?
    
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
        
        createMonsterHpBar()
        animateMonster()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        monster?.takeDamage(player?.attack() ?? 0)
        
        monsterHpBar?.progress = CGFloat(integerLiteral: monster!.health)
        if let progressBar = monsterHpBar {
            if progressBar.progress <= CGFloat(progressBar.total / 2) && progressBar.progress > CGFloat(progressBar.total / 4) {
                monsterHpBar?.bar?.color = .yellow
            } else if progressBar.progress <= CGFloat(progressBar.total / 4) {
                monsterHpBar?.bar?.color = .red
            }
        }
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
        createPlayerHpBar()
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
    
    func createMonsterHpBar() {
        //monster hp bar
        let monsterHpBackground = SKShapeNode(rectOf: CGSize(width: 180, height: 11), cornerRadius: 5)
        monsterHpBackground.setScale(4)
        monsterHpBackground.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.85)
        monsterHpBackground.zPosition = 100
        monsterHpBackground.strokeColor = .black
        monsterHpBackground.fillColor = .black
        self.addChild(monsterHpBackground)
        
        let monsterHpContainer = SKShapeNode(rectOf: CGSize(width: 150, height: 10), cornerRadius: 5)
        monsterHpContainer.setScale(4)
        monsterHpContainer.position = CGPoint(x: self.size.width/2 + 56, y:self.size.height * 0.85)
        monsterHpContainer.zPosition = 102
        monsterHpContainer.strokeColor = .lightGray
        monsterHpContainer.lineWidth = 2
        self.addChild(monsterHpContainer)
        
        let monsterHpLabel = SKLabelNode(text: "HP")
        monsterHpLabel.horizontalAlignmentMode = .center
        monsterHpLabel.position = CGPoint(x: self.size.width/2 - 296 , y: self.size.height * 0.85 - 15)
        monsterHpLabel.fontName = "AmericanTypewriter-Bold"
        monsterHpLabel.fontColor = UIColor.orange
        monsterHpLabel.fontSize = 42
        monsterHpLabel.zPosition = 102
        self.addChild(monsterHpLabel)
        
        monsterHpBar = {
            let progressBar = ProgressBar(color: .green, size: CGSize(width: 596, height: 34), totalProgress: CGFloat(integerLiteral: monster!.health))
            progressBar.position = CGPoint(x:self.size.width/2 + 56, y:self.size.height * 0.85 - 17)
            progressBar.progress = CGFloat(integerLiteral: monster!.health)
            return progressBar
        }()
        
        if let hpBar = monsterHpBar {
            self.addChild(hpBar)
        }
    }
    
    func createPlayerHpBar() {
        //player hp bar
        let playerHpBackground = SKShapeNode(rectOf: CGSize(width: 180, height: 11), cornerRadius: 5)
        playerHpBackground.setScale(4)
        playerHpBackground.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.40)
        playerHpBackground.zPosition = 100
        playerHpBackground.strokeColor = .black
        playerHpBackground.fillColor = .black
        self.addChild(playerHpBackground)
        
        let playerHpContainer = SKShapeNode(rectOf: CGSize(width: 150, height: 10), cornerRadius: 5)
        playerHpContainer.setScale(4)
        playerHpContainer.position = CGPoint(x: self.size.width/2 + 56, y:self.size.height * 0.40)
        playerHpContainer.zPosition = 102
        playerHpContainer.strokeColor = .lightGray
        playerHpContainer.lineWidth = 2
        self.addChild(playerHpContainer)
        
        let playerHpLabel = SKLabelNode(text: "HP")
        playerHpLabel.horizontalAlignmentMode = .center
        playerHpLabel.position = CGPoint(x: self.size.width/2 - 296 , y: self.size.height * 0.85 - 15)
        playerHpLabel.fontName = "AmericanTypewriter-Bold"
        playerHpLabel.fontColor = UIColor.orange
        playerHpLabel.fontSize = 42
        playerHpLabel.zPosition = 102
        self.addChild(playerHpLabel)
        
        playerHpBar = {
            let progressBar = ProgressBar(color: .green, size: CGSize(width: 596, height: 34), totalProgress: CGFloat(integerLiteral: player!.health))
            progressBar.position = CGPoint(x:self.size.width/2 + 56, y:self.size.height * 0.40 - 17)
            progressBar.progress = CGFloat(integerLiteral: player!.health)
            return progressBar
        }()
        
        if let hpBar = playerHpBar {
            self.addChild(hpBar)
        }
    }
    
    
    
}
