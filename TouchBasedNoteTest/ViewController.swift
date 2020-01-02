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
    }
    
}

