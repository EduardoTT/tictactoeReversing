//
//  Turn.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 16/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

enum Player {
    case x
    case o
    
    func oposite()->Player {
        return self == .x ? .o : .x
    }
    
    var squareValue:SquareValue {
        return self == .x ? .x : .o
    }
    
    func next()->Player {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
    
    
}
