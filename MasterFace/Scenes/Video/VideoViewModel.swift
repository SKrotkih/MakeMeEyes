//
//  PhotoShowViewModel.swift
//  MasterFace
//
//  Created by Сергей Кротких on 22/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

typealias photoPickerCompletion = (UIImage?) -> Void

class VideoViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let viewController: UIViewController
    private var completion: photoPickerCompletion?
    
    private var maskSceneView: UIView!
    private var sceneInteractor: SceneInteractor!
    private var videoCameraWrapper: EyesCvVideoCameraWrapper!
    private let speedCoordinator: VideoSpeedCoordinator
    
    required init(_ viewController: UIViewController, maskSceneView: UIView, videoCameraWrapper: EyesCvVideoCameraWrapper) {
        self.viewController = viewController
        self.sceneInteractor = SceneInteractor(parentView: maskSceneView)
        self.videoCameraWrapper = videoCameraWrapper
        speedCoordinator = VideoSpeedCoordinator()
    }
    
    func takePhoto(_ rect: CGRect, completion: @escaping (UIImage?) -> Void) {
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
}


extension VideoViewModel {
    
    func willTakePhoto() {
        videoCameraWrapper.stopCamera()
    }
    
    func didTakePhoto() {
        videoCameraWrapper.startCamera()
    }
    
    func setNeededEyesDrawing() {
        let needEyesDrawing = !OpenCVWrapper.needEyesDrawing()
        speedCoordinator.eyesIndex = needEyesDrawing ? 1 : 0
        OpenCVWrapper.setNeedEyesDrawing(needEyesDrawing)
    }

    func didSelectedEyeItem(_ index: Int) {
        speedCoordinator.eyesIndex = index
        let images = ["eye1.png", "eye2.png", "eye3.png", "eye4.png", "eye5.png", "eye6.png", "eye7.png", "eye8.png", "eye9.png"];
        let imageName = images[index]
        OpenCVWrapper.setIrisImageName(imageName)
        OpenCVWrapper.setNeedEyesDrawing(true)
    }
    
    func didSelectMaskItem(_ index: Int) {
        speedCoordinator.maskIndex = index
        switch index {
        case 0:
            sceneInteractor.addScene()
        case 1:
            videoCameraWrapper.showBox()
        default:
            break
        }
    }
    
    func drawFaceWithScale(_ scale: Double) {
        self.sceneInteractor.drawSceneWithScale(CGFloat(scale))
    }

    func setPupilPercent(_ value: Double) {
       videoCameraWrapper.setPupilPercent(value)
    }
    
    func setLenseColorAlpha(_ value: Double) {
        videoCameraWrapper.setLenseColorAlpha(value)
    }
}
