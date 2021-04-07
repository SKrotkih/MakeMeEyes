//
//  PhotoPreviewViewModel.swift
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 23/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
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
