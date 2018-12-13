//
//  PhotoPreviewViewModel.swift
//  MasterFace
//
//  Created by Сергей Кротких on 23/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import Foundation

class PhotoPreviewViewModel: NSObject {
    
    private var cameraWrapper : CvCameraWrapper?
    
    func recognizeFaceOn(_ _image: UIImage, drawTo faceView: EyesDrawingView) {
        if cameraWrapper == nil {
            cameraWrapper = CvCameraWrapper(eyesDrawingView: faceView);
        }
        cameraWrapper?.processImage(_image)
    }
    
}
