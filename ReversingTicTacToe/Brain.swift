//
//  Brain.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 20/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

extension Array {
    func randomElement()->Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

struct Brain {
    
    static func getBestMove(table:Table)->Place? {
        
        let currentTurn = table.turn
        
        let tree = Tree(table: table)
        tree.makeMoves(level:2)
        
        guard !tree.children.isEmpty else {
            return nil
        }
        
        var winMoves = [Place]()
        var loseMoves = [Place]()
        var normalMoves = [Place]()
        
        for child in tree.children {
            guard let lastMove = child.table.lastMove else { continue }
            let pathQuality = child.getPathQuality(for: currentTurn)
            switch pathQuality {
            case .good:
                winMoves.append(lastMove)
            case .bad:
                loseMoves.append(lastMove)
            case .normal:
                normalMoves.append(lastMove)
            }
        }
        
        if !winMoves.isEmpty {
            return winMoves.randomElement()
        }
        else if !normalMoves.isEmpty {
            return normalMoves.randomElement()
        }
        else {
            return loseMoves.randomElement()
        }
    }
    
    class Tree {
        var table:Table
        var children = [Tree]()
        
        init(table:Table) {
            self.table = table
        }
        
        func makeMoves() {
            for square in table.squares {
                if square.value == .empty {
                    let tableCopy = table.copy()
                    _ = tableCopy.playTurn(at: square.position, with:square.value)
                    children.append(Tree(table: tableCopy))
                }
            }
            for corner in table.corners {
                if corner.isEnabled {
                    let tableCopy = table.copy()
                    _ = tableCopy.playTurn(at: corner.position)
                    children.append(Tree(table: tableCopy))
                }
            }
        }
        
        func makeMoves(level:Int) {
            if level > 0 {
                makeMoves()
                for child in children {
                    child.makeMoves(level: level-1)
                }
            }
        }
        
        func getPathQuality(for player:Player)->PathQuality {
            let winners = table.winners
            let turn = table.turn
            let result = Result(winners: winners, player: player)
            
            switch result {
            case .victory:
                return .good
            case .defeat:
                return .bad
            default:
                break
            }
            
            guard !children.isEmpty else {
                return .normal
            }
            
            var childrenPathQuality = [PathQuality]()
            for child in children {
                let childPathQuality = child.getPathQuality(for: player)
                childrenPathQuality.append(childPathQuality)
            }
            
            if turn == player {
                if childrenPathQuality.contains(.good) {
                    return .good
                } else if childrenPathQuality.contains(.normal) {
                    return .normal
                } else {
                    return .bad
                }
            } else {
                if childrenPathQuality.contains(.bad) {
                    return .bad
                } else if childrenPathQuality.contains(.normal) {
                    return .normal
                } else {
                    return .good
                }
            }
        }
        
    }
    
    enum PathQuality {
        case good
        case bad
        case normal
    }
    
    enum Result {
        case victory
        case defeat
        case draw
        case nothing
        
        init(winners:[Winner], player:Player) {
            let victories = winners.filter({$0.player == player}).count
            let defeats = winners.filter({$0.player != player}).count
            
            if victories == 0 && defeats == 0 {
                self = .nothing
            }
            
            else if victories > defeats {
                self = .victory
            }
            
            else if victories == defeats {
                self = .draw
            }
            
            //victories < defeats
            else {
                self = .defeat
            }
        }
    }
}
