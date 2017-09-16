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
    
    var levels: [Level] = []
    
    override func didMove(to view: SKView) {
        do {
            if let file = Bundle.main.url(forResource: "levels", withExtension: "json") {
                let data = try Data(contentsOf: file)
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let sortedJson = json.sorted(by: { $0.key < $1.key })
                    print(sortedJson)
                    for (key, value) in sortedJson  {
                        let levelNumber = Int(key) ?? 0
                        if let levelDict = value as? [String : Any] {
                            let info = LevelInfo(levelNumber: levelNumber, dict: levelDict)
                            let scene = Level(size: CGSize(width: 1334, height: 750))
                            scene.info = info
                            scene.scaleMode = .aspectFill
                            levels.append(scene)
                        }
                    }
                    let reveal = SKTransition.crossFade(withDuration: 0.5)
                    self.view?.presentScene(levels[0], transition: reveal)
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
    }
    func sortFunc(num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }

}
