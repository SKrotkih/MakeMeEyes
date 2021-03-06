//
//  SceneInteractor.swift
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 12/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

import UIKit
import SceneKit

@objc final class SceneInteractor: NSObject {

    enum Constants {
        static let maskWinterHat = "SceneKit.scnassets/Winter_Hat/WinterHat.scn"
        static let winterHatChildNodeFilter = "Fur_hat_Plane"
    }
    
    private var _parentView: UIView!
    private var _sceneView: SCNView?
    private var _scnScene: SCNScene!
    private var _cameraNode: SCNNode!
    
    private var maskaNode: SCNNode!
    
    init(parentView: UIView) {
        _parentView = parentView
    }
    
    func showMask() {
        if _sceneView == nil {
            createScene()
            setupScene(maskName: Constants.maskWinterHat)
        } else {
            hideMask()
        }
    }

    func hideMask() {
        _sceneView?.removeFromSuperview()
        _sceneView = nil
    }
    
    private func createScene() {
        _sceneView = SCNView(frame: _parentView.bounds)
        _sceneView!.allowsCameraControl = false
        _sceneView!.showsStatistics = true
        _sceneView!.backgroundColor = UIColor.clear
        _sceneView!.isUserInteractionEnabled = true
        
        _sceneView!.showsStatistics = true
        _sceneView!.allowsCameraControl = true
        _sceneView!.autoenablesDefaultLighting = true
        
        _parentView.addSubview(_sceneView!)
    }
    
    private func setupScene(maskName: String) {
        _scnScene = SCNScene(named: maskName)
        _sceneView?.scene = _scnScene
        
        _scnScene.rootNode.childNodes.forEach({ print("NAME=\(String(describing: $0.name))") })

        if let node = _scnScene.rootNode.childNodes.filter({ $0.name == Constants.winterHatChildNodeFilter }).first {
            let currScale = node.scale
            // 5.231
            let scale = SCNVector3Make(currScale.x * 0.65, currScale.y * 0.65, currScale.z * 0.65)
            node.scale = scale
            self.maskaNode = node
        }
    }
    
    private func setupCamera() {
        _cameraNode = SCNNode()
        _cameraNode.camera = SCNCamera()
        _cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        _scnScene.rootNode.addChildNode(_cameraNode)
    }
    
    // Public func: handle did update pupil coordinate event
    @objc func drawSceneWithScale(_ scale: CGFloat) {
        guard let sceneView = _sceneView,
            let maskaNode = self.maskaNode else {
            return
        }

        if let face = OpenCVWrapper.face()[0] as? [Int]  {
            print(face)
        }
        
        guard let leftPupilBorderX = OpenCVWrapper.face()[0] as? [Int],
            let leftPupilBorderY = OpenCVWrapper.leftPupilBorder()[1] as? [Int],
            let rightPupilBorderX = OpenCVWrapper.rightPupilBorder()[0] as? [Int],
            let rightPupilBorderY = OpenCVWrapper.rightPupilBorder()[1] as? [Int] else {
                return
        }
        guard let leftEyeCenter = getCenter(scale, leftPupilBorderX, leftPupilBorderY),
            let rightEyeCenter = getCenter(scale, rightPupilBorderX, rightPupilBorderY) else {
                return
        }

        let xCenter: CGFloat = rightEyeCenter.x + 45.0
        let yCenter: CGFloat = leftEyeCenter.y - 220.0
        
        let maskaPosition: SCNVector3 = CGPointToSCNVector3(view: sceneView, depth: maskaNode.position.z, point: CGPoint(x: xCenter, y: yCenter))
        maskaNode.position = maskaPosition
    }

    private func getCenter(_ scale: CGFloat, _ _arrX: [Int]?, _ _arrY: [Int]?) -> CGPoint? {
        guard let arrX = _arrX, let arrY = _arrY else {
            return nil
        }
        let xMax = CGFloat(scale * CGFloat(arrX.reduce(Int.min, { max($0, $1) })))
        let xMin = CGFloat(scale * CGFloat(arrX.reduce(Int.max, { min($0, $1) })))
        let yMax = CGFloat(scale * CGFloat(arrY.reduce(Int.min, { max($0, $1) })))
        let yMin = CGFloat(scale * CGFloat(arrY.reduce(Int.max, { min($0, $1) })))
        let height = yMax - yMin
        let width = xMax - xMin
        let point = CGPoint(x: xMin + width / 2, y: yMin + height / 2)
        return point
    }
    
    private func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
        let projectedOrigin = view.projectPoint(SCNVector3Make(0, 0, depth))
        let locationWithz   = SCNVector3Make(Float(point.x), Float(point.y), projectedOrigin.z)
        return view.unprojectPoint(locationWithz)
    }
}
