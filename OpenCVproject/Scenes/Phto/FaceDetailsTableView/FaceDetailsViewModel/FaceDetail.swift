//
//  FaceDetail.swift
//  OpenCVproject
//
//  Created by Сергей Кротких on 06/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

struct FaceDetail {
    var image: UIImage
    var polyLine: [CGPoint]
    var pupils: [CGPoint]
    var face: UIImage?
}
