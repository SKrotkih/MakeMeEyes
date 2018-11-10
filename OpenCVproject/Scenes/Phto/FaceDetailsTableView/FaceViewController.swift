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
    
    @IBOutlet weak var leftEyeView: FaceDetailImageView!
    @IBOutlet weak var rightEyeView: FaceDetailImageView!
    
    @IBOutlet weak var leftEyeCutView: FaceDetailImageView!
    @IBOutlet weak var rightEyeCutView: FaceDetailImageView!
    
    var face: UIImage?
    var leftEye: FaceDetail?
    var rightEye: FaceDetail?
    var leftCutEye: FaceDetail?
    var rightCutEye: FaceDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        faceImageView.image = face
        leftEyeView.data = leftEye
        rightEyeView.data = rightEye
        leftEyeCutView.data = leftCutEye
        rightEyeCutView.data = rightCutEye
    }
    
    @IBAction func runLeftEyeButtonPressed(_ sender: Any) {
        leftEyeView.drawEye()
    }
    
    @IBAction func runRightEyeButtonPressed(_ sender: Any) {
        rightEyeView.drawEye()
    }
    
    @IBAction func runLeftCutEyeButtonPressed(_ sender: Any) {
        leftEyeCutView.cutEye()
    }
    
    @IBAction func runRightCutEyeButtonPressed(_ sender: Any) {
        rightEyeCutView.drawEyesIris() // cutEye()
    }
}
