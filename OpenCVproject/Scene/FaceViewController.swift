//
//  FaceViewController.swift
//  OpenCVproject
//
//  Created by Сергей Кротких on 06/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var leftPupilImageView: UIImageView!
    @IBOutlet weak var rightPupilImageView: UIImageView!
    
    @IBOutlet weak var leftEyeView: FaceDetailImageView!
    @IBOutlet weak var rightEyeView: FaceDetailImageView!
    
    var face: UIImage?
    var leftEye: FaceDetail?
    var rightEye: FaceDetail?
    var leftPupil: FaceDetail?
    var rightPupil: FaceDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        putImages()
        leftEyeView.data = leftEye
        rightEyeView.data = rightEye
    }
    
    private func putImages() {
        faceImageView.image = face
        leftEyeView.image = leftEye?.image
        rightEyeView.image = rightEye?.image
        leftPupilImageView.image = leftPupil?.image
        rightPupilImageView.image = rightPupil?.image
    }

    @IBAction func runLeftEyeButtonPressed(_ sender: Any) {
        leftEyeView.drawDetail()
    }
    
    @IBAction func runRightEyeButtonPressed(_ sender: Any) {
        rightEyeView.drawDetail()
    }
    
}
