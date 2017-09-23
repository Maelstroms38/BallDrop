//
//  Ladybug.swift
//  BallDrop
//
//  Created by Michael Stromer on 9/23/17.
//  Copyright © 2017 Michael Stromer. All rights reserved.
//

import Foundation
import Ladybug

//By conforming to the JSONCodable protocol, you can skip all the boilerplate that comes with Codable while still getting Codable conformance.

//Tree: JSONCodable Implementation

struct Tree: JSONCodable {
    
    enum Family: Int, Codable {
        case deciduous, coniferous
    }
    
    let name: String
    let family: Family
    let age: Int
    let plantedAt: Date
    let leaves: [Leaf]
    
    static let transformersByPropertyKey: [PropertyKey: JSONTransformer] = [
        "name": JSONKeyPath("tree_names", "colloquial", 0),
        "plantedAt": "planted_at" <- format("MM-dd-yyyy"),
        "leaves": [Leaf].transformer,
        ]
    
    struct Leaf: JSONCodable {
        
        enum Size: String, Codable {
            case small, medium, large
        }
        
        let size: Size
        let isAttached: Bool
        
        static let transformersByPropertyKey: [PropertyKey: JSONTransformer] = [
            "isAttached": "is_attached"
        ]
    }
    
}

struct Flight: JSONCodable {
    
    let passengers: [Passenger]
    let airMarshal: Passenger
    enum Airline: String, Codable {
        case delta, united, jetBlue, spirit, other
    }
    
    let airline: Airline
    let number: Int
    
    static let transformersByPropertyKey: [PropertyKey: JSONTransformer] = [
        "number": JSONKeyPath("flight_number"),
        "passengers": [Passenger].transformer,
        "airMarshal": "air_marshal" <- Passenger.transformer
    ]
    struct Passenger: JSONCodable {
        let name: String
    }
}

let flightJSON = [
"airline": "united",
"flight_number": 472,
] as [String : Any]



