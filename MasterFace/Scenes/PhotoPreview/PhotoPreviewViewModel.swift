//
//  PhotoPreviewViewModel.swift
//  MasterFace
//
//  Created by Сергей Кротких on 23/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import Foundation

class PhotoPreviewViewModel: NSObject {
    
    private var faceView: FaceView!
    private var cameraWrapper : CvCameraWrapper!
    
    init(_ _faceView: FaceView) {
        faceView = _faceView
        cameraWrapper = CvCameraWrapper(faceView: self.faceView);
    }
    
    func processImage(_ _image: UIImage) {
        cameraWrapper.processImage(_image)
    }
    
}
