//
//  Corner.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 16/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

class Corner:Place,Equatable {
    
    var position:CornerPosition
    var isEnabled = true
    
    init?(tag:Tag) {
        if let type = CornerPosition(rawValue: tag) {
            self.position = type
        } else {
            return nil
        }
    }
    
    init(position:CornerPosition) {
        self.position = position
    }
    
    func copy()->Corner {
        let copy = Corner(position: position)
        copy.isEnabled = isEnabled
        return copy
    }
    
    func squaresToChange()->[SquarePosition] {
        switch position {
        case .upLeft:
            return [.upLeft,.upCenter,.left,.center]
        case .upRight:
            return [.upCenter,.upRight,.center,.right]
        case .downLeft:
            return [.left,.center,.downLeft,.downCenter]
        case .downRight:
            return [.center,.right,.downCenter,.downRight]
        }
    }
    
    static func == (lhs:Corner,rhs:Corner)->Bool {
        return lhs.position == rhs.position
    }
}

enum CornerPosition:Int {
    case upLeft
    case upRight
    case downLeft
    case downRight
}
