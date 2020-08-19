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
    var row2 = ["target2", "target0"]
    var row3 = ["target3", "target0"]
    var scoreLabel: SKLabelNode!
    var gameTimer: Timer?
    var shotsCounter = 3
    var gameOverLabel: SKLabelNode!
    var bulletSection: SKSpriteNode!
    var reloadSection: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = .zero
        
        bulletSection = SKSpriteNode(imageNamed: "shots3")
        bulletSection.position = CGPoint(x: 100, y: 100)
        addChild(bulletSection)
        
        reloadSection = SKLabelNode(fontNamed: "Chalkduster")
        reloadSection.text = "Reload"
        reloadSection.name = "reloadButton"
        reloadSection.fontSize = 30
        reloadSection.position = CGPoint(x: 512, y: 100)
        addChild(reloadSection)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.name = "scoreLabel"
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: 900, y: 100)
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createRow), userInfo: nil, repeats: true)
        
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
        }
        
        if location.y < 150 {
            return
        }
        
        if shotsCounter == 0 {
            run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
            return
        }
        shotsCounter -= 1
        renderBulletSection()
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
    
    @objc func createRow() {
         guard let target = row1.randomElement() else { return }
         let sprite = SKSpriteNode(imageNamed: target)
         sprite.name = (target == "target0" ?  "badTarget" : "goodTarget")
         sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
         sprite.position = CGPoint(x: 1024, y: 400)
         sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
         sprite.physicsBody?.angularVelocity = 5
         sprite.physicsBody?.angularDamping = 0
         sprite.physicsBody?.linearDamping = 0
        
        let move: SKAction
        move = SKAction.moveTo(x: 0, duration: 3.0)
        
        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        sprite.run(sequence)
        addChild(sprite)
    }

}
