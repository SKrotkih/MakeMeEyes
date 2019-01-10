//
//  PhotoShowViewModel.swift
//  MasterFace
//
//  Created by Сергей Кротких on 22/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit
import RxSwift

typealias photoPickerCompletion = (UIImage?) -> Void

final class VideoViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var viewController: VideoViewController
    private let disposeBag = DisposeBag()

    private lazy var videoSpeedStrategy: VideoSpeedStrategy = {
        return VideoSpeedStrategy(videoParentView: videoParentView, drawingView: drawingView, sceneInteractor: sceneInteractor)
    }()

    private var completion: photoPickerCompletion?
    private let sceneInteractor: SceneInteractor
    
    private var observer: AnyObject?

    private let sceneView: UIView
    private let videoParentView: UIImageView
    private let drawingView: EyesDrawingView
    
    var videoSize: CGSize {
        return videoSpeedStrategy.videoSize
    }
    
    private var currentState: VideoSpeedStrategy.VideoSpeedState = .undefined {
        didSet {
            switch currentState {
            case .undefined:
                break
            case .fast:
                self.viewController.showFaceToolBar()
            case .slow:
                self.viewController.showEyesToolBar()
            }
            self.videoSpeedStrategy.currentState = currentState
        }
    }
    
    init(_ viewController: VideoViewController,
                     sceneView: UIView,
                     videoParentView: UIImageView,
                     drawingView: EyesDrawingView
                     ) {
        self.viewController = viewController
        self.sceneView = sceneView
        self.videoParentView = videoParentView
        self.drawingView = drawingView
        self.sceneInteractor = SceneInteractor(parentView: sceneView)
        super.init()
        self.subscribeNotifications()
    }
    
    // Notifications observer about changing video quality
    private func subscribeNotifications() {
        
        observer = NotificationCenter.default.addObserver(
            forName: .didUpdateVideoSize,
            object: nil,
            queue: nil) { notification in
                self.viewController.view.setNeedsLayout()
        }

        viewController.didSwitchToEyesState.subscribe(onNext: {[unowned self] _ in
            self.setNeededEyesDrawing()
            self.currentState = .slow
        }).disposed(by: disposeBag)

        viewController.didSwitchToMasksState.subscribe(onNext: {[unowned self] _ in
            self.currentState = .fast
        }).disposed(by: disposeBag)

        viewController.selectedEyeItem.subscribe(onNext: {[unowned self] index in
            if index == 100 {
                // It is an excetion
                self.videoSpeedStrategy.showBox()
            } else {
                self.didSelectedToolbarEyeItem(index)
            }
        }).disposed(by: disposeBag)

        viewController.selectedMaskItem.subscribe(onNext: {[unowned self] index in
            self.didSelectMaskItem(index)
        }).disposed(by: disposeBag)
        
        viewController.viewWillAppear.subscribe(onNext: {[unowned self] appear in
            if appear {
                if self.videoSpeedStrategy.videoIsInitialized() == true {
                    self.startCamera()
                } else {
                    self.currentState = VideoSpeedStrategy.VideoSpeedState.defaultState()
                }
            } else {
                self.stopCamera()
            }
        }).disposed(by: disposeBag)
    }
    
    private func unsubscribeNotifications() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
    
    deinit {
        unsubscribeNotifications()
    }
    
    func takePhoto(_ rect: CGRect, completion: @escaping (UIImage?) -> Void) {
        self.willTakePhoto()
        self.completion = completion
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                picker.sourceType = .camera
                picker.cameraDevice = .front
                self.viewController.present(picker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .popover
            picker.popoverPresentationController?.sourceView = self.viewController.view
            picker.popoverPresentationController?.sourceRect = rect
            self.viewController.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.didTakePhoto()
            self.completion?(nil)
        }))
        // on iPad this is a popover
        alert.popoverPresentationController?.sourceView = self.viewController.view
        alert.popoverPresentationController?.sourceRect = rect
        self.viewController.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.completion?(selectedImage)
        
        // Dismiss the picker.
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    private func willTakePhoto() {
        videoSpeedStrategy.stopCamera()
    }
    
    private func didTakePhoto() {
        videoSpeedStrategy.startCamera()
    }
}

// MARK: - 

extension VideoViewModel {
    
    private func startCamera() {
        videoSpeedStrategy.startCamera()
    }

    private func stopCamera() {
        videoSpeedStrategy.stopCamera()
    }
    
    private func setNeededEyesDrawing() {
        // let needEyesDrawing = !OpenCVWrapper.needEyesDrawing()
        OpenCVWrapper.setNeedEyesDrawing(true)
    }

    private func didSelectedToolbarEyeItem(_ index: Int) {
        let images = ["eye1.png", "eye2.png", "eye3.png", "eye4.png", "eye5.png", "eye6.png", "eye7.png", "eye8.png", "eye9.png"];
        assert(index < images.count)
        let imageName = images[index]
        OpenCVWrapper.setIrisImageName(imageName)
        OpenCVWrapper.setNeedEyesDrawing(true)
    }
    
    private func didSelectMaskItem(_ index: Int) {
        switch index {
        case 0:
            videoSpeedStrategy.showMask()
        default:
            break
        }
    }
}

// MARK: -

extension VideoViewModel {

    func setPupilPercent(_ value: Double) {
        videoSpeedStrategy.setPupilPercent(value)
    }
    
    func setLenseColorAlpha(_ value: Double) {
        videoSpeedStrategy.setLenseColorAlpha(value)
    }
}
