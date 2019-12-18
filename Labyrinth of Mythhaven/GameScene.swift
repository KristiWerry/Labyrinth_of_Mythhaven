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
    var sceneContext: SceneContext?
    
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
    
    // Button allows the user to "block" an enemy attack
    func addBlockButton() {
        // Initial action gets called when the button is initially pressed
        // endingAction gets called when the button is released
        let blockButton = Button(imageNamed: "block_button_icon.png", initialAction: { self.player?.defend() }, endingAction: { self.player?.defenseFinished() })
        blockButton.zPosition = 2
        blockButton.setScale(0.35)
        blockButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/4) + 50)
        addChild(blockButton)
    }
    
    // Creates the enemy monster
    func createMonster() {
        // Build the monster sprite
        let monsterNode = SKSpriteNode(imageNamed: "monster_1.png")
        monsterNode.setScale(2)
        monsterNode.position = CGPoint(x:self.size.width/2, y: self.size.height/2 + monsterNode.size.height/2)
        monsterNode.zPosition = 2
        
        monster = Monster(monsterNode, sceneContext?.currentLevel ?? 1)
        monster?.createMonsterHpBar(gameScene: self)
        
        if let node = monster?.monster {
            self.addChild(node)
        }
        
        // This begins the monster attack loop
        animateMonster()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .playGame:
            // Animates the players attack and deals damage to the monster
            monster?.takeDamage(player?.attack() ?? 0)
            guard monster?.isAlive == true else {
                nextPath() // If the monster is not alive then the game is over
                return
            }
        default:
            print("Non play state")
        }
    }
    
    // Handles player left / right movement
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
        let playerNode: SKSpriteNode
        // Build the player sprite
        if let gender = sceneContext?.gender {
            if gender.elementsEqual("Female") {
                playerNode = SKSpriteNode(imageNamed: "player_girl")
            }
            else {
                playerNode = SKSpriteNode(imageNamed: "player_boy")
            }
        } else {
            playerNode = SKSpriteNode(imageNamed: "player_girl")
        }
         
        playerNode.setScale(1)
        playerNode.position = CGPoint(x: playerPositionArray[1], y: self.size.height/2 + playerNode.size.height/2)
        playerNode.zPosition = 4
        
        player = Player(playerNode, playerPositionArray, gender: sceneContext?.gender ?? "Female")
        player?.attackStat = sceneContext?.attack ?? 4
        player?.health = sceneContext?.hp ?? 100
        player?.defenseStat = sceneContext?.defense ?? 3
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
    
    // Sets up the swipe gesture recognizers to recognize users swipe directions and bind them to the handleSwipes function
    func createSwipeGestureRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        swipeLeft.direction = .left // This handles swipes to the left
        swipeRight.direction = .right // This handles swipes to the right
        
        self.view?.addGestureRecognizer(swipeRight)
        self.view?.addGestureRecognizer(swipeLeft)
    }
    
    // Begins the monster attack animation
    func animateMonster() {
        // Monsters attack function returns an attack object, this object holds the monster attack animation loop and deals damage to the player if the player is hit
        if let attackAction = monster?.attack(), let playerObj = player {
            let action = attackAction.run(playerObj, gameScene: self) // Needs the game scene for animation positions / sizing
            monster?.monster.run(action, completion: { self.animateMonster() })
            
            guard playerObj.isAlive == true else {
                gameOver() // If the player is not alive then the game is over
                return
            }
        }
    }
    
    func nextPath() {
        gameState = .endGame
        
        // Remove all actions, this shouold freeze the animations
        self.removeAllActions()
        monster?.monster.removeAllActions()
        player?.player.removeAllActions()
        self.enumerateChildNodes(withName: "attack", using: {
            attack, stop in
            attack.removeAllActions()
        })
        
        createNextPathModal()
    }
    
    func gameOver() {
        gameState = .endGame
        
        // Remove all actions, this shouold freeze the animations
        self.removeAllActions()
        monster?.monster.removeAllActions()
        player?.player.removeAllActions()
        self.enumerateChildNodes(withName: "attack", using: {
            attack, stop in
            attack.removeAllActions()
        })
        sceneContext?.currentLevel = 1
        createGameOverModal()
    }
    
    func createGameOverModal() {
        // Creates the background for the modal
        let gameOverModalBackground = SKShapeNode(rectOf: CGSize(width: 100 , height: 150), cornerRadius: 5)
        gameOverModalBackground.setScale(4)
        gameOverModalBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gameOverModalBackground.zPosition = 101
        gameOverModalBackground.strokeColor = .black
        gameOverModalBackground.fillColor = .black
        self.addChild(gameOverModalBackground)
        
        // Creates a foreground that lies on the background for the modal
        let gameOverModalForeground = SKShapeNode(rectOf: CGSize(width: 95, height: 145), cornerRadius: 5)
        gameOverModalForeground.setScale(4)
        gameOverModalForeground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gameOverModalForeground.zPosition = 102
        gameOverModalForeground.strokeColor = .darkGray
        gameOverModalForeground.fillColor = .darkGray
        self.addChild(gameOverModalForeground)
        
        // Creates the game over text for this modal
        let gameOverModalLabel = SKLabelNode(text: "GAME OVER!")
        gameOverModalLabel.horizontalAlignmentMode = .center
        gameOverModalLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height/2 + 225)
        gameOverModalLabel.fontName = "AmericanTypewriter-Bold"
        gameOverModalLabel.fontColor = UIColor.red
        gameOverModalLabel.fontSize = 50
        gameOverModalLabel.zPosition = 102
        self.addChild(gameOverModalLabel)
        
        // Adds a button that is tied to the restart function that will restart the game
        let restartButton = Button(imageNamed: "restart_button_icon.png", initialAction: { self.restartGame() }, endingAction: {})
        restartButton.zPosition = 103
        restartButton.setScale(0.30)
        restartButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 125)
        self.addChild(restartButton)
        
        // Adds a button taht is tied to the goToMainMenu function that will end the game and go back to the main menu
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
    
    // Game Manager should be a ViewController, which should remove this scene from the view
    func goToMainMenu() {
        gameManager?.quitGame()
    }
    
    func setContext(_ context: SceneContext) {
        self.sceneContext = context
    }
    
    func createNextPathModal() {
        // Creates the background for the modal
        let nextPathModalBackground = SKShapeNode(rectOf: CGSize(width: 100 , height: 150), cornerRadius: 5)
        nextPathModalBackground.setScale(4)
        nextPathModalBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        nextPathModalBackground.zPosition = 101
        nextPathModalBackground.strokeColor = .black
        nextPathModalBackground.fillColor = .black
        self.addChild(nextPathModalBackground)
        
        // Creates a foreground that lies on the background for the modal
        let nextPathModalForeground = SKShapeNode(rectOf: CGSize(width: 95, height: 145), cornerRadius: 5)
        nextPathModalForeground.setScale(4)
        nextPathModalForeground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        nextPathModalForeground.zPosition = 102
        nextPathModalForeground.strokeColor = .darkGray
        nextPathModalForeground.fillColor = .darkGray
        self.addChild(nextPathModalForeground)
        
        // Creates the game over text for this modal
        let nextPathModalLabel = SKLabelNode(text: "Choose a path!")
        nextPathModalLabel.horizontalAlignmentMode = .center
        nextPathModalLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height/2 + 225)
        nextPathModalLabel.fontName = "AmericanTypewriter-Bold"
        nextPathModalLabel.fontColor = UIColor.blue
        nextPathModalLabel.fontSize = 45
        nextPathModalLabel.zPosition = 102
        self.addChild(nextPathModalLabel)
        
        // Adds a button that is tied to the next level function that will restart the game with a new level
        let leftButton = Button(imageNamed: "left_button.png", initialAction: { self.nextLevel() }, endingAction: {})
        leftButton.zPosition = 103
        leftButton.setScale(0.30)
        leftButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 125)
        self.addChild(leftButton)
        
        // Adds a button that is tied to the next level function that will restart the game with a new level
        let rightButton = Button(imageNamed: "right_button.png", initialAction: { self.nextLevel() }, endingAction: {})
        rightButton.zPosition = 103
        rightButton.setScale(0.30)
        rightButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/2))
        self.addChild(rightButton)
    }
    
    // Handles transition to the next level
    func nextLevel() {
        if let currentLevel = sceneContext?.currentLevel, let finalLevel = sceneContext?.finalLevel {
            sceneContext?.currentLevel = currentLevel + 1
            // Check if the user has reached the end of the labyrinth
            if currentLevel == finalLevel {
                sceneContext?.finalLevel = Int.random(in: 4...10)
                victory()
            }
            else {
                player?.levelUp()
                sceneContext?.attack = player?.attackStat
                sceneContext?.defense = player?.defenseStat
                sceneContext?.hp = player?.health
                restartGame()
            }
        }
    }
    
    func createVictoryModal() {
        // Creates the background for the modal
        let victoryModalBackground = SKShapeNode(rectOf: CGSize(width: 100 , height: 150), cornerRadius: 5)
        victoryModalBackground.setScale(4)
        victoryModalBackground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        victoryModalBackground.zPosition = 104
        victoryModalBackground.strokeColor = .black
        victoryModalBackground.fillColor = .black
        self.addChild(victoryModalBackground)
        
        // Creates a foreground that lies on the background for the modal
        let victoryModalForeground = SKShapeNode(rectOf: CGSize(width: 95, height: 145), cornerRadius: 5)
        victoryModalForeground.setScale(4)
        victoryModalForeground.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        victoryModalForeground.zPosition = 105
        victoryModalForeground.strokeColor = .darkGray
        victoryModalForeground.fillColor = .darkGray
        self.addChild(victoryModalForeground)
        
        // Creates the game over text for this modal
        let victoryModalLabel = SKLabelNode(text: "Congrats!")
        victoryModalLabel.horizontalAlignmentMode = .center
        victoryModalLabel.position = CGPoint(x: self.size.width/2 , y: self.size.height/2 + 225)
        victoryModalLabel.fontName = "AmericanTypewriter-Bold"
        victoryModalLabel.fontColor = UIColor.blue
        victoryModalLabel.fontSize = 45
        victoryModalLabel.zPosition = 105
        self.addChild(victoryModalLabel)
        
        let victoryModalLabel2 = SKLabelNode(text: "You made it!")
        victoryModalLabel2.horizontalAlignmentMode = .center
        victoryModalLabel2.position = CGPoint(x: self.size.width/2 , y: self.size.height/2 + 190)
        victoryModalLabel2.fontName = "AmericanTypewriter-Bold"
        victoryModalLabel2.fontColor = UIColor.blue
        victoryModalLabel2.fontSize = 35
        victoryModalLabel2.zPosition = 105
        self.addChild(victoryModalLabel2)
        
        // Adds a button that is tied to the next level function that will restart the game with a new level
        let continueButton = Button(imageNamed: "continue_button.png", initialAction: { self.goToMainMenu() }, endingAction: {})
        continueButton.zPosition = 106
        continueButton.setScale(0.30)
        continueButton.position = CGPoint(x: self.size.width/2, y: (self.size.height/2) + 125)
        self.addChild(continueButton)
    }
    
    // Handles when the game ends and the player has completed the labrinth
    func victory() {
        gameState = .endGame
        
        // Remove all actions, this shouold freeze the animations
        self.removeAllActions()
        monster?.monster.removeAllActions()
        player?.player.removeAllActions()
        self.enumerateChildNodes(withName: "attack", using: {
            attack, stop in
            attack.removeAllActions()
        })
        sceneContext?.currentLevel = 1
        createVictoryModal()
    }
}
