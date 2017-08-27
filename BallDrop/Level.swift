//
//  Level.swift
//  BallDrop
//
//  Created by Michael Stromer on 8/27/17.
//  Copyright © 2017 Michael Stromer. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Level: SKScene, SKPhysicsContactDelegate {
    
    private var level = 1
    
    var gameIsPlaying = true
    
    var backgroundMusicPlayer = AVAudioPlayer()
    var timer = Timer()
    var timeRemaining = 10
    let timerLabel = SKLabelNode(fontNamed: "Menlo")
    
    let bowlingBall = SKSpriteNode(imageNamed: "bowlingBall")
    let redButton = SKSpriteNode(imageNamed: "redButton")
    let horizontalBlock = SKSpriteNode(imageNamed: "horizontalBlock")
    let ramp = SKSpriteNode(imageNamed: "bigRamp")
    let verticalBlock1 = SKSpriteNode(imageNamed: "verticalBlock")
    let verticalBlock2 = SKSpriteNode(imageNamed: "verticalBlock")
    
    override func didMove(to view: SKView) {
        
        updateBackground()
        setUpTimerLabel()
        setupNodes()
        
        let maxAspect: CGFloat = 16.0 / 9.0
        let maxAspectHeight = size.width / maxAspect
        let playableMargin: CGFloat = (size.height - maxAspectHeight) / 2
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin*2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody?.categoryBitMask = PhysicsCategory.Edge
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if !gameIsPlaying {
            return
        }
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Ball | PhysicsCategory.Block {
            print("Ball hit block")
        }
        if collision == PhysicsCategory.Ball | PhysicsCategory.Edge {
            print("Ball hit edge")
            didLose()
        }
        if collision == PhysicsCategory.Ball | PhysicsCategory.Switch {
            print("Ball hit switch")
            didWin()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if touchedNode.name == "ball" {
                
                bowlingBall.physicsBody?.affectedByGravity = true
                verticalBlock1.physicsBody?.affectedByGravity = false
                
            }
            
            if touchedNode.name == "block" {
                
                run(SKAction.playSoundFileNamed("popSound.mp3", waitForCompletion: false))
                
                touchedNode.isUserInteractionEnabled = false
                
                let scaleDown = SKAction.scale(to: 0.0, duration: 0.15)
                let remove = SKAction.removeFromParent()
                
                let sequence = SKAction.sequence([scaleDown, remove])
                
                touchedNode.run(sequence)
                
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        updateTimerLabel()
    }
    func updateBackground() {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        bg.setScale(0.7)
        bg.zPosition = -10
        addChild(bg)
    }

    func setupNodes() {
        print(self.level)
        switch self.level {
        case 1:
            bowlingBall.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.85)
            bowlingBall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bowlingBall.setScale(0.5)
            bowlingBall.zPosition = 1
            bowlingBall.name = "ball"
            bowlingBall.physicsBody = SKPhysicsBody(circleOfRadius: bowlingBall.size.width / 2)
            bowlingBall.physicsBody?.categoryBitMask = PhysicsCategory.Ball
            bowlingBall.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Block
            bowlingBall.physicsBody?.contactTestBitMask = PhysicsCategory.Edge | PhysicsCategory.Switch | PhysicsCategory.Block
            bowlingBall.physicsBody?.affectedByGravity = false
            addChild(bowlingBall)
            
            redButton.position = CGPoint(x: self.size.width / 2, y: 20)
            redButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            redButton.setScale(0.6)
            redButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            redButton.physicsBody?.affectedByGravity = false
            redButton.physicsBody?.isDynamic = false
            redButton.physicsBody?.categoryBitMask = PhysicsCategory.Switch
            addChild(redButton)
            
            verticalBlock1.position = CGPoint(x: self.size.width / 2 - redButton.size.width / 2 - verticalBlock1.size.width / 2 + 25, y: verticalBlock1.size.height / 2)
            verticalBlock1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            verticalBlock1.setScale(1.0)
            verticalBlock1.name = "block"
            verticalBlock1.physicsBody = SKPhysicsBody(rectangleOf: verticalBlock1.frame.size)
            verticalBlock1.physicsBody?.categoryBitMask = PhysicsCategory.Block
            addChild(verticalBlock1)
            
            verticalBlock2.position = CGPoint(x: self.size.width / 2 + redButton.size.width / 2 + verticalBlock2.size.width / 2 - 25, y: verticalBlock2.size.height / 2)
            verticalBlock2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            verticalBlock2.setScale(1.0)
            verticalBlock2.name = "block"
            verticalBlock2.physicsBody = SKPhysicsBody(rectangleOf: verticalBlock2.frame.size)
            verticalBlock2.physicsBody?.categoryBitMask = PhysicsCategory.Block
            addChild(verticalBlock2)
            
            horizontalBlock.position = CGPoint(x: self.size.width / 2, y: verticalBlock1.size.height + horizontalBlock.size.height / 2)
            horizontalBlock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            horizontalBlock.setScale(1.0)
            horizontalBlock.name = "block"
            horizontalBlock.physicsBody = SKPhysicsBody(rectangleOf: horizontalBlock.frame.size)
            horizontalBlock.physicsBody?.categoryBitMask = PhysicsCategory.Block
            addChild(horizontalBlock)
        case 2:
            bowlingBall.position = CGPoint(x: self.size.width * 0.70, y: self.size.height * 0.85)
            bowlingBall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bowlingBall.setScale(0.5)
            bowlingBall.zPosition = 1
            bowlingBall.name = "ball"
            bowlingBall.physicsBody = SKPhysicsBody(circleOfRadius: bowlingBall.size.width / 2)
            bowlingBall.physicsBody?.categoryBitMask = PhysicsCategory.Ball
            bowlingBall.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Block
            bowlingBall.physicsBody?.contactTestBitMask = PhysicsCategory.Edge | PhysicsCategory.Switch | PhysicsCategory.Block
            bowlingBall.physicsBody?.affectedByGravity = false
            addChild(bowlingBall)
            
            redButton.position = CGPoint(x: self.size.width * 0.375, y: 20)
            redButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            redButton.setScale(0.6)
            redButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            redButton.physicsBody?.affectedByGravity = false
            redButton.physicsBody?.isDynamic = false
            redButton.physicsBody?.categoryBitMask = PhysicsCategory.Switch
            addChild(redButton)
            
            ramp.position = CGPoint(x: self.size.width - ramp.size.width / 2, y: ramp.size.height / 2 + 100)
            ramp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let offsetX = ramp.size.width * ramp.anchorPoint.x
            let offsetY = ramp.size.height * ramp.anchorPoint.y
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 4 - offsetX, y: 6 - offsetY))
            path.addLine(to: CGPoint(x: 640 - offsetX, y: 640 - offsetY))
            path.addLine(to: CGPoint(x: 640 - offsetX, y: 0 - offsetY))
            path.closeSubpath()
            ramp.physicsBody = SKPhysicsBody(polygonFrom: path)
            ramp.physicsBody?.affectedByGravity = false
            ramp.physicsBody?.isDynamic = false
            addChild(ramp)

        default:
            break
        }
        
    }
    func didWin() {
        timer.invalidate()
        
        self.gameIsPlaying = false
        
        let winLabel = SKLabelNode(fontNamed: "Menlo")
        winLabel.position = CGPoint(x: self.size.width/2, y: self.size.height / 4)
        winLabel.zPosition = 10
        winLabel.fontColor = SKColor.white
        winLabel.fontSize = 120
        winLabel.horizontalAlignmentMode = .center
        winLabel.verticalAlignmentMode = .center
        winLabel.text = "VICTORY!"
        addChild(winLabel)
        
        let labelAnimation = SKAction.moveTo(y: self.size.height / 2, duration: 0.2)
        let wait = SKAction.wait(forDuration: 2.0)
        let remove = SKAction.removeFromParent()
        
        let transition = SKAction.run {
            self.level = self.level + 1
            self.levelUp(level: self.level)
        }
        
        let labelSequence = SKAction.sequence([labelAnimation, wait, remove, transition])
        winLabel.run(labelSequence)
    }
    func didLose() {
        timer.invalidate()

        self.gameIsPlaying = false
        
        let loseLabel = SKLabelNode(fontNamed: "Menlo")
        loseLabel.position = CGPoint(x: self.size.width/2, y: self.size.height / 4)
        loseLabel.zPosition = 10
        loseLabel.fontColor = SKColor.white
        loseLabel.fontSize = 120
        loseLabel.horizontalAlignmentMode = .center
        loseLabel.verticalAlignmentMode = .center
        loseLabel.text = "DEFEAT!"
        addChild(loseLabel)
        
        let labelAnimation = SKAction.moveTo(y: self.size.height / 2, duration: 0.2)
        let wait = SKAction.wait(forDuration: 2.5)
        let remove = SKAction.removeFromParent()
        
        let transition = SKAction.run {
            self.levelUp(level: self.level)
        }
        
        let labelSequence = SKAction.sequence([labelAnimation, wait, remove, transition])
        loseLabel.run(labelSequence)
    }
    func playBackgroundMusic() {
        
        do {
            let path = Bundle.main.path(forResource: "physicsGameBackgroundMusic", ofType: "mp3")
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            backgroundMusicPlayer.volume = 1.0
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch {
            print("error loading audio")
        }
    }
    
    func setUpTimerLabel(){
        
        timerLabel.position = CGPoint(x: self.size.width * 0.10, y: self.size.height * 0.85)
        timerLabel.zPosition = 10
        timerLabel.fontColor = SKColor.white
        timerLabel.fontSize = 125
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.verticalAlignmentMode = .center
        timerLabel.text = "\(timeRemaining)"
        addChild(timerLabel)
        
    }
    
    func updateTimerLabel(){
        
        timerLabel.text = "\(timeRemaining)"
    }
    
    func updateTimer() {
        
        timeRemaining = timeRemaining - 1
        
        if timeRemaining < 0 {
            
            timerLabel.removeFromParent()
            self.didLose()
            
        }
    }
    func levelUp(level: Int) {
        switch level {
        case 1:
            let scene = Level(size: CGSize(width: 1334, height: 750))
            scene.level = level
            scene.scaleMode = .aspectFill
            let reveal = SKTransition.crossFade(withDuration: 0.2)
            self.view?.presentScene(scene, transition: reveal)
            
        case 2:
            let scene = Level(size: CGSize(width: 1334, height: 750))
            scene.level = level
            scene.scaleMode = .aspectFill
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.2)
            self.view?.presentScene(scene, transition: reveal)
            
        case 3:
            let scene = Level(size: CGSize(width: 1334, height: 750))
            scene.level = level
            let reveal = SKTransition.crossFade(withDuration: 0.2)
            self.view?.presentScene(scene, transition: reveal)
            
        default:
            break
        }
    }

    
}
