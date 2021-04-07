//
//  EyesDrawingView.swift
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 20/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

import UIKit

@objc class EyesDrawingView: UIView {
    @objc var imageView: UIImageView!
    
    var isEnable = true
    
    private var irisImage: UIImage?
    private var needEyesDrawing: Bool = true
    
    private var leftEyeBorderX: [Int]?
    private var leftEyeBorderY: [Int]?
    private var rightEyeBorderX: [Int]?
    private var rightEyeBorderY: [Int]?
    private var leftIrisBorderX: [Int]?
    private var leftIrisBorderY: [Int]?
    private var rightIrisBorderX: [Int]?
    private var rightIrisBorderY: [Int]?
    private var leftPupilBorderX: [Int]?
    private var leftPupilBorderY: [Int]?
    private var rightPupilBorderX: [Int]?
    private var rightPupilBorderY: [Int]?
    
    @objc func drawEyes() {
        let irisImageName = OpenCVWrapper.irisImageName()
        
        if irisImageName.count > 0 {
            irisImage = UIImage(named: irisImageName)
        } else {
            irisImage = nil
        }
        
        needEyesDrawing = OpenCVWrapper.needEyesDrawing()
        
        self.leftEyeBorderX = OpenCVWrapper.leftEyeBorder()[0] as? [Int];
        self.leftEyeBorderY = OpenCVWrapper.leftEyeBorder()[1] as? [Int];
        self.rightEyeBorderX = OpenCVWrapper.rightEyeBorder()[0] as? [Int];
        self.rightEyeBorderY = OpenCVWrapper.rightEyeBorder()[1] as? [Int];
        
        self.leftIrisBorderX = OpenCVWrapper.leftIrisBorder()[0] as? [Int];
        self.leftIrisBorderY = OpenCVWrapper.leftIrisBorder()[1] as? [Int];
        self.rightIrisBorderX = OpenCVWrapper.rightIrisBorder()[0] as? [Int];
        self.rightIrisBorderY = OpenCVWrapper.rightIrisBorder()[1] as? [Int];
        
        self.leftPupilBorderX = OpenCVWrapper.leftPupilBorder()[0] as? [Int];
        self.leftPupilBorderY = OpenCVWrapper.leftPupilBorder()[1] as? [Int];
        self.rightPupilBorderX = OpenCVWrapper.rightPupilBorder()[0] as? [Int];
        self.rightPupilBorderY = OpenCVWrapper.rightPupilBorder()[1] as? [Int];
        
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
        guard needEyesDrawing, isEnable, ((leftEyeBorderX?.count ?? 0) + (leftIrisBorderX?.count ?? 0)) > 0  else {
            return
        }
        let scale: CGFloat = self.frame.width / CGFloat(OpenCVWrapper.frameWidth());
        let path = UIBezierPath()
        
        // Draw Eye Borders
        let eyeballColor = UIColor(named: "eyeball")!
        drawPoly(path, scale, leftEyeBorderX, leftEyeBorderY, eyeballColor)
        drawPoly(path, scale, rightEyeBorderX, rightEyeBorderY, eyeballColor)
        
        // Draw Irises
        drawOval(scale, leftIrisBorderX, leftIrisBorderY, UIColor.blue, irisImage)
        drawOval(scale, rightIrisBorderX, rightIrisBorderY, UIColor.blue, irisImage)
        
        // Draw Pupils
        if irisImage == nil {
            drawOval(scale, leftPupilBorderX, leftPupilBorderY, UIColor.black, nil)
            drawOval(scale, rightPupilBorderX, rightPupilBorderY, UIColor.black, nil)
        }
        
        maskEye(scale, leftEyeBorderX, leftEyeBorderY, rightEyeBorderX, rightEyeBorderY)
        OpenCVWrapper.didDrawFinish()
    }
}

// MARK: -

extension EyesDrawingView {
    
    private func drawPoly(_ _path: UIBezierPath, _ _scale: CGFloat, _ _arrX: [Int]?, _ _arrY: [Int]?, _ color: UIColor) {
        guard let arrX = _arrX, let arrY = _arrY else {
            return
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setShouldAntialias(true);
        context.setAllowsAntialiasing(true);
        context.interpolationQuality = .high;
        
        let point0 = self.point(_scale, arrX[0], arrY[0])
        _path.move(to: point0)
        var i = 3
        while i < arrX.count {
            let point1 = self.point(_scale, arrX[i - 2], arrY[i - 2])
            let point2 = self.point(_scale, arrX[i - 1], arrY[i - 1])
            let point3 = self.point(_scale, arrX[i],     arrY[i])
            _path.addCurve(to: point3, controlPoint1: point1, controlPoint2: point2)
            i += 1
        }
        _path.close()
        color.setFill()
        _path.fill()
    }
    
    private func maskEye(_ _scale: CGFloat, _ _arr1X: [Int]?, _ _arr1Y: [Int]?, _ _arr2X: [Int]?, _ _arr2Y: [Int]?) {
        let path = UIBezierPath()
        drawPoly(path, _scale, _arr1X, _arr1Y, UIColor.clear)
        drawPoly(path, _scale, _arr2X, _arr2Y, UIColor.clear)
        let mask           = CAShapeLayer()
        mask.path          = path.cgPath
        layer.mask         = mask
    }
    
    private func drawOval(_ _scale: CGFloat, _ _arrX: [Int]?, _ _arrY: [Int]?, _ color: UIColor, _ image: UIImage?) {
        guard let rect = makeRect(_scale, _arrX, _arrY) else {
            return
        }
        if image == nil {
            let path = UIBezierPath(ovalIn: rect)
            color.setFill()
            path.fill()
        } else {
            image!.draw(in: rect)
        }
    }
    
    private func point(_ _scale: CGFloat, _ _x: Any, _ _y: Any) -> CGPoint {
        let x = CGFloat(_scale * CGFloat(_x as! Int))
        let y = CGFloat(_scale * CGFloat(_y as! Int))
        return CGPoint(x: x, y: y)
    }
    
    private func makeRect(_ _scale: CGFloat, _ _arrX: [Int]?, _ _arrY: [Int]?) -> CGRect? {
        guard let arrX = _arrX, let arrY = _arrY else {
            return nil
        }
        let xMax = CGFloat(_scale * CGFloat(arrX.reduce(Int.min, { max($0, $1) })))
        let xMin = CGFloat(_scale * CGFloat(arrX.reduce(Int.max, { min($0, $1) })))
        let yMax = CGFloat(_scale * CGFloat(arrY.reduce(Int.min, { max($0, $1) })))
        let yMin = CGFloat(_scale * CGFloat(arrY.reduce(Int.max, { min($0, $1) })))
        let vRadius = yMax - yMin
        let hRadius = xMax - xMin
        let rect = CGRect(x: xMin, y: yMin, width: hRadius, height: vRadius)
        return rect
    }
}

