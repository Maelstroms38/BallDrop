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
        //
        // SAGA GAMING
        // GAME ONE: Roll Out 
        //
        // Level selection screen from JSON data. Each level has a unique track to roll over.
        // Each player controls a rollable machine that blasts its way to the finish! >>>>>>
        
        // 1) create each level, we can decode a JSON tree for the level section screen.
        
        // 2) THEN map each level to the starter levels bundle.
        
        // 3) If this is their first playthrough, show a "how to kickass" tutorial.
        do {
            if let file = Bundle.main.url(forResource: "flights", withExtension: "json") {
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
                    //Start the game, with the first level.
                    
                    //let reveal = SKTransition.crossFade(withDuration: 0.5)
                    //self.view?.presentScene(levels[0], transition: reveal)
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
    }
    func sortFunc(num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    func jsonDecoable(withLadybug: Bool) {
        if withLadybug {
            if let file = Bundle.main.url(forResource: "flights", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data)
                    let directFlight = try Flight(json: flightJSON)
                    let flightWithLayover = try Array<Flight>(json: [flightJSON, directFlight, json])
                    
                    print(flightWithLayover)
                } catch(let error) {
                    print(error.localizedDescription)
                }
            }
        }
    }

}
