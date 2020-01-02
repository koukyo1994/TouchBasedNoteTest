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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            drawLine(touch: touch)
        }
    }
    
    private func drawLine(touch: UITouch) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        image?.draw(in: bounds)
        updateContext(context: context, touch: touch)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func updateContext(context: CGContext, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        let width = getLineWidth(touch: touch)
        
        color.setStroke()
        context.setLineWidth(width)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.move(to: previousLocation)
        context.addLine(to: location)
        context.strokePath()
    }
    
    private func getLineWidth(touch: UITouch) -> CGFloat {
        var width = baseSize
        if touch.force > 0 {
            width = width * touch.force
        }
        
        return width
    }
}
