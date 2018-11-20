//
//  FaceView.swift
//  MasterFace
//
//  Created by Сергей Кротких on 20/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

@objc class FaceView: UIImageView {

    @objc func drawFace() {
        let coordinates = OpenCVWrapper.faceCoordinates()


    }
    
}
