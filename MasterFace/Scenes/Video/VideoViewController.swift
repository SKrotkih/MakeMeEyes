//
//  VideoViewController.swift
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit
import SceneKit

@objc class VideoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoWidthConstraint: NSLayoutConstraint!
    
    private var videoCameraWrapper : CvVideoCameraWrapper!
    private var sceneInteractor: SceneInteractor!
    private var needDrawEyes: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCameraWrapper = CvVideoCameraWrapper(controller: self, andImageView: imageView)
        
        self.sceneInteractor = SceneInteractor(parentView: self.imageView)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        let h = self.view.frame.height
        let w = h * 288.0 / 352.0   // S.K. 288.0 / 352.0  480.0 / 640.0
        videoHeightConstraint.constant = h;
        videoWidthConstraint.constant = w;
        
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

    @IBAction func needDrawEyesButtonPressed(_ sender: Any) {
        needDrawEyes = !needDrawEyes
        videoCameraWrapper.setNeedDrawEyes(needDrawEyes)
    }
    
    @objc func updatePupilsCoordinate(_ leftX: Int, _leftY: Int, _rightX: Int, _rightY: Int) {
        self.sceneInteractor.updatePupilsCoordinate(leftX, _leftY: _leftY, _rightX: _rightX, _rightY: _rightY)
    }
    
    @IBAction func didChangeSliderTransparetValue(_ sender: Any) {
        let slider = sender as! UISlider
        let value = slider.value
        videoCameraWrapper.setLenseColorAlpha(Double(value))
    }
    
    @IBAction func didChangeSliderPupilPercentValue(_ sender: Any) {
        let slider = sender as! UISlider
        let value = slider.value
        videoCameraWrapper.setPupilPercent(Double(value))
    }
}
