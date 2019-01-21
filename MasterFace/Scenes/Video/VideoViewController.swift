//
//  VideoViewController.swift
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@objc class VideoViewController: UIViewController {

    enum Constants {
        static let eyesFaceSwitchButtonId = 100
        static let takePhotoSegue = "showphotosegue"
        static let tabEyesItemsCount = 10
        static let tabMasksItemsCount = 9
    }

    var viewWillAppear = PublishSubject<Bool>()
    
    var didSwitchToEyesState = PublishSubject<Bool>()
    var didSwitchToMasksState = PublishSubject<Bool>()
    
    var selectedEyeItem = PublishSubject<Int>()
    var selectedMaskItem = PublishSubject<Int>()
    
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
    
    @IBOutlet weak var eyesButtonBackgroundView: UIView!
    @IBOutlet weak var maskButtonBackgroundView: UIView!
    
    private var viewModel: VideoViewModel!

    private var photo: UIImage!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = VideoViewModel(self,
                                  sceneView: maskSceneView,
                                  videoParentView: imageView,
                                  drawingView: self.eyesDrawingView)
        configureView()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        updateVideoFrameSize()
        layoutTabBarSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppear.onNext(true)
        eyesDrawingView.isEnable = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewWillAppear.onNext(false)
        eyesDrawingView.isEnable = false
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
        selectedEyeItem.onNext(button.tag)
    }
    
    @IBAction func didTapOnMasksButtyon(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        selectedMaskItem.onNext(button.tag)
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
    
    func showEyesToolBar() {
        eyesButtonBackgroundView.isHidden = true
        maskButtonBackgroundView.isHidden = false
        eyesTabBarView.isHidden = false
        masksTabBarView.isHidden = true
    }
    
    func showFaceToolBar() {
        eyesButtonBackgroundView.isHidden = false
        maskButtonBackgroundView.isHidden = true
        eyesTabBarView.isHidden = true
        masksTabBarView.isHidden = false
    }
    
    private func takePhoto() {
        viewModel.takePhoto(self.takePhotoView.frame) { selectedImage in
            if selectedImage != nil {
                self.photo = selectedImage
                self.performSegue(withIdentifier: Constants.takePhotoSegue, sender: self)
            }
        }
    }
    
    private func configureView() {
        
        func bindEyesButton() {
            self.eyesButton.rx.tap.bind(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.didSwitchToEyesState.onNext(true)
            }).disposed(by: disposeBag)
        }

        func bindMasksButton() {
            self.masksButton.rx.tap.bind(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.didSwitchToMasksState.onNext(true)
            }).disposed(by: disposeBag)
        }
        
        func bindTakePhotoButton() {
            self.takePhotoButton.rx.tap.bind(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.takePhoto()
            }).disposed(by: disposeBag)
        }
        
        eyesDrawingView.imageView = foregroundImageView
        
        takePhotoButton.layer.borderColor = UIColor.green.cgColor
        
        eyesButton.layer.cornerRadius = eyesButton.bounds.width / 2.0
        masksButton.layer.cornerRadius = masksButton.bounds.width / 2.0
        
        bindEyesButton()
        bindMasksButton()
        bindTakePhotoButton()
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
