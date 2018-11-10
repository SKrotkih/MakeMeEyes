//
//  VideoViewController.swift
//  OpenCVproject
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var videoCameraWrapper : CvVideoCameraWrapper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCameraWrapper = CvVideoCameraWrapper(controller: self, andImageView: imageView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        videoCameraWrapper.startCamera()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        videoCameraWrapper.stopCamera()
    }
}
