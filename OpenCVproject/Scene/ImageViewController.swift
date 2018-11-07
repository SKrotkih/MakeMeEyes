//
//  ImageViewController.swift
//  FaceVision
//
//  Created by Dragos Andrei Holban on 05/08/2017.
//  Copyright © 2017 IntelligentBee. All rights reserved.
//

import UIKit
import Vision

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!

    var face: UIImage?
    var leftEye: FaceDetail?
    var rightEye: FaceDetail?
    var leftCutEye: FaceDetail?
    var rightCutEye: FaceDetail?
    
    var faceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var facePins = [CGPoint]()

    var leftEyePins = [CGPoint]()
    var rightEyePins = [CGPoint]()
    var leftPupilPins = [CGPoint]()
    var rightPupilPins = [CGPoint]()
    
    var scale2: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
        process()
    }
    
    @IBAction func tapOnImage(_ sender: Any) {
        performSegue(withIdentifier: "faceSequence", sender: self)
    }
    
    private func process() {
        var orientation: CGImagePropertyOrientation
        
        // detect image orientation, we need it to be accurate for the face detection to work
        switch image.imageOrientation {
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
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: orientation ,options: [:])
        do {
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            print(error)
        }
    }
    
    func handleFaceFeatures(request: VNRequest, errror: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type!")
        }
        
        // All Faces
        for face in observations {
            addFaceLandmarksToImage(face)
        }
    }
    
    func addFaceLandmarksToImage(_ face: VNFaceObservation) {
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // draw the image
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let imageRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        image.draw(in: imageRect)
        
        // draw the face rect
        let faceBound = face.boundingBox
        let w = faceBound.size.width * imageWidth
        let h = faceBound.size.height * imageHeight
        let x = faceBound.origin.x * imageWidth
        let y = faceBound.origin.y * imageHeight
        faceRect = CGRect(x: floor(x), y: floor(y), width: floor(w), height: floor(h))
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.saveGState()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(8.0)
        context?.addRect(faceRect)
        context?.drawPath(using: .stroke)
        context?.restoreGState()

        scale2 = image.scale
        
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
                leftEyePins.append(point)
                //let p2 = putPoint(point)
                //                if i == 0 {
                //                    context?.move(to: p2)
                //                } else {
                //                    context?.addLine(to: p2)
                //                }
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
                rightEyePins.append(point)
                
                // let p2 = putPoint(point)
                // if i == 0 {
                //     context?.move(to: p2)
                // } else {
                //     context?.addLine(to: p2)
                // }
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
                leftPupilPins.append(point)

//                let p2 = putPoint(point)
//                if i == 0 {
//                    context?.move(to: p2)
//                } else {
//                    context?.addLine(to: p2)
//                }
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
                rightPupilPins.append(point)

//                let p2 = putPoint(point)
//                if i == 0 {
//                    context?.move(to: p2)
//                } else {
//                    context?.addLine(to: p2)
//                }
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
        imageView.image = finalImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "faceSequence" {
            if let faceViewController = segue.destination as? FaceViewController {
                cropComponents()
                faceViewController.face = face
                faceViewController.leftEye = leftEye
                faceViewController.rightEye = rightEye
                faceViewController.leftCutEye = leftCutEye
                faceViewController.rightCutEye = rightCutEye
            }
        }
    }

    private func cropComponents() {
        let image = imageView.image!

        var rect = faceRect
        rect.origin.y = image.size.height - (rect.origin.y + rect.size.height)
        rect.origin.x *= image.scale
        rect.origin.y *= image.scale
        rect.size.width *= image.scale
        rect.size.height *= image.scale

        face = image.crop(area: rect)
        leftEye = crop(image, pins: leftEyePins, pupils: leftPupilPins)
        rightEye = crop(image, pins: rightEyePins, pupils: rightPupilPins)
        leftCutEye = crop(image, pins: leftEyePins, pupils: leftPupilPins)
        rightCutEye = crop(image, pins: rightEyePins, pupils: rightPupilPins)
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
    
    private func crop(_ image: UIImage, pins: [CGPoint], pupils: [CGPoint]) -> FaceDetail? {
        let w = faceRect.width
        let h = faceRect.height
        let x = faceRect.minX
        let y = faceRect.minY
        
        var xMin: CGFloat = 100000000.0
        var xMax: CGFloat = 0.0
        var yMin: CGFloat = 100000000.0
        var yMax: CGFloat = 0.0
        
        var pts = [CGPoint]()
        pins.forEach { (point) in
            var x0 = point.x
            var y0 = point.y
            x0 = x + x0 * w
            y0 = y + y0 * h
            pts.append(CGPoint(x: x0, y: y0))
            xMin = min(x0, xMin)
            xMax = max(x0, xMax)
            yMin = min(y0, yMin)
            yMax = max(y0, yMax)
        }
        var rect = CGRect(x: xMin, y: yMin, width: xMax - xMin, height: yMax - yMin)
        
        rect.origin.y = image.size.height - (rect.origin.y + rect.size.height)
        rect.origin.x *= image.scale
        rect.origin.y *= image.scale
        rect.size.width *= image.scale
        rect.size.height *= image.scale
        
        if let cropedImage = image.crop(area: rect) {
            
            print("\(cropedImage)")
            
            let imageHeight = cropedImage.size.height
            let polyLine: [CGPoint] = pts.map { (point) -> CGPoint in
                let x = point.x - xMin
                let y = point.y - yMin
                return CGPoint(x: x, y: imageHeight - y)
            }
            
            var pts = [CGPoint]()
            pupils.forEach { (point) in
                var x0 = point.x
                var y0 = point.y
                x0 = x + x0 * w
                y0 = y + y0 * h
                pts.append(CGPoint(x: x0, y: y0))
            }
            let pupilsPolyLine: [CGPoint] = pts.map { (point) -> CGPoint in
                let x = point.x - xMin
                let y = point.y - yMin
                return CGPoint(x: x, y: imageHeight - y)
            }
            return FaceDetail(image: cropedImage, polyLine: polyLine, pupils: pupilsPolyLine)
        } else {
            return nil
        }
    }
}
