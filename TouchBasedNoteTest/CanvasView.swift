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
    private var isWriting = false
    
    private var ruledLineHeight: CGFloat = 30.0
    
    private var touchDate = Date()
    private var lastLoction = CGPoint()
    private var touchEvents = [(interval: Double, distance: Double, point: CGPoint)]()
    
    private let roiThreshold = 0.5
    private let distanceThreshold = 20.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.type == UITouch.TouchType.stylus {
            isWriting = true
            let point = touch.location(in: self)

            let date = Date()
            let interval = touchDate.distance(to: date)
            
            let distanceFromLastLocation = distance(point, lastLoction)
            
            touchDate = date
            lastLoction = point
            touchEvents.append((interval: Double(interval), distance: distanceFromLastLocation, point: point))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.type == UITouch.TouchType.stylus {
            let point = touch.location(in: self)
            drawLine(touch: touch)
            
            let date = Date()
            let interval = touchDate.distance(to: date)
            
            let distanceFromLastLocation = distance(point, lastLoction)
            
            touchDate = date
            lastLoction = point
            touchEvents.append((interval: Double(interval), distance: distanceFromLastLocation, point: point))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.isWriting = false
            if !self.isWriting {
                if let rect = self.getBoundingBox(
                    pointSequence: self.collectRegionOfInterest()) {
                    self.displayRegionOfInterest(rect: rect)
                    if let croppedImage = self.image?.cropRect(rect: rect) {
                        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
                    }
                }
            }
        })
    }
    
    func clear() {
        image = nil
        layer.sublayers = nil
        setNeedsDisplay()
        layoutIfNeeded()
    }
    
    private func collectRegionOfInterest() -> [CGPoint] {
        var regionOfInterest = [CGPoint]()
        for (interval, dist, point) in touchEvents.reversed() {
            if interval > roiThreshold {
                regionOfInterest.append(point)
                if dist > distanceThreshold {
                    break
                }
            }
            regionOfInterest.append(point)
        }
        return regionOfInterest
    }
    
    private func getBoundingBox(pointSequence: [CGPoint]) -> CGRect? {
        if pointSequence.count == 0 {
            return nil
        }
        
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
        // Delete previous ROI
        layer.sublayers = nil
        setNeedsDisplay()
        
        let roiLayer = CAShapeLayer()
        roiLayer.frame = rect

        // Yellow
        roiLayer.fillColor = CGColor(srgbRed: 255, green: 217, blue: 0, alpha: 0.3)
        roiLayer.strokeColor = CGColor(srgbRed: 255, green: 217, blue: 0, alpha: 0.3)
        roiLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)).cgPath

        layer.addSublayer(roiLayer)
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
            width = max(width * (touch.force * 0.6 + 0.2), width)
        }
        
        return width
    }
}
