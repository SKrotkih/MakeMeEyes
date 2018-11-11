//
//  VideoViewController.swift
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit
import SceneKit

class VideoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var videoCameraWrapper : CvVideoCameraWrapper!
    private var _sceneView: SCNView!
    private var _scnScene: SCNScene!
    private var _cameraNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCameraWrapper = CvVideoCameraWrapper(controller: self, andImageView: imageView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoCameraWrapper.startCamera()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoCameraWrapper.stopCamera()
    }
    
    @IBAction func addSceneButtonPressed(_ sender: Any) {
        addScene()
    }
    
    private func addScene() {
        setupView()
        setupScene()
        setupCamera()
        spawnShape()
    }

    func setupView() {
        _sceneView = SCNView(frame: self.view.frame)
        _sceneView.allowsCameraControl = false
        _sceneView.showsStatistics = true
        _sceneView.backgroundColor = UIColor.clear
        _sceneView.isUserInteractionEnabled = true

        _sceneView.showsStatistics = true
        _sceneView.allowsCameraControl = true
        _sceneView.autoenablesDefaultLighting = true
        
        imageView.addSubview(_sceneView)
    }
    
    func setupScene() {
        _scnScene = SCNScene()
        _sceneView.scene = _scnScene
        //_scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    
    func setupCamera() {
        _cameraNode = SCNNode()
        _cameraNode.camera = SCNCamera()
        _cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        _scnScene.rootNode.addChildNode(_cameraNode)
    }
    
    func spawnShape() {
        var geometry:SCNGeometry
        switch ShapeType.random() {
        default:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
        let geometryNode = SCNNode(geometry: geometry)
        _scnScene.rootNode.addChildNode(geometryNode)
    }
}
