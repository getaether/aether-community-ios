//
//  WelcomeViewController.swift
//  Aether
//
//  Created by Gabriel Gazal on 06/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import Lottie
import WebKit
import HomeKit

class WelcomeViewController: UIViewController {
    private let strings = AEStrings.WelcomeViewController.self
    
    @IBOutlet weak var animation: AnimationView!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var startButton: DesignableButton!
    @IBOutlet weak var haventReceivedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = strings.Label.title
        descLabel.text = strings.Label.description
        startButton.setTitle(
            strings.Button.start,
            for: .normal
        )
        haventReceivedButton.setTitle(
            strings.Button.haventReceived,
            for: .normal
        )
        descLabel.textColor = ColorManager.bodyTextColor
        animation.loopMode = .loop
        animation.play()
        
        startButton.addTarget(self, action: #selector(self.onStartButton), for: .touchUpInside)
        haventReceivedButton.addTarget(self, action: #selector(onHaventReceivedButton), for: .touchUpInside)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        animation.loopMode = .loop
        animation.play()
    }
    
    
    @objc func onStartButton() {
        let vc = AEPermissionsViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onHaventReceivedButton() {
        let vc = AEWebStoreViewController()
        
        present(vc, animated: true, completion: nil)
    }
}


class AEWebStoreViewController: UIViewController, WKUIDelegate {
    
    private lazy var wkView: WKWebView = {
        let view = WKWebView(
            frame: .zero,
            configuration: .init()
        )
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.uiDelegate = self
    
        return view
    }()
    
    override func loadView() {
        view = wkView
    }
    
    override func viewDidLoad() {
        guard
            let url = URL(string: "https://aether-backend.herokuapp.com/landingpage/store")
        else { return }
        
        let request = URLRequest(url: url)
        
        wkView.load(request)
    }
    
    
}
