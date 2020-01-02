//
//  CanvasView.swift
//  TouchBasedNoteTest
//
//  Created by 荒居秀尚 on 02.01.20.
//  Copyright © 2020 荒居秀尚. All rights reserved.
//

import UIKit


class CanvasView: UIImageView {
    private let baseSize: CGFloat = 5.0
    private var color: UIColor = .black
    
    public var path = UIBezierPath()
    private var startPoint = CGPoint()
    private var touchPoint = CGPoint()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        startPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchPoint = touch.location(in: self)
        
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        drawLine(touch: touch)
    }
    
    func clear() {
        path.removeAllPoints()
        layer.sublayers = nil
        setNeedsDisplay()
    }
    
    private func drawLine(touch: UITouch) {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = getLineWidth(touch: touch)
        strokeLayer.strokeColor = color.cgColor
        strokeLayer.path = path.cgPath
        self.layer.addSublayer(strokeLayer)
    }
    
    private func getLineWidth(touch: UITouch) -> CGFloat {
        var width = baseSize
        if touch.force > 0 {
            width = width * touch.force
        }
        
        return width
    }
}
