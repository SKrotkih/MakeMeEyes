//
//  FaceDetailView.swift
//  OpenCVproject
//
//  Created by Сергей Кротких on 06/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

class FaceDetailImageView: UIImageView {
    
    var data: FaceDetail? {
        didSet {
            self.image = data?.image
        }
    }
    
    func drawEye() {
        guard let currImage = self.data?.image else {
            return
        }
        guard let pupils = data?.pupils,
            let polyLine = data?.polyLine, polyLine.count > 2 else {
            return
        }
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(currImage.size)
        
        // Draw the starting image in the current context as background
        currImage.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.yellow.cgColor)
        
        // Eye
        for i in 0..<polyLine.count {
            let point = polyLine[i]
            if i == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
        }
        context.addLine(to: polyLine[0])
        
        // Pupil
        for i in 0..<pupils.count {
            let point = pupils[i]
            if i == 0 {
                context.addEllipse(in: CGRect(x: point.x - 5.0, y: point.y - 5.0, width: 10.0, height: 10.0))
            } else {
                context.addLine(to: point)
            }
        }

        context.strokePath()
        context.drawPath(using: .stroke)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
    }

    func cutEye() {
        guard let currImage = self.data?.image else {
            return
        }
        guard let pupils = data?.pupils,
            let polyLine = data?.polyLine, polyLine.count > 2 else {
                return
        }
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(currImage.size)
        
        // Draw the starting image in the current context as background
        currImage.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.yellow.cgColor)
        
        // Eye
        for i in 0..<polyLine.count {
            let point = polyLine[i]
            if i == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
        }
        // Cut eye
        context.addLine(to: polyLine[0])
        context.setFillColor(UIColor.white.cgColor)
        context.fillPath()
        
        // Draw pupil
        for i in 0..<pupils.count {
            let point = pupils[i]
            if i == 0 {
                context.addEllipse(in: CGRect(x: point.x - 6.0, y: point.y - 6.0, width: 12.0, height: 12.0))
                context.setFillColor(UIColor.blue.cgColor)
                context.fillPath()

                context.addEllipse(in: CGRect(x: point.x - 2.0, y: point.y - 2.0, width: 4.0, height: 4.0))
                context.setFillColor(UIColor.black.cgColor)
                context.fillPath()
            } else {
                context.addLine(to: point)
            }
        }

        context.strokePath()
        context.drawPath(using: .stroke)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
    }

    func drawEyesIris() {
        
//        self.image = self.data?.face
        
        guard let cropedFaceImage = self.data?.face else {
            return
        }
        self.image = OpenCVWrapper.detectEyeIris(cropedFaceImage)
    }
}

