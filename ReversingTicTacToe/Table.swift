//
//  Table.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 17/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

class Table {
    
    var squares = [Square]()
    
    var corners = [Corner]()
    
    var turn = Player.x
    
    var lastMove:Place?
    
    var winners = [Winner]()
    
    var gameIsOn:Bool {
        return winners.isEmpty
    }
    
    init() {
        
        squares = squarePositions.map({Square(position: $0)})
        
        corners = [0,1,2,3].flatMap({Corner(tag:$0)})
    }
    
    private func getWinners()->[Winner] {
        
        var result = [Winner]()
        
        for line in tableLines {
            guard
                let firstSquareValue = squares.first(where: {$0.position == line.firstSquare})?.value,
                let secondSquareValue = squares.first(where: {$0.position == line.secondSquare})?.value,
                let thirdSquareValue = squares.first(where: {$0.position == line.thirdSquare})?.value
            else {
                return []
            }
            
            let firstSquare = Square(position: line.firstSquare, value: firstSquareValue)
            let secondSquare = Square(position: line.secondSquare, value: secondSquareValue)
            let thirdSquare = Square(position: line.thirdSquare, value: thirdSquareValue)
            
            if  firstSquare.value != .empty &&
                firstSquare.value == secondSquare.value &&
                firstSquare.value == thirdSquare.value
            {
                if let player = firstSquare.ownerPlayer {
                    result.append(Winner(player: player, line: line))
                }
            }
        }
        return result
    }
    
    func playTurn(at squarePosition:SquarePosition, with squareValue:SquareValue)->Square? {
        
        guard gameIsOn else { return nil }
        
        guard let squareToChange = squares.first(where: {$0.position == squarePosition}) else {
            return nil
        }
        
        guard squareToChange.value == .empty else {
            return nil
        }
        
        squareToChange.value = turn.squareValue
        nextTurn()
        lastMove = squareToChange
        winners = getWinners()
        return squareToChange
    }
    
    func playTurn(at cornerPosition:CornerPosition)->(Corner,[Square])? {
        
        guard gameIsOn else { return nil }
        
        guard let cornerToUpdate = corners.first(where: {$0.position == cornerPosition}), cornerToUpdate.isEnabled else {
            return nil
        }
        
        var updatedSquares = [Square]()
        
        let squaresToChange = cornerToUpdate.squaresToChange()
        for square in squares {
            if squaresToChange.contains(square.position) {
                square.value = square.value.oposite()
                updatedSquares.append(square)
            }
        }
        
        cornerToUpdate.isEnabled = false
        nextTurn()
        lastMove = cornerToUpdate
        winners = getWinners()
        return (cornerToUpdate,updatedSquares)
    }
    
    private func nextTurn() {
        turn = turn.next()
    }
    
    func copy()->Table {
        let table = Table()
        table.squares = squares.map({$0.copy()})
        table.corners = corners.map({$0.copy()})
        table.turn = turn
        return table
    }
    
    private let tableLines = [Line(type: .row0, firstSquare: .upLeft, secondSquare: .upCenter, thirdSquare: .upRight),
                              Line(type: .row1, firstSquare: .left, secondSquare: .center, thirdSquare: .right),
                              Line(type: .row2, firstSquare: .downLeft, secondSquare: .downCenter, thirdSquare: .downRight),
                              Line(type: .column0, firstSquare: .upLeft, secondSquare: .left, thirdSquare: .downLeft),
                              Line(type: .column1, firstSquare: .upCenter, secondSquare: .center, thirdSquare: .downCenter),
                              Line(type: .column2, firstSquare: .upRight, secondSquare: .right, thirdSquare: .downRight),
                              Line(type: .diagonal0, firstSquare: .upRight, secondSquare: .center, thirdSquare: .downLeft),
                              Line(type: .diagonal1, firstSquare: .upLeft, secondSquare: .center, thirdSquare: .downRight)]
    
    private let squarePositions:[SquarePosition] = [.upLeft,
                                                    .upCenter,
                                                    .upRight,
                                                    .left,
                                                    .center,
                                                    .right,
                                                    .downLeft,
                                                    .downCenter,
                                                    .downRight]

}
