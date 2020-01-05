//
//  ViewController.swift
//  TouchBasedNoteTest
//
//  Created by 荒居秀尚 on 02.01.20.
//  Copyright © 2020 荒居秀尚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let canvasView = CanvasView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.backgroundColor = .white
        canvasView.frame = view.frame
        canvasView.isUserInteractionEnabled = true
        canvasView.clipsToBounds = true
        view.addSubview(canvasView)
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.02))
        let navItem = UINavigationItem(title: "Navigation Area")
        let barButton = UIBarButtonItem(title: "clear", style: .plain, target: self, action: #selector(self.clear))
        navItem.rightBarButtonItem = barButton
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
    }
    
    @objc private func clear(_ sender: UIBarButtonItem) {
        canvasView.clear()
    }
    
}

