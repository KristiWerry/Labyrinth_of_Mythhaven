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
    var gameState = GameState.playGame
    var gameManager: GameManager?
    
    enum GameState {
        case preGame, playGame, endGame, pauseGame
    }
    
    override func didMove(to view: SKView) {
        createBackground()
        createPlayer()
        createMonster()
        createSwipeGestureRecognizer()
        addBlockButton()
    }
    
    func addBlockButton() {
        let blockButton = Button(imageNamed: "block_button_icon.png", initialAction: { self.player?.defend() }, endingAction: { self.player?.defenseFinished() })
        blockButton.zPosition = 2
        blockButton.setScale(0.35)
        blockButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/4) + 50)
        addChild(blockButton)
    }
    
    func createMonster() {
        let monsterNode = SKSpriteNode(imageNamed: "monster_1.png")
        monsterNode.setScale(2)
        monsterNode.position = CGPoint(x:self.size.width/2, y: self.size.height/2 + monsterNode.size.height/2)
        monsterNode.zPosition = 2
        
        monster = Monster(monsterNode)
        monster?.createMonsterHpBar(gameScene: self)
        
        if let node = monster?.monster {
            self.addChild(node)
        }
        
        animateMonster()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .playGame:
            if monster?.isAlive ?? true {
                monster?.takeDamage(player?.attack() ?? 0)
            } else {
                gameOver()
            }
        default:
            print("Non play state")
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        switch gameState {
        case .playGame:
            player?.movePlayer(direction: sender.direction)
        default:
            print("Non play state")
        }
    }
    
    func createPlayer() {
        let playerPositionArray: [CGFloat] = [self.size.width/3, self.size.width / 2, self.size.width * 2/3] // The player can exist in one of the three positions provided by this array
        
        let playerNode = SKSpriteNode(imageNamed: "player_girl")
        playerNode.setScale(1)
        playerNode.position = CGPoint(x: playerPositionArray[1], y: self.size.height/2 + playerNode.size.height/2)
        playerNode.zPosition = 4
        
        player = Player(playerNode, playerPositionArray)
        player?.createPlayerHpBar(gameScene: self)
        
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
            if player?.isAlive ?? true {
                let action = attackAction.run(playerObj, gameScene: self)
                monster?.monster.run(action, completion: { self.animateMonster() })
            } else {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        gameState = .endGame
        self.removeAllActions()
        monster?.monster.removeAllActions()
        player?.player.removeAllActions()
        self.enumerateChildNodes(withName: "attack", using: {
            attack, stop in
            attack.removeAllActions()
        })
        
        createGameOverModal()
    }
    
    func createGameOverModal() {
        let gameOverModalBackground = SKShapeNode(rectOf: CGSize(width: 100 , height: 150), cornerRadius: 5)
        gameOverModalBackground.setScale(4)
        gameOverModalBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gameOverModalBackground.zPosition = 101
        gameOverModalBackground.strokeColor = .black
        gameOverModalBackground.fillColor = .black
        self.addChild(gameOverModalBackground)
        
        let gameOverModalForeground = SKShapeNode(rectOf: CGSize(width: 95, height: 145), cornerRadius: 5)
        gameOverModalForeground.setScale(4)
        gameOverModalForeground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gameOverModalForeground.zPosition = 102
        gameOverModalForeground.strokeColor = .darkGray
        gameOverModalForeground.fillColor = .darkGray
        self.addChild(gameOverModalForeground)
        
        let gameOverModalLabel = SKLabelNode(text: "GAME OVER!")
        gameOverModalLabel.horizontalAlignmentMode = .center
        gameOverModalLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height/2 + 225)
        gameOverModalLabel.fontName = "AmericanTypewriter-Bold"
        gameOverModalLabel.fontColor = UIColor.red
        gameOverModalLabel.fontSize = 50
        gameOverModalLabel.zPosition = 102
        self.addChild(gameOverModalLabel)
        
        let restartButton = Button(imageNamed: "restart_button_icon.png", initialAction: { self.restartGame() }, endingAction: {})
        restartButton.zPosition = 103
        restartButton.setScale(0.25)
        restartButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 125)
        self.addChild(restartButton)
        
        let quitButton = Button(imageNamed: "quit_button.png", initialAction: { self.goToMainMenu() }, endingAction: {})
        quitButton.zPosition = 103
        quitButton.setScale(0.30)
        quitButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/2))
        self.addChild(quitButton)
    }
    
    func restartGame() {
        self.removeAllChildren()
        createBackground()
        createPlayer()
        createMonster()
        createSwipeGestureRecognizer()
        addBlockButton()
        gameState = .playGame
    }
    
    func goToMainMenu() {
        gameManager?.quitGame()
    }
}
