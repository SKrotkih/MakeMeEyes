//
//  SceneInteractor.swift
//  MasterFace
//
//  Created by Сергей Кротких on 12/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit
import SceneKit

class SceneInteractor {

    private var _parentView: UIView!
    private var _sceneView: SCNView?
    private var _scnScene: SCNScene!
    private var _cameraNode: SCNNode!
    
    private var _leftEyeNode: SCNNode!
    private var _rightEyeNode: SCNNode!
    
    init(parentView: UIView) {
        _parentView = parentView
    }
    
    func addScene() {
        if _sceneView == nil {
            configureScene()
            setupScene()
            setupCamera()
            createMask()
        } else {
            _sceneView?.removeFromSuperview()
            _sceneView = nil
        }
    }
    
    private func configureScene() {
        _sceneView = SCNView(frame: _parentView.bounds)
        _sceneView!.allowsCameraControl = false
        _sceneView!.showsStatistics = true
        _sceneView!.backgroundColor = UIColor.clear
        _sceneView!.isUserInteractionEnabled = true
        
        _sceneView!.showsStatistics = true
        _sceneView!.allowsCameraControl = true
        _sceneView!.autoenablesDefaultLighting = true
        
        _parentView.addSubview(_sceneView!)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeftGesture.direction = .left
        _sceneView!.addGestureRecognizer(swipeLeftGesture)
    }
    
    @objc private func handleSwipe(_ gestureRecognize: UISwipeGestureRecognizer) {
        if (gestureRecognize.direction == .left) {
        }
        else if (gestureRecognize.direction == .right) {
        }
    }
    
    private func setupScene() {
        _scnScene = SCNScene()
        _sceneView?.scene = _scnScene
        //_scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    
    private func setupCamera() {
        _cameraNode = SCNNode()
        _cameraNode.camera = SCNCamera()
        _cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        _scnScene.rootNode.addChildNode(_cameraNode)
    }
    
    private func createMask() {
        createLeftEye()
        createRightEye()
    }
    
    private func createLeftEye() {
        var geometry: SCNGeometry
        switch ShapeType.random() {
        default:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
        _leftEyeNode = SCNNode(geometry: geometry)
        _scnScene.rootNode.addChildNode(_leftEyeNode)
    }
    
    private func createRightEye() {
        var geometry: SCNGeometry
        switch ShapeType.random() {
        default:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
        _rightEyeNode = SCNNode(geometry: geometry)
        _scnScene.rootNode.addChildNode(_rightEyeNode)
    }
    
    // Public func: handle did update pupil coordinate event
    func drawSceneWithScale(_ scale: CGFloat) {
        guard let sceneView = _sceneView else {
            return
        }
        guard let leftPupilBorderX = OpenCVWrapper.leftPupilBorder()[0] as? [Int],
            let leftPupilBorderY = OpenCVWrapper.leftPupilBorder()[1] as? [Int],
            let rightPupilBorderX = OpenCVWrapper.rightPupilBorder()[0] as? [Int],
            let rightPupilBorderY = OpenCVWrapper.rightPupilBorder()[1] as? [Int] else {
                return
        }
        guard let leftEyeCenter = getCenter(scale, leftPupilBorderX, leftPupilBorderY),
            let rightEyeCenter = getCenter(scale, rightPupilBorderX, rightPupilBorderY) else {
                return
        }

        let leftEyePosition: SCNVector3 = CGPointToSCNVector3(view: sceneView, depth: _leftEyeNode.position.z, point: leftEyeCenter)
        _leftEyeNode.position = leftEyePosition

        let rightEyePosition: SCNVector3 = CGPointToSCNVector3(view: sceneView, depth: _rightEyeNode.position.z, point: rightEyeCenter)
        _rightEyeNode.position = rightEyePosition
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
