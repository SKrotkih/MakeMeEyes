//
//  PhotoPreviewViewController.swift
//  MasterFace
//
//  Created by Сергей Кротких on 22/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var faceView: FaceView!
    
    private var viewModel: PhotoPreviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PhotoPreviewViewModel(faceView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = image
        viewModel.processImage(image)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        

        self.navigationController?.popViewController(animated: true)
    }
}
