//
//  SceneInteractor.swift
//  OpenCVproject
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
    func updatePupilsCoordinate(_ leftX: Int, _leftY: Int, _rightX: Int, _rightY: Int) {
        guard let sceneView = _sceneView else {
            return
        }
        
        let leftEyePoint = CGPoint(x: CGFloat(leftX), y: CGFloat(_leftY))
        let leftEyePosition: SCNVector3 = CGPointToSCNVector3(view: sceneView, depth: _leftEyeNode.position.z, point: leftEyePoint)
        _leftEyeNode.position = leftEyePosition
        
        let rightEyePoint = CGPoint(x: CGFloat(_rightX), y: CGFloat(_rightY))
        let rightEyePosition: SCNVector3 = CGPointToSCNVector3(view: sceneView, depth: _rightEyeNode.position.z, point: rightEyePoint)
        _rightEyeNode.position = rightEyePosition
    }
    
    private func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
        let projectedOrigin = view.projectPoint(SCNVector3Make(0, 0, depth))
        let locationWithz   = SCNVector3Make(Float(point.x), Float(point.y), projectedOrigin.z)
        return view.unprojectPoint(locationWithz)
    }
}
