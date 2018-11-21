//
//  FaceView.swift
//  MasterFace
//
//  Created by Сергей Кротких on 20/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

@objc class FaceView: UIView {
    @objc var imageView: UIImageView!
    private var scale: Double = 0
    private var leftEyeBorderX: [Any]?
    private var leftEyeBorderY: [Any]?
    private var rightEyeBorderX: [Any]?
    private var rightEyeBorderY: [Any]?

    @objc func drawFaceWithScale(scale: Double) {
        self.scale = scale
        self.leftEyeBorderX = OpenCVWrapper.leftEyeBorder()[0] as? [Any];
        self.leftEyeBorderY = OpenCVWrapper.leftEyeBorder()[1] as? [Any];
        self.rightEyeBorderX = OpenCVWrapper.rightEyeBorder()[0] as? [Any];
        self.rightEyeBorderY = OpenCVWrapper.rightEyeBorder()[1] as? [Any];
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.clear(rect);
        
        drawPoly(leftEyeBorderX, leftEyeBorderY)
        drawPoly(rightEyeBorderX, rightEyeBorderY)
        OpenCVWrapper.didDrawFinish()
    }
}

// MARK: -

extension FaceView {
    
    private func drawPoly(_ _arrX: [Any]?, _ _arrY: [Any]?) {
        guard let arrX = _arrX, let arrY = _arrY else {
            return
        }
        let path = UIBezierPath()
        for i in 0..<arrX.count {
            let x = arrX[i]
            let y = arrY[i]
            if i == 0 {
                path.move(to: self.point(scale, x, y))
            } else {
                path.addLine(to: self.point(scale, x, y))
            }
        }
        path.close()
        UIColor.orange.setFill()
        path.fill()
    }
    
    private func point(_ scale: Double, _ _x: Any, _ _y: Any) -> CGPoint {
        let x = CGFloat(scale * Double(_x as! Int))
        let y = CGFloat(scale * Double(_y as! Int))
        return CGPoint(x: x, y: y)
    }
}
