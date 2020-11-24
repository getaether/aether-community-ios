//
//  AETabBarViewController.swift
//  
//
//  Created by Bruno Pastre on 11/08/20.
//

import UIKit

class AETabBarViewController: UITabBarController {
    typealias strings = AEStrings.AETabBarViewController
    private var easterEggState = EasterEggRevealState.getFirstState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = self.getTabBars()
        self.tabBar.tintColor = ColorManager.highlightColor
    }
    
    
    private func getTabBars() -> [UIViewController] {
        let vcs = [
            HomeViewController(),
            ScenesViewController(),
//            LojaViewController(),
            SettingsViewController(),
        ]
        
        let icons = [
            "home-icon",
            "lampIcon",
//            "shopping-cart-icon",
            "settings-icon"
        ]
        
        let titles = [
            strings.TabBarItem.home,
            strings.TabBarItem.scene,
//            strings.TabBarItem.store,
            strings.TabBarItem.settings
        ]
        
        vcs.enumerated().forEach { (i, vc) in
            let image = UIImage(named: icons[i])
            vc.tabBarItem = UITabBarItem(title: titles[i], image: image, selectedImage: image)
        }
        
        let ret =  vcs.map { UINavigationController(rootViewController: $0) }
        
        ret.forEach {
            $0.navigationBar.prefersLargeTitles = true
            $0.navigationItem.largeTitleDisplayMode = .always
        }
        
        return ret
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        touches.forEach {
            let pos = $0.location(in: self.view)
            self.updateEasterEgg(pos)
        }
    }
    
    private func updateEasterEgg(_ pos: CGPoint) {
        let easterEggPos = getEasterEggPosition(easterEggState)
        
        let frame = CGRect(
            origin: easterEggPos,
            size: CGSize(
                width: easterEggState.touchArea(),
                height: easterEggState.touchArea()
            )
        )
        
        if frame.contains(pos) {
            self.presentEasterEggFeedback()
            if let nextState = self.easterEggState.next() {
                self.easterEggState = nextState
                return
            }
            
            self.easterEggState = .getFirstState()
            self.presentEasterEgg()
            
            return
        }
        
    }
    
    func presentEasterEggFeedback() {
        let imageView = UIImageView(
            image: UIImage(named: "rabbit")
        )
        
        imageView.frame = .init(
            origin: self.getEasterEggPosition(self.easterEggState),
            size: CGSize(
                width: 40.0,
                height: 40.0
            )
        )
        
        self.view.addSubview(imageView)
        
        let center = self.view.center
        
        UIView.animate(withDuration: 0.8) {
            imageView.transform = imageView.transform
                .scaledBy(
                    x: 4,
                    y: 4
                ).translatedBy(
                    x: center.x - imageView.center.x,
                    y: center.y - imageView.center.y
                )
            
            imageView.alpha = 0
            
            UIImpactFeedbackGenerator(
                style: .heavy
            ).impactOccurred(
                intensity: .greatestFiniteMagnitude
            )
            
        } completion: { (_) in
            imageView.removeFromSuperview()
        }

        
    }
    
    private func presentEasterEgg() {
        let vc = EasterEggViewController()
        
        self.present(vc, animated: true, completion: nil)
    }
    
    private func getEasterEggPosition(_ state: EasterEggRevealState) -> CGPoint {
        let mult = state.inView()
        
        return CGPoint(
            x: self.view.frame.width * mult.x + state.offset().x,
            y: (self.view.frame.height) * mult.y + state.offset().y
        )
        
    }
    
    
    
}
