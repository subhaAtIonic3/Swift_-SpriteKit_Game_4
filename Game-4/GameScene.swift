//
//  GameScene.swift
//  Game-4
//
//  Created by Subhrajyoti Chakraborty on 19/08/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var row1 = ["target1", "target0"]
    var row2 = ["target2", "target1", "target3"]
    var row3 = ["target3", "target0"]
    var scoreLabel: SKLabelNode!
    var gameTimer: Timer?
    var firstRowTimer: Timer?
    var secondRowTimer: Timer?
    var thirdRowTimer: Timer?
    var shotsCounter = 3
    var gameOverLabel: SKSpriteNode!
    var bulletSection: SKSpriteNode!
    var reloadSection: SKLabelNode!
    var restartButton: SKLabelNode!
    var finalScoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        
        startGame()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "reloadButton" {
                run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
                bulletSection.texture = SKTexture(imageNamed: "shots3")
                shotsCounter = 3
                return
            }
            
            if node.name == "restart" {
                gameOverLabel.removeFromParent()
                restartButton.removeFromParent()
                finalScoreLabel.removeFromParent()
                
                shotsCounter = 3
                score = 0
                startGame()
                
                return
            }
         }
        
        if location.y < 150 {
            return
        }
        
        if shotsCounter == 0 {
            run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
            return
        }
        
        for node in tappedNodes {
            if node.name == "goodTarget" {
                node.removeFromParent()
                score += 1
            } else if node.name == "badTarget" {
                node.removeFromParent()
                score -= 3
            }
        }
        
        shotsCounter -= 1
        renderBulletSection()
    }
    
    func startGame() {
        bulletSection = SKSpriteNode(imageNamed: "shots3")
        bulletSection.position = CGPoint(x: 100, y: 100)
        addChild(bulletSection)
        
        reloadSection = SKLabelNode(fontNamed: "Chalkduster")
        reloadSection.text = "Reload"
        reloadSection.name = "reloadButton"
        reloadSection.fontSize = 30
        reloadSection.position = CGPoint(x: 512, y: 100)
        addChild(reloadSection)
        
        restartButton = SKLabelNode(fontNamed: "Chalkduster")
        restartButton.text = "Restart Game"
        restartButton.name = "restart"
        restartButton.fontSize = 30
        restartButton.position = CGPoint(x: 512, y: 100)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.name = "scoreLabel"
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: 900, y: 100)
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(gamePlayTimer), userInfo: nil, repeats: false)
        firstRowTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(createRowOneCallFunction), userInfo: nil, repeats: true)
        secondRowTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createRowTwoCallFunction), userInfo: nil, repeats: true)
        thirdRowTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(createRowThreeCallFunction), userInfo: nil, repeats: true)
    }
    
    func renderBulletSection() {
        run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
        if shotsCounter == 2 {
            bulletSection.texture = SKTexture(imageNamed: "shots2")
        } else if shotsCounter == 1 {
            bulletSection.texture = SKTexture(imageNamed: "shots1")
        } else {
            bulletSection.texture = SKTexture(imageNamed: "shots0")
        }
    }
    
    @objc func createRowOneCallFunction() {
        createRow(row: row1, fwd: true, height: 300)
    }
    
    @objc func createRowTwoCallFunction() {
        createRow(row: row2, fwd: false, height: 500)
    }
    
    @objc func createRowThreeCallFunction() {
        createRow(row: row3, fwd: true, height: 700)
    }
    
    func createRow(row: [String], fwd: Bool, height: Double) {
        guard let target = row.randomElement() else { return }
         let sprite = SKSpriteNode(imageNamed: target)
         sprite.name = (target == "target0" ?  "badTarget" : "goodTarget")
         sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
         sprite.position = CGPoint(x: fwd ? 0 : 1024, y: height)
         sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
         sprite.physicsBody?.angularVelocity = 5
         sprite.physicsBody?.angularDamping = 0
         sprite.physicsBody?.linearDamping = 0
        
        let move: SKAction
        move = SKAction.moveTo(x: fwd ? 1024 : 0, duration: 3.0)
        
        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        sprite.run(sequence)
        addChild(sprite)
    }
    
    @objc func gamePlayTimer() {
        removeAll()
        
        gameOverLabel = SKSpriteNode(imageNamed: "game-over")
        gameOverLabel.zPosition = 1
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        
        finalScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        finalScoreLabel.fontSize = 30
        finalScoreLabel.position = CGPoint(x: 512, y: 280)
        finalScoreLabel.text = "Score: \(score)"
        
        addChild(gameOverLabel)
        addChild(finalScoreLabel)
        addChild(restartButton)
    }
    
    func removeAll() {
        gameTimer?.invalidate()
        firstRowTimer?.invalidate()
        secondRowTimer?.invalidate()
        thirdRowTimer?.invalidate()
        bulletSection.removeFromParent()
        reloadSection.removeFromParent()
        scoreLabel.removeFromParent()
    }

}
