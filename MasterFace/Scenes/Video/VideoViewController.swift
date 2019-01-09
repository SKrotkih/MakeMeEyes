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

    enum Constants {
        static let eyesFaceSwitchButtonId = 100
        static let takePhotoSegue = "showphotosegue"
        static let tabEyesItemsCount = 10
        static let tabMasksItemsCount = 9
    }
    
    @IBOutlet weak var videoContentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var videoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var eyesDrawingView: EyesDrawingView!
    
    @IBOutlet weak var tabEyesScrollView: UIScrollView!
    @IBOutlet weak var eyesContentView: UIView!
    
    @IBOutlet weak var tabMasksScrollView: UIScrollView!
    @IBOutlet weak var masksContentView: UIView!
    
    @IBOutlet weak var maskSceneView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var takePhotoView: UIView!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var masksContentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eyesButton: UIButton!
    @IBOutlet weak var masksButton: UIButton!
    
    @IBOutlet weak var eyesTabBarView: UIView!
    @IBOutlet weak var masksTabBarView: UIView!
    
    private lazy var viewModel: VideoViewModel = {
        return VideoViewModel(self,
                              sceneView: maskSceneView,
                              videoParentView: imageView,
                              drawingView: self.eyesDrawingView)
    }()

    private var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        updateVideoFrameSize()
        layoutTabBarSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eyesDrawingView.isEnable = true
        viewModel.startCamera()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        eyesDrawingView.isEnable = false
        viewModel.stopCamera()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoShowVC = segue.destination as? PhotoPreviewViewController {
            photoShowVC.image = self.photo
        }
    }
    
    @IBAction func didTabOnEyesButton(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if button.tag == Constants.eyesFaceSwitchButtonId {
            viewModel.setNeededEyesDrawing()
        } else {
            viewModel.didSelectedToolbarEyeItem(tag: button.tag)
        }
    }

    @IBAction func didTapOnMasksButtyon(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        viewModel.didSelectMaskItem(button.tag)
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
            if selectedImage != nil {
                self.photo = selectedImage
                self.performSegue(withIdentifier: Constants.takePhotoSegue, sender: self)
            }
        }
    }
    
    // TODO: remove
    
    @IBAction func didChangeSliderTransparetValue(_ sender: Any) {
        let slider = sender as! UISlider
        let value = slider.value
        viewModel.setLenseColorAlpha(Double(value))
    }
    
    @IBAction func didChangeSliderPupilPercentValue(_ sender: Any) {
        let slider = sender as! UISlider
        let value = slider.value
        viewModel.setPupilPercent(Double(value))
    }
}

// MARK: - View's private methods

extension VideoViewController {

    private func configureView() {
        eyesDrawingView.imageView = foregroundImageView
        
        takePhotoButton.layer.cornerRadius = takePhotoButton.bounds.width / 2.0
        takePhotoButton.layer.borderColor = UIColor.green.cgColor
        takePhotoButton.layer.borderWidth = 1.0
        
        eyesButton.layer.cornerRadius = eyesButton.bounds.width / 2.0
        masksButton.layer.cornerRadius = masksButton.bounds.width / 2.0
        
        eyesTabBarView.isHidden = false
        masksTabBarView.isHidden = true
    }

    private func layoutTabBarSubviews() {
        let tabBarHeight = tabEyesScrollView.frame.height
        
        let eyesContentWidth = CGFloat(Constants.tabEyesItemsCount) * tabBarHeight
        let masksContentWidth = CGFloat(Constants.tabMasksItemsCount) * tabBarHeight
        
        tabEyesScrollView.contentSize = CGSize(width: eyesContentWidth, height: tabBarHeight)
        tabMasksScrollView.contentSize = CGSize(width: masksContentWidth, height: tabBarHeight)
        
        contentViewWidthConstraint.constant = eyesContentWidth
        masksContentViewWidthConstraint.constant = masksContentWidth
    }

    private func updateVideoFrameSize() {
        let videoSize = viewModel.videoSize
        let videoWidth = videoSize.width
        let videoHeight = videoSize.height
        if videoWidth > 0 && videoHeight > 0 {
            let viewHeight = videoContentView.frame.height
            let k = videoWidth / videoHeight
            let h = viewHeight
            let w = h * k
            
            print("Video size: [\(videoSize)]; screen size: [\(w);\(h)]")

            DispatchQueue.main.async {
                self.videoWidthConstraint.constant = w;
                self.videoHeightConstraint.constant = h;
            }
        }
    }
}
