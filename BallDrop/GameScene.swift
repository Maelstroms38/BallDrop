//
//  GameScene.swift
//  BallDrop
//
//  Created by Michael Stromer on 8/27/17.
//  Copyright © 2017 Michael Stromer. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None:    UInt32 = 0
    static let Ball:    UInt32 = 0b1 // 1
    static let Block:   UInt32 = 0b10 // 2
    static let Switch:  UInt32 = 0b100 // 4
    static let Edge:    UInt32 = 0b1000 // 8
    static let Ramp:    UInt32 = 0b10000 // 16
    static let Triangle:UInt32 = 0b100000 // 32
}


class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let scene = Level(size: CGSize(width: 1334, height: 750))
        scene.scaleMode = .aspectFill
        let reveal = SKTransition.crossFade(withDuration: 0.2)
        self.view?.presentScene(scene, transition: reveal)
        
    }
}
