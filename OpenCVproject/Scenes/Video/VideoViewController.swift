//
//  VideoViewController.swift
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit
import SceneKit

@objc class VideoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    private var videoCameraWrapper : CvVideoCameraWrapper!
    private var sceneInteractor: SceneInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCameraWrapper = CvVideoCameraWrapper(controller: self, andImageView: imageView)
        
        self.sceneInteractor = SceneInteractor(parentView: self.imageView)
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
        sceneInteractor.addScene()
    }
    
    @IBAction func addFaceButtonPressed(_ sender: Any) {
        videoCameraWrapper.showBox()
    }
    
    @objc func updatePupilsCoordinate(_ leftX: Int, _leftY: Int, _rightX: Int, _rightY: Int) {
        self.sceneInteractor.updatePupilsCoordinate(leftX, _leftY: _leftY, _rightX: _rightX, _rightY: _rightY)
    }
}
