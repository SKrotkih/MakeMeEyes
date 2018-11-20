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
    private var arrX: [Any]?
    private var arrY: [Any]?
    
    @objc func drawFaceWithScale(scale: Double) {
        self.scale = scale
        guard let _arrX = OpenCVWrapper.eyeBorder()[0] as? [Any] else {
            return
        }
        guard let _arrY = OpenCVWrapper.eyeBorder()[1] as? [Any] else {
            return
        }
        let size = _arrX.count
        guard size > 0 else {
            return
        }
        print(size)
        self.arrX = _arrX;
        self.arrY = _arrY;
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    func point(_ scale: Double, _ _x: Any, _ _y: Any) -> CGPoint {
        let x = CGFloat(scale * Double(_x as! Int))
        let y = CGFloat(scale * Double(_y as! Int))
        return CGPoint(x: x, y: y)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let arrX = self.arrX, let arrY = self.arrY else {
            return
        }
        let path = UIBezierPath()
        path.move(to: self.point(scale, arrX[0], arrY[0]))
        for i in 1..<arrX.count {
            path.addLine(to: self.point(scale, arrX[i], arrY[i]))
        }
        path.close()
        UIColor.orange.setFill()
        path.fill()
    }
}
