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
    private var scale: CGFloat = 0.0
    private var leftEyeBorderX: [Any]?
    private var leftEyeBorderY: [Any]?
    private var rightEyeBorderX: [Any]?
    private var rightEyeBorderY: [Any]?
    private var leftIrisBorderX: [Any]?
    private var leftIrisBorderY: [Any]?
    private var rightIrisBorderX: [Any]?
    private var rightIrisBorderY: [Any]?
    private var leftPupilBorderX: [Any]?
    private var leftPupilBorderY: [Any]?
    private var rightPupilBorderX: [Any]?
    private var rightPupilBorderY: [Any]?

    @objc func drawFaceWithScale(scale: CGFloat) {
        self.scale = scale
        self.leftEyeBorderX = OpenCVWrapper.leftEyeBorder()[0] as? [Any];
        self.leftEyeBorderY = OpenCVWrapper.leftEyeBorder()[1] as? [Any];
        self.rightEyeBorderX = OpenCVWrapper.rightEyeBorder()[0] as? [Any];
        self.rightEyeBorderY = OpenCVWrapper.rightEyeBorder()[1] as? [Any];

        self.leftIrisBorderX = OpenCVWrapper.leftIrisBorder()[0] as? [Any];
        self.leftIrisBorderY = OpenCVWrapper.leftIrisBorder()[1] as? [Any];
        self.rightIrisBorderX = OpenCVWrapper.rightIrisBorder()[0] as? [Any];
        self.rightIrisBorderY = OpenCVWrapper.rightIrisBorder()[1] as? [Any];
        
        self.leftPupilBorderX = OpenCVWrapper.leftPupilBorder()[0] as? [Any];
        self.leftPupilBorderY = OpenCVWrapper.leftPupilBorder()[1] as? [Any];
        self.rightPupilBorderX = OpenCVWrapper.rightPupilBorder()[0] as? [Any];
        self.rightPupilBorderY = OpenCVWrapper.rightPupilBorder()[1] as? [Any];
        
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
        
        if ((leftEyeBorderX?.count ?? 0) + (leftIrisBorderX?.count ?? 0)) > 0 {
            drawPoly(leftEyeBorderX, leftEyeBorderY, UIColor.red)
            drawPoly(rightEyeBorderX, rightEyeBorderY, UIColor.red)
            drawPoly(leftIrisBorderX, leftIrisBorderY, UIColor.green)
            drawPoly(rightIrisBorderX, rightIrisBorderY, UIColor.green)
            drawPoly(leftPupilBorderX, leftPupilBorderY, UIColor.black)
            drawPoly(rightPupilBorderX, rightPupilBorderY, UIColor.black)

            OpenCVWrapper.didDrawFinish()
        }
    }
}

// MARK: -

extension FaceView {
    
    private func drawPoly(_ _arrX: [Any]?, _ _arrY: [Any]?, _ color: UIColor) {
        guard let arrX = _arrX, let arrY = _arrY else {
            return
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setShouldAntialias(true);
        context.setAllowsAntialiasing(true);
        context.interpolationQuality = .high;
        let path = UIBezierPath()
        let point0 = self.point(arrX[0], arrY[0])
        path.move(to: point0)
        var i = 3
        while i < arrX.count {
            let point1 = self.point(arrX[i - 2], arrY[i - 2])
            let point2 = self.point(arrX[i - 1], arrY[i - 1])
            let point3 = self.point(arrX[i],     arrY[i])
            path.addCurve(to: point3, controlPoint1: point1, controlPoint2: point2)
            i += 1
        }
        path.close()
        color.setFill()
        path.fill()
    }

    private func drawPoly2(_ _arrX: [Any]?, _ _arrY: [Any]?, _ color: UIColor) {
        guard let arrX = _arrX, let arrY = _arrY else {
            return
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setShouldAntialias(true);
        context.setAllowsAntialiasing(true);
        context.interpolationQuality = .high;
        
        let path = UIBezierPath()
        for i in 0..<arrX.count {
            let point = self.point(arrX[i], arrY[i])
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        color.setFill()
        path.fill()
    }

    
    private func point(_ _x: Any, _ _y: Any) -> CGPoint {
        let x = CGFloat(scale * CGFloat(_x as! Int))
        let y = CGFloat(scale * CGFloat(_y as! Int))
        return CGPoint(x: x, y: y)
    }
}
