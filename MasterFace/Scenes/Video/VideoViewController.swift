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

    @IBOutlet weak var eyesDrawingView: EyesDrawingView!
    
    @IBOutlet weak var tabEyesScrollView: UIScrollView!
    @IBOutlet weak var eyesContentView: UIView!
    
    @IBOutlet weak var tabMasksScrollView: UIScrollView!
    @IBOutlet weak var masksContentView: UIView!
    
    @IBOutlet weak var maskSceneView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var takePhotoView: UIView!
    
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

        eyesDrawingView.imageView = foregroundImageView
        
        takePhotoButton.layer.cornerRadius = takePhotoButton.bounds.width / 2.0
        takePhotoButton.layer.borderColor = UIColor.green.cgColor
        takePhotoButton.layer.borderWidth = 1.0
        
        eyesButton.layer.cornerRadius = eyesButton.bounds.width / 2.0
        masksButton.layer.cornerRadius = masksButton.bounds.width / 2.0

        eyesTabBarView.isHidden = false
        masksTabBarView.isHidden = true

        viewModel = VideoViewModel(self,
                                   sceneView: maskSceneView,
                                   videoParentView: imageView,
                                   drawingView: self.eyesDrawingView)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        let camWidth = viewModel.videoSize.width
        let camHeight = viewModel.videoSize.height
        let h = self.view.frame.height
        let w = h * CGFloat(camWidth) / CGFloat(camHeight);
        videoHeightConstraint.constant = h;
        videoWidthConstraint.constant = w;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tabBarHeight = tabEyesScrollView.frame.height
        let tabEyesItemsCount = 10
        let tabMasksItemsCount = 9
        
        let eyesContentWidth = CGFloat(tabEyesItemsCount) * tabBarHeight
        let masksContentWidth = CGFloat(tabMasksItemsCount) * tabBarHeight
        
        tabEyesScrollView.contentSize = CGSize(width: eyesContentWidth, height: tabBarHeight)
        tabMasksScrollView.contentSize = CGSize(width: masksContentWidth, height: tabBarHeight)

        contentViewWidthConstraint.constant = eyesContentWidth
        masksContentViewWidthConstraint.constant = masksContentWidth
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eyesDrawingView.isEnable = true
        viewModel.didTakePhoto()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eyesDrawingView.isEnable = false
        viewModel.willTakePhoto()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoShowVC = segue.destination as? PhotoPreviewViewController {
            photoShowVC.image = self.photo
        }
    }
    
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
    
    @IBAction func didTabOnEyesButton(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if button.tag == 100 {
            viewModel.setNeededEyesDrawing()
            // needDrawEyes = !needDrawEyes
            // eyesVideoCameraWrapper.setNeedDrawEyes(needDrawEyes)
        } else {
            viewModel.didSelectedEyeItem(button.tag)
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
        viewModel.willTakePhoto()
        viewModel.takePhoto(self.takePhotoView.frame) { selectedImage in
            if selectedImage == nil {
                self.viewModel.didTakePhoto()
            } else {
                self.photo = selectedImage
                self.performSegue(withIdentifier: "showphotosegue", sender: self)
            }
        }
    }
}
