//
//  MenuViewController.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 25/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController:UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let boardViewController = segue.destination as? BoardViewController
        if segue.identifier == "isIndividualGame" {
            boardViewController?.isIndividualGame = true
        } else {
            boardViewController?.isIndividualGame = false
        }
    }
}
