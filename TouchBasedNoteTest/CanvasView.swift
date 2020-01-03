//
//  CanvasView.swift
//  TouchBasedNoteTest
//
//  Created by 荒居秀尚 on 02.01.20.
//  Copyright © 2020 荒居秀尚. All rights reserved.
//

import UIKit
import Foundation

class CanvasView: UIImageView {
    private let baseSize: CGFloat = 5.0
    private var color: UIColor = .black
    
    public var path = UIBezierPath()
    private var startPoint = CGPoint()
    private var touchPoint = CGPoint()
    
    private var touchDate = Date()
    private var touchEvents = [(interval: Double, point: CGPoint)]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        startPoint = point
        
        let date = Date()
        let interval = touchDate.distance(to: date)
        
        touchDate = date
        touchEvents.append((interval: Double(interval), point: point))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        touchPoint = point
        
        let date = Date()
        let interval = touchDate.distance(to: date)
        
        touchDate = date
        touchEvents.append((interval: Double(interval), point: point))
        
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        drawLine(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
        //    print(Date())
        // })
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
