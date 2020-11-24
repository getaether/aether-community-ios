//
//  EasterEggViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 15/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol EasterEggBoardDelegate: class{
    func didSelectLamp(at index: Int)
}

class EasterEggView: UIView {
    
    private static let offImage = UIImage(named: "onboarding1")
    private static let onImage = UIImage(named: "onboarding3")
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: offImage)
        
        view.isUserInteractionEnabled = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        return view
    }()
    
    var isOn = false
    
    init() {
        super.init(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: 80, height: 80)
            )
        )
        
        self.imageView.frame = self.frame
        self.addSubview(self.imageView)
    }
    
    func toggle() {
        self.isOn.toggle()
        
        self.imageView.image = self.isOn ?
            EasterEggView.onImage :
            EasterEggView.offImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EasterEggBoardView: UIView {
    
    var lamps: [EasterEggView]
    
    override init(frame: CGRect) {
        lamps = [
            EasterEggView(),
            EasterEggView(),
            EasterEggView(),
            EasterEggView()
        ]
        super.init(frame: frame)
    }
    
    func configure() {
        
        let board = UIStackView(arrangedSubviews: [
            self.getRow([
                self.lamps[0],
                self.lamps[1],
            ]),
            self.getRow([
                self.lamps[2],
                self.lamps[3],
            ]),
        ])
        
        board.alignment = .fill
        board.axis = .vertical
        board.distribution = .fillEqually
        
        board.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(board)
        
        board.centerXAnchor.constraint(
            equalTo: centerXAnchor
        ).isActive = true
        
        board.centerYAnchor.constraint(
            equalTo: centerYAnchor
        ).isActive = true
        
        board.widthAnchor.constraint(
            equalTo: widthAnchor
        ).isActive = true
        
        board.heightAnchor.constraint(
            equalTo: heightAnchor
        ).isActive = true
    }
    
    func toggle(index: Int) {
        self.lamps[index].toggle()
    }
    
    func resetLamps() {
        self.lamps.forEach {
            if $0.isOn {
                $0.toggle()
            }
        }
    }
    
    private func getRow(_ views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        return stack
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EasterEggPlayerBoardView: EasterEggBoardView {
    
    weak var delegate: EasterEggBoardDelegate?
    
    override func configure() {
        super.configure()
        
        lamps.forEach {
            let gesture = UITapGestureRecognizer(
                target: self,
                action: #selector(self.didSelectLamp)
            )
            
            $0.addGestureRecognizer(gesture)
        }
    }
    
    @objc func didSelectLamp(_ gesture: UITapGestureRecognizer) {
        guard
            let view = gesture.view as? EasterEggView,
            let index = self.lamps.firstIndex(of: view )
        else { return }
        view.toggle()
        self.delegate?.didSelectLamp(at: index)
    }
    
}

class EasterEggViewController: UIViewController, EasterEggBoardDelegate {
    
    private let cpuBoard = EasterEggBoardView()
    private let playerBoard = EasterEggPlayerBoardView()
    
    private var infoLabel: UILabel = {
        let view = TitleLabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.font = view.font.withSize(30)
        view.isHidden = true
        view.textColor = ColorManager.titleTextColor
        
        return view
    }()
    
    private var isPlayerTurn = false
    
    private var moves: [Int] = []
    private var playerMoves: [Int] = []
    
    override func viewDidLoad() {
        cpuBoard.configure()
        playerBoard.configure()
        
        self.playerBoard.delegate = self
        
        self.setupCPUBoard()
        self.setupPlayerBoard()
        self.setupInfoLabel()
        
        self.view.backgroundColor = ColorManager.backgroundColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startGame()
    }
    
    private func setupCPUBoard() {
        cpuBoard.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cpuBoard)
        cpuBoard.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        
        cpuBoard.topAnchor.constraint(
            equalTo: view.topAnchor
        ).isActive = true
        
        cpuBoard.widthAnchor.constraint(
            equalTo: view.widthAnchor,
            multiplier: 0.7
        ).isActive = true
        
        cpuBoard.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.4
        ).isActive = true
    }
    private func setupPlayerBoard() {
        playerBoard.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerBoard)
        playerBoard.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        
        playerBoard.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        ).isActive = true
        
        playerBoard.widthAnchor.constraint(
            equalTo: view.widthAnchor,
            multiplier: 0.7
        ).isActive = true
        
        playerBoard.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.4
        ).isActive = true
        
    }
    private func setupInfoLabel() {
        self.view.addSubview(self.infoLabel)
        
        self.infoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.infoLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func startGame() {
        self.playerMoves.removeAll()
        
        self.runTimer { [weak self] in
            guard let self = self else { return }
            let message = self.isPlayerTurn ? "Your turn" : "CPU is playing"
            self.displayTurn(message) {
                    self.cpuPlay()
            }
        }
    }
    private func runTimer(completion: (() -> Void)? = nil) {
        var time = 3
        self.infoLabel.isHidden = false
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.infoLabel.text = time < 1 ? "GO!" : String(time)
            
            time -= 1
            
            if time < -1 {
                self.infoLabel.isHidden = true
                completion?()
                timer.invalidate()
            }
        }
    }
    
    private func displayTurn(_ message: String, completion: (() -> Void)? = nil) {
        self.infoLabel.text = message
        
        self.infoLabel.isHidden = false
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (_) in
            guard let self = self else { return }
            
            self.infoLabel.isHidden = true
            completion?()
        }
    }
    
    private func cpuPlay() {
        self.isPlayerTurn = false
        self.playerMoves.removeAll()
        guard
            let newMove = (0...3).randomElement()
        else { return }
        
        moves.append(newMove)
        var clone = moves.map { $0 }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            guard
                clone.count > 0
            else {
                timer.invalidate()
                self.endCPUPlay()
                return
            }
            
            let index = clone.remove(at: 0)
            self.cpuBoard.toggle(index: index)
        }
        
    }
    
    private func endCPUPlay() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (_) in
            guard let self = self else { return }
            
            self.cpuBoard.resetLamps()
            self.isPlayerTurn = true
            
            let message = self.isPlayerTurn ? "Your turn" : "CPU is playing"
            self.displayTurn(message)
        }
    }
    
    private func onGameOver() {
        self.displayTurn("GAME OVER!PERDEU") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    private func isGameOver() -> Bool {
        for (i, move) in self.playerMoves.enumerated() {
            if self.moves[i] != move { return true }
        }
        
        return false
    }
    
    private func playerFiguredItOut() -> Bool {
        return self.moves.count == self.playerMoves.count
    }
    
    func didSelectLamp(at index: Int) {
        guard
            isPlayerTurn
        else { return }
        
        if isGameOver() {
            self.onGameOver()
            return
        }
        
        self.playerMoves.append(index)
        
        if self.playerFiguredItOut() {
            self.displayTurn("BOA! Vem a proxima") { [weak self] in
                guard let self = self else { return }
                self.playerBoard.resetLamps()
                self.runTimer {
                    self.cpuPlay()
                }
            }
        }
    }
}

