//
//  LampSetupViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 06/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

class LampSetupViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let strings = AEStrings.LampSetupViewController.self
    
    // MARK: - UI Components
    private lazy var nextButton: DesignableButton = {
        let button = DesignableButton()
    
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(
            strings.Button.next, for: .normal)
        
        return button
    }()
    private let closeButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close 1"), for: .normal)
        button.tintColor = ColorManager.lighterColor
        
        return button
    }()
    private let pageControl: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.backgroundColor = .clear

        let proxy = UIPageControl.appearance()
        
        proxy.pageIndicatorTintColor = ColorManager.lightestColor
        proxy.currentPageIndicatorTintColor = ColorManager.highlightColor
        
        return vc
    }()
    
    private lazy var vcs =  [
        LampSetupImageInstructionViewController(
            title: strings.Instructions.First.title,
            description: strings.Instructions.First.description,
            imageName:"onboarding1"
        ),
        LampSetupImageInstructionViewController(
            title: strings.Instructions.Second.title,
            description: strings.Instructions.Second.description,
            imageName:"onboarding1"
        ),
        LampSetupImageInstructionViewController(
            title: strings.Instructions.Third.title,
            description: strings.Instructions.Third.description,
            imageName:"onboarding1"
        )
    ]
    
    private var currentPage = 0
    weak var delegate: ViewControllerDismissDelegate?
    
    
    // MARK: - ViewController Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorManager.backgroundColor
        
        self.setupNextButton()
        self.setupCloseButton()
        self.setupPageControl()
    
    }
    
    // MARK: - Setup methods
    func setupNextButton() {
        self.view.addSubview(nextButton)
        
        nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        nextButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        nextButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
        
        nextButton.addTarget(self, action: #selector(self.onNext), for: .touchDown)
    }
    func setupCloseButton() {
        self.view.addSubview(self.closeButton)
        
        self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        self.closeButton.addTarget(self, action: #selector(self.onClose), for: .touchDown)
    }
    func setupPageControl() {
        
        self.pageControl.dataSource = self
        self.pageControl.delegate = self
        
        self.addChild(self.pageControl)
        self.view.addSubview(self.pageControl.view)
        
        
        self.pageControl.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pageControl.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        
        self.pageControl.view.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor, constant: -40).isActive = true
        self.pageControl.view.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 40).isActive = true
        
        self.pageControl.didMove(toParent: self)
   
        self.pageControl.setViewControllers([self.getViewControllers()[0]], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - UIPageViewControllerDelegate & DataSource methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = self.getViewControllers().firstIndex(of: viewController) else { return nil }
        
        if vcIndex <= 0 { return nil}
        return self.getViewControllers()[vcIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = self.getViewControllers().firstIndex(of: viewController) else { return nil }
        
        if vcIndex >= self.getViewControllers().count - 1 { return nil}
        return self.getViewControllers()[vcIndex + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.first else { return }
        guard let index = self.getViewControllers().firstIndex(of: vc) else { return }
        
        self.updateButtonName(isDone: index == self.getViewControllers().count - 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.getViewControllers().count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }

    // MARK: - Helper methods
    
    func updateButtonName(isDone: Bool) {
        let name = !isDone ? strings.Button.next : strings.Button.ready
        
        self.nextButton.setTitle(name, for: .normal)
    }
    
    func goToNextPage() {
        guard let currVc = self.pageControl.viewControllers?.first else { return }
        guard let currVcIndex = self.getViewControllers().firstIndex(of: currVc) else { return }
        guard currVcIndex + 1 < self.getViewControllers().count else { return }
        
        let nextVc = self.getViewControllers()[currVcIndex + 1]
        
        self.currentPage = currVcIndex + 1
        self.pageControl.setViewControllers([nextVc], direction: .forward, animated: true, completion: nil)
        
        self.updateButtonName(isDone: self.currentPage == self.getViewControllers().count - 1)
    }
    
    
    func dismissToRoot(should goOn: Bool) {
        
        self.dismiss(animated: true) {
            self.delegate?.onDismiss(self, should: goOn)
        }
        
    }

    
    func getViewControllers() -> [UIViewController] {
        return vcs
    }
    
    // MARK: - Callbacks
    
    @objc func onNext() {
        if self.nextButton.title(for: .normal) == strings.Button.ready {
            self.dismissToRoot(should: true)
        } else {
            self.goToNextPage()
        }
    }
    
    @objc func onClose() {
        self.dismissToRoot(should: false)
    }
    

}
