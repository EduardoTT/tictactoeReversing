//
//  Square.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 16/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

class Square:Place {
    var position:SquarePosition
    var value: SquareValue
    
    init(position:SquarePosition, value:SquareValue = .empty) {
        self.position = position
        self.value = value
    }
    
    var ownerPlayer:Player? {
        return value.belongsToPlayer
    }
    
    func copy()->Square {
        let copy = Square(position: position)
        copy.value = value
        return copy
    }
}

enum SquareValue {
    case empty
    case x
    case o
    
    func oposite()->SquareValue {
        switch self {
        case .x: return .o
        case .o: return .x
        case .empty: return .empty
        }
    }
    
    fileprivate var belongsToPlayer:Player? {
        switch self {
        case .x:
            return .x
        case .o:
            return .o
        default:
            return nil
        }
    }
}

enum SquarePosition:Tag {
    case upLeft
    case upCenter
    case upRight
    case left
    case center
    case right
    case downLeft
    case downCenter
    case downRight
}
