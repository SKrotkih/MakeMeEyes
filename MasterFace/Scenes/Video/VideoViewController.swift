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
    
    @IBOutlet weak var masksScrollView: UIScrollView!
    @IBOutlet weak var masksContentView: UIView!
    
    @IBOutlet weak var maskSceneView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var takePhotoView: UIView!
    
    private var videoCameraWrapper : CvVideoCameraWrapper!
    private var sceneInteractor: SceneInteractor!
    private var needDrawEyes: Bool = true

    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var masksContentViewWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var eyesButton: UIButton!
    @IBOutlet weak var masksButton: UIButton!
    
    @IBOutlet weak var eyesTabBarView: UIView!
    @IBOutlet weak var masksTabBarView: UIView!
    
    private var viewModel: VideoViewModel!
    private var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faceView.imageView = foregroundImageView
        
        self.videoCameraWrapper = CvVideoCameraWrapper(controller: self, andImageView: imageView, foreground: self.faceView);
        self.sceneInteractor = SceneInteractor(parentView: self.maskSceneView)
        
        takePhotoButton.layer.cornerRadius = takePhotoButton.bounds.width / 2.0
        takePhotoButton.layer.borderColor = UIColor.green.cgColor
        takePhotoButton.layer.borderWidth = 1.0
        
        eyesButton.layer.cornerRadius = eyesButton.bounds.width / 2.0
        masksButton.layer.cornerRadius = masksButton.bounds.width / 2.0

        eyesTabBarView.isHidden = false
        masksTabBarView.isHidden = true
        
        viewModel = VideoViewModel(self)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let eyesContentWidth = CGFloat(10 * 50)
        let masksContentWidth = CGFloat(9 * 50)
        
        eyesScrollView.contentSize = CGSize(width: eyesContentWidth, height: 50)
        
        masksScrollView.contentSize = CGSize(width: masksContentWidth, height: 50)

        contentViewWidthConstraint.constant = eyesContentWidth
        masksContentViewWidthConstraint.constant = masksContentWidth
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        faceView.needFaceDrawing = true
        videoCameraWrapper.startCamera()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        faceView.needFaceDrawing = false
        videoCameraWrapper.stopCamera()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoShowVC = segue.destination as? PhotoPreviewViewController {
            photoShowVC.image = self.photo
        }
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
        if button.tag == 100 {
            faceView.needFaceDrawing = !faceView.needFaceDrawing
            
//            needDrawEyes = !needDrawEyes
//            videoCameraWrapper.setNeedDrawEyes(needDrawEyes)
            
        } else {
            faceView.needFaceDrawing = true
            let images = ["eye1.png", "eye2.png", "eye3.png", "eye4.png", "eye5.png", "eye6.png", "eye7.png", "eye8.png", "eye9.png"];
            let imageName = images[button.tag]
            let image = UIImage(named: imageName)
            faceView.irisImage = image
        }
    }

    @IBAction func didTapOnMasksButtyon(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        let tag = button.tag
        
        switch tag {
        case 0:
            sceneInteractor.addScene()
        case 1:
            videoCameraWrapper.showBox()
        default:
            break
        }
    }
    
    @IBAction func eyesButtonPressed(_ sender: Any) {
        eyesTabBarView.isHidden = false
        masksTabBarView.isHidden = true
    }
    
    @IBAction func masksButtonPressed(_ sender: Any) {
        eyesTabBarView.isHidden = true
        masksTabBarView.isHidden = false
    }
    
    @IBAction func pressOnTakePhotoButton(_ sender: Any) {
        viewModel.takePhoto(self.takePhotoView.frame) { selectedImage in
            self.photo = selectedImage
            self.performSegue(withIdentifier: "showphotosegue", sender: self)
        }
    }
    
    //
    @objc func drawFaceWithScale(_ scale: Double) {
        self.sceneInteractor.drawSceneWithScale(CGFloat(scale))
    }
}
