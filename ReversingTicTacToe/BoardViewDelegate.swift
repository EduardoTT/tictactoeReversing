//
//  BoardViewDelegate.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 16/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation

protocol BoardViewDelegate:class {
    func showResultLines(_ winners:[Winner])
    func update(square:Square)
    func update(corner:Corner)
}
