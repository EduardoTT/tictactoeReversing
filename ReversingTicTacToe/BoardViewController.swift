//
//  ViewController.swift
//  ReversingTicTacToe
//
//  Created by Eduardo Tolmasquim on 15/05/17.
//  Copyright © 2017 Eduardo. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController,BoardViewDelegate {
    
    @IBOutlet var squares: [UIButton]!

    @IBOutlet var corners: [UIButton]!
    
    @IBOutlet var linesImageViews: [UIImageView]!
    
    private let xImage = UIImage(named:"x")
    private let oImage = UIImage(named: "emptyBall")
    private let whiteBall = UIImage(named: "whiteBall")
    private let greyBall = UIImage(named:"greyBall")
    
    private let viewModel = BoardViewModel()
    
    var isIndividualGame = true
    
    @IBOutlet weak var downStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var midleStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var upStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableDivisorHorizontalDown: NSLayoutConstraint!
    @IBOutlet weak var tableDivisorHorizontalUp: NSLayoutConstraint!
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var cornerUpLeftCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var cornerDownRightCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var cornerDownLeftCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var cornerUpRightCenterYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.isIndividualGame = isIndividualGame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upStackViewConstraint.constant = tableImageView.frame.height * 0.15
        midleStackViewConstraint.constant = tableImageView.frame.height * 0.50
        downStackViewConstraint.constant = tableImageView.frame.height * 0.85
        
        cornerUpLeftCenterYConstraint.constant = tableImageView.frame.height * 0.33
        cornerDownRightCenterYConstraint.constant = tableImageView.frame.height * 0.66
        cornerDownLeftCenterYConstraint.constant = tableImageView.frame.height * 0.66
        cornerUpRightCenterYConstraint.constant = tableImageView.frame.height * 0.33
        tableDivisorHorizontalDown.constant = tableImageView.frame.height * 0.66
        tableDivisorHorizontalUp.constant = tableImageView.frame.height * 0.33
    }

    private func getSquareFrom(button:UIButton)->Square? {
        
        guard let position = SquarePosition(rawValue: button.tag) else {
            return nil
        }
        
        var value:SquareValue
        if button.image(for: .normal) == xImage {
            value = .x
        }
        else if button.image(for: .normal) == oImage {
            value = .o
        }
        else {
            value = .empty
        }
        
        return Square(position: position, value: value)
    }
    
    @IBAction func didTapCorner(_ sender: UIButton) {
        
        guard let corner = Corner(tag: sender.tag) else { return }
        
        viewModel.didTap(corner:corner)
    }
    
    @IBAction func didTapSquare(_ sender: UIButton) {
        
        guard let square = getSquareFrom(button: sender) else { return }
        
        viewModel.didTap(square:square)
    }
    
    
    @IBAction func didTapRestart() {
        for square in squares {
            square.setImage(nil, for: .normal)
            square.isEnabled = true
        }
        for corner in corners {
            corner.setImage(whiteBall, for: .normal)
            corner.isEnabled = true
        }
        for lineImageView in linesImageViews {
            lineImageView.isHidden = true
        }
        viewModel.restart()
    }
    
    
    //MARK: BoardViewDelegate
    
    func showResultLines(_ winners:[Winner]) {
        guard !winners.isEmpty else { return }
        for winner in winners {
            for lineImageView in linesImageViews {
                if LineType(rawValue:lineImageView.tag) == winner.line.type {
                    lineImageView.tintColor = winner.player == .x ? .blue : .red
                    lineImageView.isHidden = false
                }
            }
        }
        for square in squares {
            square.isEnabled = false
        }
        for corner in corners {
            corner.isEnabled = false
        }
    }
    
    func update(square:Square) {
        for button in squares {
            let squareFromButton = getSquareFrom(button: button)
            if squareFromButton?.position == square.position {
                switch square.value {
                case .empty:
                    button.setImage(nil, for: .normal)
                case .o:
                    button.setImage(oImage, for: .normal)
                    button.tintColor = .red
                case .x:
                    button.setImage(xImage, for: .normal)
                    button.tintColor = .blue
                }
            }
        }
    }
    
    func update(corner:Corner) {
        if let buttonToUpdate = corners.first(where: {$0.tag == corner.position.rawValue}) {
            if corner.isEnabled {
                buttonToUpdate.setImage(whiteBall, for: .normal)
            } else {
                buttonToUpdate.setImage(greyBall, for: .normal)
            }
        }
    }
}

