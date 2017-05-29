//
//  Line.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 16/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

struct Line {
    let type:LineType
    let firstSquare:SquarePosition
    let secondSquare:SquarePosition
    let thirdSquare:SquarePosition
}

typealias Tag = Int
enum LineType:Tag {
    case column0
    case column1
    case column2
    case row0
    case row1
    case row2
    case diagonal0
    case diagonal1
}
