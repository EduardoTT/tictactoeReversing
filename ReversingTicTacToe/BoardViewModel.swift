//
//  BoardViewModel.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 15/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

class BoardViewModel {
    
    private var table = Table()
    
    weak var delegate:BoardViewDelegate?
    
    var visualTurn = Player.x
    
    var isIndividualGame = true
    
    func restart() {
        table = Table()
        visualTurn = table.turn
    }
    
    private func playAI() {
        let place = Brain.getBestMove(table: table)
        switch place.self {
        case is Square:
            if let squareToPlay = place as? Square {
                if let square = table.playTurn(at: squareToPlay.position, with: squareToPlay.value) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.visualTurn = self.table.turn
                        self.delegate?.update(square: square)
                    })
                }
            }
        case is Corner:
            if let cornerToPlay = place as? Corner {
                if let (cornerToUpdate,squaresToChange) = table.playTurn(at: cornerToPlay.position) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.visualTurn = self.table.turn
                        self.updateInterfaceAfterMoveOnCorner(corner: cornerToUpdate, squares: squaresToChange)
                    })
                }
            }
        default:
            break
        }
        
        if !table.winners.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: {
                self.delegate?.showResultLines(self.table.winners)
            })
        }
    }
    
    private func updateInterfaceAfterMoveOnCorner(corner:Corner,squares:[Square]) {
        for squareToChange in squares {
            delegate?.update(square: squareToChange)
        }
        
        delegate?.update(corner: corner)
    }
    
    func didTap(square:Square) {
        if isIndividualGame {
            guard visualTurn == .x else { return }
        }
        if let square = table.playTurn(at: square.position, with:square.value) {
            visualTurn = table.turn
            delegate?.update(square: square)
            if table.winners.isEmpty {
                if isIndividualGame {
                    self.playAI()
                }
            } else {
                delegate?.showResultLines(table.winners)
            }
        }
    }
    
    func didTap(corner:Corner) {
        if isIndividualGame {
            guard visualTurn == .x else { return }
        }
        if let (cornerToUpdate,squaresToChange) = table.playTurn(at: corner.position) {
            visualTurn = table.turn
            updateInterfaceAfterMoveOnCorner(corner: cornerToUpdate, squares: squaresToChange)
            if table.winners.isEmpty {
                if isIndividualGame {
                    self.playAI()
                }
            } else {
                delegate?.showResultLines(table.winners)
            }
        }
    }
}
