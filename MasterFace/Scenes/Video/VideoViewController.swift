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
    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var videoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var faceView: FaceView!
    @IBOutlet weak var eyesScrollView: UIScrollView!
    @IBOutlet weak var eyesContentView: UIView!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    private var videoCameraWrapper : CvVideoCameraWrapper!
    private var sceneInteractor: SceneInteractor!
    private var needDrawEyes: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faceView.imageView = foregroundImageView
        
        self.videoCameraWrapper = CvVideoCameraWrapper(controller: self, andImageView: imageView, foreground: self.faceView);
        self.sceneInteractor = SceneInteractor(parentView: self.foregroundImageView)
        
        takePhotoButton.layer.cornerRadius = takePhotoButton.bounds.width / 2.0
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        let camWidth = videoCameraWrapper.camWidth();
        let camHeight = videoCameraWrapper.camHeight();
        let h = self.view.frame.height
        let w = h * CGFloat(camWidth) / CGFloat(camHeight);
        videoHeightConstraint.constant = h;
        videoWidthConstraint.constant = w;
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        eyesScrollView.contentSize = CGSize(width: 9*50, height: 50)
        eyesContentView.frame = CGRect(x: 0, y: 0, width: 9*50, height: 50)
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
    
    @IBAction func didTabOnEyesButton(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        let images = ["eye1.png", "eye2.png", "eye3.png", "eye4.png", "eye5.png", "eye6.png", "eye7.png", "eye8.png", "eye9.png"];
        let imageName = images[button.tag]
        let image = UIImage(named: imageName)
        faceView.irisImage = image
    }
    
    @IBAction func pressOnTakePhotoButton(_ sender: Any) {
        print("123")
    }
    
    
    //
    @objc func drawFaceWithScale(_ scale: Double) {
        self.sceneInteractor.drawSceneWithScale(CGFloat(scale))
    }
}
