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
    
    private let roiThreshold = 2.0
    private let distanceThreshold = 40.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        startPoint = point
        
        // let date = Date()
        // let interval = touchDate.distance(to: date)
        
        // touchDate = date
        // touchEvents.append((interval: Double(interval), point: point))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        touchPoint = point
        
        // let date = Date()
        // let interval = touchDate.distance(to: date)
        
        // touchDate = date
        // touchEvents.append((interval: Double(interval), point: point))
        
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        drawLine(touch: touch)
    }
    
    //override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    DispatchQueue.main.async {
    //        self.displayRegionOfInterest(
    //            rect: self.getBoundingBox(
    //                pointSequence: self.collectRegionOfInterest()
    //            )
    //        )
    //    }
    //}
    
    func clear() {
        path.removeAllPoints()
        layer.sublayers = nil
        setNeedsDisplay()
    }
    
    private func collectRegionOfInterest() -> [CGPoint] {
        var regionOfInterest = [CGPoint]()
        var previousPoint = touchEvents.reversed()[0].point
        for (interval, point) in touchEvents.reversed() {
            if interval > roiThreshold || distance(point, previousPoint) > distanceThreshold {
                regionOfInterest.append(point)
                break
            }
            regionOfInterest.append(point)
            previousPoint = point
        }
        return regionOfInterest
    }
    
    private func getBoundingBox(pointSequence: [CGPoint]) -> CGRect {
        var xSequence = [CGFloat]()
        var ySequence = [CGFloat]()
        _ = pointSequence.map {point in
            xSequence.append(point.x)
            ySequence.append(point.y)
        }
        
        let xmax = xSequence.max()!
        let xmin = xSequence.min()!
        let ymax = ySequence.max()!
        let ymin = ySequence.min()!
        
        let width = xmax - xmin
        let height = ymax - ymin
        return CGRect(
            x: xmin - 10,
            y: ymin - 10,
            width: width + 20,
            height: height + 20)
    }
    
    private func displayRegionOfInterest(rect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // Yellow
        context.setFillColor(CGColor(srgbRed: 255, green: 217, blue: 0, alpha: 0.3))
        context.fill(rect)
        
        guard let uiImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        image = uiImage

        UIGraphicsEndImageContext()
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
