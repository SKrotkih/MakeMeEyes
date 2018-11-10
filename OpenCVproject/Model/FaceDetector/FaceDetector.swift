//
//  ImageViewController.swift
//  FaceVision
//
//  Created by Dragos Andrei Holban on 05/08/2017.
//  Copyright © 2017 IntelligentBee. All rights reserved.
//

import UIKit
import Vision

@objc class FaceDetector: NSObject {
    
    @objc open weak var imageView: UIImageView?
    
    weak var inputImage: UIImage!
    var outputImage: UIImage!
    
    private var cleanFace: UIImage?
    private var face: UIImage?
    private var leftEye: FaceDetail?
    private var rightEye: FaceDetail?
    private var leftCutEye: FaceDetail?
    private var rightCutEye: FaceDetail?
    
    private var faceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var facePins = [CGPoint]()
    
    private var leftEyePins = [CGPoint]()
    private var rightEyePins = [CGPoint]()
    private var leftPupilPins = [CGPoint]()
    private var rightPupilPins = [CGPoint]()
    
    private var scale2: CGFloat = 1.0
    
    @objc func runRecognize(_ _image: UIImage) {
        
        self.inputImage = _image
        self.outputImage = self.imageView?.image
        
        
        var orientation: CGImagePropertyOrientation
        
        // detect image orientation, we need it to be accurate for the face detection to work
        switch inputImage.imageOrientation {
        case .up:
            orientation = .up
        case .right:
            orientation = .right
        case .down:
            orientation = .down
        case .left:
            orientation = .left
        case .downMirrored:
            orientation = .downMirrored
        case .leftMirrored:
            orientation = .leftMirrored
        case .rightMirrored:
            orientation = .rightMirrored
        case .upMirrored:
            orientation = .upMirrored
        }
        
        // vision
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceFeatures)
        let requestHandler = VNImageRequestHandler(cgImage: inputImage.cgImage!, orientation: orientation ,options: [:])
        do {
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            print(error)
        }
    }
    
    private func handleFaceFeatures(request: VNRequest, errror: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type!")
        }
        
        // All Faces
        for face in observations {
            addFaceLandmarksToImage(face)
        }
    }
    
    private func addFaceLandmarksToImage(_ face: VNFaceObservation) {
        UIGraphicsBeginImageContextWithOptions(outputImage.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // draw the image
        let imageWidth = outputImage.size.width
        let imageHeight = outputImage.size.height
        let imageRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        outputImage.draw(in: imageRect)
        
        // draw the face rect
        let faceBound = face.boundingBox
        let w = faceBound.size.width * imageWidth
        let h = faceBound.size.height * imageHeight
        let x = faceBound.origin.x * imageWidth
        let y = faceBound.origin.y * imageHeight
        faceRect = CGRect(x: floor(x), y: floor(y), width: floor(w), height: floor(h))
        
        context?.translateBy(x: 0, y: outputImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.saveGState()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(8.0)
        context?.addRect(faceRect)
        context?.drawPath(using: .stroke)
        context?.restoreGState()
        
        scale2 = outputImage.scale
        
        // face contour
        
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.faceContour {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                facePins.append(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // outer lips
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.outerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // inner lips
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.innerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // left eye
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // right eye
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                 let p2 = putPoint(point)
                 if i == 0 {
                     context?.move(to: p2)
                 } else {
                     context?.addLine(to: p2)
                 }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // left pupil
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // right pupil
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // left eyebrow
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // right eyebrow
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // nose
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.nose {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // nose crest
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.noseCrest {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // median line
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.medianLine {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                let p2 = putPoint(point)
                if i == 0 {
                    context?.move(to: p2)
                } else {
                    context?.addLine(to: p2)
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // get the final image
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end drawing context
        UIGraphicsEndImageContext()
        DispatchQueue.main.async {
            self.imageView?.image = finalImage
        }
    }
    
    private func putPoint(_ point: CGPoint) -> CGPoint {
        let w = faceRect.width
        let h = faceRect.height
        let x = faceRect.minX
        let y = faceRect.minY
        let x0 = x + CGFloat(point.x) * w
        let y0 = y + CGFloat(point.y) * h
        return CGPoint(x: x0, y: y0)
    }
}
