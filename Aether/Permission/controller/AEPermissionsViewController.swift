//
//  AEPermissionsViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 21/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit
import Lottie

class AEPermissionsViewController: UIViewController, PermissionAskerDelegate {
    private let strings = AEStrings.AEPermissionsViewController.self
    private let animationView: UIView = {
        let view = UIView()
        let animationView = AnimationView(animation: Animation.named("celular"))
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        animationView.loopMode = .loop
        animationView.play()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = TitleLabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = strings.Label.title
        
        return view
    }()
    private lazy var descriptionLabel: UILabel =  {
        let label = BodyTextLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.Label.description
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    private let optionsStackView: UIStackView = {
        let view = UIStackView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 20
        
        return view
    }()
    
    private var permissionAskers: [AEPermissionAsker] = []
    private var canNavigate = true
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        view.backgroundColor = ColorManager.backgroundColor
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        addSubviews()
        constrainSubviews()
        
        createAskers()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateAskers()
    }
    
    // MARK: - View setup
    private func addSubviews() {
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(optionsStackView)
    }
    
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            titleLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
        ])
        
        NSLayoutConstraint.activate([
            animationView.bottomAnchor.constraint(
                equalTo: titleLabel.topAnchor,
                constant: -20
            ),
            
            animationView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            animationView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.5
            ),
            
            animationView.heightAnchor.constraint(
                equalTo: animationView.widthAnchor,
                constant: 0.6
            ),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            descriptionLabel.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.7
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 20
            )
        ])
        
        NSLayoutConstraint.activate([
            optionsStackView.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 20
            ),
            
            optionsStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            optionsStackView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.9
            ),
            
            optionsStackView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.2
            )
        ])
    }
    
    // MARK: - Askers functions and delegate
    func createAskers() {
        let bleAsker = BLEPermissionAsker()
        bleAsker.delegate = self
        createPermission(asker: bleAsker)
        
        let homeAsker = HomePermissionAsker()
        homeAsker.delegate = self
        createPermission(asker: homeAsker)
    }
    
    private func updateAskers() {
        permissionAskers.forEach {
            $0.updatePermission()
        }
    }
    
    func presentAlert(_ alert: UIAlertController) {
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func permissionDidChange(_ asker: AEPermissionAsker, to isAllowed: Bool) {
        guard
            let index = permissionAskers.firstIndex(where: { $0.name == asker.name } ),
            let imageView = optionsStackView.arrangedSubviews[index].subviews.filter( { $0 is UIImageView } ).first as? UIImageView
        else { return }
        
        imageView.image = UIImage(named: "purplecheckmark")
        navigateIfPossible()
    }
    
    private func navigateIfPossible() {
        if allPermissionsAllowed() {
            NotificationCenter.default.removeObserver(self)
            self.onAllPermissionsGranted()
        }
    }
    
    private func onAllPermissionsGranted() {
        guard canNavigate else { return }
        canNavigate = false
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "wifiConfig")
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func allPermissionsAllowed() -> Bool { !permissionAskers.map { $0.isAllowed }.contains(false) }
    
    // MARK: - Callbacks
    
    @objc func onOptionTapped(_ sender: UITapGestureRecognizer) {
        guard
            let view = sender.view,
            let index = self.optionsStackView.arrangedSubviews.firstIndex(of: view),
            !permissionAskers[index].isAllowed
        else { return }
        
        permissionAskers[index].ask()
    }
    
    @objc func didBecomeActive() {
        self.updateAskers()
        
        if
            let animationView = self.animationView.subviews.first as? AnimationView {
            animationView.play()
        }
    }
    
    
    
    // MARK: - Options helpers
    private func createPermission(asker: AEPermissionAsker) {
        optionsStackView.addArrangedSubview(getPermissionOption(title: asker.name))
        permissionAskers.append(asker)
    }
    
    private func getPermissionOption(title: String) -> UIView {
        let view: UIView = {
            let view = UIView()
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.borderWidth = 1
            view.layer.borderColor = ColorManager.lighterColor.cgColor
            view.layer.cornerRadius = 8
            
            view.backgroundColor = .clear
            
            return view
        }()
        
        let label: UILabel = {
            let label = UILabel()
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.font = label.font.withSize(16)
            
            return label
        }()
        
        let trailingIcon: UIImageView = {
            let imageView: UIImageView = .init(image: UIImage(systemName: "chevron.right")?.withTintColor(.black))
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .black
            
            return imageView
        }()
        
        view.addSubview(label)
        view.addSubview(trailingIcon)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            
            label.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            
            trailingIcon.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            
            trailingIcon.widthAnchor.constraint(
                equalTo: trailingIcon.heightAnchor
            ),
            
            trailingIcon.heightAnchor.constraint(
                equalTo: label.heightAnchor
            ),
            
            trailingIcon.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            )
            
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onOptionTapped))
        
        view.addGestureRecognizer(gesture)
        
        return view
    }
    
}
