//
//  UIImage+Extension.swift
//  TouchBasedNoteTest
//
//  Created by 荒居秀尚 on 05.01.20.
//  Copyright © 2020 荒居秀尚. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func cropRect(rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        guard let croppedImage = cgImage.cropping(to: CGRect(x: rect.minX * scale, y: rect.minY * scale, width: rect.width * scale, height: rect.height * scale)) else {
            return nil
        }
        
        return UIImage(cgImage: croppedImage, scale: scale, orientation: imageOrientation)
    }
}
