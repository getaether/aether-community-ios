//
//  LojaViewController.swift
//  Aether
//
//  Created by Gabriel Gazal on 01/09/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class LojaViewController: UIViewController {
    typealias strings = AEStrings.LojaViewController
    let paging = UIPageControl()
    var index = 0
    let imagem = UIImageView()
    let imagens = ["ilustra1","lampadinha","ilustra1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpScreen(){
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
        backgroundView.backgroundColor = ColorManager.backgroundColor
        
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
        ])
        
        var titulo = UILabel()
        titulo.translatesAutoresizingMaskIntoConstraints = false
        let descricao = BodyTextLabel()
        descricao.translatesAutoresizingMaskIntoConstraints = false
        descricao.numberOfLines = 0
        
        descricao.text = strings.Label.description
        
        self.view.addSubview(titulo)
        self.view.addSubview(descricao)
        titulo.attributedText = setUpTitle()
        
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.backgroundColor = ColorManager.backgroundColor
        self.view.addSubview(itemView)
        setUpView(view: itemView)
        
        let buyButton = UIButton()
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buyButton)
        setUpButton(button: buyButton)
        
        NSLayoutConstraint.activate([
            titulo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titulo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            titulo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 95),
            titulo.heightAnchor.constraint(equalToConstant: 30),
            
            descricao.leadingAnchor.constraint(equalTo: titulo.leadingAnchor),
            descricao.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.78),
            descricao.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 15),
            descricao.heightAnchor.constraint(equalTo: titulo.heightAnchor, multiplier: 4),
            
            itemView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            itemView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            itemView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            itemView.topAnchor.constraint(equalTo: descricao.bottomAnchor, constant: 15),
            
            buyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buyButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            buyButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07),
            buyButton.topAnchor.constraint(equalTo: itemView.bottomAnchor, constant: 15),
        ])
        
        
        let stackPages = UIStackView()
        stackPages.translatesAutoresizingMaskIntoConstraints = false
        stackPages.axis = .vertical
        stackPages.distribution = .fillProportionally
        itemView.addSubview(stackPages)
        
        let collectionBackground = UIView()
        collectionBackground.translatesAutoresizingMaskIntoConstraints = false
        collectionBackground.backgroundColor = .clear
        stackPages.addArrangedSubview(collectionBackground)
        
        let descriptionView = UIView()
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.backgroundColor = .clear
        stackPages.addArrangedSubview(descriptionView)
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.75)
        itemView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            stackPages.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            stackPages.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            stackPages.widthAnchor.constraint(equalTo: itemView.widthAnchor),
            stackPages.heightAnchor.constraint(equalTo: itemView.heightAnchor),
            
            collectionBackground.centerXAnchor.constraint(equalTo: stackPages.centerXAnchor),
            collectionBackground.widthAnchor.constraint(equalTo: stackPages.widthAnchor),
            collectionBackground.topAnchor.constraint(equalTo: stackPages.topAnchor),
            collectionBackground.heightAnchor.constraint(equalTo: stackPages.heightAnchor, multiplier: 0.5),
            
            
            descriptionView.centerXAnchor.constraint(equalTo: stackPages.centerXAnchor),
            descriptionView.widthAnchor.constraint(equalTo: stackPages.widthAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: stackPages.bottomAnchor),
            descriptionView.heightAnchor.constraint(equalTo: stackPages.heightAnchor, multiplier: 0.5),
            
            separator.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            separator.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            separator.widthAnchor.constraint(equalTo: itemView.widthAnchor, multiplier: 0.9),
            separator.heightAnchor.constraint(equalToConstant: 2),
        ])
        
        
        //Configurar a collection
        
        
        
        let nomeLabel = UILabel()
        let descriptionLabel = BodyTextLabel()
        let precoLabel = UILabel()
        
        nomeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        precoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionView.addSubview(nomeLabel)
        descriptionView.addSubview(descriptionLabel)
        descriptionView.addSubview(precoLabel)
        
        nomeLabel.text = strings.Label.productName
        nomeLabel.font = UIFont.boldSystemFont(ofSize: 35)
        nomeLabel.textColor = ColorManager.titleTextColor
        
        descriptionLabel.text = strings.Label.productDescription
        descriptionLabel.numberOfLines = 0
        
        precoLabel.text = strings.Label.productPrice
        precoLabel.font = UIFont.boldSystemFont(ofSize: 35)
        precoLabel.textColor = ColorManager.highlightColor
        
        NSLayoutConstraint.activate([
            nomeLabel.widthAnchor.constraint(equalTo: descriptionView.widthAnchor, multiplier: 0.55),
            nomeLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 25),
            nomeLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 40),
            nomeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.widthAnchor.constraint(equalTo: descriptionView.widthAnchor, multiplier: 0.55),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 25),
            descriptionLabel.centerYAnchor.constraint(equalTo: descriptionView.centerYAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 60),
            
            precoLabel.widthAnchor.constraint(equalTo: descriptionView.widthAnchor, multiplier: 0.55),
            precoLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 25),
            precoLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -40),
            precoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            
        ])
        
        let pageView = UIView()
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.backgroundColor = .clear
        collectionBackground.addSubview(pageView)
        
        NSLayoutConstraint.activate([
            pageView.centerXAnchor.constraint(equalTo: collectionBackground.centerXAnchor),
            pageView.centerYAnchor.constraint(equalTo: collectionBackground.centerYAnchor),
            pageView.heightAnchor.constraint(equalTo: collectionBackground.heightAnchor, multiplier: 0.9),
            pageView.widthAnchor.constraint(equalTo: pageView.heightAnchor),
        ])
        
        
        let nPaginas = imagens.count
        
        imagem.image = UIImage(named: imagens[index])
        paging.numberOfPages = nPaginas
        paging.currentPageIndicatorTintColor = ColorManager.highlightColor
        paging.pageIndicatorTintColor = ColorManager.bodyTextColor
        pageView.addSubview(imagem)
        imagem.translatesAutoresizingMaskIntoConstraints = false
        paging.translatesAutoresizingMaskIntoConstraints = false
        imagem.backgroundColor = .clear
        imagem.contentMode = .scaleAspectFit
        pageView.addSubview(paging)
        NSLayoutConstraint.activate([
            imagem.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            imagem.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 0.8),
            imagem.heightAnchor.constraint(equalTo: imagem.widthAnchor),
            imagem.topAnchor.constraint(equalTo: pageView.topAnchor),
            
            paging.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            paging.bottomAnchor.constraint(equalTo: pageView.bottomAnchor),
            paging.heightAnchor.constraint(equalTo: pageView.heightAnchor, multiplier: 0.2)
        ])
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        pageView.addGestureRecognizer(swipeLeft)
        pageView.addGestureRecognizer(swipeRight)
        
        buyButton.addTarget(self, action: #selector(comprou), for: .touchDown)
    }
    func setUpTitle() -> NSAttributedString{
        let navTitle = NSMutableAttributedString(string: "Aether ", attributes:[
                                                    NSAttributedString.Key.foregroundColor: ColorManager.titleTextColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 35)])
        
        navTitle.append(NSMutableAttributedString(string: strings.Label.productName, attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 35),
                                                    NSAttributedString.Key.foregroundColor: ColorManager.highlightColor]))
        
        
        return navTitle
    }
    func setUpView(view: UIView){
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 1, height: 3)
        view.layer.shadowOpacity = 0.2
    }
    func setUpButton(button: UIButton){
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.masksToBounds = true
        button.setTitle(
            strings.Button.buyNow,
            for: .normal
        )
        button.setTitleColor(
            ColorManager.backgroundColor,
            for: .normal
        )
        button.layer.cornerRadius = (self.view.frame.height * 0.07) / 2
        button.backgroundColor = ColorManager.titleTextColor
    }
    
    func comprouAlertView(){
        let alert = UIAlertController(
            title: AEStrings.Alert.Unavailable.title,
            message: AEStrings.Alert.Unavailable.message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: AEStrings.Alert.Unavailable.Action.ok,
                style: .default) {action in
            print("apagou o bichin")
        })
        
        self.present(alert, animated: true)
    }
    
    @objc func swipeL(){
        if paging.currentPage <= 2{
            paging.currentPage += 1
            imagem.image = UIImage(named: imagens[paging.currentPage])
            
        }
    }
    
    @objc func swipeR(){
        if paging.currentPage >= 0 {
            paging.currentPage -= 1
            imagem.image = UIImage(named: imagens[paging.currentPage])

        }
    }
    
    @objc func comprou(){
        comprouAlertView()
    }
    
}
